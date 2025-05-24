# AzureVNetExplorer
AzureVNetExplorer is a PowerShell module designed for both Azure pentesting and administration. It helps security professionals identify network misconfigurations and potential vulnerabilities while also enabling cloud administrators to audit and manage Azure VNets effectively. By leveraging key cmdlets, users can enumerate VNets, analyze virtual machines within a network, assess NSG security posture, check for firewall presence, map peering connections, and visualize network topology. This dual functionality makes it valuable for securing Azure environments and ensuring proper network configuration.

![AzureVNetExplorer](AzureVNetExplorer_Image.PNG)

# Getting Started
## System Requirements
- Windows Operating System with Administrator Access
- PowerShell 5.0 or above
- Azure Cloud Account

## Installation
**1.** Download "AzureVNetExplorer.psm1"

**2.** Create a folder called "AzureVNetExplorer" in the following directory on your Windows system: C:\Program Files\WindowsPowerShell\Modules\

**3.** Save AzureVNetExplorer.psm1 to C:\Program Files\WindowsPowerShell\Modules\AzureVNetExplorer\

**4.** Run the following PowerShell Command:
```powershell
Import-Module AzureVNetExplorer
```
**5.** Connect to your Azure Account and begin using AzVNetExplorer
```powershell
Connect-AzAccount
```
## Cmdlets Overview

### 🔹 List VNets in a Subscription
```powershell
Get-AzVNets -SubscriptionId <ID>
```
### 🔹 List VMs in a VNet
```powershell
Get-AzVMsInVNet -VNetName <Name> -ResourceGroupName <RG>  
```
### 🔹 List Firewalls in a VNet 
```powershell
Get-AzVNetFirewall -VNetName <Name> -ResourceGroupName <RG>  
```
### 🔹 List Vulnerbilities in a Network Security Group (NSG)
```powershell
Get-AzNSGVulnerabilities -ResourceGroupName <RG> 
```
### 🔹 List VNet Peering
```powershell
Get-AzVNetPeering -VNetName <Name> -ResourceGroupName <RG> 
```
### 🔹 List Network Security Groups (NSGs) Without a VNet
```powershell
Get-AzVMsWithoutNSGInVNet -VNetName <Name> -ResourceGroupName <RG> 
```
### 🔹 List the Help Menu
```powershell
Get-AzVNetExplorerHelp
```
### 🔹 Create a VNet Topology Grid
```powershell
Get-AzVNetTopologyGrid -VNetName <Name> -ResourceGroupName <RG>
```
# Future Development
This tool will be added to the Powershell Gallery in the near future. The goal is to expand this tool based on recommendations of the community.

