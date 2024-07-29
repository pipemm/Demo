
[System.String]$PathCJK  = 'File\CJK\';
[System.String]$Language = "${env:Language}";

Add-Type -AssemblyName PresentationFramework;
Get-ChildItem -Recurse -File -LiteralPath "${PathCJK}" |
ForEach-Object -Process {
    [System.String]$FullName = $_.FullName;
    $FullName;
    [System.Windows.Media.GlyphTypeface]$FontFile = New-Object -TypeName System.Windows.Media.GlyphTypeface -ArgumentList "${FullName}";
    $FamilyNames = ${FontFile}.FamilyNames;
    $FamilyName  = (${FamilyNames} | Where-Object {$_.Key -eq "${Language}"}).Value;
    ${FontFile} | Add-Member -MemberType NoteProperty -Name 'FamilyName' -Value ${FamilyName};
}