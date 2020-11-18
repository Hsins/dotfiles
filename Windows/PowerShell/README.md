# PowerShell

## Files Locations

```bash
profile.ps1 > %USERPROFILE%\Documents\WindowsPowerShell
```

### Change Execution Policy

The PowerShell [execution policy](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies) is default set to `Restricted`. We should change the PowerShell execution policies with [`Set-ExecutionPolicy`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy) cmdlet.

```posh
PS> Set-ExecutionPolicy Unrestricted    # Change the Execution Policy
PS> Get-ExecutionPolicy                 # Get current Execution Policy
```

There are four different execution policies in PowerShell:

- `Restricted` – No scripts can be run.
- `AllSigned` – Only scripts signed by a trusted publisher can be run.
- `RemoteSigned` – Downloaded scripts must be signed by a trusted publisher.
- `Unrestricted` – All Windows PowerShell scripts can be run.

## Install Modules

Install the packages managed by [Powershell Gallery](https://www.powershellgallery.com/).

```posh
PS> Install-Module -Name PackageManagement -Force     # PackageManagement
PS> Install-Module -Name PowerShellGet -Force         # PowerShellGet

PS> Install-Module -Name posh-git -AllowPrerelease    # posh-git
PS> Install-Module -Name oh-my-posh -AllowPrerelease  # oh-my-posh
PS> Install-Module -Name windows-screenfetch          # screenfetch
```

## References

- [Oh my Posh 3](https://ohmyposh.dev/)
