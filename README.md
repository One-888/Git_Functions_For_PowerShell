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
# Sample Commands
<pre><code> C:\Git_Functions_For_PowerShell [develop ≡]> cgsb
cgit: git show-branch --all --list
7/2/2021 9:03:15 AM - Processing...
* [develop] Update README.md
  [master] Merge branch 'release/0.05.16'
  [origin/develop] Update README.md
  [origin/master] Merge branch 'release/0.05.16'
7/2/2021 9:03:16 AM - Completed!
1 seconds or 0.0166666666666667 minutes
Help: cphelp or cphelpa
</code></pre>
