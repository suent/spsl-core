# spsl-core
The core functionality of the Suent PowerShell Library.

## Executing the demo script

The SPSL demo script provides a demonstration of the functionality of the library.

### Download and execute in memory

```
Invoke-WebRequest "https://raw.githubusercontent.com/suent/spsl-core/main/script/SuentPowerShellLibrary.ps1" | Invoke-Expression
```

Note: Parameters cannot be supplied when using this method.

### Download to disk, and execute

```
Invoke-WebRequest "https://raw.githubusercontent.com/suent/spsl-core/main/script/SuentPowerShellLibrary.ps1" -OutFile ".\SuentPowerShellLibrary.ps1"
.\SuentPowerShellLibrary.ps1
```
