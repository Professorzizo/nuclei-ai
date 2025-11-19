#!/bin/bash

# ----------------------------------------------------------
#   249Security – Automated Nuclei Bug Scanner
#   Author : SadiQ Hashim
#   Version: 1.0
# ----------------------------------------------------------

clear
echo -e "\e[36m"
echo " ██████  ██   ██  ██████       ███████ ███████  ██████  ██    ██ ██   ██ ██ "
echo "██    ██ ██  ██  ██    ██      ██      ██      ██   ██ ██    ██ ██  ██  ██ "
echo "██    ██ █████   ██    ██      ███████ █████    ██████  ██    ██ █████   ██ "
echo "██    ██ ██  ██  ██    ██           ██ ██       ██      ██    ██ ██  ██  ██ "
echo " ██████  ██   ██  ██████       ███████ ███████  ██       ██████  ██   ██ ███████ "
echo "                          249Security Recon Engine"
echo -e "                   Created by: \e[33mSadiQ Hashim\e[0m"
echo -e "\e[36m----------------------------------------------------------\e[0m"
sleep 1

if [ "$1" != "-l" ] || [ -z "$2" ]; then
    echo "Usage: $0 -l live-subs.txt"
    exit 1
fi

LIVE="$2"

if [ ! -f "$LIVE" ]; then
    echo "File not found: $LIVE"
    exit 1
fi

# 1. CLEAN DUPLICATES
echo "[+] Removing duplicates from $LIVE ..."
sort -u "$LIVE" -o "$LIVE"

# OUTPUT FOLDER
OUT="nuclei-results"
mkdir -p $OUT/raw

# QUERIES LIST
declare -a QUERIES=(
"Find sensitive information in HTML comments (debug notes, API keys, tokens)"
"Find exposed .env files leaking credentials, API keys, and database details"
"Find exposed configuration files containing sensitive information"
"Find exposed backup/archive files such as .zip, .tar.gz, .bak"
"Find exposed Git repositories allowing full repo download"
"Find exposed SVN directories allowing full repo download"
"Find exposed Jenkins/Ci/CD pipelines leaking credentials"
"Find exposed log files with sensitive information"
"Find exposed SQL dumps/database backups"
"Find exposed phpinfo.php files leaking sensitive data"
"Find exposed admin panels/login portals"
"Identify open directory listings disclosing sensitive data"
"Find exposed .DS_Store or .git directories leaking development artifacts"
"Detect web applications running in debug mode, potentially exposing stack traces"
"Detect debug endpoints revealing system information"
"Identify test and staging environments exposed to the internet"
"Detect endpoints with verbose error messages"
"Find CORS misconfigurations allowing wildcard/origin reflection"
"Detect exposed stack traces in error messages"
"Detect misconfigured access controls in APIs"
"Detect default credentials in login forms"
"Identify exposed admin panels of CMS (WordPress, Joomla, Drupal)"
"Identify exposed JavaScript files containing API keys or tokens"
"Detect exposed .bak/.old/.sql files"
"Identify exposed AWS keys and cloud credentials"
"Detect sensitive API keys leaking in responses and URLs"
"Find exposed JWT tokens or OAuth secrets"
"Find open Kubernetes dashboards"
"Detect exposed cloud storage keys"
"Detect GCP keys exposed in JS files or responses"
"Find web cache poisoning via Host, X-Forwarded-Host headers"
"Detect web cache poisoning in CDN/proxy configurations"
"Identify cache poisoning by injecting unkeyed parameters"
"Find cache poisoning in X-Original-URL, X-Rewrite-URL headers"
"Detect poisoned cache responses"
)

echo "[+] Running Nuclei AI Scans..."
i=1
for q in "${QUERIES[@]}"; do
    echo "[+] ($i/${#QUERIES[@]}) $q"
    nuclei -list "$LIVE" -silent -ai "$q" > "$OUT/raw/scan_$i.txt"

    if [ ! -s "$OUT/raw/scan_$i.txt" ]; then
        rm "$OUT/raw/scan_$i.txt"
    fi

    ((i++))
done

# ------------- HTML REPORT ------------
REPORT="$OUT/report.html"

echo "[+] Building HTML report..."

{
echo "<html><head><title>249Security Nuclei Report</title>"
echo "<style>
body{font-family:Arial;background:#111;color:#eee;padding:20px;}
h1{color:#00eaff;}
h2{color:#ffd700;}
.box{background:#1b1b1b;margin:10px;padding:15px;border-radius:6px;}
pre{background:#000;padding:10px;color:#0f0;overflow-x:auto;}
</style></head><body>"
echo "<h1>249Security – Nuclei Scan Report</h1>"
echo "<p><b>Author:</b> SadiQ Hashim<br>"
echo "Generated: $(date)</p>"

for file in $OUT/raw/*.txt; do
    name=$(basename "$file" .txt)
    echo "<div class='box'><h2>$name</h2><pre>"
    cat "$file"
    echo "</pre></div>"
done

echo "</body></html>"
} > "$REPORT"

echo "[+] DONE!"
echo "[+] HTML report saved at: $REPORT"
echo "[+] Raw results at: $OUT/raw/"
