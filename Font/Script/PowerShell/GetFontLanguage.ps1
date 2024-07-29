
[System.String]$PathCJK    = 'File\CJK\';
[System.String]$Language   = "${env:Language}";
[System.String]$PathTarget = 'File\Target\';
New-Item -Name "${PathTarget}" -ItemType 'directory';

if ( "${Language}" -ne '' ) {
    Add-Type -AssemblyName PresentationFramework;
    Get-ChildItem -Recurse -File -LiteralPath "${PathCJK}" |
        ForEach-Object -Process {
            [System.String]$FullName = $_.FullName;
            [System.Windows.Media.GlyphTypeface]$FontFile = New-Object -TypeName System.Windows.Media.GlyphTypeface -ArgumentList "${FullName}";
            $FamilyNames = ${FontFile}.FamilyNames;  ## MS.Internal.Text.TextInterface.LocalizedStrings
            $FamilyName  = (${FamilyNames} | Where-Object {$_.Key -eq "${Language}"}).Value;
            if ( ${FamilyName} -ne $null ) {
                Copy-Item "${FullName}" -Destination "${PathTarget}";
                $FaceNames = ${FontFile}.FaceNames;
                $FaceName  = (${FaceNames} | Where-Object {$_.Key -eq "${Language}"}).Value;
                if ( ${FaceName} -eq $null ) {
                    $FaceName = ${FaceNames}.Values[0];
                }
                ${FontFile} | Add-Member -MemberType NoteProperty -Name 'FamilyName' -Value ${FamilyName};
                ${FontFile} | Add-Member -MemberType NoteProperty -Name 'FaceName'   -Value ${FaceName};
                ${FontFile};
            }
        } ;
}
