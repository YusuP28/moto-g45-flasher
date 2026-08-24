#!/bin/bash

clear
echo "================================================="
echo "   MOTO G45 ALL-IN-ONE MULTI-VERSION FLASHER"
echo "================================================="

# 1. Setup Izin Penyimpanan
echo -e "\n[1/4] Menyiapkan izin penyimpanan..."
termux-setup-storage
echo "-> INSTRUKSI: Jika muncul jendela pop-up, klik 'ALLOW / IZINKAN'."
read -p "Tekan [ENTER] jika sudah memberikan izin penyimpanan..."

# 2. Update Sistem & Install Tools
echo -e "\n[2/4] Memperbarui sistem dan menginstal android-tools..."
echo "-> INSTRUKSI: Jika muncul pertanyaan konfirmasi, ketik 'y' lalu tekan [ENTER]."
read -p "Tekan [ENTER] untuk melanjutkan pembaruan sistem..."

termux-change-repo
apt update && apt full-upgrade -y
pkg install android-tools -y

# 3. Menyalin Folder dari Internal ke Home Termux
echo -e "\n[3/4] Menyalin file firmware ke lingkungan Termux..."
cd ~/
rm -rf FLASHABLE\ FOGOS\ TERMUX\ ROOT
cp -r /sdcard/FLASHABLE\ FOGOS\ TERMUX\ ROOT ./

# Masuk ke direktori kerja
cd ~/FLASHABLE\ FOGOS\ TERMUX\ ROOT

# 4. Menu Pilihan Versi Android (Menggunakan read -n 1 agar langsung merespons)
echo -e "\n================================================="
echo "           PILIH VERSI ANDROID"
echo "================================================="
echo " [1] Android 14 (Menggunakan firmware14 & flash14.sh)"
echo " [2] Android 15 (Menggunakan firmware15 & flash15.sh)"
echo "================================================="
echo -n "Silakan tekan angka pilihan Anda (1 atau 2): "
read -n 1 pilihan
echo ""

if [ "$pilihan" = "1" ]; then
    echo -e "\n-> Anda memilih Android 14. Menjalankan flash14.sh..."
    SCRIPT_NAME="flash14.sh"
elif [ "$pilihan" = "2" ]; then
    echo -e "\n-> Anda memilih Android 15. Menjalankan flash15.sh..."
    SCRIPT_NAME="flash15.sh"
else
    echo -e "\n[X] Pilihan tidak valid! Anda menekan tombol yang salah. Harap ulangi dari awal."
    exit 1
fi

# 5. Membuka Root dan Menjalankan Flashing Sesuai Pilihan
echo -e "\n[4/4] Membuka akses root dan menjalankan proses flashing..."
echo "-> INSTRUKSI: Ketik 'su' lalu tekan [ENTER] (klik GRANT/IZINKAN jika muncul pop-up Superuser)."
read -p "Tekan [ENTER] untuk mulai mengeksekusi perintah root..."

su -c "export PATH=/data/data/com.termux/files/usr/bin:\$PATH && cd /data/data/com.termux/files/home/FLASHABLE\ FOGOS\ TERMUX\ ROOT && bash $SCRIPT_NAME"
