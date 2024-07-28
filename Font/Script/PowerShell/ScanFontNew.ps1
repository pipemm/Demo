
[System.String]$PathBasic = 'File\Basic\';
[System.String]$PathNew   = 'File\New\';


#Add-Type -AssemblyName PresentationFramework;
Get-ChildItem -LiteralPath 'C:\Windows\Fonts' |
ForEach-Object -Process {
    [System.String]$FullName = $_.FullName;
    $_ ;
}
