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
pip install pandas
pip install openai
```
## 🚀 Usage

1. **Clone or download** this repository and open the notebook (`ZeekAIAnalyzer.ipynb`) or run the script.

2. **Insert your Azure OpenAI credentials:**

```python
   client = AzureOpenAI(
       api_key="<YOUR_API_KEY>",
       api_version="<API_VERSION>",
       azure_endpoint="<AZURE_ENDPOINT>"
```
3. **Specify you deployed model:**
```python
   model = "<DEPLOYED_MODEL_NAME>"
```
4. Run the notebook to perform the following steps:
- Load and parse the conn.log

- Generate traffic and behavioral summaries

- Send the summary to Azure OpenAI for analysis

- Print a plain-language report of notable findings

