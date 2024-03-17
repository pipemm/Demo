
## https://learn.microsoft.com/en-us/training/modules/automate-azure-tasks-with-powershell/6-exercise-create-resource-interactively

[System.Int32] $NumberVM      = [System.Int32]${Env:NUM_VMS};
if ( $(NumberVM} -eq $null ) {
    [System.Int32] $NumberVM  = [System.Int32]1;
} elseif ( $(NumberVM} -lt 1) {
    [System.Int32] $NumberVM  = [System.Int32]1;
} elseif ( $(NumberVM} -gt 9) {
    [System.Int32] $NumberVM  = [System.Int32]9;
}
[System.Int32] $port_ssh_open  = 22;
[System.String]$ImageVM        = "${Env:IMMAGE}";
[System.String]$ResourceGroup  = "${Env:RESOURCEGROUPNAME}";
[System.String]$LocationVM     = "${Env:LOCATION}";
[System.String]                $username    =  "${Env:VM_USERNAME}";
[System.Security.SecureString] $password    = ("${Env:VM_PASSWORD}" | ConvertTo-SecureString -AsPlainText -Force);
[System.Management.Automation.PSCredential] $Credential = [System.Management.Automation.PSCredential]::New(${username},${password});
[System.String]                $UsernameVM = ${Credential}.Username;

if ( "${ResourceGroup}" -eq '' ) {
    Write-Error -Message 'There is no resource group found. '
    exit 1;
}

Write-Output "Resource Group               : ${ResourceGroup}";
Write-Output "Virtual Machine Location     : ${LocationVM}";
Write-Output "Virtual Machine Image        : ${ImageVM}";
Write-Output "Port for Secure Shell (Open) : ${port_ssh_open}";
Write-Output "Virtual Machine User Name    : ${UsernameVM}";
Write-Output "Number of Machines to be disployed : ${NumberVM}";

[System.String]  $PrefixVM  = 'testvm';
[System.Int32[]] $PortsOpen = @(${port_ssh_open});

foreach( $n in 1..${NumberVM} ){
    [System.String]$NameVM = "${PrefixVM}-${LocationVM}-" + ${n}.ToString().PadLeft(3,'0')
    Write-Output "Deploying Virtual Machine : ${NameVM}";
    [Microsoft.Azure.Commands.Compute.Models.PSVirtualMachine]$vm = 
        (
            New-AzVm -ResourceGroupName "${ResourceGroup}"`
                -Name       "${NameVM}" `
                -Credential  ${Credential} `
                -Location   "${LocationVM}" `
                -Image      "${ImageVM}" `
                -OpenPorts   ${PortsOpen} `
                -PublicIpAddressName "${NameVM}"
        );
    Write-Output ${vm};
}