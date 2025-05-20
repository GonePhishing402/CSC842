# AzureVNetExplorer
This tool was written to assist in Azure pentesting or Azure administration. This is a PowerShell module that uses a variety of cmdlets to gain information on the network topology and details of your Azure Virtual Network. Here are the Following cmdlets:
<Get-AzVNets -SubscriptionId <ID>>  : Lists all VNets in the subscription.
Get-AzVMsInVNet -VNetName <Name> -ResourceGroupName <RG>  : Lists VMs and their IPs in a VNet.
Get-AzVNetFirewall -VNetName <Name> -ResourceGroupName <RG>  : Checks if a Firewall is linked to a VNet.
Get-AzNSGVulnerabilities -ResourceGroupName <RG>  : Checks NSGs for open inbound rules (high-risk ports).
Get-AzVNetPeering -VNetName <Name> -ResourceGroupName <RG>  : Lists peered VNets and verifies connectivity.
Get-AzVMsWithoutNSGInVNet -VNetName <Name> -ResourceGroupName <RG>  : Checks if VMs within a VNet have NSGs.
Get-AzVNetExplorerHelp  : Displays this help menu.
Get-AzVNetTopologyGrid -VNetName <Name> -ResourceGroupName <RG>  : Displays VM topology in a grid format using Out-GridView.
