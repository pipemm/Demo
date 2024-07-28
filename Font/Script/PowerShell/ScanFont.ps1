
[System.String]$PathBasic = 'File\Basic\';
New-Item -Name "${PathBasic}" -ItemType 'directory';

Add-Type -AssemblyName PresentationFramework;
Get-ChildItem -LiteralPath 'C:\Windows\Fonts' |
ForEach-Object -Process {
    [System.String]$FullName = $_.FullName;
    try { 
        [System.Windows.Media.GlyphTypeface]$FontFile = New-Object -TypeName System.Windows.Media.GlyphTypeface -ArgumentList "${FullName}";
        ${FontFile};
        Copy-Item "${FullName}" -Destination "${PathBasic}";
    } catch {
        Write-Warning "Ignoring ${FullName}";
    };
}
