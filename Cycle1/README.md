# AzureVNetExplorer

AzureVNetExplorer is a PowerShell module designed to assist in **Azure pentesting** or **Azure administration**. It provides various cmdlets to gather information about the **network topology** and details of your **Azure Virtual Network (VNet)**.

## Cmdlets Overview

### 🔹 List VNets in a Subscription
```powershell
Get-AzVNets -SubscriptionId <ID>
```
### 🔹 List VMs in a VNet
```powershell
Get-AzVMsInVNet -VNetName <Name> -ResourceGroupName <RG>  : Lists VMs and their IPs in a VNet.
```
### 🔹 List Firewalls in a VNet
```powershell
Get-AzVNetFirewall -VNetName <Name> -ResourceGroupName <RG>  : Checks if a Firewall is linked to a VNet.
```
### 🔹 List Vulnerbilities in a Network Security Group (NSG)
```powershell
Get-AzNSGVulnerabilities -ResourceGroupName <RG>  : Checks NSGs for open inbound rules (high-risk ports).
```
### 🔹 List VNet Peering
```powershell
Get-AzVNetPeering -VNetName <Name> -ResourceGroupName <RG>  : Lists peered VNets and verifies connectivity.
```
### 🔹 List Network Security Groups (NSGs) Without a VNet
```powershell
Get-AzVMsWithoutNSGInVNet -VNetName <Name> -ResourceGroupName <RG>  : Checks if VMs within a VNet have NSGs.
```
### 🔹 List the Help Menu
```powershell
Get-AzVNetExplorerHelp  : Displays this help menu.
```
### 🔹 Create a VNet Topology Grid
```powershell
Get-AzVNetTopologyGrid -VNetName <Name> -ResourceGroupName <RG>  : Displays VM topology in a grid format using Out-GridView.
```

