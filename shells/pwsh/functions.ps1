<#
 * Author   : Hsins
 * Email    : hsinspeng@gmail.com
 * Updated  : 2021/10/10
 * Version  : 2.0.0
 * Path     : %USERPROFILE%\Documents\PowerShell\functions.ps1
#>

if ($null -eq (Get-Variable "ColorInfo" -ErrorAction "Ignore")) {
  Set-Variable -Name "ColorInfo" -Value "DarkYellow"
}

# --------------------------------------------------
# General
# --------------------------------------------------

function Get-Aliases {
  <#
  .SYNOPSIS
      Lists aliases.
  .INPUTS
      None
  .OUTPUTS
      Microsoft.PowerShell.Commands.Internal.Format
  .LINK
      Get-Alias
  #>
  Get-Alias | Format-Table Name, ResolvedCommandName, Description, HelpUri
}

function Get-Mounts {
  <#
  .SYNOPSIS
      Lists drive mounts.
  .INPUTS
      None
  .OUTPUTS
      Microsoft.PowerShell.Commands.Internal.Format
      System.String
  .LINK
      http://lifeofageekadmin.com/display-mount-points-drives-using-powershell/
  #>
  [CmdletBinding()]
  param()

  $Capacity = @{Name = "Capacity(GB)"; Expression = { [math]::round(($_.Capacity / 1073741824)) } }
  $FreeSpace = @{Name = "FreeSpace(GB)"; Expression = { [math]::round(($_.FreeSpace / 1073741824), 1) } }
  $Usage = @{Name = "Usage"; Expression = { -join ([math]::round(100 - ((($_.FreeSpace / 1073741824) / ($_.Capacity / 1073741824)) * 100), 0), '%') }; Alignment = "Right" }

  if ($IsCoreCLR) {
    $volumes = Get-CimInstance -ClassName Win32_Volume
  }
  else {
    $volumes = Get-WmiObject Win32_Volume
  }
  $volumes | Where-Object name -notlike \\?\Volume* | Format-Table DriveLetter, Label, FileSystem, $Capacity, $FreeSpace, $Usage, PageFilePresent, IndexingEnabled, Compressed
}
function Get-Path {
  <#
  .SYNOPSIS
      Prints each PATH entry on a separate lines.
  .INPUTS
      None
  .OUTPUTS
      System.String[]
  #>
  begin {
    $separator = ';'
    if (!$IsWindows) {
      $separator = ':'
    }
  }

  process {
    ${Env:PATH}.split($separator)
  }
}

function Get-TopProcess {
  <#
  .SYNOPSIS
      Monitors processes and system resource..
  .INPUTS
      None
  .OUTPUTS
      System.Object
  #>
  while ($true) {
    Clear-Host
    # Sort by Working Set size.
    Get-Process | Sort-Object -Descending "WS" | Select-Object -First 30 | Format-Table -Autosize
    Start-Sleep -Seconds 2
  }
}

function Search-History {
  <#
  .SYNOPSIS
      Displays/Searches global history.
  .INPUTS
      System.Object
  .OUTPUTS
      System.String
  .LINK
      Get-Content
  #>
  $pattern = '*' + $args + '*'
  Get-Content (Get-PSReadlineOption).HistorySavePath | Where-Object { $_ -Like $pattern } | Get-Unique
}

function Invoke-RepeatCommand {
  <#
  .SYNOPSIS
      Repeats a command `x` times.
  .DESCRIPTION
      Allows issuing a command multiple times in a row.
  .PARAMETER Count
      The max number of times to repeat a command.
  .PARAMETER Command
      The command to run. Can include spaces and arguments.
  .EXAMPLE
      Repeat-Command 5 echo hello world
  .INPUTS
      System.String
  .OUTPUTS
      None
  #>
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [int]$Count,

    [Parameter(Mandatory = $true)]
    $Command,

    [Parameter(ValueFromRemainingArguments = $true)]
    $Params
  )

  begin {
    $Params = $Params -join ' '
  }

  process {
    for ($i = 1; $i -le $Count; $i++) {
      if ($Params) {
        &$Command $Params
      }
      else {
        &$Command
      }
    }
  }
}

