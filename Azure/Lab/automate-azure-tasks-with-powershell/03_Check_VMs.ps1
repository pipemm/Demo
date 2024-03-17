
[System.String]                                                  $resource_group = "${Env:RESOURCEGROUPNAME}";
[Microsoft.Azure.Commands.Compute.Models.PSVirtualMachineList[]] $VMs            = (Get-AzVM -ResourceGroupName "${resource_group}")

if ( "${resource_group}" -eq '' ) {
    Write-Error -Message 'There is no resource group found. '
    exit 1;
}

Write-Output 'List of virtual machines. ';
Write-Output ${VMs};

${VMs} |
    ForEach-Object -Process {
        [Microsoft.Azure.Commands.Compute.Models.PSVirtualMachineList]${vm} = ${_};
        [System.String]$vm_name = ${vm}.Name;
        Write-Output "Information for the virtual machine ${vm_name} : ";
        Write-Output ${vm};
        Write-Output "HardwareProfile section of the virtual machine ${vm_name} : ";
        Write-Output ${vm}.HardwareProfile;
        Write-Output "StorageProfile section of the virtual machine ${vm_name} : ";
        Write-Output ${vm}.StorageProfile;
        Write-Output "Information on the disks of the virtual machine ${vm_name} : ";
        Write-Output ${vm}.StorageProfile.OsDisk;
        Write-Output "Available sizes (first 5) for the virtual machine ${vm_name} : ";
        ${vm} | Get-AzVMSize | Select-Object -First 5 | Format-Table;
    }