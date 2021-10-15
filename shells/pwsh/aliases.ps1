<#
 * Author   : Hsins
 * Email    : hsinspeng@gmail.com
 * Updated  : 2021/10/10
 * Version  : 2.0.0
 * Path     : %USERPROFILE%\Documents\PowerShell\aliases.ps1
#>

# --------------------------------------------------
# General
# --------------------------------------------------

Set-Alias -Name "h" -Value Search-History -Description "Displays/Searches global history."
Set-Alias -Name "alias" -Value Get-Aliases -Description "Lists aliases."
Set-Alias -Name "repeat" -Value Invoke-RepeatCommand -Description "Repeats a command x times."

# --------------------------------------------------
# Time
# --------------------------------------------------

Set-Alias -Name "now" -Value Get-DateExtended -Description "Displays local date and time in ISO-8601 format YYYY-MM-DDThh:mm:ss."
Set-Alias -Name "unow" -Value Get-DateExtendedUTC -Description "Displays UTC date and time in ISO-8601 format YYYY-MM-DDThh:mm:ss."
Set-Alias -Name "nowdate" -Value Get-CalendarDate -Description "Displays local date in YYYY-MM-DD format."
Set-Alias -Name "unowdate" -Value Get-CalendarDateUTC -Description "Displays UTC date in YYYY-MM-DD format."
Set-Alias -Name "nowtime" -Value Get-Time -Description "Displays local time in hh:mm:ss format."
Set-Alias -Name "unowtime" -Value Get-TimeUTC -Description "Displays UTC time in hh:mm:ss format."
Set-Alias -Name "timestamp" -Value Get-Timestamp -Description "Displays Unix time stamp."
Set-Alias -Name "week" -Value Get-WeekDate -Description "Displays week number in ISO-9601 format YYYY-Www."
Set-Alias -Name "weekday" -Value Get-Weekday -Description "Displays weekday number."

# --------------------------------------------------
# System Operations
# --------------------------------------------------

Set-Alias -Name "lock" -Value Invoke-Lock -Description "Locks the session."
Set-Alias -Name "hibernate" -Value Invoke-Hibernate -Description "Goes to sleep."
Set-Alias -Name "reboot" -Value Invoke-Restart -Description "Restarts the system."
Set-Alias -Name "poweroff" -Value Invoke-PowerOff -Description "Shuts down the system."

# --------------------------------------------------
# Networking
# --------------------------------------------------

Set-Alias -Name "flushdns" -Value Clear-DNSCache -Description "Flushes the DNS cache."
Set-Alias -Name "ips" -Value Get-IPS -Description "Gets all IP addresses."
Set-Alias -Name "localip" -Value Get-LocalIP -Description "Gets local IP address."
Set-Alias -Name "publicip" -Value Get-PublicIP -Description "Gets external IP address."
Set-Alias -Name "GET" -Value Invoke-RestMethodGet -Description "Sends a GET http request."
Set-Alias -Name "HEAD" -Value Invoke-RestMethodHead -Description "Sends a HEAD http request."
Set-Alias -Name "POST" -Value Invoke-RestMethodPost -Description "Sends a POST http request."
Set-Alias -Name "PUT" -Value Invoke-RestMethodPut -Description "Sends a PUT http request."
Set-Alias -Name "DELETE" -Value Invoke-RestMethodDelete -Description "Sends a DELETE http request."
Set-Alias -Name "TRACE" -Value Invoke-RestMethodTrace -Description "Sends a TRACE http request."
Set-Alias -Name "OPTIONS" -Value Invoke-RestMethodOptions -Description "Sends an OPTIONS http request."

# --------------------------------------------------
# System Administrator
# --------------------------------------------------

Set-Alias -Name "mnt" -Value Get-Mounts -Description "Lists drive mounts."
Set-Alias -Name "path" -Value Get-Path -Description "Prints each PATH entry on a separate line."

foreach ($_ in ("ntop", "atop", "htop", "top", "Get-TopProcess")) {
  if (Get-Command $_ -ErrorAction "Ignore") {
    Set-Alias -Name "top" -Value $_ -Description "Monitors processes and system resources."
    break
  }
}

foreach ($_ in ("winfetch", "neofetch", "screenfetch")) {
  if (Get-Command $_ -ErrorAction "Ignore") {
    Set-Alias -Name "sysinfo" -Value $_ -Description "Displays information about the system."
    break
  }
}

# --------------------------------------------------
# Hash Functions
# --------------------------------------------------

Set-Alias -Name "md5sum" -Value Get-FileHashMD5 -Description "Calculates the MD5 hash of an input."
Set-Alias -Name "sha1sum" -Value Get-FileHashSHA1 -Description "Calculates the SHA1 hash of an input."
Set-Alias -Name "sha256sum" -Value Get-FileHashSHA256 -Description "Calculates the SHA256 hash of an input."

# --------------------------------------------------
# Weather Functions
# --------------------------------------------------

Set-Alias -Name "forecast" -Value Get-WeatherForecast -Description "Displays detailed weather and forecast."
Set-Alias -Name "weather" -Value Get-WeatherCurrent -Description "Displays current weather."