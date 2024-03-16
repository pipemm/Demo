
When you're working with a local install of Azure PowerShell, you need to authenticate before you can execute Azure commands.

In the Azure Cloud Shell (PowerShell), obtain the Access Token and the Account ID using below script.

```powershell
$Token=(Get-AzAccessToken).Token;
$Id=(Get-AzContext).Account;

## extra

'You can connect to Azure by executing following command.' 
''
"Connect-AzAccount -AccessToken '${Token}' -AccountId '${Id}'"

```
