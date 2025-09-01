Param(
  [Parameter(Mandatory=$false)][string]$ExtensionId
)

if (-not $ExtensionId) {
  $ExtensionId = Read-Host "Enter the Chrome extension ID (from chrome://extensions)"
}

$BaseDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$HelperPath = Join-Path $BaseDir "native\open_in_brave.py"
$HostName = "uk.co.adgico.open-in-brave"
$ManifestDir = "$env:LOCALAPPDATA"
$ManifestPath = Join-Path $ManifestDir "$HostName.json"

# Build JSON from template
$templatePath = Join-Path $BaseDir "native\host-manifests\uk.co.adgico.open-in-brave.template.json"
$template = Get-Content $templatePath -Raw | ConvertFrom-Json
$template.path = $HelperPath
$template.allowed_origins = @("chrome-extension://$ExtensionId/")
$template | ConvertTo-Json -Depth 5 | Out-File -FilePath $ManifestPath -Encoding UTF8

# Registry registration (Current User)
$RegPath = "HKCU:\Software\Google\Chrome\NativeMessagingHosts\$HostName"
New-Item -Path $RegPath -Force | Out-Null
New-ItemProperty -Path $RegPath -Name "(Default)" -Value $ManifestPath -PropertyType String -Force | Out-Null

Write-Host "Installed native host manifest to $ManifestPath and registry key $RegPath"
Write-Host "Ensure Python 3 is on PATH and Brave is installed."
