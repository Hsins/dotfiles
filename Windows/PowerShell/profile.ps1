<#
 * Author   : Hsins
 * Email    : hsinspeng@gmail.com
 * Updated  : 2020/11/19
 * Version  : 1.0.0
#>


# --------------------------------------------------
# Contents Managed by Third-Party Softwares
# --------------------------------------------------

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
(& "C:\ProgramData\Anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
#endregion


# --------------------------------------------------
# Import Modules
# --------------------------------------------------

Import-Module posh-git
Import-Module oh-my-posh
Import-Module windows-screenfetch
Set-Theme Honukai


# --------------------------------------------------
# Setup Hot-keys
# --------------------------------------------------

# 設置 Tab 選單補全
Set-PSReadLineKeyHandler -Chord "tab" -Function MenuComplete                # tab     選單補全

# 設置 Ctrl 組合快鍵
Set-PSReadLineKeyHandler -Chord "ctrl+z" -Function Undo                     # ctrl+z  撤銷操作
Set-PSReadLineKeyHandler -Chord "ctrl+u" -Function RevertLine               # ctrl+u  清除命令行
Set-PSReadlineKeyHandler -Chord "ctrl+e" -Function EndOfLine                # ctrl+e  移動游標到尾部
Set-PSReadlineKeyHandler -Chord "ctrl+a" -Function BeginningOfLine          # ctrl+a  移動游標到頭部
Set-PSReadlineKeyHandler -Chord "ctrl+d" -Function ViExit                   # ctrl+d  退出 PowerShell

# 設定上下鍵
Set-PSReadLineKeyHandler -Chord "UpArrow" -Function HistorySearchBackward   # up      向前搜索命令紀錄
Set-PSReadLineKeyHandler -Chord "DownArrow" -Function HistorySearchForward  # down    向後搜索命令紀錄


# --------------------------------------------------
# Define Custom Functions
# --------------------------------------------------

# 更新 TexLive (update TexLive)
function Update-TexLive {
  $CurrentYear = Get-Date -Format yyyy
  Write-Host "[Update TeXLive]" $CurrentYear -ForegroundColor Magenta -BackgroundColor Cyan
  tlmgr update --self
  tlmgr update --all
}
