
[Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.PSResource[]]    $Resources       = (Get-AzResource);
[System.Int32]                                                               $NumberResources = ${Resources}.Count;
Write-Output "This environment contains ${NumberResources} resource(s): "
Write-Output ${Resources};
${Resources} | Format-Table;
Write-Output '';

[Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.PSResourceGroup[]]$ResourceGroups = (Get-AzResourceGroup);

Write-Output "Viewable Resource Groups : ";
Write-Output ${ResourceGroups};

${ResourceGroups} |
    ForEach-Object -Process {
        [Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.PSResourceGroup] $ResourceGroup   = ${_};
        [System.String]                                                              $GroupName       = ${ResourceGroup}.ResourceGroupName;
        [Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.PSResource[]]    $Resources       = (Get-AzResource -ResourceGroupName "${GroupName}");
        [System.Int32]                                                               $NumberResources = ${Resources}.Count;
        Write-Output "The ${GroupName} resource group contains ${NumberResources} resource(s): "
        Write-Output ${Resources};
        ${Resources} | Format-Table;
        ${Resources} | 
            Group-Object -Property ResourceType -NoElement |
            Sort-Object -Property Count -Descending
        Write-Output '';
    }

