# SentinelTune

This PowerShell tool automates the retrieval, analysis, and reporting of **Microsoft Sentinel** alert rules and incident data over the last 90 days.
![SentinelTune](SentinelTune.PNG)

## 🔍 Features

- **Fetches all Sentinel alert rules** from a specified Azure Resource Group and Workspace.
- **Calculates key statistics**:
  - Total number of rules
  - Percentage of enabled rules
  - Percentage of rules with entity mappings
- **Correlates alert rules** with incident data to determine how many times each rule has triggered incidents in the last 90 days.
- **Generates structured reports** in:
  - **Excel (.xlsx)** with enhanced formatting
  - **HTML** with styling for readability

## 📦 Output

- `Sentinel_Report.xlsx`: Detailed alert rule data for analysis in Excel.
- `Sentinel_Report.html`: A styled, browser-friendly report for quick review.

## 🛠️ Requirements

- Azure PowerShell modules:
  - `Az.SecurityInsights`
  - `Az.OperationalInsights`
- PowerShell module: [`ImportExcel`](https://github.com/dfinke/ImportExcel) (for Excel export)

## ⚙️ Parameters

| Parameter         | Description                          | Default         |
|------------------|--------------------------------------|-----------------|
| `ResourceGroupName` | Azure resource group name            | `SOC_Central`   |
| `WorkspaceName`     | Sentinel workspace name              | `SOC-Central`   |
| `WorkspaceId`       | (Optional) Sentinel Workspace ID     | Auto-discovered |

## 📁 Default Output Paths

- **Excel**: `C:\Users\<username>\Documents\REPO\Powershell\Sentinel_Report.xlsx`
- **HTML**: `C:\Users\<username>\Documents\REPO\Powershell\Sentinel_Report.html`
