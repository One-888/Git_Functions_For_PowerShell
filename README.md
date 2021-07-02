# Git_Functions_For_PowerShell
Git Utility Functions for Windows Powershell (cgit)

cgit helps you to reduce number of keystrokes by combinding multiple git commands into a shorthen PowerShell function.

cgit also added some utility functions such as timing your git commands. cgit can work with git-flow.

# How to load cgit
function cgit {
  Import-Module "(Your Folder)\Git_Functions_Main.psm1" -DisableNameChecking
  Write-Host "Load cgit complete!" -ForegroundColor Red 
  "Help: cghelp"
}