#!/bin/bash

# Palet Warna ANSI Estetik
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
NC='\033[0m' # No Color

# Fungsi Animasi Spinner
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
echo -e "${CYAN}┌─────────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${GREEN}     MOTO G45 ALL-IN-ONE MULTI-VERSION FLASHER   ${CYAN}│${NC}"
echo -e "${CYAN}└─────────────────────────────────────────────────┘${NC}"

# 1. Setup Izin Penyimpanan
echo -e "\n${MAGENTA}[1/3] Menyiapkan izin penyimpanan...${NC}"
termux-setup-storage
echo -e "${YELLOW}-> INSTRUKSI: Jika muncul jendela pop-up, klik 'ALLOW / IZINKAN'.${NC}"
read -p "Tekan [ENTER] jika sudah memberikan izin penyimpanan..."

# 2. Update Sistem & Install Tools
echo -e "\n${MAGENTA}[2/3] Memperbarui sistem dan menginstal android-tools...${NC}"
echo -e "${YELLOW}-> INSTRUKSI: Jika muncul pertanyaan konfirmasi, ketik 'y' lalu tekan [ENTER].${NC}"
read -p "Tekan [ENTER] untuk melanjutkan pembaruan sistem..."

termux-change-repo
( apt update && apt full-upgrade -y && pkg install android-tools -y ) > /dev/null 2>&1 &
pid=$!
tampil_loading $pid "Mengunduh dan memasang utilitas android-tools..."
echo -e "${GREEN}[✔] Paket android-tools berhasil terpasang dengan sempurna!${NC}"

# 3. Validasi Keberadaan Folder
echo -e "\n${MAGENTA}[3/3] Memeriksa struktur direktori firmware...${NC}"
TARGET_PATH="/sdcard/FLASHABLE_FOGOS_TERMUX_ROOT"

if [ -d "$TARGET_PATH" ]; then
    echo -e "${GREEN}[✔] Folder target ditemukan di penyimpanan internal!${NC}"
else
    echo -e "\n${RED}[X] Error: Folder '$TARGET_PATH' tidak ditemukan!${NC}"
    echo -e "${YELLOW}Pastikan Anda membuat folder dengan nama tepat 'FLASHABLE_FOGOS_TERMUX_ROOT' di memori internal utama HP.${NC}"
    exit 1
fi

# 4. Menu Pilihan Versi Android Interaktif
echo -e "\n${CYAN}┌─────────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│               ${GREEN}PILIH VERSI ANDROID${CYAN}               │${NC}"
echo -e "${CYAN}├─────────────────────────────────────────────────┤${NC}"
echo -e "${CYAN}│${NC}  ${YELLOW}[1]${NC} Android 14 ${BLUE}(firmware14 & flash14.sh)${NC}       ${CYAN}│${NC}"
echo -e "${CYAN}│${NC}  ${YELLOW}[2]${NC} Android 15 ${BLUE}(firmware15 & flash15.sh)${NC}       ${CYAN}│${NC}"
echo -e "${CYAN}└─────────────────────────────────────────────────┘${NC}"
echo -n -e "${MAGENTA}Silakan ketik angka pilihan Anda (1 atau 2): ${NC}"
read -n 1 pilihan
echo ""

if [ "$pilihan" = "1" ]; then
    echo -e "\n${GREEN}-> Mengaktifkan mode skrip untuk Android 14...${NC}"
    SCRIPT_NAME="flash14.sh"
elif [ "$pilihan" = "2" ]; then
    echo -e "\n${GREEN}-> Mengaktifkan mode skrip untuk Android 15...${NC}"
    SCRIPT_NAME="flash15.sh"
else
    echo -e "\n${RED}[X] Pilihan tidak valid! Skrip dihentikan.${NC}"
    exit 1
fi

# 5. Eksekusi Otomatis Langsung ke Folder Penyimpanan Internal dengan Root
echo -e "\n${CYAN}┌─────────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${GREEN}         MENJALANKAN SKRIP FLASHING...           ${CYAN}│${NC}"
echo -e "${CYAN}└─────────────────────────────────────────────────┘${NC}"
echo -e "${YELLOW}-> INSTRUKSI: Klik 'GRANT/IZINKAN' jika muncul izin Superuser.${NC}"
read -p "Tekan [ENTER] untuk mulai mengeksekusi proses flashing..."

# Menjalankan perintah root dengan path absolut dan langsung mengeksekusi skrip di dalam foldernya
su -c "export PATH=/data/data/com.termux/files/usr/bin:\$PATH && cd '$TARGET_PATH' && sh $SCRIPT_NAME"
