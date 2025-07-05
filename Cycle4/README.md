# ZeekAIAnalyzer

ZeekAIAnalyzer is a Python-based Jupyter Notebook tool designed to analyze Zeek `conn.log` network connection logs. It summarizes network behavior and detects potential anomalies or beaconing using Azure OpenAI.

---

## 📌 Features

- Parses Zeek connection logs in JSON (NDJSON) format
- Computes statistical summaries of network traffic
- Identifies top source and destination IPs
- Uses Azure OpenAI to generate a human-readable security analysis
- Helps analysts quickly spot suspicious or beacon-like behavior

---

## 🧰 Requirements

- Python 3.8+
- [`pandas`](https://pandas.pydata.org/)
- [`openai`](https://pypi.org/project/openai/) (Azure-compatible SDK)

Install dependencies using:

```bash
pip install pandas openai
