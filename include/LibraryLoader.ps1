<#
.SYNOPSIS

Performs the lifting for loading libaries from the Suent PowerShell Library.

.PARAMETER SpslLibraries

The libraries to load.

.PARAMETER SpslIncludePath

The path to the SPSL library folder.

.PARAMETER SpslForceDownload

Forces download of SPSL libraries to the SPSL include path.

#>

[CmdletBinding()]
param (
	[string[]]	$SpslLibraries,
	[string]	$SpslIncludePath = "{{Undefined}}",
	[switch]	$SpslForceDownload
)

If ($SpslIncludePath -eq "{{Undefined}}") {
	$SpslIncludePath = $PSScriptRoot
}

# Validate include directory and display once
if (!($spslDisplayedScriptIncludeDirectory)) {
	Write-SpslDebug "Checking include directory..."
	Write-Verbose "SPSL include path: $(OptimizePath $SpslIncludePath)"
	$spslDisplayedScriptIncludeDirectory=$true
}

# Load libraries
foreach ($library in $SpslLibraries) {
	if (!(Get-Variable -Name "spsl_$($library)_Loaded" -ErrorAction SilentlyContinue)) {
		. ("$SpslIncludePath/$($library).ps1") 
	}
}
