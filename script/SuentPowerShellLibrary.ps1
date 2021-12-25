#Requires -Version 5
<#
.SYNOPSIS

Provides interfaces to explore the Suent PowerShell Library.

.PARAMETER SpslIncludePath

The path to the SPSL library folder. If not specified, the path is searched in the following order:

./
include/
../include/
$env:USERPROFILE/.suent/spsl

If specified, only the specified path is used, even if libraries exist in another common folder.

.PARAMETER SpslForceDownload

Forces download of SPSL libraries to the SPSL include path.

#>

[CmdletBinding()]
param(
	[string]	$SpslIncludePath,
	[switch]	$SpslForceDownload
)

# Start timer used for script diagnostics
$stopwatch =  [system.diagnostics.stopwatch]::StartNew()

# Load SPSL libraries
$spslLibraries = @(
	"Common"
)

# Begin SPSL Library Loader snippet
##############################################################################
# SPSL-LLSv1
$ErrorActionPreference = "Stop"
$spslLibraryLoaderFilename = "LibraryLoader.ps1"
$spslDefaultIncludePath = "$env:USERPROFILE/.suent/spsl"
$spslLoaderSource = "https://raw.githubusercontent.com/suent/spsl-core/main/include/LibraryLoader.ps1" 
$spslLoader = $null

Function OptimizePath ($x) {
	<#
	.SYNOPSIS
		Optimizes a path for readability. Cross platform powershell scrips are not consistent, for example with path separators.
		This function makes the path pretty and readable.
	#>
	return [IO.Path]::GetFullPath([IO.Path]::Combine($(Get-Location),$x))
}

Function Write-SpslDebug ($x) {
	<#
	.SYNOPSIS
		Writes a debug message with a timestamp.
	#>
	Write-Debug "$(Get-Date -Format 'MM-dd-yyyy HH:mm:ss.fff'): $x"
}

# Check include path
If ($SpslIncludePath) {
	$spslCheckIncludePath = $SpslIncludePath
	$spslUseIncludePath = $SpslIncludePath
} else {
	if (-Not $SpslForceDownload) {
		Write-SpslDebug "Searching for SPSL include path..."
	}
	$spslUseIncludePath = $spslDefaultIncludePath
	$spslCheckIncludePath = @(
		".",
		"include",
		"../include",
		$spslIncludePath
	)
}

# Check if loader exists, if not forced download
If (-Not $SpslForceDownload) {
	ForEach ($spslCheckInclude in $spslCheckIncludePath) {
		Write-SpslDebug "Checking $(OptimizePath($spslCheckInclude))"
		If (Test-Path "$spslCheckInclude/$spslLibraryLoaderFilename") {
			$spslLoader = "$spslCheckInclude/$spslLibraryLoaderFilename"
			Write-SpslDebug "Found: $(OptimizePath($spslLoader))"
			Break
		}
	}
}

# Download if it doesnt, or if forced
If (-not $spslLoader) {
	Write-SpslDebug "Downloading LibraryLoader.ps1 from GitHub..."
	If (-not (Test-Path $spslUseIncludePath)) {
		New-Item -Path $spslUseIncludePath -ItemType Directory -Verbose:$VerbosePreference | Out-Null
	}
	$spslLoader = "$spslUseIncludePath/LibraryLoader.ps1"
	Invoke-WebRequest $spslLoaderSource -OutFile $spslLoader -Verbose:$False -Debug:$DebugPreference
	Write-Verbose "SPSL LibraryLoader downloaded: $(OptimizePath($spslLoader))"
}

# Execute LibraryLoader
. $spslLoader -SpslLibraries $spslLibraries

##############################################################################
# End SPSL Library Loader snippet

Write-Host "Hello World"
