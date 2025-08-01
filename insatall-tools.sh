#!/bin/bash

# 🎨 bugzbunny BANNER
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

# 🛠 إعداد مجلد الأدوات
TOOLS_DIR="/opt/bugbounty-tools"
mkdir -p "$TOOLS_DIR"
cd "$TOOLS_DIR" || exit 1

# ✅ تحديث النظام
echo -e "\e[1;34m[*] Updating system packages...\e[0m"
apt update && apt upgrade -y

# ✅ تثبيت المتطلبات الأساسية
echo -e "\e[1;34m[*] Installing required packages...\e[0m"
apt install -y curl wget git python3 python3-pip golang make gcc jq unzip nodejs npm cargo ruby ruby-dev build-essential

# ✅ إعداد GOPATH
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# 📦 عداد التقدم
progress_bar() {
    local duration=$1
    local delay=0.2
    local spinstr='|/-\'
    echo -ne "\e[0;32m     ["
    for ((i=0;i<20;i++)); do
        printf "█"
        sleep $((duration / 20))
    done
    echo -e "] Done ✅\e[0m"
}

# ✅ دالة التثبيت مع عداد + لون
install_tool() {
    name=$1
    cmd_check=$2
    install_cmd=$3

    echo -e "\n\e[1;36m[*] Installing $name...\e[0m"
    eval "$install_cmd" &> /dev/null &

    pid=$!
    while kill -0 $pid 2>/dev/null; do
        echo -ne "\r\e[1;33m    ⏳ $name is being installed...\e[0m"
        sleep 0.5
    done

    if command -v $cmd_check >/dev/null 2>&1; then
        echo -e "\r\e[1;32m[+] $name installed successfully ✅\e[0m"
    else
        echo -e "\r\e[1;31m[!] $name failed to install ❌\e[0m"
    fi
}

# 🔽 تثبيت الأدوات
install_tool "Subfinder" "subfinder" "go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
install_tool "Assetfinder" "assetfinder" "go install -v github.com/tomnomnom/assetfinder@latest"
install_tool "Amass" "amass" "snap install amass"
install_tool "Findomain" "findomain" "wget https://github.com/Findomain/Findomain/releases/latest/download/findomain-linux.zip && unzip findomain-linux.zip && chmod +x findomain && mv findomain /usr/bin/findomain"
install_tool "httpx" "httpx" "go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest"
install_tool "dnsx" "dnsx" "go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
install_tool "naabu" "naabu" "go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest"
install_tool "gau" "gau" "go install -v github.com/lc/gau/v2/cmd/gau@latest"
install_tool "waybackurls" "waybackurls" "go install -v github.com/tomnomnom/waybackurls@latest"
install_tool "nuclei" "nuclei" "go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
install_tool "gf" "gf" "go install -v github.com/tomnomnom/gf@latest && mkdir -p ~/.gf && cp -r $GOPATH/src/github.com/tomnomnom/gf/examples ~/.gf"
install_tool "dalfox" "dalfox" "go install -v github.com/hahwul/dalfox/v2@latest"
install_tool "kxss" "kxss" "go install -v github.com/Emoe/kxss@latest"
install_tool "Gxss" "Gxss" "go install -v github.com/KathanP19/Gxss@latest"
install_tool "ffuf" "ffuf" "go install -v github.com/ffuf/ffuf@latest"
install_tool "hakrawler" "hakrawler" "go install -v github.com/hakluke/hakrawler@latest"
install_tool "notify" "notify" "go install -v github.com/projectdiscovery/notify/cmd/notify@latest"

# ✅ إضافة الأدوات إلى PATH بشكل دائم
if ! grep -q "go/bin" ~/.bashrc; then
    echo "export PATH=\"\$HOME/go/bin:\$PATH\"" >> ~/.bashrc
    echo -e "\e[1;34m[~] GOPATH added to .bashrc\e[0m"
fi

source ~/.bashrc

# ✅ نهاية
echo -e "\n\e[1;32m🎉 All tools installed and ready to use! Happy hunting, BugzBunny! 🔥\e[0m"
echo -e "\e[1;33mFor more tools and updates, visit: