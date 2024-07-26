
Get-WindowsCapability -Online |
  Where-Object State -EQ 'NotPresent' |
  Where-Object Name -Match '^Language\.Fonts' |
  Where-Object Name -Match 'Jpan' |
  ForEach-Object -Process {
    [System.String]$Capability = $_.Name;
    ${Capability};
    Add-WindowsCapability -Online -Name "${Capability}";
  }
