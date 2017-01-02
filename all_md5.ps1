Param(
  [Parameter(Mandatory=$true)][string]$filePath
)

function FileHash([string] $path)
{
    #if ($PSVersionTable.PSVersion.Major -ge 4){
    #    $hash = (Get-FileHash -Algorithm MD5 $path).Hash
    #}
    #else{
        $md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
        $hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($path)))

        $hash = $hash -replace "-", ""
    #}
    return $hash
}

Write-Host ""

if ((Get-Item $filePath) -is [System.IO.DirectoryInfo]){
    foreach ($entry in Get-ChildItem $filePath){
        # Make sure it's a file, not a directory
        $fpath = $filePath + "\" + $entry
        if (-Not ((Get-Item $fpath) -is [System.IO.DirectoryInfo])){
            Write-Host $entry
            Write-Host (FileHash($fpath))
            Write-Host ""
        }
    }
}
else{
    # If the parameter is a filename, get a single hash:
    Write-Host $filePath
    FileHash($filePath)
}