# --------------------------------------------------
# System Operations
# --------------------------------------------------

function Invoke-Lock {
  <#
  .SYNOPSIS
      Locks the session.
  .PARAMETER Force
      Do not prompt for confirmation.
  .INPUTS
      None
  .OUTPUTS
      None
  #>
  [CmdletBinding(
    SupportsShouldProcess = $true,
    ConfirmImpact = 'Medium'
  )]
  param(
    [switch]$Force
  )

  if ($Force -or $PSCmdlet.ShouldContinue("Are you sure you want to do this?", "Lock the session.")) {

    if ($IsWindows) {
      Invoke-Command { rundll32.exe user32.dll, LockWorkStation }
    }
    elseif ($IsMacOS) {
      pmset displaysleepnow
    }
    elseif (Get-Command "vlock" -ErrorAction "Ignore") {
      vlock --all
    }
    elseif (Get-Command "gnome-screensaver-command" -ErrorAction "Ignore") {
      gnome-screensaver-command --lock
    }
  }
}

function Invoke-Hibernate {
  <#
  .SYNOPSIS
      Goes to sleep.
  .PARAMETER Force
      Do not prompt for confirmation.
  .INPUTS
      None
  .OUTPUTS
      None
  #>
  [CmdletBinding(
    SupportsShouldProcess = $true,
    ConfirmImpact = 'Medium'
  )]
  param(
    [switch]$Force
  )

  if ($Force -or $PSCmdlet.ShouldContinue("Are you sure you want to do this?", "Send the system to sleep.")) {
    if ($IsLinux) {
      systemctl suspend
    }
    elseif ($IsMacOS) {
      pmset sleep now
    }
    else {
      shutdown.exe /h
    }
  }
}

function Invoke-Restart {
  <#
  .SYNOPSIS
      Restarts the system.
  .PARAMETER Force
      Do not prompt for confirmation.
  .INPUTS
      None
  .OUTPUTS
      None
  .LINK
      Restart-Computer
  #>
  [CmdletBinding(
    SupportsShouldProcess = $true,
    ConfirmImpact = 'Medium'
  )]
  param(
    [switch]$Force
  )

  if ($Force -or $PSCmdlet.ShouldContinue("Are you sure you want to do this?", "Restart the system.")) {
    if ($IsLinux) {
      sudo /sbin/reboot
    }
    elseif ($IsMacOS) {
      osascript -e 'tell application "System Events" to restart'
    }
    else {
      Restart-Computer
    }
  }
}

function Invoke-PowerOff {
  <#
  .SYNOPSIS
      Shuts down the system.
  .PARAMETER Force
      Do not prompt for confirmation.
  .INPUTS
      None
  .OUTPUTS
      None
  .LINK
      Stop-Computer
  #>
  [CmdletBinding(
    SupportsShouldProcess = $true,
    ConfirmImpact = 'Medium'
  )]
  param(
    [switch]$Force
  )

  if ($Force -or $PSCmdlet.ShouldContinue("Are you sure you want to do this?", "Shut down the system.")) {
    if ($IsLinux) {
      sudo /sbin/poweroff
    }
    elseif ($IsMacOS) {
      osascript -e 'tell application "System Events" to shut down'
    }
    else {
      Stop-Computer
    }
  }
}

# --------------------------------------------------
# Time Functions
# --------------------------------------------------

function Get-DateExtended {
  <#
  .SYNOPSIS
      Display local date and time in ISO-8601 format `YYYY-MM-DDThh:mm:ss`.
  .INPUTS
      None
  .OUTPUTS
      System.String
  .LINK
      Get-Date
  .LINK
      https://e.wikipedia.org/wiki/ISO_8601
  #>
  Get-Date -Format "yyyy-MM-ddTHH:mm:ss"
}

