[Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.PSResourceProviderLocation[]] $Locations     = (Get-AzLocation);
[System.Collections.Specialized.OrderedDictionary]                                        $Location_Dict = [ordered]@{};
${Locations} |
Where-Object -FilterScript { $_.RegionType -eq 'Physical' } |
ForEach-Object -Process {
    [System.String]$Location         = $_.Location;
    [System.String]$DisplayName      = $_.DisplayName;
    [System.String]$PhysicalLocation = $_.PhysicalLocation;
    [System.String]$GeographyGroup   = $_.GeographyGroup;
    [System.String]$DisplayLocation  = "${PhysicalLocation}, ${GeographyGroup}";
    if ( "${PhysicalLocation}" -eq '') {
        [System.String]$DisplayLocation = "${GeographyGroup}";
    }
    $Location_Dict["${Location}"]    = "${DisplayName} (${Location}), ${DisplayLocation}";
}

[Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.PSResourceGroup[]]$ResourceGroups = (Get-AzResourceGroup);
Write-Output ${ResourceGroups}
if ( ${ResourceGroups}.Count -gt 0 ) {
    [Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.PSResourceGroup]$group = ${ResourceGroups}[0];
    [System.String]$groupname      = $group.ResourceGroupName;
    [System.String]$glocation      = $group.Location;
    [System.String]$location_disp  = "${glocation}";
    if ( $Location_Dict.Contains("${glocation}") ) {
        [System.String]$location_disp  = $Location_Dict["${glocation}"]
    }
} else {
    Write-Error -Message 'There is no resource group found. '
    exit 1;
}

[System.String]$LocationUsed = "${Env:LOCATION}"
if ( "${LocationUsed}" -eq 'default' ) {
    [System.String]$LocationUsed = "${glocation}"
}
[System.String]$LocationUsed_Disp  = "${LocationUsed}";
if ( $Location_Dict.Contains("${LocationUsed}") ) {
    [System.String]$LocationUsed_Disp  = $Location_Dict["${LocationUsed}"]
}

[Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.PSResource[]]$resources = (Get-AzResource -ResourceGroupName "${groupname}");
[System.Int32] $number_resources = ${resources}.Count;
Write-Output ${resources};
${resources} | Format-Table

Write-Output "The ${groupname} resource group will be used. Its location is ${location_disp}. It contains ${number_resources} resource(s). "
Write-Output "The location ${LocationUsed_Disp} will be used."

if ( "${Env:GITHUB_ENV}" -ne $null ) {
    Write-Output 'Setting Github Environment Variables. ';
    Write-Output "GROUP_NAME=${groupname}";
    "GROUP_NAME=${groupname}"  >> "${Env:GITHUB_ENV}"
    Write-Output "LOCATION=${LocationUsed}";
    "LOCATION=${LocationUsed}" >> "${Env:GITHUB_ENV}"
}
