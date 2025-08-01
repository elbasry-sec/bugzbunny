# 🐰 BugzBunny Automated Bug Bounty Scanner

A fully automated bash script to streamline reconnaissance and vulnerability discovery during bug bounty hunting.

---

## ⚔️ Features

* ✅ Passive + active subdomain enumeration (`subfinder`, `assetfinder`, `amass`)
* ✅ Live host detection (`httpx`)
* ✅ URL collection (`gau`, `waybackurls`)
* ✅ XSS detection (`dalfox`, `kxss`, `Gxss`)
* ✅ Directory bruteforce with `ffuf`
* ✅ Vulnerability scanning with `nuclei`
* ✅ Organized output structure by date
* ✅ Ready for automation on VPS or daily cronjobs

---

## 📦 Requirements

Install all tools using the [bugzbunny installer script](https://github.com/elbasry_sec) or manually ensure the following are installed:

* `subfinder`
* `assetfinder`
* `amass`
* `httpx`
* `gau`
* `waybackurls`
* `dalfox`
* `kxss`
* `Gxss`
* `ffuf`
* `nuclei`

---

## 🚀 Usage

```bash
chmod +x bugzbunny-scan.sh
./bugzbunny-scan.sh target.com
```

📂 Output will be saved in:

```
~/bugzbunny/results/YYYY-MM-DD/
```

Optionally, you can set a custom folder name:

```bash
./bugzbunny-scan.sh target.com my-scan-folder
```

---

## 📁 Output Structure

```
results/
└── 2025-08-01/
    ├── all-subs.txt
    ├── live.txt
    ├── live-only.txt
    ├── all-urls.txt
    ├── xss-dalfox.txt
    ├── xss-kxss.txt
    ├── xss-gxss.txt
    ├── ffuf/
    │   └── target.md
    └── nuclei-results.txt
```

---

## 💡 Notes

* `nuclei` will automatically update templates before scanning.
* FFUF runs on top 20 live domains to keep things efficient.
* Add your `notify` config at `~/.config/notify/config.yaml` to get alerts (optional).
* Designed for daily scans, VPS automation, and unattended recon setups.

---

## 👑 Author

> **Elbasry aka BugzBunny 🐰**
> github.com/elbasry\_sec
> t.me/elbasy\_sec

---

## 🧠 Tips

* Run daily on a cronjob with a domain list.
* Review all `.txt` and `.md` outputs for manual verification.
* Extend with more custom modules like `jsfinder`, `paramspider`, or `rescope`.

---

## 🔐 License

MIT - Free to use, modify, and contribute.

---
