if (-not (Test-Path "$PSScriptRoot\..\bin\packer\packer.exe"))
{
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	Invoke-WebRequest -Uri 'https://releases.hashicorp.com/packer/1.1.1/packer_1.1.1_windows_amd64.zip' -UseBasicParsing -OutFile "$PSScriptRoot\..\bin\packer.zip" -ErrorAction:Stop
	Write-Host "Downloaded: $PSScriptRoot\..\bin\packer.zip"
	if (-not (Test-Path "$PSScriptRoot\..\bin\packer"))
	{
		New-Item -ItemType Directory "$PSScriptRoot\..\bin\packer"
	}
	Write-Host "Extracting $PSScriptRoot\..\bin\packer.zip"
	Expand-Archive -Path "$PSScriptRoot\..\bin\packer.zip" -DestinationPath "$PSScriptRoot\..\bin\packer" -ErrorAction:Stop
	Write-Host "Deleting Archive. $PSScriptRoot\..\bin\packer.zip"
	Remove-Item "$PSScriptRoot\..\bin\packer.zip"
}
