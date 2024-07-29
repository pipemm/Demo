
[System.String]$Language = "${env:Language}";

if ( "${Language}" -ne '' ) {
    Get-WindowsCapability -Online |
        Where-Object State -EQ 'NotPresent' |
        Where-Object Name -Match '^Language\.Fonts' |
        Where-Object Name -Match "${Language}" |
        ForEach-Object -Process {
            [System.String]$Capability = $_.Name;
            ${Capability};
            Add-WindowsCapability -Online -Name "${Capability}";
        }
}
