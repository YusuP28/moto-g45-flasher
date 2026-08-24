
#!/bin/sh

# Palet Warna ANSI Estetik
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
NC='\033[0m' # No Color

clear
echo "┌─────────────────────────────────────────────────┐"
echo "│${GREEN}     MOTO G45 ALL-IN-ONE MULTI-VERSION FLASHER   ${NC}│"
echo "└─────────────────────────────────────────────────┘"

# 1. Setup Izin Penyimpanan
echo ""
echo "${MAGENTA}📂 [1/3] Menyiapkan izin penyimpanan...${NC}"
termux-setup-storage
echo "${YELLOW}ℹ️  INSTRUKSI: Jika muncul jendela pop-up, klik 'ALLOW / IZINKAN'.${NC}"
read -p "Tekan [ENTER] jika sudah memberikan izin penyimpanan..."

# 2. Update Sistem & Install Tools
echo ""
echo "${MAGENTA}⚙️  [2/3] Memperbarui sistem dan menginstal android-tools...${NC}"
echo "${YELLOW}ℹ️  INSTRUKSI: Jika muncul pertanyaan konfirmasi, ketik 'y' lalu tekan [ENTER].${NC}"
read -p "Tekan [ENTER] untuk melanjutkan pembaruan sistem..."

termux-change-repo
echo "${YELLOW}⏳ Sedang memperbarui repositori dan menginstal utilitas...${NC}"
apt update && apt full-upgrade -y
pkg install android-tools -y
echo "${GREEN}✔ Paket android-tools berhasil terpasang dengan sempurna!${NC}"

# 3. Validasi Keberadaan Folder Utama
echo ""
echo "${MAGENTA}🔍 [3/3] Memeriksa struktur direktori firmware...${NC}"
TARGET_PATH="/sdcard/FLASHABLE_FOGOS_TERMUX_ROOT"

if [ -d "$TARGET_PATH" ]; then
    echo "${GREEN}✔ Folder target ditemukan di penyimpanan internal!${NC}"
else
    echo ""
    echo "${RED}❌ Error: Folder '$TARGET_PATH' tidak ditemukan!${NC}"
    echo "${YELLOW}⚠️  Pastikan Anda membuat folder dengan nama tepat 'FLASHABLE_FOGOS_TERMUX_ROOT' di memori internal utama HP.${NC}"
    exit 1
fi

# 4. Menu Pilihan Versi Android Interaktif
echo ""
echo "┌─────────────────────────────────────────────────┐"
echo "│               ${GREEN}PILIH VERSI ANDROID${NC}               │"
echo "├─────────────────────────────────────────────────┤"
echo "│  ${YELLOW}[1]${NC} Android 14 ${BLUE}(firmware14 & flash14.sh)${NC}       │"
echo "│  ${YELLOW}[2]${NC} Android 15 ${BLUE}(firmware15 & flash15.sh)${NC}       │"
echo "└─────────────────────────────────────────────────┘"
printf "${MAGENTA}👉 Silakan ketik angka pilihan Anda (1 atau 2): ${NC}"
read -n 1 pilihan
echo ""

if [ "$pilihan" = "1" ]; then
    echo ""
    echo "${GREEN}🚀 Mengaktifkan skrip eksekusi untuk Android 14...${NC}"
    SCRIPT_NAME="flash14.sh"
elif [ "$pilihan" = "2" ]; then
    echo ""
    echo "${GREEN}🚀 Mengaktifkan skrip eksekusi untuk Android 15...${NC}"
    SCRIPT_NAME="flash15.sh"
else
    echo ""
    echo "${RED}❌ Pilihan tidak valid! Skrip dihentikan.${NC}"
    exit 1
fi

# 5. Eksekusi Otomatis ke Folder Penyimpanan Internal dengan Root
echo ""
echo "┌─────────────────────────────────────────────────┐"
echo "│${CYAN}         MENJALANKAN MODUL FLASHING...           ${NC}│"
echo "└─────────────────────────────────────────────────┘"
echo "${YELLOW}ℹ️  INSTRUKSI: Klik 'GRANT/IZINKAN' jika muncul izin Superuser.${NC}"
read -p "Tekan [ENTER] untuk mulai mengeksekusi proses flashing..."

su -c "export PATH=/data/data/com.termux/files/usr/bin:\$PATH && cd '$TARGET_PATH' && sh $SCRIPT_NAME"
