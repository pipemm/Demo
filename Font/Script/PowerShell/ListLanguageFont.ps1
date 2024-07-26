
Get-WindowsCapability -Online |
  Where-Object Name -Match '^Language\.Fonts';