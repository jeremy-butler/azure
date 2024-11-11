$resourceGroupName = ""
$vmName = ""
$nicName = ""

# Get the VM
$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName

# Find the NIC to remove
$nicToRemove = $vm.NetworkProfile.NetworkInterfaces | Where-Object { $_.Id -like "*$nicName*" }

if ($nicToRemove) {
    # Remove the NIC from the VM's network profile
    $vm.NetworkProfile.NetworkInterfaces.Remove($nicToRemove)

    # Update the VM
    Update-AzVM -ResourceGroupName $resourceGroupName -VM $vm

    Write-Output "NIC '$nicName' has been detached from VM '$vmName'."
} else {
    Write-Output "NIC '$nicName' not found on VM '$vmName'."
}