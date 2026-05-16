# nft-mint-agent

**Deskripsi**: Agent AI yang dapat membantu pengguna mencetak (mint) NFT pada blockchain Ethereum (atau jaringan kompatibel) menggunakan library Web3.js / ethers.js. Agent ini menyediakan perintah untuk:

1. **Menyambungkan ke wallet** – mengimpor private key atau menggunakan MetaMask via browser automation.
2. **Membuat metadata NFT** – menerima nama, deskripsi, gambar URL, dan menghasilkan file JSON metadata.
3. **Mengunggah aset ke IPFS** – melalui layanan publik (infura, pinata) atau node lokal.
4. **Mencetak NFT** – berinteraksi dengan smart contract ERC‑721 atau ERC‑1155 yang sudah dideploy, atau dapat mendepoy kontrak baru jika diperlukan.
5. **Mengecek status transaksi** – menampilkan hash, status konfirmasi, dan link explorer.

**Prasyarat**
- Node.js (v20+) terinstall.
- `npm install ethers axios form-data` atau paket serupa.
- Akun wallet dengan cukup ETH untuk gas.
- Akses ke endpoint RPC (Infura, Alchemy, atau node lokal).
- API key untuk layanan IPFS (misalnya Pinata) atau endpoint IPFS publik.

**Struktur folder**
```
skills/nft-mint-agent/
│   SKILL.md          # dokumentasi (ini)
│   package.json       # dependensi Node.js
│   mint.js            # skrip utama untuk mint NFT
│   ipfs.js            # helper upload ke IPFS
│   config.example.json# contoh config (RPC, API keys)
```

**Cara pakai**
1. Salin contoh konfigurasi dan isi dengan nilai Anda:
   ```bash
   cp config.example.json config.json
   # edit config.json sesuai dengan RPC URL, privateKey, dan IPFS API key
   ```
2. Install dependensi:
   ```bash
   npm install
   ```
3. Jalankan perintah mint:
   ```bash
   node mint.js --name "My NFT" --description "Deskripsi NFT" --image "path/to/image.png"
   ```
   Agent akan:
   - Mengunggah gambar ke IPFS dan mendapatkan CID.
   - Membuat metadata JSON dan mengunggahnya ke IPFS.
   - Memanggil fungsi `mint` pada kontrak ERC‑721 yang dikonfigurasi.
   - Menampilkan transaksi hash dan link explorer.

**Opsi tambahan**
- `--contract <address>`: alamat kontrak ERC‑721 yang sudah ada. Jika tidak diberikan, agent akan menyebarkan kontrak baru (dengan nama dan simbol yang diberikan lewat `--tokenName` dan `--tokenSymbol`).
- `--network <chain>`: pilih jaringan (mainnet, goerli, sepolia, polygon, etc.) – mengubah RPC endpoint.

**Keamanan**
- Private key disimpan hanya di file `config.json` lokal. Pastikan file ini tidak dibagikan.
- Semua interaksi dilakukan melalui node RPC yang terpercaya.
- Agent tidak menyimpan data pengguna di cloud.

**Catatan pengembangan**
- Untuk integrasi dengan browser (MetaMask), gunakan skill `browser-automation` untuk otomatisasi UI login.
- Jika ingin menambahkan fitur batch mint, ubah `mint.js` untuk menerima array metadata.

**Referensi**
- ERC‑721 standard: https://eips.ethereum.org/EIPS/eip-721
- ethers.js docs: https://docs.ethers.io/v5/
- IPFS Pinata API: https://pinata.cloud/documentation

---

*Skill ini dapat di‑install melalui ClawHub atau langsung dengan menyalin folder ke `~/.openclaw/workspace/skills/`.*
