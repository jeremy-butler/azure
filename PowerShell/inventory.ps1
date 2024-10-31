<#
.SYNOPSIS
    This PowerShell script queries all Azure subscriptions available to the logged in user and produces a .csv file output with all Azure resources.

.DESCRIPTION
    This script is designed to query all available subscriptions within an Azure tenant for resources currently.
    The script will output a .csv file with the following columns: Name, Resource Group, Location, Resource Type, SubscriptionName, and Subscription.

.NOTES
    Author: Jeremy Butler
    Date: 2021-09-27
    Version: 0.1
#>

# Get a list of subscriptions and prompt user to select one
$subscriptions = Get-AzSubscription

# Initialize an array to hold the resource details with readiness status
$resourceDetails = @()

foreach ($subscription in $subscriptions) {

set-azcontext $subscription.id

# Get the list of resources in the subscription
$resources = Get-AzResource


# Perform analysis for each resource
foreach ($resource in $resources) {
    $resourceType = $resource.ResourceType
    $resourceId = $resource.ResourceId
    
    $resourceDetails += [PSCustomObject]@{
        Name             = $resource.Name
        ResourceGroup    = $resource.ResourceGroupName
        Location         = $resource.Location
        ResourceType     = $resource.ResourceType
        SubscriptionName = $subscription.name
        Subscription     = $subscription.Id
    }
}


# Export resource details to a CSV file in the current directory
$exportFilePath = Join-Path -Path (Get-Location) -ChildPath "CspResources.csv"
$resourceDetails | Export-Csv -Path $exportFilePath -NoTypeInformation
Write-Output "Analysis complete. Please check the output above for resource readiness details."
Write-Output "Exported resource list to $exportFilePath"
}