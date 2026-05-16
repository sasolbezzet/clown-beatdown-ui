#!/usr/bin/env node

/**
 * Simple NFT minting script.
 * Usage: node mint.js --name "My NFT" --description "Desc" --image ./path.png [--contract 0x...] [--network goerli]
 *
 * This is a minimal example. Replace the placeholder functions with real implementations.
 */

import { ethers } from 'ethers';
import fs from 'fs';
import path from 'path';
import axios from 'axios';
import FormData from 'form-data';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Simple arg parser
const args = process.argv.slice(2);
const getArg = (key) => {
  const idx = args.indexOf(`--${key}`);
  if (idx !== -1 && idx + 1 < args.length) return args[idx + 1];
  return null;
};

const name = getArg('name');
const description = getArg('description');
const imagePath = getArg('image');
const contractAddress = getArg('contract');
const network = getArg('network') || 'goerli';

if (!name || !description || !imagePath) {
  console.error('Missing required arguments.');
  process.exit(1);
}

// Load config
const configPath = path.resolve(__dirname, 'config.json');
if (!fs.existsSync(configPath)) {
  console.error('Config file not found. Copy config.example.json to config.json and fill values.');
  process.exit(1);
}
const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));

// Helper: upload file to Pinata (IPFS)
async function uploadToPinata(filePath) {
  const url = `https://api.pinata.cloud/pinning/pinFileToIPFS`;
  const data = new FormData();
  data.append('file', fs.createReadStream(filePath));
  const res = await axios.post(url, data, {
    maxContentLength: Infinity,
    maxBodyLength: Infinity,
    headers: {
      'Content-Type': `multipart/form-data; boundary=${data.getBoundary()}`,
      pinata_api_key: config.ipfsPinataApiKey,
      pinata_secret_api_key: config.ipfsPinataSecretApiKey,
    },
  });
  return `ipfs://${res.data.IpfsHash}`;
}

async function main() {
  // 1. Upload image
  console.log('Uploading image to IPFS...');
  const imageUri = await uploadToPinata(path.resolve(imagePath));
  console.log('Image URI:', imageUri);

  // 2. Create metadata JSON
  const metadata = {
    name,
    description,
    image: imageUri,
    attributes: [],
  };
  const metadataPath = path.join(__dirname, 'metadata.json');
  fs.writeFileSync(metadataPath, JSON.stringify(metadata, null, 2));

  // 3. Upload metadata
  console.log('Uploading metadata to IPFS...');
  const metadataUri = await uploadToPinata(metadataPath);
  console.log('Metadata URI:', metadataUri);

  // 4. Setup ethers provider & wallet
  const provider = new ethers.JsonRpcProvider(config.rpcUrl);
  const wallet = new ethers.Wallet(config.privateKey, provider);

  // 5. Interact with contract
  const iface = new ethers.Interface([
    'function mint(address to, string memory tokenURI) public returns (uint256)'
  ]);
  const contract = new ethers.Contract(contractAddress, iface, wallet);

  console.log('Minting NFT...');
  const tx = await contract.mint(wallet.address, metadataUri);
  console.log('Transaction submitted. Hash:', tx.hash);
  const receipt = await tx.wait();
  console.log('Transaction confirmed in block', receipt.blockNumber);
}

main().catch((err) => {
  console.error('Error:', err);
  process.exit(1);
});
