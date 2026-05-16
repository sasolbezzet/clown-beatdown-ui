# Clown Beatdown DApp

Ini adalah DApp React + Vite yang berinteraksi dengan kontrak **Clown Beatdown** pada jaringan **Seismic Testnet**.

- Pastikan file `.env` di `my-src20/frontend/` berisi:
  ```
  VITE_RPC_URL=https://gcp-1.seismictest.net/rpc
  VITE_PRIVATE_KEY=0xYOUR_PRIVATE_KEY
  VITE_CONTRACT_ADDRESS=0xYOUR_CONTRACT_ADDRESS
  ```
- Jalankan `npm ci && npm run dev` untuk menguji secara lokal.
- Build produksi dengan `npm run build` dan GitHub Actions akan mem‑publish otomatis ke GitHub Pages.
