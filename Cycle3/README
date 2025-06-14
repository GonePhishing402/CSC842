# Windows API Call Analyzer for Ghidra

### 📌 **Author:** GonePhishing402  
### 📂 **Category:** Windows Analysis  
### 🎯 **Purpose:** Identify Windows API calls, their locations, and categorize them.

## 🔍 Overview
The **Windows API Call Analyzer** is a Ghidra script designed to **analyze external API calls** within a binary, **categorize them**, and provide insights into their functionality. This tool is valuable for **reverse engineering**, **malware analysis**, and **security research**.

## ⚡ Features
✅ **Detects Windows API calls** and their memory addresses  
✅ **Identifies the function each API call resides in**  
✅ **Categorizes API calls into key behavioral groups**  
✅ **Supports anti-debugging detection for API like `IsDebuggerPresent`**  

## 🏷️ API Categories
| **Category**         | **Example APIs** |
|----------------------|-----------------|
| File System         | `CreateFile`, `WriteFile`, `DeleteFile` |
| Network            | `InternetConnect`, `WinHttpOpen`, `send`, `recv` |
| Memory Management  | `VirtualAlloc`, `VirtualProtect`, `HeapAlloc` |
| Process Control    | `CreateProcess`, `TerminateProcess`, `OpenProcess`, `GetProcessId`, `GetCurrentProcessId` |
| Anti-Debugging     | `IsDebuggerPresent` |

## 🚀 How to Use
1️⃣ **Open Ghidra** and load the binary you wish to analyze.  
2️⃣ **Go to `Window > Script Manager`** in Ghidra.  
3️⃣ **Create a new Python script** and paste the code from `Windows_API_Call_Analyzer.py`.  
4️⃣ **Run the script** → API calls, functions, and categories will be displayed in the console.  

## 📊 Output Example
