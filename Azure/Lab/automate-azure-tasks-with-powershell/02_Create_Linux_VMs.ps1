
[System.Int32] $number_vm      = 3;
[System.Int32] $port_ssh_open  = 22;
[System.String]$image_vm       = 'Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest';
[System.String]$resource_group = "${Env:GROUP_NAME}";
[System.String]$location_vm    = "${Env:LOCATION}";
[System.String]                $username    =  "${Env:VM_USERNAME}";
[System.Security.SecureString] $password    = ("${Env:VM_PASSWORD}" | ConvertTo-SecureString -AsPlainText -Force);
[System.Management.Automation.PSCredential] $credential = [System.Management.Automation.PSCredential]::New(${username},${password});
[System.String]                $username_vm = ${credential}.Username;

${resource_group} -eq '';
if ( "${resource_group}" -eq '' ) {
    Write-Error -Message 'There is no resource group found. '
    exit 1;
}

Write-Output "Resource Group               : ${resource_group}";
Write-Output "Virtual Machine Location     : ${location_vm}";
Write-Output "Virtual Machine Image        : ${image_vm}";
Write-Output "Port for Secure Shell (Open) : ${port_ssh_open}";
Write-Output "Virtual Machine User Name    : ${username_vm}";
Write-Output "Number of Machines to be disployed : ${number_vm}";

[System.String]  $prefix_vm  = 'testvm';
[System.Int32[]] $ports_open = @(${port_ssh_open});

foreach( $n in 1..${number_vm} ){
    [System.String]$name_vm = "${prefix_vm}-${location_vm}-" + ${n}.ToString().PadLeft(3,'0')
    Write-Output "Deploying Virtual Machine : ${name_vm}";
    $vm = (New-AzVm -ResourceGroupName "${resource_group}" -Name "${name_vm}" `
            -Credential ${credential} `
            -Location "${location_vm}" `
            -Image "${image_vm}" `
            -OpenPorts ${ports_open} `
            -PublicIpAddressName "${name_vm}"
        );
    ${vm}.GetType().FullName;
    ${vm}.HardwareProfile;
    ${vm}.StorageProfile.OsDisk;
    ${vm} | Get-AzVMSize
}