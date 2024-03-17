
## https://learn.microsoft.com/en-us/training/modules/automate-azure-tasks-with-powershell/6-exercise-create-resource-interactively

[System.Int32] $NumberVM      = [System.Int32]${Env:NUM_VMS};
if ( ${NumberVM} -eq $null ) {
    [System.Int32] $NumberVM  = [System.Int32]1;
} elseif ( ${NumberVM} -lt 1) {
    [System.Int32] $NumberVM  = [System.Int32]1;
} elseif ( ${NumberVM} -gt 9) {
    [System.Int32] $NumberVM  = [System.Int32]9;
}
[System.String]$ResourceGroup = "${Env:RESOURCEGROUPNAME}";
[System.String]$LocationVM    = "${Env:LOCATION}";
[System.String]$PrefixVM      = 'testvm';

if ( "${ResourceGroup}" -eq '' ) {
    Write-Error -Message 'There is no resource group found. '
    exit 1;
}

[Microsoft.Azure.Commands.Compute.Models.PSVirtualMachine[]]$vms = ( foreach( $n in 1..${NumberVM} ) {
        [System.String]$VirtualMachine = "${PrefixVM}-${LocationVM}-" + ${n}.ToString().PadLeft(3,'0');
        Get-AzVM -ResourceGroupName "${ResourceGroup}" -Name "${VirtualMachine}";
    }
);
${vms} | ForEach-Object -Process {
    [Microsoft.Azure.Commands.Compute.Models.PSVirtualMachine]$vm = ${_};
    [System.String]$VM_Name               = ${vm}.Name;
    [System.String]$VM_ResourceGroupName  = ${vm}.ResourceGroupName;
    
    Write-Output "Shutting down the virtual machine ${VM_Name} in the ${VM_ResourceGroupName} resource group. "
    Stop-AzVM -Name ${vm}.Name -ResourceGroupName ${vm}.ResourceGroupName -Force;

    Write-Output "Deleting the virtual machine ${VM_Name} in the ${VM_ResourceGroupName} resource group. "
    Remove-AzVM -Name ${vm}.Name -ResourceGroupName ${vm}.ResourceGroupName -Force;

    Write-Output "The network interface of the virtual machine ${VM_Name} in the ${VM_ResourceGroupName} resource group. "

    Write-Output "The managed OS disks of the virtual machine ${VM_Name} in the ${VM_ResourceGroupName} resource group. "
    Get-AzDisk -ResourceGroupName ${vm}.ResourceGroupName -DiskName ${vm}.StorageProfile.OSDisk.Name;

    Write-Output "The virtual network of the virtual machines in the ${VM_ResourceGroupName} resource group. "
    Get-AzVirtualNetwork -ResourceGroupName $vm.ResourceGroupName
}
