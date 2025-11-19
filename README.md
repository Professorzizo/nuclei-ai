# nuclei-X


automate scan with nuclei -ai tag


---—--—------------------------------




⚡ Features

✔️ Automated Nuclei AI scanning

✔️ Removes duplicated subdomains automatically

✔️ Runs grouped AI queries (Low-Hanging Fruits, Sensitive Exposures, Cloud Issues, Cache Poisoning, etc.)

✔️ Categorized output folders

✔️ Saves only valid findings (no empty outputs)

✔️ Generates a professional HTML report


🚀 Usage

./nuclei-X.sh -l live-subs.txt

Arguments

Flag	Description

-l	Path to live subdomains file (required)
-o	Output directory (default: nuclei-ai-output)
-h	Show help



---

📂 Output Structure

nuclei-ai-output/
│── results/
│   ├── low/
│   ├── sensitive/
│   ├── cloud/
│   ├── cache/
│── report.html

Each category contains only non-empty results.


---

🧠 What Does It Scan For?

🔹 Low Hanging Fruits

HTML comments leaking sensitive info

Exposed .env, config, backup files

Exposed Git/SVN

Exposed log files

Debug endpoints

Admin panels / open directories


🔹 Sensitive Data Exposure

API keys & secrets in JS

AWS/GCP/Azure keys

JWT tokens

Error-based data leaks

Database dumps


🔹 Cloud Security Issues

Kubernetes dashboards

Misconfigured cloud buckets

Exposed cloud access keys


🔹 Web Cache Poisoning

Host header poisoning

CDN misconfigurations

Unkeyed parameter cache poisoning



---

📊 HTML Report

After each run, the tool creates:

report.html

Containing:

Vulnerability categories

Number of bugs found

Link to each result file

