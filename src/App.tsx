import React, { useEffect, useState } from 'react';
import { ethers } from 'ethers';
import clownAbi from './abi/ClownBeatdown.json';
import src20Abi from './abi/SRC20.json';
import { CLOWN_ADDRESS, SRC20_ADDRESS } from './config';

function App() {
  const [provider, setProvider] = useState<ethers.BrowserProvider | null>(null);
  const [signer, setSigner] = useState<ethers.Signer | null>(null);
  const [account, setAccount] = useState<string>('');
  const [clown, setClown] = useState<ethers.Contract | null>(null);
  const [src20, setSrc20] = useState<ethers.Contract | null>(null);
  const [secret, setSecret] = useState<string>('');
  const [msg, setMsg] = useState<string>('');
  const [stamina, setStamina] = useState<string>('');
  const [roundNum, setRoundNum] = useState<string>('');
  const [secretsCnt, setSecretsCnt] = useState<string>('');
  const [hits, setHits] = useState<string>('0');

  // Inisialisasi provider, signer, dan kontrak
  useEffect(() => {
    const init = async () => {
      if (!(window as any).ethereum) {
        setMsg('MetaMask belum terpasang.');
        return;
      }
      const prov = new ethers.BrowserProvider((window as any).ethereum);
      setProvider(prov);
      await prov.send('eth_requestAccounts', []);
      const sgn = await prov.getSigner();
      setSigner(sgn);
      const addr = await sgn.getAddress();
      setAccount(addr);

      const clownContract = new ethers.Contract(CLOWN_ADDRESS, clownAbi, sgn);
      setClown(clownContract);

      const tokenContract = new ethers.Contract(SRC20_ADDRESS, src20Abi, sgn);
      setSrc20(tokenContract);
    };
    init();
  }, []);

  // Refresh contract stats whenever contract or account changes
  useEffect(() => {
    if (!clown || !account) return;
    const fetchStats = async () => {
      try {
        const [stam, rnd, secCnt] = await Promise.all([
          clown.clownStamina(),
          clown.round(),
          clown.secretsCount()
        ]);
        setStamina(stam.toString());
        setRoundNum(rnd.toString());
        setSecretsCnt(secCnt.toString());
        const hitCount = await clown.hitsPerRound(rnd, account);
        setHits(hitCount.toString());
      } catch (e) {
        console.error('Error fetching stats', e);
      }
    };
    fetchStats();
  }, [clown, account]);

  const addSecret = async () => {
    if (!clown) return;
    try {
      setMsg('Mengirim addSecret…');
      const tx = await clown.addSecret(secret);
      await tx.wait();
      setMsg('Secret berhasil ditambahkan.');
    } catch (e) {
      console.error(e);
      setMsg('Gagal menambahkan secret.');
    }
  };

  const hit = async () => {
    if (!clown) return;
    try {
      setMsg('Mengirim hit…');
      const tx = await clown.hit();
      await tx.wait();
      setMsg('Hit berhasil.');
    } catch (e) {
      console.error(e);
      setMsg('Gagal hit.');
    }
  };

  const robAndReward = async () => {
    if (!clown) return;
    try {
      setMsg('Mencoba rob & reward…');
      const tx = await clown.robAndReward();
      const receipt = await tx.wait();
      // event atau return value tidak diproses di sini – hanya menampilkan pesan sukses
      setMsg('Rob berhasil, reward 1 SRC20 dikirim ke Anda.');
    } catch (e) {
      console.error(e);
      setMsg('Rob gagal (stamina belum 0 atau belum berkontribusi).');
    }
  };

  // Rob tanpa reward (view only)
  const rob = async () => {
    if (!clown) return;
    try {
      setMsg('Mengambil secret…');
      const secretBytes = await clown.rob();
      // Convert bytes to string (utf8) if possible
      let secretStr: string;
      try {
        secretStr = ethers.toUtf8String(secretBytes);
      } catch {
        secretStr = ethers.toUtf8String(secretBytes);
      }
      setMsg(`Secret: ${secretStr}`);
    } catch (e) {
      console.error(e);
      setMsg('Gagal mengambil secret. Pastikan stamina = 0 dan Anda sudah kontribusi.');
    }
  };

  // Reset clown (only when down)
  const resetClown = async () => {
    if (!clown) return;
    try {
      setMsg('Resetting...');
      const tx = await clown.reset();
      await tx.wait();
      setMsg('Reset selesai.');
    } catch (e) {
      console.error(e);
      setMsg('Reset gagal.');
    }
  };

  const checkBalance = async () => {
    if (!src20) return;
    const bal = await src20.balanceOf(account);
    const readable = ethers.formatUnits(bal, 18);
    alert(`Saldo SRC20 Anda: ${readable}`);
  };

  return (
    <div style={{ padding: '1rem', fontFamily: 'Arial, Helvetica, sans-serif' }}>
      <h2>🎪 Clown Beatdown UI</h2>
      <p><strong>Wallet:</strong> {account || 'Tidak terhubung'}</p>

      <div style={{ marginBottom: '0.8rem' }}>
        <label>Secret:&nbsp;</label>
        <input
          type="text"
          value={secret}
          onChange={e => setSecret(e.target.value)}
          placeholder="ketik secret"
        />
        <button onClick={addSecret} style={{ marginLeft: '0.5rem' }}>
          Add Secret
        </button>
      </div>

      <button onClick={hit} style={{ marginRight: '0.5rem' }}>
        Hit (kurangi stamina)
      </button>
      <button onClick={robAndReward} style={{ marginRight: '0.5rem' }}>
        Rob & Reward
      </button>
      <button onClick={checkBalance} style={{ marginRight: '0.5rem' }}>
        Cek Saldo SRC20
      </button>
      {/* Tambahan fungsi */}
      <button onClick={rob} style={{ marginRight: '0.5rem' }} disabled={stamina !== '0'}>
        Rob (tanpa reward)
      </button>
      <button onClick={resetClown} style={{ marginRight: '0.5rem' }} disabled={stamina !== '0'}>
        Reset Clown
      </button>
      {/* Statistik */}
      <div style={{ marginTop: '1rem' }}>
        <p>Stamina: {stamina || '-'} | Round: {roundNum || '-'} | Secrets: {secretsCnt || '-'} | Hits Anda: {hits}</p>
      </div>

      {msg && <p style={{ marginTop: '1rem', color: 'green' }}>{msg}</p>}
    </div>
  );
}

export default App;
