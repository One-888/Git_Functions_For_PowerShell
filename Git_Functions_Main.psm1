#
# Custome Git Functions for Windows PowerShell
# Created 6/24/2021
#
#
function show-loading {param([string] $Act, [int] $pct)
    Write-Progress -Activity $Act -PercentComplete $pct
    Start-Sleep -MilliSeconds 200
}

function Display-Message {param ([string] $command_text)
    Write-Host ("cgit: " + "$command_text") -ForegroundColor Green 
}

show-loading -Act Loading -pct 20

function cgit-version { Write-Host "cgit version 0.08" -ForegroundColor Red;}
cgit-version

#function gcforce {git gc --aggressive --force --prune=all}

function gcommitpush {
  param([string] $message)
    Display-Message "git commit and push"
    show-loading -Act "git commit and push" -pct 20
	
	$date_string = (Get-Date -Format "MM/dd/yyyy HH:mm:ss").ToString() 
    $new_message = $date_string  + ": " + $message 
    
	git commit -am $new_message 
    
    show-loading -Act "git commit" -pct 40

	git push
    
    show-loading -Act "git push" -pct 60
	
	git log --oneline --graph -3
    
    show-loading -Act "git log" -pct 80
	git status -s 
    
    show-loading -Act "git status" -pct 100
}

show-loading  -Act Loading -pct 40

function gcommit {
  param([string] $message)
    Display-Message "git commit"
	$date_string = (Get-Date -Format "MM/dd/yyyy HH:mm:ss").ToString() 
    $new_message = $date_string  + ": " + $message 
    
	git commit -am $new_message 

    show-loading -Act "git commit" -pct 20
	git log --oneline --graph -3

    show-loading -Act "git log" -pct 80
	git status -s

    show-loading -Act "git status" -pct 100
}

function gadd {
    Display-Message "git add"
	git add .
    show-loading -Act "git add" -pct 50
	git status -s
    show-loading -Act "git status" -pct 100
}

show-loading  -Act Loading -pct 60

function gclone {
# Must be in the Original Folder
	param([string] $new_folder)
    Display-Message "git clone"
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
	git gc --aggressive --force --prune=all 
}

#
### System section #####################################################################
#

function ct { 
	param ([string] $command_text)

    Write-Host ("cgit: " + "$command_text") -ForegroundColor Green 
	check-time "Processing..."  
    
	$a = (Get-Date).ToString()
	Invoke-Expression $command_text
	check-time "Completed!"
    
	$b = (Get-Date).ToString()
	((New-TimeSpan -start $a -end $b).TotalSeconds).ToString() + " seconds" + " or " + (“{0:N2}” -f ((New-TimeSpan -start $a -end $b)).TotalMinutes).ToString() + " minutes"

    Write-Host ("Help: cghelp or cghelpa; Time git: ct ""any git command here""") 
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
function cgamend { ct "git commit --amend --no-edit -a"}
function cgb {ct "git branch" }
function cgba {ct "git branch --all --list"}
function cgc {param ([string] $command_text) ct "gcommit ""$command_text"""}
function cggcf { ct "git gc --aggressive --force --prune=all"}
function cgclone {param ([string] $command_text) ct "gclone ""$command_text"""}
function cgcp {param ([string] $command_text) ct "gcommitpush ""$command_text"""}
function cgd {ct "git diff" }
function cgds {ct "git diff --stat" }
function cgdns {ct "git diff --name-status" }
function cgdd {ct "git diff develop" }
function cgddns {ct "git diff develop --name-status" }
function cgdds {ct "git diff develop --stat" }
function cgdm {ct "git diff master" }
function cgdmns {ct "git diff master --name-status" }
function cgdms {ct "git diff master --stat" }
function cgfff {param ([string] $command_text) ct "git flow feature finish ""$command_text"""}
function cgffs {param ([string] $command_text) ct "git flow feature start ""$command_text"""}
function cgfinit {ct "git flow init -d -f"} # Default Git Flow
function cginit {ct "git init -d -f"} # Default Git Init
function cgfrf {param ([string] $command_text) ct "git flow release finish ""$command_text"""}
function cgfrs {param ([string] $command_text) ct "git flow release start ""$command_text"""}
function cghist {ct "git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short" }
function cglg1 {ct "git log --oneline --graph -10 --all"}
function cghelp {ct "Get-Command -Module Git_Functions_Main cg* | Select-Object Name | format-wide -column 4"}
function cghelpa {ct "Get-Command -Module Git_Functions_Main | Select-Object Name | format-wide -column 4"}
function cgp {ct "git push" }
function cgpa {ct "git push --all" }
function cgl { ct "git log --oneline" }
function cglg3 { ct "git log --oneline --graph -3" }
function cgl10 {ct "git log --oneline -n 10" }
function cglga {ct "git log --all --decorate --oneline --graph" }
function cglast {ct "git log -1 HEAD" }
function cglp {ct "git log -10 --pretty=format:'%C(bold red)%h%Creset - %ci - %s %Cgreen(%cr)%Creset %C(bold blue)%d%Creset' --abbrev-commit" }
function cgsb {ct "git show-branch --all --list"}
function cgst {ct "git status"}
function cgstb {ct "git status -b"}
function cgsts {ct "git status -s"}
function cgv {cgit-version}

function cgmon {Get-Counter "\Process(powershell*)\% Processor Time" -SampleInterval 1 -MaxSamples 10000 | Select-Object -ExpandProperty  countersamples | Select-Object CookedValue,InstanceName | Format-Table }

show-loading  -Act Loading -pct 100
# Last Line
cghelp