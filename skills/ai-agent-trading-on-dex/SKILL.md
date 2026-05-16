---
name: ai-agent-trading-on-dex
description: AI agent that can trade futures on the Ethereal decentralized exchange (DEX) using Web3 tools. Supports price queries, order placement, position monitoring, and risk checks.
---

# AI Agent – Trading Futures on Ethereal DEX

## Overview
This agent automates futures trading on **Ethereal** (a fictional Ethereum‑compatible DEX). It can:
- Query current futures contract prices.
- Open/close long or short positions.
- Check account balances and open positions.
- Estimate collateral and liquidation risk.
- Send notifications (via `write` to a log file) when important events occur.

## Activation
Trigger the agent when the user mentions “Ethereal futures”, “trade futures on ethereal”, or any request that involves futures trading on a DEX.

## Core Workflow
1. **Identify intent** – future‑price query, open‑position, close‑position, risk‑check, or status report.
2. **Select tool** –
   - `web_fetch`/`web_search` for market data (if public API available).
   - `exec` to run a local script that uses `web3.py` or `ethers.js` to interact with the Ethereal smart contracts (requires user‑approved execution).
   - `read`/`write` for persisting logs or reading stored credentials (e.g., private key placeholder).
3. **Execute & gather results** – run the chosen tool, retry on failure, and collect the JSON response.
4. **Compose response** – summarize price, position status, risk metrics, and include any needed `MEDIA:` (e.g., chart screenshot) or `Source:` references.

## Required Files (optional but recommended)
- `scripts/ethereal_futures.py` – Python script that wraps Web3 calls:
  - `get_price(contract_address)`
  - `open_position(side, size, leverage)`
  - `close_position(position_id)`
  - `get_positions(address)`
- `reference/api.md` – Brief description of Ethereal’s REST/GraphQL endpoints and contract ABIs.

## Safety Guidelines
- **Never expose a real private key**. The script should read the key from an environment variable (`ETHEREAL_PK`) set by the user.
- All `exec` calls that could move funds require explicit `/approve` from you before execution.
- Perform a *risk check* (collateral vs. liquidation price) before opening a leveraged position; if risk > 80 % of collateral, ask for confirmation.
- Log every trade to `memory/trade_log_YYYY-MM-DD.md` for auditability.

## Example Interactions
### 1. Query future price
User: "Berapa harga futures ETH/USDT pada Ethereal?"
- Agent calls `web_fetch` to the public ticker endpoint, returns price and timestamp.

### 2. Open a leveraged long position
User: "Buka posisi long 5 ETH dengan leverage 10x pada kontrak ETH/USDT futures."
- Agent:
  1. Retrieves current price.
  2. Calculates required collateral.
  3. Shows risk estimate and asks for confirmation.
  4. After you `/approve` the generated command, runs:
     ```
     exec command="python scripts/ethereal_futures.py open --side long --size 5 --leverage 10" timeout=30
     ```
  5. Returns transaction hash and updated position summary.

### 3. Close a position
User: "Tutup semua posisi long saya di ETH/USDT futures."
- Agent lists open positions, asks which one(s) to close, then runs `exec` with `close` arguments after approval.

### 4. Risk monitoring
User: "Berikan laporan risiko untuk semua posisi futures saya."
- Agent reads positions via script, computes liquidation price, and returns a table.

## Extending the Agent
- Add more contract addresses in `reference/contracts.md`.
- Implement additional strategies (grid, stop‑loss) in `scripts/strategies/` and expose them via new intents.
- Connect to a notification service (e.g., Telegram) by adding a script in `scripts/notify.py` and calling it after each trade.

## End of Skill
This skill provides a safe, step‑by‑step framework for futures trading on Ethereal. Adjust the description, add more reference files, or refine the Python script as your workflow evolves.
