#!/bin/bash

# Pastikan skrip berhenti jika ada error fatal
set -e

# Kode Warna ANSI
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
NC='\033[0m' # No Color

# Fungsi Animasi Loading Spinner
tampil_loading() {
    local pid=$1
    local pesan=$2
    local spin='-\|/'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) % 4 ))
        printf "\r${YELLOW}[${spin:$i:1}]${NC} $pesan"
        sleep 0.1
    done
    printf "\r"
}

clear
echo -e "${CYAN}=================================================${NC}"
echo -e "${GREEN}    MOTO G45 ALL-IN-ONE MULTI-VERSION FLASHER    ${NC}"
echo -e "${CYAN}=================================================${NC}"

# 1. Setup Izin Penyimpanan
echo -e "\n${MAGENTA}[1/4] Menyiapkan izin penyimpanan...${NC}"
termux-setup-storage
echo -e "${YELLOW}-> INSTRUKSI: Jika muncul jendela pop-up, klik 'ALLOW / IZINKAN'.${NC}"
read -p "Tekan [ENTER] jika sudah memberikan izin penyimpanan..."

# 2. Update Sistem & Install Tools
echo -e "\n${MAGENTA}[2/4] Memperbarui sistem dan menginstal android-tools...${NC}"
echo -e "${YELLOW}-> INSTRUKSI: Jika muncul pertanyaan konfirmasi, ketik 'y' lalu tekan [ENTER].${NC}"
read -p "Tekan [ENTER] untuk melanjutkan pembaruan sistem..."

termux-change-repo
( apt update && apt full-upgrade -y && pkg install android-tools -y ) > /dev/null 2>&1 &
pid=$!
tampil_loading $pid "Sedang mengunduh dan memperbarui paket sistem..."
echo -e "${GREEN}[✔] Paket android-tools berhasil diinstal!${NC}"

# 3. Menyalin Folder dari Internal ke Home Termux
echo -e "\n${MAGENTA}[3/4] Menyalin file firmware ke lingkungan Termux...${NC}"
cd ~/
if [ -d "/sdcard/FLASHABLE FOGOS TERMUX ROOT" ]; then
    ( rm -rf FLASHABLE\ FOGOS\ TERMUX\ ROOT && cp -r /sdcard/FLASHABLE\ FOGOS\ TERMUX\ ROOT ./ ) > /dev/null 2>&1 &
    pid=$!
    tampil_loading $pid "Menyalin file firmware besar (harap tunggu)..."
    echo -e "${GREEN}[✔] File firmware berhasil disalin ke Termux!${NC}"
else
    echo -e "\n${RED}[X] Error: Folder '/sdcard/FLASHABLE FOGOS TERMUX ROOT' tidak ditemukan!${NC}"
    echo -e "${RED}Pastikan Anda sudah menaruh folder tersebut di Penyimpanan Internal utama HP.${NC}"
    exit 1
fi

# Masuk ke direktori kerja
cd ~/FLASHABLE\ FOGOS\ TERMUX\ ROOT

# 4. Menu Pilihan Versi Android Interaktif
echo -e "\n${CYAN}================================================="
echo -e "              ${GREEN}PILIH VERSI ANDROID${CYAN}"
echo -e "================================================="
echo -e " ${YELLOW}[1]${NC} Android 14 ${BLUE}(firmware14 & flash14.sh)${NC}"
echo -e " ${YELLOW}[2]${NC} Android 15 ${BLUE}(firmware15 & flash15.sh)${NC}"
echo -e "${CYAN}=================================================${NC}"
echo -n -e "${MAGENTA}Silakan tekan angka pilihan Anda (1 atau 2): ${NC}"
read -n 1 pilihan
echo ""

if [ "$pilihan" = "1" ]; then
    echo -e "\n${GREEN}-> Anda memilih Android 14. Memuat flash14.sh...${NC}"
    SCRIPT_NAME="flash14.sh"
elif [ "$pilihan" = "2" ]; then
    echo -e "\n${GREEN}-> Anda memilih Android 15. Memuat flash15.sh...${NC}"
    SCRIPT_NAME="flash15.sh"
else
    echo -e "\n${RED}[X] Pilihan tidak valid! Anda menekan tombol yang salah. Harap ulangi dari awal.${NC}"
    exit 1
fi

# 5. Membuka Root dan Menjalankan Flashing Sesuai Pilihan
echo -e "\n${MAGENTA}[4/4] Membuka akses root dan menjalankan proses flashing...${NC}"
echo -e "${YELLOW}-> INSTRUKSI: Ketik 'su' lalu tekan [ENTER] (klik GRANT/IZINKAN jika muncul pop-up Superuser).${NC}"
read -p "Tekan [ENTER] untuk mulai mengeksekusi perintah root..."

su -c "export PATH=/data/data/com.termux/files/usr/bin:\$PATH && cd /data/data/com.termux/files/home/FLASHABLE\ FOGOS\ TERMUX\ ROOT && bash $SCRIPT_NAME"