function Get-DateExtendedUTC {
  <#
  .SYNOPSIS
      Display UTC date and time in ISO-8601 format `YYYY-MM-DDThh:mm:ss`.
  .INPUTS
      None
  .OUTPUTS
      System.String
  .LINK
      Get-Date
  .LINK
      https://en.wikipedia.org/wiki/ISO_8601
  #>
  (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss")
}

function Get-CalendarDate {
  <#
  .SYNOPSIS
      Displays local date in `YYYY-MM-DD` format.
  .INPUTS
      None
  .OUTPUTS
      System.String
  .LINK
      Get-Date
  .LINK
      https://en.wikipedia.org/wiki/ISO_8601
  #>
  Get-Date -Format "yyyy-MM-dd"
}

function Get-CalendarDateUTC {
  <#
  .SYNOPSIS
      Displays UTC date in `YYYY-MM-DD` format.
  .INPUTS
      None
  .OUTPUTS
      System.String
  .LINK
      Get-Date
  .LINK
      https://en.wikipedia.org/wiki/ISO_8601
  #>
  (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd")
}

function Get-Time {
  <#
  .SYNOPSIS
      Displays local time in `hh:mm:ss` format.
  .INPUTS
      None
  .OUTPUTS
      System.String
  .LINK
      Get-Date
  .LINK
      https://en.wikipedia.org/wiki/ISO_8601
  #>
  Get-Date -Format "HH:mm:ss"
}

function Get-TimeUTC {
  <#
  .SYNOPSIS
      Displays UTC time in `hh:mm:ss` format.
  .INPUTS
      None
  .OUTPUTS
      System.String
  .LINK
      Get-Date
  .LINK
      https://en.wikipedia.org/wiki/ISO_8601
  #>
  (Get-Date).ToUniversalTime().ToString("HH:mm:ss")
}

function Get-Timestamp {
  <#
  .SYNOPSIS
      Display Unix time stamp.
  .INPUTS
      None
  .OUTPUTS
      System.String
  .LINK
      Get-Date
  #>
  Get-Date -UFormat %s -Millisecond 0
}

function Get-WeekDate {
  <#
  .SYNOPSIS
      Displays week number in ISO-9601 format `YYYY-Www`.
  .INPUTS
      None
  .OUTPUTS
      System.String
  .LINK
      Get-Date
  .LINK
      https://en.wikipedia.org/wiki/ISO_8601
  #>
  (Get-Date -UFormat %Y-W) + (Get-Date -UFormat %W).PadLeft(2, '0')
}

function Get-Weekday {
  <#
  .SYNOPSIS
      Displays weekday number.
  .INPUTS
      None
  .OUTPUTS
      System.String
  .LINK
      Get-Date
  .LINK
      https://en.wikipedia.org/wiki/ISO_8601
  #>
  Get-Date -UFormat %u
}

# --------------------------------------------------
# Networking
# --------------------------------------------------

function Clear-DNSCache {
  <#
  .SYNOPSIS
      Flushes the DNS cache.
  .INPUTS
      None
  .OUTPUTS
      System.String
  #>
  [CmdletBinding()]
  param()

  if ($IsLinux) {
    sudo /etc/init.d/dns-clean restart
  }
  elseif ($IsMacOS) {
    dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
  }
  else {
    ipconfig /flushdns
  }
  Write-Information "DNS cache flushed."
}

function Get-IPS {
  <#
  .SYNOPSIS
      Gets all IP addresses.
  .INPUTS
      None
  .OUTPUTS
      Microsoft.PowerShell.Commands.Internal.Format
      System.String[]
  .LINK
      Get-NetIPAddress
  #>
  if ($IsWindows) {
    Get-NetIPAddress | Where-Object { $_.AddressState -eq "Preferred" } | Sort-object IPAddress | Format-Table -Wrap -AutoSize
  }
  else {
    ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'
  }
}

function Get-LocalIP {
  <#
  .SYNOPSIS
      Gets local IP address.
  .INPUTS
      None
  .OUTPUTS
      System.String
      Object
  #>
  if ($IsWindows) {
    $IPAddress = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.Ipaddress.length -gt 1 }
    $IPAddress.ipaddress[0]
  }
  else {
    ipconfig getifaddr en0
  }
}

function Get-PublicIP {
  <#
  .SYNOPSIS
      Gets external IP address.
  .INPUTS
      None
  .OUTPUTS
      Microsoft.PowerShell.Commands.MatchInfo
      System.Boolean
      System.String
  .LINK
      Invoke-RestMethod
  .LINK
      https://github.com/chubin/awesome-console-services
  #>
  Invoke-RestMethod http://ipinfo.io/json | Select-Object -exp ip
}

function Invoke-RestMethodGet {
  <#
  .SYNOPSIS
      Sends a GET http request.
  .INPUTS
      System.Object
  .OUTPUTS
      System.Object
  .LINK
      Invoke-RestMethod
  #>
  Invoke-RestMethod -Method GET @args
}

function Invoke-RestMethodHead {
  <#
  .SYNOPSIS
      Sends a HEAD http request.
  .INPUTS
      System.Object
  .OUTPUTS
      System.Object
  .LINK
      Invoke-RestMethod
  #>
  Invoke-RestMethod -Method HEAD @args
}

function Invoke-RestMethodPost {
  <#
  .SYNOPSIS
      Sends a POST http request.
  .INPUTS
      System.Object
  .OUTPUTS
      System.Object
  .LINK
      Invoke-RestMethod
  #>
  Invoke-RestMethod -Method POST @args
}

function Invoke-RestMethodPut {
  <#
  .SYNOPSIS
      Sends a PUT http request.
  .INPUTS
      System.Object
  .OUTPUTS
      System.Object
  .LINK
      Invoke-RestMethod
  #>
  Invoke-RestMethod -Method PUT @args
}

function Invoke-RestMethodDelete {
  <#
  .SYNOPSIS
      Sends a DELETE http request.
  .INPUTS
      System.Object
  .OUTPUTS
      System.Object
  .LINK
      Invoke-RestMethod
  #>
  Invoke-RestMethod -Method DELETE @args
}

function Invoke-RestMethodTrace {
  <#
  .SYNOPSIS
      Sends a TRACE http request.
  .INPUTS
      System.Object
  .OUTPUTS
      System.Object
  .LINK
      Invoke-RestMethod
  #>
  Invoke-RestMethod -Method TRACE @args
}

function Invoke-RestMethodOptions {
  <#
  .SYNOPSIS
      Sends an OPTIONS http request.
  .INPUTS
      System.Object
  .OUTPUTS
      System.Int64
      System.String
      System.Xml.XmlDocument
      PSObject
  .LINK
      Invoke-RestMethod
  #>
  Invoke-RestMethod -Method OPTIONS @args
}

# --------------------------------------------------
# Directory Browsing
# --------------------------------------------------

function Get-ChildItemSimple {
  <#
  .SYNOPSIS
      Lists visible files in wide format.
  .PARAMETER Path
      The directory to list from.
  .INPUTS
      System.String[]
  .OUTPUTS
      System.IO.FileInfo
      System.IO.DirectoryInfo
  .LINK
      Get-ChildItem
  #>
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $true
    )]
    [string[]]$Path = ".",

    [Parameter(ValueFromRemainingArguments = $true)]
    $Params
  )

  begin {
    # https://stackoverflow.com/a/33302472
    $hashtable = @{}
    if ($Params) {
      $Params | ForEach-Object {
        if ($_ -match "^-") {
          $hashtable.$($_ -replace "^-") = $null
        }
        else {
          $hashtable.$(([string[]]$hashtable.Keys)[-1]) = $_
        }
      }
    }
  }

  process {
    Get-ChildItem -Path @Path @hashtable | Format-Wide
  }
}

