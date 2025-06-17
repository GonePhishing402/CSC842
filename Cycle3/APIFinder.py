# Windows API Call Analyzer for Ghidra
# Author: GonePhishing402 
# Category: Windows Analysis
# Purpose: Find API calls, their locations, categorize them, and extract network indicators.

import re
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

# Function to extract hardcoded IPs and domains
def extract_network_indicators():
    network_indicators = []

    # Define regex patterns for IP addresses and domains
    ip_pattern = re.compile(r'\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b')
    domain_pattern = re.compile(r'\b(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}\b')

    # Iterate through memory blocks
    memory = currentProgram.getMemory()
    for block in memory.getBlocks():
        start = block.getStart()
        end = block.getEnd()

        address = start
        while address < end:
            data = getDataAt(address)
            if data and data.hasStringValue():
                value = data.getValue()
                if ip_pattern.match(value) or domain_pattern.match(value):
                    network_indicators.append(value)
            
            address = address.add(1)  # Move to next address

    return network_indicators

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

print("\n[API Calls]")
for i in range(len(table)):
    print("{} : {} | Function: {} | Category: {}".format(table[i][0], table[i][1], table[i][2], table[i][3]))

print("\nAPI Types:{}, Call Count:{}".format(len(Counter(table2)), len(table)))

# Extract and print network indicators
network_indicators = extract_network_indicators()
if network_indicators:
    print("\n[Network Indicators]")
    for indicator in network_indicators:
        print(indicator)
else:
    print("\nNo hardcoded network indicators found.")
