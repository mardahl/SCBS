#Requires -runasadministrator

<#
    .SYNOPSIS
    Creates required scheduled tasks, required by the SideCarBehaviour Script Solution.
    .REQUIREMENTS
    This script myst be run as an administrator.
    All files that go with this script must be placed in their final location on the client device, 
    before executing this script, as the tasks will reference them directly.
    .EXAMPLE
    Just run the script Configure-ScheduledTasks.ps1 without any parameters in an elevated PowerShell Session.
    .COPYRIGHT
    MIT License, feel free to distribute and use as you like, please leave author information.
    .AUTHOR
    Michael Mardahl - @michael_mardahl on twitter - BLOG: https://www.iphase.dk
    .DISCLAIMER
    This script is provided AS-IS, with no warranty - Use at own risk!
#>

##########################################################################
#
# FUNCTIONS SECTION
#
##########################################################################

function get-realScriptPath (){
    #gets the true path of the script, even in PowerShell ISE
    $myPath = $MyInvocation.MyCommand.Path
    if (!$myPath) {$myPath = $psISE.CurrentFile.Fullpath}
    if ($myPath) {$myPath = split-path $myPath -Parent} else {$myPath = "${env:ProgramFiles(x86)}\SideCarBehaviourScript"}

    return $myPath
}

function create-sideCarTask (){
    [cmdletbinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [String]$taskName,
        [Parameter(Mandatory=$true, Position=1)]
        [String]$scriptFileName,
        [Parameter(Mandatory=$false, Position=2)]
        [Switch]$repeatTask
    )

    #Configure required task parameters
    $scriptFile = join-path $(get-realScriptPath) $scriptFileName 
    $argument = '-NoProfile -WindowStyle Hidden -File "{0}"' -f $scriptFile
    $action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument $argument
    $settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 5) -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

    #Configure repetition behaviour
    if ($repeatTask) { 
        $triggers = @()
        $triggers += New-ScheduledTaskTrigger -At (get-date) -Once -RepetitionInterval (New-TimeSpan -Minutes 90)
        $triggers += New-ScheduledTaskTrigger -AtLogOn
    } else {
        $triggers = @()
        $triggers += New-ScheduledTaskTrigger -AtStartup
    }

    $Params = @{`
        "TaskName"=$taskName;
        "User"="NT AUTHORITY\SYSTEM";
        "Settings"=$settings;
        "Trigger"=$triggers;
        "Action"=$action;
        "TaskPath"="\Microsoft\Intune\";
        "Description"="Modifies Intune Management Extention Behaviour"
    }

    #Unregister any existing task as a precaution
    Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue |  Unregister-ScheduledTask -Confirm:$false

    #Register the actual task
    Register-ScheduledTask @Params
}


##########################################################################
#
# EXECUTION SECTION
#
##########################################################################

create-sideCarTask -taskName "SideCarBehaviour - AtStartup" -scriptFileName "SideCarBehaviour-AtStartup.ps1"
create-sideCarTask -taskName "SideCarBehaviour - Reload" -scriptFileName "SideCarBehaviour-Reload.ps1" -repeatTask