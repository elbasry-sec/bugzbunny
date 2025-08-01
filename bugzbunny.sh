#!/bin/bash
clear
echo -e "\e[1;35m"
cat << "EOF"
  _                     _                             
 | |__  _   _  __ _ ___| |__  _   _ _ __  _ __  _   _ 
 | '_ \| | | |/ _` |_  / '_ \| | | | '_ \| '_ \| | | |
 | |_) | |_| | (_| |/ /| |_) | |_| | | | | | | | |_| |
 |_.__/ \__,_|\__, /___|_.__/ \__,_|_| |_|_| |_|\__, |
              |___/                             |___/ 
EOF
echo -e "\e[1;36m                      ⚔️  bugzbunny Tools Installer"
echo -e "\e[1;33m             github.com/elbasry_sec | t.me/elbasy_sec"
echo -e "\e[0m"

# 🔰 إعداد متغيرات
INPUT=$1
OUTDIR="${2:-results}"
TODAY=$(date +"%Y-%m-%d")
BASE_DIR="$HOME/bugzbunny/$OUTDIR/$TODAY"

# 🗂 إنشاء مجلد التخزين
mkdir -p "$BASE_DIR"
cd "$BASE_DIR" || exit 1

echo -e "\e[1;35m[~] Starting Automated Bug Bounty Recon for: $INPUT\e[0m"
echo -e "\e[1;36m[~] Output Directory: $BASE_DIR\e[0m"

# 🎯 1. Subdomain Enumeration
echo -e "\n\e[1;33m[+] Subdomain Enumeration...\e[0m"
subfinder -d "$INPUT" -silent -o subs-subfinder.txt
assetfinder --subs-only "$INPUT" > subs-assetfinder.txt
amass enum -d "$INPUT" -passive -o subs-amass.txt
cat subs-*.txt | sort -u > all-subs.txt
echo "[✔] Found $(wc -l < all-subs.txt) unique subdomains."

# 🔎 2. Live Hosts Check
echo -e "\n\e[1;33m[+] Checking Live Hosts...\e[0m"
httpx -l all-subs.txt -silent -status-code -threads 100 > live.txt
cut -d' ' -f1 live.txt > live-only.txt
echo "[✔] Found $(wc -l < live-only.txt) live domains."

# 🌐 3. URLs Collection
echo -e "\n\e[1;33m[+] Collecting URLs (gau + wayback)...\e[0m"
gau -subs "$INPUT" > urls-gau.txt
waybackurls "$INPUT" > urls-wayback.txt
cat urls-*.txt | sort -u > all-urls.txt
echo "[✔] Collected $(wc -l < all-urls.txt) URLs."

# 🔐 4. XSS Discovery (Dalfox + kxss + Gxss)
echo -e "\n\e[1;33m[+] Testing for XSS...\e[0m"
dalfox file all-urls.txt --skip-bav -o xss-dalfox.txt
cat all-urls.txt | kxss > xss-kxss.txt
cat all-urls.txt | Gxss > xss-gxss.txt
echo "[✔] XSS scan done."

# 📊 5. Directory Bruteforce (ffuf)
echo -e "\n\e[1;33m[+] Running FFUF on Live Domains (Top 20 only)...\e[0m"
WORDLIST="/usr/share/wordlists/dirb/common.txt"
mkdir -p ffuf
head -n 20 live-only.txt | while read -r url; do
    ffuf -w $WORDLIST -u "$url/FUZZ" -mc 200 -t 50 -of md -o "ffuf/$(echo $url | sed 's/https\?:\/\///g' | tr '/' '_').md"
done
echo "[✔] FFUF scan finished."

# 🧠 6. Vulnerability Templates (Nuclei)
echo -e "\n\e[1;33m[+] Running nuclei templates...\e[0m"
nuclei -update-templates
nuclei -l live-only.txt -silent -o nuclei-results.txt
echo "[✔] Nuclei scan done."

# 📩 7. Notification (اختياري)
# notify -bulk -pc config.yaml -i nuclei-results.txt

# ✅ النهاية
echo -e "\n\e[1;32m✅ Scan Complete! Check: $BASE_DIR\e[0m"
echo -e "\e[1;33mFor more tools and updates, visit: