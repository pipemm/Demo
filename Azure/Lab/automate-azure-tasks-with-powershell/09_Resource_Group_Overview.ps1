
[Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.PSResourceGroup[]]$ResourceGroups = (Get-AzResourceGroup);

${ResourceGroups} |
    ForEach-Object -Process {
        [Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.PSResourceGroup] $ResourceGroup   = ${_};
        [System.String]                                                              $GroupName       = ${ResourceGroup}.Name;
        [Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.PSResource[]]    $Resources       = (Get-AzResource -ResourceGroupName "${GroupName}");
        [System.Int32]                                                               $NumberResources = ${Resources}.Count;
        Write-Output "The ${GroupName} resource group contains ${NumberResources} resource(s): "
        Write-Output ${Resources};
        ${Resources} | Format-Table;
        Write-Output '';
    }
