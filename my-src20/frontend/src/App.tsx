import React, { useEffect, useState } from 'react';
import { createWalletClient, http, parseEther } from 'viem';
import { privateKeyToAccount } from 'viem/accounts';
import ClownBeatdownAbi from './abi/ClownBeatdown.json';

const rpcUrl = import.meta.env.VITE_RPC_URL as string;
const privateKey = import.meta.env.VITE_PRIVATE_KEY as string;
const contractAddress = import.meta.env.VITE_CONTRACT_ADDRESS as `0x${string}`;

function App() {
  const [client, setClient] = useState<any>(null);
  const [connected, setConnected] = useState(false);
  const [status, setStatus] = useState<string>('');

  useEffect(() => {
    if (rpcUrl && privateKey) {
      const account = privateKeyToAccount(privateKey as `0x${string}`);
      const viemClient = createWalletClient({
        chain: undefined, // Seismic testnet chain not pre‑defined; using custom RPC
        transport: http(rpcUrl),
        account,
      });
      setClient({ viemClient, account });
    }
  }, []);

  const callContract = async (method: string, args: any[] = []) => {
    if (!client) return;
    try {
      const result = await client.viemClient.writeContract({
        address: contractAddress,
        abi: ClownBeatdownAbi as any,
        functionName: method,
        args,
        // In Seismic you may need to add `type: 'suint256'` for shielded params
      });
      setStatus(`✅ ${method} called, tx hash: ${result}`);
    } catch (e: any) {
      setStatus(`❌ Error calling ${method}: ${e.message}`);
    }
  };

  return (
    <div style={{ padding: '1rem', fontFamily: 'sans-serif' }}>
      <h1>Clown Beatdown DApp</h1>
      <p>RPC: {rpcUrl}</p>
      <p>Contract: {contractAddress}</p>
      <button onClick={() => callContract('addSecret', ['my secret'])}>Add Secret</button>{' '}
      <button onClick={() => callContract('hit')}>Hit</button>{' '}
      <button onClick={() => callContract('rob')}>Rob</button>{' '}
      <button onClick={() => callContract('robAndReward')}>Rob & Reward</button>{' '}
      <button onClick={() => callContract('reset')}>Reset</button>{' '}
      <button onClick={() => callContract('stats')}>Stats</button>
      <pre style={{ marginTop: '1rem' }}>{status}</pre>
    </div>
  );
}

export default App;
