
Add-Type -AssemblyName PresentationFramework;
Get-ChildItem -LiteralPath 'C:\Windows\Fonts' |
ForEach-Object -Process {
    [System.String]$FullName = $_.FullName;
    try { 
        [System.Windows.Media.GlyphTypeface]$FontFile = New-Object -TypeName System.Windows.Media.GlyphTypeface -ArgumentList "${FullName}";
        $FullName;
        $FontFile;
    } catch {
        Write-Warning "Ignoring ${FullName}";
    };
}
