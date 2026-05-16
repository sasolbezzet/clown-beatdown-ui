# MyShieldedToken (SRC20)

Repository contoh untuk membuat token **SRC20** di jaringan **Seismic**.

## Isi
- `src/SRC20.sol` – kontrak token yang menggunakan tipe shielded `suint256`.
- `test/SRC20.t.sol` – unit‑test yang dijalankan dengan `sforge test`.
- `foundry.toml` – konfigurasi Foundry.
- `package.json` & `src/interact.js` – contoh skrip JavaScript menggunakan **Viem** untuk berinteraksi dengan kontrak.
- `.env` – placeholder untuk RPC URL dan private key (harus di‑isi sendiri).

## Langkah selanjutnya
1. Install Rust, `sforge`, Foundry, dan Node.js (lihat instruksi di pesan sebelumnya).
2. Jalankan `sforge test -vv` untuk memastikan kontrak berfungsi.
3. Deploy dengan `forge create …`.
4. Interaksi lewat `node src/interact.js`.
