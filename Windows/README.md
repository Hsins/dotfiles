## PowerShell

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

## Windows Terminal

- Put `settings.json` in `%USERPROFILE%\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState`
- Put icons in `%USERPROFILE%\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState`

## References

- [新生代 Windows 终端：Windows Terminal 的全面自定義](https://sspai.com/post/59380)
- [告别 Windows 終端的難看難用，從改造 PowerShell 的外觀開始](https://sspai.com/post/52868)
- [Windows Terminal Themes](https://windowsterminalthemes.dev/)
- [[Help] How to install NeoFetch/Screenfetch on Windows 10?](https://www.reddit.com/r/windows/comments/8dwm5m/help_how_to_install_neofetchscreenfetch_on/)
