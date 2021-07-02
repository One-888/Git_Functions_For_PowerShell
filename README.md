# Git Functions for PowerShell (cgit)

cgit helps you to reduce number of keystrokes by combinding multiple git commands into a shorthen PowerShell function.

cgit also adds some utility functions such as timing your git commands. cgit can work with git-flow.

# How to load cgit
<pre><code> function cgit {
  Import-Module "(Your Folder)\Git_Functions_Main.psm1" -DisableNameChecking
  Write-Host "Load cgit complete!" -ForegroundColor Red 
  "Help: cghelp"
}
</code></pre>
