<#
.SYNOPSIS
    This PowerShell script queries all Azure subscriptions available to the logged in user and produces a .csv file output with all network related resources.

.DESCRIPTION
    This script is designed to query all available subscriptions within an Azure tenant for any network related resources.
    The script will output a .csv file with the following columns: ResourceGroupName, Name, Type, Location.

.NOTES
    Author: Jeremy Butler
    Date: 2021-10-30
    Version: 0.1
#>

# Get all subscriptions
$subscriptions = Get-AzSubscription

# Initialize an array to hold all network resources
$networkResources = @()

# Loop through each subscription
foreach ($subscription in $subscriptions) {
    # Set the current subscription context
    Set-AzContext -SubscriptionId $subscription.Id

    # Get network-related resources
    $vnetworks = Get-AzVirtualNetwork
    $nsgs = Get-AzNetworkSecurityGroup
    $publicIps = Get-AzPublicIpAddress
    $loadBalancers = Get-AzLoadBalancer
    $appGateways = Get-AzApplicationGateway
    $firewall = Get-AzFirewall
    $bastionHosts = Get-AzBastionHost
    $dnsZones = Get-AzDnsZone
    $expressRouteCircuits = Get-AzExpressRouteCircuit
    $firewallPolicies = Get-AzFirewallPolicy
    $networkGateways = Get-AzVirtualNetworkGateway
    $natGateways = Get-AzNatGateway
    $privateDnsZones = Get-AzPrivateDnsZone
    $privateEndpoints = Get-AzPrivateEndpoint
    $routeTables = Get-AzRouteTable
    $vpnGateways = Get-AzVpnGateway
    

    # Add the resources to the array
    $networkResources += $vnetworks
    $networkResources += $nsgs
    $networkResources += $publicIps
    $networkResources += $loadBalancers
    $networkResources += $appGateways
    $networkResources += $subscription
    $networkResources += $firewall
    $networkResources += $bastionHosts
    $networkResources += $dnsZones
    $networkResources += $expressRouteCircuits
    $networkResources += $firewallPolicies
    $networkResources += $networkGateways
    $networkResources += $natGateways
    $networkResources += $privateDnsZones
    $networkResources += $privateEndpoints
    $networkResources += $routeTables
    $networkResources += $vpnGateways
}

# Output all network resources

# $networkResources += [PSCustomObject]@{
#     Name             = $networkResources.Name
#     ResourceGroup    = $networkResources.ResourceGroupName
#     Location         = $networkResources.Location
#     ResourceType     = $networkResources.ResourceType
#     SubscriptionName = $subscription.name
#     Subscription     = $subscription.Id
# }

$exportFilePath = Join-Path -Path (Get-Location) -ChildPath "CspResources.csv"
$networkResources | Export-Csv -Path $exportFilePath -NoTypeInformation

Write-Output "Analysis complete. Please check the output above for resource readiness details."
Write-Output "Exported resource list to $exportFilePath"








#$networkResources | Export-Csv -Path "./networkResources.csv"

