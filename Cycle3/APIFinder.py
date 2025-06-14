# -*- coding: utf-8 -*-
# Windows API Call Analyzer for Ghidra
# Author: Bigdrea6 (Modified by Copilot)
# Category: Windows Analysis
# Purpose: Find API calls, their locations, and categorize them.

from collections import Counter

table = []
table2 = []

# Define API categories (Updated)
api_categories = {
    "File System": ["CreateFile", "WriteFile", "DeleteFile"],
    "Network": ["InternetConnect", "WinHttpOpen", "send", "recv"],
    "Memory Management": ["VirtualAlloc", "VirtualProtect", "HeapAlloc"],
    "Process Control": ["CreateProcess", "TerminateProcess", "OpenProcess", "GetProcessId", "GetCurrentProcessId"],
    "Anti-Debugging": ["IsDebuggerPresent"],  # New category added
}

# Scan external references in the binary
for externalReference in currentProgram.getReferenceManager().getExternalReferences():
    if externalReference.getReferenceType().isCall():
        call_addr = externalReference.getFromAddress()
        api = externalReference.getExternalLocation().getLabel()

        # Get the function that contains the API call
        function = getFunctionContaining(call_addr)
        function_name = function.getName() if function else "Unknown"

        # Categorize API calls
        category = "Unknown"
        for cat, apis in api_categories.items():
            if api in apis:
                category = cat
                break

        set = []
        set.extend([call_addr, api, function_name, category])
        table.append(set)
        table2.append(api)

table = sorted(table)

for i in range(len(table)):
    print("{} : {} | Function: {} | Category: {}".format(table[i][0], table[i][1], table[i][2], table[i][3]))

print("API Types:{}, Call Count:{}".format(len(Counter(table2)), len(table)))
