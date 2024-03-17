
[System.String]                                                  $ResourceGroup = "${Env:RESOURCEGROUPNAME}";
[Microsoft.Azure.Commands.Compute.Models.PSVirtualMachineList[]] $VMs           = (Get-AzVM -ResourceGroupName "${resource_group}")

if ( "${ResourceGroup}" -eq '' ) {
    Write-Error -Message 'There is no resource group found. '
    exit 1;
}

Write-Output 'List of virtual machines. ';
Write-Output ${VMs};

${VMs} |
    ForEach-Object -Process {
        [Microsoft.Azure.Commands.Compute.Models.PSVirtualMachineList]${vm} = ${_};
        [System.String]$NameVM = ${vm}.Name;
        Write-Output "Information for the virtual machine ${NameVM} : ";
        Write-Output ${vm};
        Write-Output "HardwareProfile section of the virtual machine ${NameVM} : ";
        Write-Output ${vm}.HardwareProfile;
        Write-Output "StorageProfile section of the virtual machine ${NameVM} : ";
        Write-Output ${vm}.StorageProfile;
        Write-Output "Information on the disks of the virtual machine ${NameVM} : ";
        Write-Output ${vm}.StorageProfile.OsDisk;
        Write-Output "Available sizes (first 5) for the virtual machine ${NameVM} : ";
        ${vm} | Get-AzVMSize | Select-Object -First 5 | Format-Table;
    }

## to do
## pwd && hostname && ip address
${VMs} |
    ForEach-Object -Process {
        [Microsoft.Azure.Commands.Compute.Models.PSVirtualMachineList]${vm} = ${_};
        [System.String]$NameVM = ${vm}.Name;
        Write-Output "The public IP address of the virtual machine ${NameVM} : ";
        Get-AzPublicIpAddress -ResourceGroupName "${ResourceGroup}" -Name "${NameVM}"
    }