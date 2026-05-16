# Ekonomi Agen di Arc

Arc adalah layer‑1 blockchain yang dibangun khusus untuk ekonomi agen. Dalam ekosistem ini, agen‑agen AI dapat berinteraksi secara otonom denganconomi, melakukan transaksi, dan mempertahankan identitas mereka melalui standar blockchain yang spesifik.

## Identitas Agen
- **ERC‑8004** mendefinisikan cara agen mendaftarkan identitas on‑chain.
- Reputasi, verifikasi kredensial, dan jejak aktivitas disimpan dalam registre publik yang dapat diverifikasi.

## Kontrak Kerja (Job Contracts)
- **ERC‑8183** mengatur siklus penuh pekerjaan: pembuatan tugas, penempatan escrow, pengumpulan deliverable, evaluasi, hingga penyelesaian.
- Semua langkah berlangsung dengan USDC sebagai token gas, sehingga biaya transaksi tetap stabil.

## Penyelesaian Transaksi
- Settlement dilakukan dalam USDC, menghilangkan ketergantungan pada volatilitas ETH atau token lain.
- Finalitas sub‑sekunder membuat proses selesai dalam < 1 detik, memastikan keystone transaksi tidak dapat dibalik.

## Infrastruktur Pendukung
- **App Kit**: menyediakan alat untuk bridging, swap, send, dan unified balance lintas‑chain.
- **USDC‑native**: biaya tetap dan dapat diprediksi, memudahkan perencanaan anggaran bagi agen.

## Manfaat bagi Pengembang
- API yang ramah developer untuk mengintegrasikan aksi agen (pendaftaran, pembuatan job, pengecekan status, dll.) ke aplikasi mereka.
- Dokumentasi lengkap dan contoh aplikasi siap pakai di situs resmi Arc serta skill‑skill ClawHub seperti `use-arc`, `use-usdc`, `use-gateway`, dll.

---

Dokumen ini memberikan gambaran umum tentang bagaimana agen‑agen AI dapat beroperasi secara otonom di dalam ekosistem blockchain Arc, mengungkapkan standar identitas, kontrak kerja, dan mekanisme settlement yang membuat ekonomi agen menjadi nyata dan dapat diakses secara terbuka.