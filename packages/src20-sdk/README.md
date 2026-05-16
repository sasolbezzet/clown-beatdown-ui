# @seismic/src20-sdk (workspace package)

TypeScript SDK that wraps the **SRC20 Factory** contract and provides convenient helpers for:

* Deploying a new SRC20 token (`createToken`).
* Reading public token metadata (`getTokenInfo`).
* Resolving the factory address for a given chain (`getFactoryAddress`).

The SDK is **internal to this workspace** – it is not published to npm. It is consumed by the `packages/cli` and `packages/web` packages in the monorepo.

## Installation (workspace)
```bash
# From the workspace root (same level as my-src20/)
cd packages/src20-sdk
npm install   # installs dev deps (typescript) and viem
npm run build # compile to dist/
```

## Usage example
```ts
import { createToken, getTokenInfo, getFactoryAddress } from "@seismic/src20-sdk";
import { createShieldedWalletClient, createPublicClient, http } from "@seismic/viem";

// 1️⃣ Shielded client (for deployment)
const shielded = createShieldedWalletClient({
  chain: { id: 5124, name: "Seismic Testnet", rpcUrls: { default: { http: [process.env.SEISMIC_RPC_URL!] } } },
  transport: http(process.env.SEISMIC_RPC_URL!),
  account: privateKeyToAccount(process.env.PRIVATE_KEY!),
});

// Deploy token
const { tokenAddress, txHash } = await createToken(shielded, {
  name: "MyShieldedToken",
  symbol: "MST",
  initialSupply: 1_000_000n * 10n ** 18n,
});
console.log("Deployed at", tokenAddress, "tx", txHash);

// 2️⃣ Public client (for reading metadata)
const publicClient = createPublicClient({
  chain: shielded.chain,
  transport: http(process.env.SEISMIC_RPC_URL!),
});

const info = await getTokenInfo(publicClient, tokenAddress);
console.log(info);
```

## API surface
* `createToken(client, params) → Promise<CreateTokenResult>`
* `getTokenInfo(client, tokenAddress) → Promise<TokenInfo>`
* `getFactoryAddress(chainId) → Address`
* Exports `SRC20FactoryAbi` and `SRC20TokenAbi`.

---

> **Note**: The SDK expects a **shielded wallet client** from `@seismic/viem` for deployment because the factory writes shielded values. For read‑only queries a normal `PublicClient` works.
