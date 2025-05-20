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

Get-AzVNetFirewall -VNetName <Name> -ResourceGroupName <RG>  : Checks if a Firewall is linked to a VNet.
Get-AzNSGVulnerabilities -ResourceGroupName <RG>  : Checks NSGs for open inbound rules (high-risk ports).
Get-AzVNetPeering -VNetName <Name> -ResourceGroupName <RG>  : Lists peered VNets and verifies connectivity.
Get-AzVMsWithoutNSGInVNet -VNetName <Name> -ResourceGroupName <RG>  : Checks if VMs within a VNet have NSGs.
Get-AzVNetExplorerHelp  : Displays this help menu.
Get-AzVNetTopologyGrid -VNetName <Name> -ResourceGroupName <RG>  : Displays VM topology in a grid format using Out-GridView.

