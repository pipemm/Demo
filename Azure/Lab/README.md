
When you're working with a local install of Azure PowerShell, you need to authenticate before you can execute Azure commands.

In the Azure Cloud Shell (PowerShell), obtain the Access Token and the Account ID using below script.

```powershell
[System.String]$Token = (Get-AzAccessToken).Token;
[System.String]$Id    = (Get-AzAccessToken).UserId;

## extra
[System.String]$Expire = (Get-AzAccessToken).ExpiresOn.ToString('u');
'You can connect to Azure by executing the following command:' 
"Connect-AzAccount -AccessToken '${Token}' -AccountId '${Id}';"
''
"Pay attention to the fact that the session will expire beyond ${Expire}."

```
