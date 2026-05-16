#!/usr/bin/env bash

# ------------------------------------------------------------
# Seismic Development Suite – Automated Setup
# ------------------------------------------------------------
# This script performs the full installation required to
# develop, test, and deploy SRC20 contracts.
# ------------------------------------------------------------
# Prasyarat: curl, git, bash (atau zsh). Pastikan Anda
# menjalankan script ini pada mesin Ubuntu/macOS atau pada
# Windows melalui WSL2.
# ------------------------------------------------------------
set -e

# 1. Install Rust + Cargo (jika belum ada)
if ! command -v rustc >/dev/null 2>&1; then
  echo "[+] Menginstall Rust..."
  curl https://sh.rustup.rs -sSf | sh -s -- -y
  # Muat environment baru (bash atau zsh)
  if [[ -f "$HOME/.bashrc" ]]; then
    source "$HOME/.bashrc"
  fi
  if [[ -f "$HOME/.zshrc" ]]; then
    source "$HOME/.zshrc"
  fi
else
  echo "[i] Rust sudah terpasang (versi $(rustc --version))"
fi

# 2. Install sfoundryup (installer Foundry khusus Seismic)
if ! command -v sfoundryup >/dev/null 2>&1; then
  echo "[+] Menginstall sfoundryup..."
  curl -L \
       -H "Accept: application/vnd.github.v3.raw" \
       "https://api.github.com/repos/SeismicSystems/seismic-foundry/contents/sfoundryup/install?ref=seismic" \
       | bash
else
  echo "[i] sfoundryup sudah tersedia (versi $(sfoundryup --version || true))"
fi

# 3. Pasang sforge, sanvil, ssolc melalui sfoundryup
echo "[+] Menjalankan sfoundryup untuk menginstall sforge, sanvil, ssolc..."
sfoundryup

# 4. Pastikan tools berada di PATH
if [[ -f "$HOME/.bashrc" ]]; then
  source "$HOME/.bashrc"
fi
if [[ -f "$HOME/.zshrc" ]]; then
  source "$HOME/.zshrc"
fi

# 5. Verifikasi instalasi
echo "[+] Memverifikasi versi tools:"
echo -n "sforge: " && sforge --version
echo -n "sanvil: " && sanvil --version
echo -n "ssolc: " && ssolc --version

# 6. Install dependensi Node.js dalam proyek contoh (my-src20)
if [ -d "my-src20" ]; then
  echo "[+] Menginstall dependensi Node.js untuk contoh proyek (my-src20)..."
  cd my-src20
  # Pastikan npm tersedia (biasanya sudah terinstall bersama Node.js)
  if ! command -v npm >/dev/null 2>&1; then
    echo "[!] npm tidak ditemukan. Silakan instal Node.js terlebih dahulu."
    exit 1
  fi
  npm install
  cd ..
else
  echo "[!] Direktori my-src20 tidak ditemukan. Pastikan proyek contoh ada."
fi

echo "
=== Setup selesai! ===

Langkah selanjutnya:
1. Buka file .env di my-src20/ dan isi SEISMIC_RPC_URL serta PRIVATE_KEY Anda.
2. Jalankan unit‑test:  cd my-src20 && sforge test -vv
3. Deploy kontrak:    source my-src20/.env && forge create src/SRC20.sol:SRC20 \
     --rpc-url $SEISMIC_RPC_URL \
     --private-key $PRIVATE_KEY \
     --constructor-args $(cast abi-encode "suint256" 1000000)
4. Salin alamat kontrak ke src/interact.js (variabel CONTRACT_ADDRESS).
5. Interaksi:          node src/interact.js
"