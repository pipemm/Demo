
Get-WindowsCapability -Online |
  Where-Object State -EQ 'NotPresent' |
  Where-Object Name -Match '^Language\.Fonts';