function Get-ChildItemVisible {
  <#
  .SYNOPSIS
      Lists visible files in long format.
  .PARAMETER Path
      The directory to list from.
  .INPUTS
      System.String[]
  .OUTPUTS
      System.IO.FileInfo
      System.IO.DirectoryInfo
  .LINK
      Get-ChildItem
  #>
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $true
    )]
    [string[]]$Path = ".",

    [Parameter(ValueFromRemainingArguments = $true)]
    $Params
  )

  begin {
    # https://stackoverflow.com/a/33302472
    $hashtable = @{}
    if ($Params) {
      $Params | ForEach-Object {
        if ($_ -match "^-") {
          $hashtable.$($_ -replace "^-") = $null
        }
        else {
          $hashtable.$(([string[]]$hashtable.Keys)[-1]) = $_
        }
      }
    }
  }

  process {
    Get-ChildItem -Path @Path @hashtable
  }
}

function Get-ChildItemAll {
  <#
  .SYNOPSIS
      Lists all files in long format, excluding `.` and `..`.
  .PARAMETER Path
      The directory to list from.
  .INPUTS
      System.String[]
  .OUTPUTS
      System.IO.FileInfo
      System.IO.DirectoryInfo
  .LINK
      Get-ChildItem
  #>
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $true
    )]
    [string[]]$Path = ".",

    [Parameter(ValueFromRemainingArguments = $true)]
    $Params
  )

  begin {
    # https://stackoverflow.com/a/33302472
    $hashtable = @{}
    if ($Params) {
      $Params | ForEach-Object {
        if ($_ -match "^-") {
          $hashtable.$($_ -replace "^-") = $null
        }
        else {
          $hashtable.$(([string[]]$hashtable.Keys)[-1]) = $_
        }
      }
    }
  }

  process {
    Get-ChildItem -Path @Path -Force @hashtable
  }
}

