
[System.String]$PathBasic   = 'File\Basic\';
[System.String]$Pathptional = 'File\Optional\';
New-Item -Name "${Pathptional}" -ItemType 'directory';

Add-Type -AssemblyName PresentationFramework;
Get-ChildItem -File -LiteralPath 'C:\Windows\Fonts\' |
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
            Copy-Item "${FullName}" -Destination "${Pathptional}";
        } catch {
            Write-Warning "Ignoring ${FullName}";
        };
    }
}
