
[System.String]$PathBasic = 'File\Basic\';
[System.String]$PathNew   = 'File\New\';


#Add-Type -AssemblyName PresentationFramework;
Get-ChildItem -LiteralPath 'C:\Windows\Fonts' |
ForEach-Object -Process {
    [System.String]$FullName      = $_.FullName;
    [System.String]$Name          = $_.Name;
    [System.String]$PathFileBasic = (Join-Path -Path "${PathBasic}" -ChildPath "${Name}");
    if (Test-Path "${PathFileBasic}" -PathType 'Leaf') {
        $PathFileBasic;
    } else {
        $FullName ;
    }
    
}
