[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if (-not (Test-Path "C:\HashiCorp\Vagrant\"))
{
	Invoke-WebRequest -Uri 'https://releases.hashicorp.com/vagrant/2.0.1/vagrant_2.0.1_x86_64.msi' -UseBasicParsing -OutFile "$PSScriptRoot\..\bin\vagrant.msi"
	msiexec.exe /i /quiet "$PSScriptRoot\..\bin\vagrant.msi"
	Remove-Item "$PSScriptRoot\..\bin\vagrant.msi"
}

