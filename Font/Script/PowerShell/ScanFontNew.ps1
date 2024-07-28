
[System.String]$PathBasic = 'File\Basic\';
[System.String]$PathNew   = 'File\New\';


#Add-Type -AssemblyName PresentationFramework;
Get-ChildItem -LiteralPath 'C:\Windows\Fonts' |
ForEach-Object -Process {
    [System.String]$FullName      = $_.FullName;
    [System.String]$Name          = $_.Name;
    [System.String]$PathFileBasic = (Join-Path -Path "${PathBasic}" -ChildPath "${Name}");
    if (Test-Path "${PathFileBasic}" -PathType 'Leaf') {
        Write-Information "Ignoring  ${FullName}";
    } else {
        try { 
            [System.Windows.Media.GlyphTypeface]$FontFile = New-Object -TypeName System.Windows.Media.GlyphTypeface -ArgumentList "${FullName}";
            ${FontFile};
            Copy-Item "${FullName}" -Destination "${PathNew}";
        } catch {
            Write-Warning "Ignoring ${FullName}";
        };
    }
    
}
