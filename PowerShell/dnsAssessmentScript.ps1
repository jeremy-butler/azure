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

    $resourceGroups = Get-AzResourceGroup

    foreach ($resourceGroup in $resourceGroups) {
        # Get network-related resources
        $vnetworks = Get-AzVirtualNetwork -ResourceGroupName $resourceGroup.ResourceGroupName
        $nsgs = Get-AzNetworkSecurityGroup -ResourceGroupName $resourceGroup.ResourceGroupName
        $publicIps = Get-AzPublicIpAddress -ResourceGroupName $resourceGroup.ResourceGroupName
        $loadBalancers = Get-AzLoadBalancer -ResourceGroupName $resourceGroup.ResourceGroupName
        $appGateways = Get-AzApplicationGateway -ResourceGroupName $resourceGroup.ResourceGroupName
        $firewall = Get-AzFirewall -ResourceGroupName $resourceGroup.ResourceGroupName
        $dnsZones = Get-AzDnsZone -ResourceGroupName $resourceGroup.ResourceGroupName
        $expressRouteCircuits = Get-AzExpressRouteCircuit -ResourceGroupName $resourceGroup.ResourceGroupName
        $networkGateways = Get-AzVirtualNetworkGateway -ResourceGroupName $resourceGroup.ResourceGroupName
        $routeTables = Get-AzRouteTable -ResourceGroupName $resourceGroup.ResourceGroupName
        $vpnGateways = Get-AzVpnGateway -ResourceGroupName $resourceGroup.ResourceGroupName

        # Add the resources to the array
        $networkResources += $vnetworks
        $networkResources += $nsgs
        $networkResources += $publicIps
        $networkResources += $loadBalancers
        $networkResources += $appGateways
        $networkResources += $firewall
        $networkResources += $dnsZones
        $networkResources += $expressRouteCircuits
        $networkResources += $networkGateways
        $networkResources += $routeTables
        $networkResources += $vpnGateways
    }
}

# Create an array to hold the resource details for export
$resourceDetails = @()

# Iterate over each resource and create a custom object for export
foreach ($resource in $networkResources) {
    $resourceDetails += [PSCustomObject]@{
        Name             = $resource.Name
        ResourceGroup    = $resource.ResourceGroupName
        Location         = $resource.Location
        ResourceType     = $resource.ResourceType
        SubscriptionName = $subscription.Name
        Subscription     = $subscription.Id
    }
}

# Export the resource details to a CSV file
$exportFilePath = Join-Path -Path (Get-Location) -ChildPath "CspResources.csv"
$resourceDetails | Export-Csv -Path $exportFilePath -NoTypeInformation

Write-Output "Analysis complete. Please check the output above for resource readiness details."
Write-Output "Exported resource list to $exportFilePath"