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
# update and check current modules (PackageManagement and PowerShellGet are required.)
PS> Update-Module
PS> Get-Module

# install the modules
PS> Install-Module -Name posh-git               # posh-git
PS> Install-Module -Name oh-my-posh             # oh-my-posh
PS> Install-Module -Name windows-screenfetch    # screenfetch
```

## References

- [Oh my Posh 3](https://ohmyposh.dev/)
