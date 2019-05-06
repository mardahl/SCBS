#Requires -RunAsAdministrator
# Evaluate scripts that have been loaded by Intune management Extensions, and reset appropriately.


#forces a restart of the Microsoft Intune Management Extension service even if there was no scripts requesting a reload.
#useful if you want to make sure that new policies are downloaded at the time the script runs.
$restartAlways = $true 

# Get all the User Guids that have been assigned a policy
$guids = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\IntuneManagementExtension\Policies

#get all the policies assigned to each user
foreach ($guid in $guids) {

    $policyResults = Get-ChildItem -Path $guid.PSPath
    #Determine which key need to be deleted in order to get the policy to re-run.
    foreach ($policy in $policyResults) {

        $result = Get-ItemProperty -Path $policy.PSPath
        if ($result.ResultDetails -match "##SideCarBehaviour##RELOAD") {

            #Found a match, deleting key.
            Write-Host "Deleting: $(($result.ResultDetails).Split([Environment]::NewLine)[0])"
            Remove-Item -Path $policy.PSPath

            #Telling the script that we found a match, and need to have the Intune Management Extension service Reset.
            $foundMatch = $true

        }            

    }

}

if ($foundMatch -or $restartAlways) {

    #Restart intune Management Extension, in order for the policy to Reload
    Get-Service -Name IntuneManagementExtension | Restart-Service

}
