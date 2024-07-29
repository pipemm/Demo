
[System.String]$PathCJK  = 'File\CJK\';
[System.String]$Language = "${env:Language}";

if ( "${Language}" -ne '' ) {
    Add-Type -AssemblyName PresentationFramework;
    Get-ChildItem -Recurse -File -LiteralPath "${PathCJK}" |
        ForEach-Object -Process {
            [System.String]$FullName = $_.FullName;
            [System.Windows.Media.GlyphTypeface]$FontFile = New-Object -TypeName System.Windows.Media.GlyphTypeface -ArgumentList "${FullName}";
            $FamilyNames = ${FontFile}.FamilyNames;  ## MS.Internal.Text.TextInterface.LocalizedStrings
            $FamilyName  = (${FamilyNames} | Where-Object {$_.Key -eq "${Language}"}).Value;
            ${FontFile} | Add-Member -MemberType NoteProperty -Name 'FamilyName' -Value ${FamilyName};
        } | 
        Where-Object FamilyName -NE $null;
}
