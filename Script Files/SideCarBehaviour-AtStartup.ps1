#Requires -RunAsAdministrator
# Evaluate scripts that have been loaded by Intune management Extensions, and reset appropriately.

# Get all the User Guids that have been assigned a policy
$guids = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\IntuneManagementExtension\Policies

#get all the policies assigned to each user
foreach ($guid in $guids) {

    $policyResults = Get-ChildItem -Path $guid.PSPath
    #Determine which key need to be deleted in order to get the policy to re-run.
    foreach ($policy in $policyResults) {

        $result = Get-ItemProperty -Path $policy.PSPath
        if ($result.ResultDetails -match "##SideCarBehaviour##ATSTARTUP") {

            #Found a match, deleting key.
            Write-Host "Deleting: $(($result.ResultDetails).Split([Environment]::NewLine)[0])"
            Remove-Item -Path $policy.PSPath

        }            

    }

}