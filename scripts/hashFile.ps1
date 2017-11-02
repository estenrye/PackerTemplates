[Reflection.Assembly]::LoadWithPartialName("System.Security") | Out-Null
function HashFile([string] $filePath) {
	if ([string]::IsNullOrEmpty($filePath) -or !(Test-Path $filePath -PathType Leaf)) {
		return $null
	}

	[System.IO.Stream] $file = $null;
	[System.Security.Cryptography.SHA1] $hash = $null;
	try {
		$hash = [System.Security.Cryptography.SHA1]::Create()
		$file = [System.IO.File]::OpenRead($filePath)
		return [System.BitConverter]::ToString($hash.ComputeHash($file)).Replace('-', '').ToLower()
	}
	finally {
		if ($file -ne $null) {
			$file.Dispose()
		}
	}
}