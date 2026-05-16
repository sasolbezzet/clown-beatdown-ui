// SPDX-License-Identifier: MIT
// Generated minimal ABIs for SRC20 SDK. Replace with full ABIs if needed.

export const SRC20FactoryAbi = [
  // createToken(name:string, symbol:string, initialSupply:uint256, decimals:uint8)
  {
    "inputs": [
      { "internalType": "string", "name": "name", "type": "string" },
      { "internalType": "string", "name": "symbol", "type": "string" },
      { "internalType": "uint256", "name": "initialSupply", "type": "uint256" },
      { "internalType": "uint8", "name": "decimals", "type": "uint8" }
    ],
    "name": "createToken",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  // events
  {
    "anonymous": false,
    "inputs": [
      { "indexed": true, "internalType": "address", "name": "token", "type": "address" },
      { "indexed": false, "internalType": "address", "name": "owner", "type": "address" }
    ],
    "name": "TokenCreated",
    "type": "event"
  }
];

export const SRC20TokenAbi = [
  { "inputs": [], "name": "name", "outputs": [{ "type": "string" }], "stateMutability": "view", "type": "function" },
  { "inputs": [], "name": "symbol", "outputs": [{ "type": "string" }], "stateMutability": "view", "type": "function" },
  { "inputs": [], "name": "decimals", "outputs": [{ "type": "uint8" }], "stateMutability": "view", "type": "function" },
  { "inputs": [], "name": "owner", "outputs": [{ "type": "address" }], "stateMutability": "view", "type": "function" },
  { "inputs": [], "name": "totalSupply", "outputs": [{ "type": "uint256" }], "stateMutability": "view", "type": "function" },
  // ... additional SRC20 functions (transfer, approve, balanceOf, etc.) can be added as needed
];
