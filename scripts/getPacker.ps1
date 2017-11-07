[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri 'https://releases.hashicorp.com/packer/1.1.1/packer_1.1.1_windows_amd64.zip' -UseBasicParsing -OutFile "$PSScriptRoot\..\bin\packer.zip"
if (-not (Test-Path "$PSScriptRoot\..\bin\packer"))
{
	New-Item -ItemType Directory "$PSScriptRoot\..\bin\packer"
}
Expand-Archive -Path "$PSScriptRoot\..\bin\packer.zip" -DestinationPath "$PSScriptRoot\..\bin\packer"
Remove-Item "$PSScriptRoot\..\bin\packer.zip"
