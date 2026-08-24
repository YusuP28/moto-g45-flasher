#!/bin/bash

clear
echo "================================================="
echo "   ALL-IN-ONE MOTO G45 5G FLASHING TOOL"
echo "================================================="

# 1. Setup Izin Penyimpanan
echo -e "\n[1/3] Menyiapkan izin penyimpanan..."
termux-setup-storage
echo "-> INSTRUKSI: Jika muncul jendela pop-up di layar, klik 'ALLOW / IZINKAN'."
read -p "Tekan [ENTER] jika sudah memberikan izin penyimpanan..."

# 2. Update Sistem & Install Tools
echo -e "\n[2/3] Memperbarui sistem dan menginstal android-tools..."
echo "-> INSTRUKSI: Jika muncul pertanyaan konfirmasi, ketik 'y' lalu tekan [ENTER]."
read -p "Tekan [ENTER] untuk melanjutkan pembaruan sistem..."

termux-change-repo
apt update && apt full-upgrade -y
pkg install android-tools -y

# Menyiapkan folder dari internal ke home Termux
cd ~/
rm -rf FLASHABLE\ FOGOS\ TERMUX\ ROOT
cp -r /sdcard/FLASHABLE\ FOGOS\ TERMUX\ ROOT ./

# 3. Masuk Root & Jalankan Flashing
echo -e "\n[3/3] Membuka akses root dan menjalankan proses flashing..."
echo "-> INSTRUKSI: Ketik 'su' lalu tekan [ENTER] (klik GRANT/IZINKAN jika muncul pop-up Superuser)."
read -p "Tekan [ENTER] untuk mulai mengeksekusi perintah root..."

su -c "export PATH=/data/data/com.termux/files/usr/bin:\$PATH && cd /data/data/com.termux/files/home/FLASHABLE\ FOGOS\ TERMUX\ ROOT && bash flash.sh"
