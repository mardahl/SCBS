#Intune PS TAG
write-output "RELOAD.ps1"
write-output "##SideCarBehaviour##RELOAD"


# add the required .NET assembly:
Add-Type -AssemblyName System.Windows.Forms
# show the MsgBox:
$result = [System.Windows.Forms.MessageBox]::Show('SideCar PowerShell Script! ##RELOAD', 'Warning', 'Ok', 'Warning')