function Get-ChildItemDirectory {
  <#
  .SYNOPSIS
      Lists only directories in long format.
  .PARAMETER Path
      The directory to list from.
  .INPUTS
      System.String[]
  .OUTPUTS
      System.IO.FileInfo
      System.IO.DirectoryInfo
  .LINK
      Get-ChildItem
  #>
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $true
    )]
    [string[]]$Path = ".",

    [Parameter(ValueFromRemainingArguments = $true)]
    $Params
  )

  begin {
    # https://stackoverflow.com/a/33302472
    $hashtable = @{}
    if ($Params) {
      $Params | ForEach-Object {
        if ($_ -match "^-") {
          $hashtable.$($_ -replace "^-") = $null
        }
        else {
          $hashtable.$(([string[]]$hashtable.Keys)[-1]) = $_
        }
      }
    }
  }

  process {
    Get-ChildItem -Path @Path -Directory @hashtable
  }
}

function Get-ChildItemHidden {
  <#
  .SYNOPSIS
      Lists only hidden files in long format.
  .PARAMETER Path
      The directory to list from.
  .INPUTS
      System.String[]
  .OUTPUTS
      System.IO.FileInfo
      System.IO.DirectoryInfo
  .LINK
      Get-ChildItem
  #>
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $true
    )]
    [string[]]$Path = ".",

    [Parameter(ValueFromRemainingArguments = $true)]
    $Params
  )

  begin {
    # https://stackoverflow.com/a/33302472
    $hashtable = @{}
    if ($Params) {
      $Params | ForEach-Object {
        if ($_ -match "^-") {
          $hashtable.$($_ -replace "^-") = $null
        }
        else {
          $hashtable.$(([string[]]$hashtable.Keys)[-1]) = $_
        }
      }
    }
  }

  process {
    Get-ChildItem -Path @Path -Hidden @hashtable
  }
}

# --------------------------------------------------
# Hash Functions
# --------------------------------------------------

