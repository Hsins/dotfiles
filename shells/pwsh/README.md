# PowerShell

### Set the PowerShell Execution Policy

The PowerShell [execution policy](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies) is default set to `Restricted`. We should change the PowerShell execution policies with [`Set-ExecutionPolicy`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy) cmdlet.

```powershell
$ Set-ExecutionPolicy Unrestricted    # Change the Execution Policy
$ Get-ExecutionPolicy                 # Get current Execution Policy
```

There are four different execution policies in PowerShell:

- `Restricted` – No scripts can be run.
- `AllSigned` – Only scripts signed by a trusted publisher can be run.
- `RemoteSigned` – Downloaded scripts must be signed by a trusted publisher.
- `Unrestricted` – All Windows PowerShell scripts can be run.


[SamplePSReadLineProfile.ps1](https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1)

## References

- [Leverage PowerShell History across multiple machines](https://argonsys.com/microsoft-cloud/library/leverage-powershell-history-across-multiple-machines/)