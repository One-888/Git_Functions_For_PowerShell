#
# Custome Git Functions for Windows PowerShell
# Created 6/24/2021
#
#
function show-loading {param([string] $Act, [int] $pct)
Write-Progress -Activity $Act -PercentComplete $pct
Start-Sleep -MilliSeconds 200
}

show-loading -Act Loading -pct 20

function cgit-version { Write-Host "cgit version 0.06" -ForegroundColor Red;}
cgit-version

function git-log-3 {git log --oneline --graph -3}

function gcforce {git gc --aggressive --force --prune=all}

function gcommitpush {
  param([string] $message)

    show-loading -Act Wait -pct 20
	" Git Commit------------------------------"
	$date_string = (Get-Date -Format "MM/dd/yyyy HH:mm:ss").ToString() 
    $new_message = $date_string  + ": " + $message 
    
	git commit -am $new_message 
    
    show-loading -Act Wait -pct 40

	" Git Push------------------------------"
	git push
    
    show-loading -Act Wait -pct 60
	" Git Status------------------------------"
	git-log-3 
    
    show-loading -Act Wait -pct 80
	gst 
    
    show-loading -Act Wait -pct 100
}

show-loading  -Act Loading -pct 40

function gcommit {
  param([string] $message)
	$date_string = (Get-Date -Format "MM/dd/yyyy HH:mm:ss").ToString() 
    $new_message = $date_string  + ": " + $message 
    
	git commit -am $new_message 

    show-loading -Act Wait -pct 20
	git-log-3 

    show-loading -Act Wait -pct 80
	gst 
}

function gadd {
	git add .
	gst 
}

show-loading  -Act Loading -pct 60

function gclone {
# Must be in the Original Folder
	param([string] $new_folder)
	git clone --local --progress --no-single-branch . ../$($new_folder)
	cd ../$($new_folder)
	git show-branch
}

function gcut-over {
	param([string] $branch_to_cutover)
	<# 
git checkout --orphan tmp # create a temporary branch
git add -A  # Add all files and commit them
git commit -m 'Start Over'
git branch -D 'develop' # Deletes the master branch
git branch -m 'develop' # Rename the current branch to master
git gc --aggressive --prune=all # remove the old files
#>
	git checkout --orphan tmp-branch
	git add -A 
	git commit -m ('Initial Cutover for ' + ($branch_to_cutover).ToString())
	git branch -D $branch_to_cutover 
	git branch -m $branch_to_cutover 
	git branch --set-upstream-to=origin/$branch_to_cutover $branch_to_cutover 
	gcforce 
}

# Default Git Flow
function gf-init { git flow init -d -f }

#
### System section #####################################################################
#

function ct { 
	param ([string] $command_text)
	check-time "Processing..."
    
	$a = (Get-Date).ToString()
	Invoke-Expression $command_text
	check-time "Completed!"
    
	$b = (Get-Date).ToString()
	(		(			New-TimeSpan -start $a -end $b).TotalSeconds).ToString() + " seconds"
    (		(			New-TimeSpan -start $a -end $b).TotalMinutes).ToString() + " minutes"
  Write-Host "            "
}

function check-time { 
	param([string] $text_message)
	Write-Host ((Get-Date).ToString() + " - " + $text_message) -ForegroundColor Yellow 
}

function cgit-scan {
param ([string] $command_text, [string] $Include_folder_text)
Get-ChildItem -Directory -Path $Include_folder_text | % { Push-Location $_.FullName; $_.FullName; Invoke-Expression $command_text; Pop-Location; }
}

#
### Alias section #####################################################################
#
show-loading  -Act Loading -pct 80

function cgadd {ct "gadd"}
function cgal { Get-Alias -Name cg* }
function cgbr {ct "git branch" }
function cgbra {ct "git branch --all --list"}
function cgc {param ([string] $command_text) ct "gcommit ""$command_text"""}
function cgcf { ct "gcforce"}
function cgclone {param ([string] $command_text) ct "gclone ""$command_text"""}
function cgcp {param ([string] $command_text) ct "gcommitpush ""$command_text"""}
function cgd {ct "git diff" }
function cgfff {param ([string] $command_text) ct "git flow feature finish ""$command_text"""}
function cgffs {param ([string] $command_text) ct "git flow feature start ""$command_text"""}
function cgfinit {ct "gf-init"}
function cgfrf {param ([string] $command_text) ct "git flow release finish ""$command_text"""}
function cgfrs {param ([string] $command_text) ct "git flow release start ""$command_text"""}
function cghist {ct "git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short" }
function cglag {ct "git log --all --decorate --oneline --graph" }
function cglast {ct "git log -1 HEAD" }
function cglg1 {ct "git log --oneline --graph -10 --all"}
function cglo { ct "git log --oneline" }
function cglo10 {ct "git log --oneline -n 10" }
function cglop {ct "git log -10 --pretty=format:'%C(bold red)%h%Creset - %ci - %s %Cgreen(%cr)%Creset %C(bold blue)%d%Creset' --abbrev-commit" }
function cgsb {ct "git show-branch --all --list"}
function cgstb {ct "git status -b"}
function cgsts {ct "git status -s"}
function cgv {cgit-version}

show-loading  -Act Loading -pct 100
# Last Line
#cgal # Show Alias