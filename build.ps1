[CmdletBinding()]
param(
	[string]$ImageName = 'WindowsServer2016StdCore-BaseInstall',
	[ValidateSet("Quiet", "Minimal", "Normal", "Verbose", "Diagnostic")]
	[string]$Verbosity = "Diagnostic",
	[Alias("DryRun", "Noop")]
	[switch]$WhatIf,
	[Parameter(Position = 0, Mandatory = $false, ValueFromRemainingArguments = $true)]
	[string[]]$ScriptArgs
)
$BIN_DIR = Join-Path $PSScriptRoot bin
$SCRIPTS_DIR = Join-Path $PSScriptRoot scripts

if (-not (Test-Path $BIN_DIR))
{
	New-Item -ItemType Directory $BIN_DIR
}

& "$SCRIPTS_DIR\getPacker.ps1"

if (-not (Test-Path "$BIN_DIR\powershell-yaml"))
{
	& "$SCRIPTS_DIR\getPowershellYaml.ps1"
}

[Reflection.Assembly]::LoadFile("$BIN_DIR\powershell-yaml\lib\net45\YamlDotNet.dll")
Import-Module "$BIN_DIR\powershell-yaml\powershell-yaml.psm1" -Force

$osData = ConvertFrom-Yaml (Get-Content -Raw "$PSScriptRoot\build.supported_os.yaml")
$os = $osData | Where-Object {$_.Name -eq $ImageName} | Select-Object -First 1
Write-Output "'os_name=$($os.osName)'"
Write-Output "'iso_checksum=$($os.isoChecksum)'"
Write-Output "'iso_url=$($os.isoURL)'"
Write-Output "$PSScriptRoot\$($os.BuildPath)"
$env:TMP = "$PSScriptRoot\temp"
$env:PACKER_CACHE_DIR = "$PSScriptRoot\packer-cache"
$env:PACKER_LOG = 1
$env:PACKER_LOG_PATH = "$PSScriptRoot\packer.log"

if (-not (Test-Path $env:TMP))
{
	New-Item -ItemType Directory $env:TMP
}
if (-not (Test-Path $env:PACKER_CACHE_DIR))
{
	New-Item -ItemType Directory $env:PACKER_CACHE_DIR
}
Start-Process -FilePath "$BIN_DIR\packer\packer.exe" -Wait -NoNewWindow -ArgumentList @(
	"build",
	"-var",
	"os_name=$($os.osName)",
	"-var",
	"iso_checksum=$($os.isoChecksum)",
	"-var",
	"iso_url=$($os.isoURL)",
	# '-debug',
	"$PSScriptRoot\$($os.BuildPath)")
