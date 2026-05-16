// interact.js – contoh penggunaan Viem untuk kontrak SRC20
import { createPublicClient, http, encodeFunctionData, decodeFunctionResult } from "viem";
import { privateKeyToAccount } from "viem/accounts";
import * as dotenv from "dotenv";

dotenv.config();

const RPC_URL = process.env.SEISMIC_RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = "0xYOUR_CONTRACT_ADDRESS_HERE"; // ganti setelah deploy

if (!RPC_URL || !PRIVATE_KEY) {
  console.error("⚠️  Pastikan .env terisi SEISMIC_RPC_URL dan PRIVATE_KEY");
  process.exit(1);
}

const account = privateKeyToAccount(PRIVATE_KEY);

// Chain config – gunakan chain Seismic bila tersedia di viem; untuk contoh gunakan sepolia placeholder
const client = createPublicClient({
  transport: http(RPC_URL),
  // chain: seismicTestnet, // uncomment bila viem sudah mendukung
});

const abi = [
  {
    type: "function",
    name: "balanceOf",
    inputs: [{ name: "account", type: "address" }],
    outputs: [{ name: "", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "transfer",
    inputs: [
      { name: "to", type: "address" },
      { name: "amount", type: "uint256" }, // Viem masih memakai uint256, compiler Seismic akan meng‑wrap ke suint256
    ],
    outputs: [{ name: "", type: "bool" }],
    stateMutability: "nonpayable",
  },
];

// -----------------------------------------------------------------
// 1. Baca saldo publik (selalu 0)
// -----------------------------------------------------------------
async function readPublicBalance(address) {
  const result = await client.readContract({
    address: CONTRACT_ADDRESS,
    abi,
    functionName: "balanceOf",
    args: [address],
  });
  console.log(`Public balance of ${address} = ${result.toString()} (selalu 0)`);
}

// -----------------------------------------------------------------
// 2. Transfer token (jumlah shielded)
// -----------------------------------------------------------------
async function transfer(to, amountWei) {
  const data = encodeFunctionData({
    abi,
    functionName: "transfer",
    args: [to, amountWei],
  });

  const hash = await client.sendTransaction({
    account,
    to: CONTRACT_ADDRESS,
    data,
    gas: 200_000n,
  });

  console.log("🚀 Transaction hash:", hash);
  const receipt = await client.waitForTransactionReceipt({ hash });
  console.log("✅ Confirmed in block", receipt.blockNumber);
}

// -----------------------------------------------------------------
// Demo usage
// -----------------------------------------------------------------
(async () => {
  const me = account.address;
  const alice = "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";

  await readPublicBalance(me);
  await transfer(alice, 100n * 10n ** 18n); // kirim 100 token (shielded)
})();
