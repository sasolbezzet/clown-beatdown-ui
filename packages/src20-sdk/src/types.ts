/**
 * Type definitions for the SRC20 SDK.
 * These mirror the documentation provided in the SDK reference page.
 */

import type { Address, Hash } from "viem";

export interface CreateTokenParams {
  name: string;
  symbol: string;
  initialSupply: bigint; // in base units (e.g. 1_000_000n * 10n ** 18n)
  decimals?: number; // defaults to 18
}

export interface CreateTokenResult {
  tokenAddress: Address;
  txHash: Hash;
}

export interface TokenInfo {
  name: string;
  symbol: string;
  decimals: number;
  owner: Address;
  totalSupply: bigint;
}
