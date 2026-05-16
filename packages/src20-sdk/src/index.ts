import type { ShieldedWalletClient, PublicClient } from "@seismic/viem";
import { parseAbiItem, getContract, parseEventLogs } from "viem";
import { SRC20FactoryAbi, SRC20TokenAbi } from "./abis";
import { CreateTokenParams, CreateTokenResult, TokenInfo } from "./types";

// Mapping of supported chain IDs to factory addresses (as per docs)
const FACTORY_ADDRESSES: Record<number, `0x${string}`> = {
  5124: "0x87F850cbC2cFfac086F20d0d7307E12d06fA2127",
};

/** Resolve factory address for a given chain ID */
export function getFactoryAddress(chainId: number): `0x${string}` {
  const addr = FACTORY_ADDRESSES[chainId];
  if (!addr) throw new Error(`Factory address not configured for chainId ${chainId}`);
  return addr;
}

/** Deploy a new SRC20 token using the factory contract */
export async function createToken(
  client: ShieldedWalletClient,
  params: CreateTokenParams,
): Promise<CreateTokenResult> {
  const { name, symbol, initialSupply, decimals = 18 } = params;

  const factoryAddr = getFactoryAddress(client.chain.id);
  const factory = getContract({
    address: factoryAddr,
    abi: SRC20FactoryAbi,
    client,
  });

  const hash = await factory.write.createToken([
    name,
    symbol,
    initialSupply,
    decimals,
  ], {
    // Viem automatically handles shielding for shielded clients
    // No extra parameters needed here
  });

  // Wait for transaction receipt to extract the TokenCreated event
  const receipt = await client.waitForTransactionReceipt({ hash });

  // Parse TokenCreated event – the first indexed param is the token address
  const logs = parseEventLogs({
    abi: SRC20FactoryAbi,
    logs: receipt.logs,
    eventName: "TokenCreated",
  });

  if (logs.length === 0) {
    throw new Error("TokenCreated event not found in transaction receipt");
  }

  const tokenAddress = logs[0].args.token as `0x${string}`;

  return {
    tokenAddress,
    txHash: hash,
  };
}

/** Read public metadata of a deployed SRC20 token */
export async function getTokenInfo(
  client: PublicClient,
  tokenAddress: `0x${string}`,
): Promise<TokenInfo> {
  const token = getContract({
    address: tokenAddress,
    abi: SRC20TokenAbi,
    client,
  });

  const [name, symbol, decimals, owner, totalSupply] = await Promise.all([
    token.read.name(),
    token.read.symbol(),
    token.read.decimals(),
    token.read.owner(),
    token.read.totalSupply(),
  ]);

  return {
    name,
    symbol,
    decimals,
    owner,
    totalSupply: BigInt(totalSupply as unknown as string),
  };
}