function Get-FileHashMD5 {
  <#
  .SYNOPSIS
      Calculates the MD5 hash of an input.
  .PARAMETER Path
      Path to calculate hashes from.
  .EXAMPLE
      Get-FileHashMD5 file
  .EXAMPLE
      Get-FileHashMD5 file1,file2
  .EXAMPLE
      Get-FileHashMD5 *.gz
  .INPUTS
      System.String[]
  .OUTPUTS
      Microsoft.PowerShell.Commands.FileHashInfo
  .LINK
      Get-FileHash
  #>
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true
    )]
    [string]$Path
  )
  Get-FileHash $Path -Algorithm MD5
}

function Get-FileHashSHA1 {
  <#
  .SYNOPSIS
      Calculates the SHA1 hash of an input.
  .PARAMETER Path
      File(s) to calculate hashes from.
  .EXAMPLE
      Get-FileHashSHA1 file
  .EXAMPLE
      Get-FileHashSHA1 file1,file2
  .EXAMPLE
      Get-FileHashSHA1 *.gz
  .INPUTS
      System.String[]
  .OUTPUTS
      Microsoft.PowerShell.Commands.FileHashInfo
  .LINK
      Get-FileHash
  #>
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true
    )]
    [string]$Path
  )
  Get-FileHash $Path -Algorithm SHA1
}

function Get-FileHashSHA256 {
  <#
  .SYNOPSIS
      Calculates the SHA256 hash of an input.
  .PARAMETER Path
      File(s) to calculate hashes from.
  .EXAMPLE
      Get-FileHashSHA256 file
  .EXAMPLE
      Get-FileHashSHA256 file1,file2
  .EXAMPLE
      Get-FileHashSHA256 *.gz
  .INPUTS
      System.String[]
  .OUTPUTS
      Microsoft.PowerShell.Commands.FileHashInfo
  .LINK
      Get-FileHash
  #>
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true
    )]
    [string]$Path
  )
  Get-FileHash $Path -Algorithm SHA256
}

# --------------------------------------------------
# Weather Functions
# --------------------------------------------------

function Get-Weather {
  <#
  .SYNOPSIS
      Display the current weather and forecast.
  .DESCRIPTION
      Fetches the weather information from https://wttr.in for terminal
      display.
  .PARAMETER Request
      The full URL to the wttr request.
  .PARAMETER Timeout
      The number of seconds to wait for a response.
  .EXAMPLE
      Get-Weather nF 10
  .INPUTS
      System.String
  .OUTPUTS
      System.String
  .LINK
      https://github.com/chubin/wttr.in
  .LINK
      https://wttr.in
  #>
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $true
    )]
    [string]$Request,

    [Parameter(Mandatory = $false)]
    [PSDefaultValue(Help = '10')]
    [int]$Timeout = 10
  )

  begin {
    if ($Request) {
      $Request = '?' + $Request
    }
    $Request = 'https://wttr.in' + $Request
  }

  process {
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Encoding", 'deflate, gzip')
      (Invoke-WebRequest -Uri "$Request" -UserAgent "curl" -Headers $headers -UseBasicParsing -TimeoutSec "$Timeout").content
  }
}

function Get-WeatherForecast {
  <#
  .SYNOPSIS
      Displays detailed weather and forecast.
  .DESCRIPTION
      Fetches the weather information from wttr.in for terminal display.
  .INPUTS
      None
  .OUTPUTS
      System.String
  .LINK
      https://wttr.in
  #>
  [CmdletBinding()]
  param()

  Get-Weather 'F'
}

function Get-WeatherCurrent {
  <#
  .SYNOPSIS
      Displays current weather.
  .DESCRIPTION
      Fetches the weather information from wttr.in for terminal display.
  .INPUTS
      None
  .OUTPUTS
      System.String
  .LINK
      https://wttr.in
  #>
  [CmdletBinding()]
  param()

  Get-Weather 'format=%l:+(%C)+%c++%t+[%h,+%w]'
}

# --------------------------------------------------
# Update Functions
# --------------------------------------------------

function Update-TexLive {
  $CurrentYear = Get-Date -Format yyyy
  Write-Host "[Update TeXLive]" $CurrentYear -ForegroundColor Magenta -BackgroundColor Cyan
  tlmgr update --self
  tlmgr update --all
}