## View Virtual Networks in Azure Subscription
function Get-AzVNets {
    param ([string]$SubscriptionId)

    # Set subscription context
    Select-AzSubscription -SubscriptionId $SubscriptionId

    # Get VNets
    $vnets = Get-AzVirtualNetwork

    foreach ($vnet in $vnets) {
        Write-Output "VNet: $($vnet.Name) in Resource Group: $($vnet.ResourceGroupName)"
    }
}
## View VMs in a Virtual Network
function Get-AzVMsInVNet {
    param (
        [string]$VNetName,
        [string]$ResourceGroupName
    )

    $vnet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName
    $subnets = $vnet.Subnets

    foreach ($subnet in $subnets) {
        Write-Output "Subnet: $($subnet.Name)"

        $nics = Get-AzNetworkInterface | Where-Object { $_.IpConfigurations.Subnet.Id -match $subnet.Id }

        foreach ($nic in $nics) {
            $vm = Get-AzVM | Where-Object { $_.Id -eq $nic.VirtualMachine.Id }

            if ($vm) {
                Write-Output "  VM: $($vm.Name) - Private IP: $($nic.IpConfigurations.PrivateIpAddress)"
            } else {
                Write-Output "  Orphaned NIC: $($nic.Name) - Private IP: $($nic.IpConfigurations.PrivateIpAddress)"
            }
        }
    }
}
## View if Azure Firewall is Present
function Get-AzVNetFirewall {
    param (
        [string]$VNetName,
        [string]$ResourceGroupName
    )

    # Get the VNet object
    $vnet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName

    if ($vnet) {
        Write-Output "Checking Firewall for VNet: $($vnet.Name)..."

        # Get all Azure Firewalls in the subscription
        $firewalls = Get-AzFirewall

        foreach ($fw in $firewalls) {
            if ($fw.IpConfigurations.Subnet.Id -match $vnet.Id) {
                Write-Output "🔥 Azure Firewall Found! 🔥"
                Write-Output "Firewall Name: $($fw.Name)"
                Write-Output "Resource Group: $($fw.ResourceGroupName)"
                Write-Output "Public IP: $($fw.IpConfigurations.PublicIpAddress)"
                return
            }
        }

        Write-Output "❌ No Azure Firewall associated with VNet: $VNetName ❌"
    } else {
        Write-Output "⚠ VNet '$VNetName' not found in resource group '$ResourceGroupName'."
    }
}
## Check for NSG Vulnerabilities
function Get-AzNSGVulnerabilities {
    param ([string]$ResourceGroupName)

    $nsgs = Get-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName

    foreach ($nsg in $nsgs) {
        Write-Output "NSG: $($nsg.Name) - Resource Group: $($nsg.ResourceGroupName)"

        foreach ($rule in $nsg.SecurityRules) {
            if ($rule.Access -eq "Allow" -and $rule.Direction -eq "Inbound" -and $rule.SourceAddressPrefix -eq "*") {
                Write-Output "⚠ Warning: Open Inbound Rule - Port $($rule.DestinationPortRange) from ANY source!"
            }
        }
    }
}
## Check for Peered Networks
function Get-AzVNetPeering {
    param ([string]$VNetName, [string]$ResourceGroupName)

    $vnet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName
    $peering = Get-AzVirtualNetworkPeering -VirtualNetworkName $VNetName -ResourceGroupName $ResourceGroupName

    foreach ($peer in $peering) {
        Write-Output "Peered VNet: $($peer.RemoteVirtualNetwork.Id)"
        Write-Output "Allow Connectivity: $($peer.AllowVirtualNetworkAccess)"
    }
}
## Detect Virtual Machines Without NSGs
function Get-AzVMsWithoutNSGInVNet {
    param (
        [string]$VNetName,
        [string]$ResourceGroupName
    )

    # Get the VNet object
    $vnet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName
    if (-not $vnet) {
        Write-Output "❌ VNet '$VNetName' not found in Resource Group '$ResourceGroupName'."
        return
    }

    Write-Output "🔍 Checking VNet: $VNetName for VMs without NSGs..."
    $allVMsHaveNSG = $true  # Flag to track if all VMs have an NSG

    # Get subnets in the VNet
    $subnets = $vnet.Subnets

    foreach ($subnet in $subnets) {
        Write-Output "➡ Subnet: $($subnet.Name)"

        # Find NICs associated with the subnet
        $nics = Get-AzNetworkInterface | Where-Object { $_.IpConfigurations.Subnet.Id -match $subnet.Id }

        foreach ($nic in $nics) {
            $vm = Get-AzVM | Where-Object { $_.Id -eq $nic.VirtualMachine.Id }

            if ($vm) {
                if (-not $nic.NetworkSecurityGroup) {
                    Write-Output "⚠ VM: $($vm.Name) - Private IP: $($nic.IpConfigurations.PrivateIpAddress) - No NSG Attached!"
                    $allVMsHaveNSG = $false  # At least one VM is missing an NSG
                }
            }
        }
    }

    # If all VMs have an NSG, display success message
    if ($allVMsHaveNSG) {
        Write-Output "✅ All VMs in VNet '$VNetName' have an NSG attached!"
    }
}
## VNet Topology Graph
function Get-AzVNetTopologyGrid {
    param (
        [string]$VNetName,
        [string]$ResourceGroupName
    )

    $vnet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName
    if (-not $vnet) {
        Write-Output "❌ VNet '$VNetName' not found in Resource Group '$ResourceGroupName'."
        return
    }

    Write-Output "🔍 Generating VM topology overview..."

    $vmData = @()

    foreach ($subnet in $vnet.Subnets) {
        $nics = Get-AzNetworkInterface | Where-Object { $_.IpConfigurations.Subnet.Id -match $subnet.Id }

        foreach ($nic in $nics) {
            $vm = Get-AzVM | Where-Object { $_.Id -eq $nic.VirtualMachine.Id }

            if ($vm) {
                $vmData += [PSCustomObject]@{
                    VMName = $vm.Name
                    PrivateIP = $nic.IpConfigurations.PrivateIpAddress
                    Subnet = $subnet.Name
                    NSG = if ($nic.NetworkSecurityGroup) { $nic.NetworkSecurityGroup.Name } else { "❌ No NSG" }
                }
            }
        }
    }

    $vmData | Out-GridView -Title "Azure VM Topology Overview"
}


## Help Option
function Get-AzVNetExplorerHelp {
    Write-Output "AzureVNetExplorer Module Help:"
    Write-Output "----------------------------------------------------"
    Write-Output "Get-AzVNets -SubscriptionId <ID>  : Lists all VNets in the subscription."
    Write-Output "Get-AzVMsInVNet -VNetName <Name> -ResourceGroupName <RG>  : Lists VMs and their IPs in a VNet."
    Write-Output "Get-AzVNetFirewall -VNetName <Name> -ResourceGroupName <RG>  : Checks if a Firewall is linked to a VNet."
    Write-Output "Get-AzNSGVulnerabilities -ResourceGroupName <RG>  : Checks NSGs for open inbound rules (high-risk ports)."
    Write-Output "Get-AzVNetPeering -VNetName <Name> -ResourceGroupName <RG>  : Lists peered VNets and verifies connectivity."
    Write-Output "Get-AzVMsWithoutNSGInVNet -VNetName <Name> -ResourceGroupName <RG>  : Checks if VMs within a VNet have NSGs."
    Write-Output "Get-AzVNetExplorerHelp  : Displays this help menu."
    Write-Output "Get-AzVNetTopologyGrid -VNetName <Name> -ResourceGroupName <RG>  : Displays VM topology in a grid format using Out-GridView."
}





