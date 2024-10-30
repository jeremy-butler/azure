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

    # Get all network-related resources
    $vnetworks = Get-AzVirtualNetwork
    $nsgs = Get-AzNetworkSecurityGroup
    $publicIps = Get-AzPublicIpAddress
    $loadBalancers = Get-AzLoadBalancer
    $appGateways = Get-AzApplicationGateway
    

    # Add the resources to the array
    $networkResources += $vnetworks
    $networkResources += $nsgs
    $networkResources += $publicIps
    $networkResources += $loadBalancers
    $networkResources += $appGateways
    $networkResources += $subscription
}

# Output all network resources
$networkResources | Format-Csv -Property Subscription, ResourceGroupName, Name, Type, Location | Out-File -FilePath "./networkResources.csv"