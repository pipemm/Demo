
[System.String]$PathCJK  = 'File\CJK\';
[System.String]$Language = "${env:Language}";

"${Language}";

Add-Type -AssemblyName PresentationFramework;
Get-ChildItem -Recurse -File -LiteralPath "${PathCJK}" |
ForEach-Object -Process {
    [System.String]$FullName = $_.FullName;
    $FullName;
    [System.Windows.Media.GlyphTypeface]$FontFile = New-Object -TypeName System.Windows.Media.GlyphTypeface -ArgumentList "${FullName}";
    ${FontFile}.FamilyNames.GetType();
    ${FontFile}.FamilyNames.GetType().FullName;
    ${FontFile};
}