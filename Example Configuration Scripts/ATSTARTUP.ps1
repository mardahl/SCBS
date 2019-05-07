#Intune PS TAG
write-output "ATSTARTUP.ps1"
write-output "##SideCarBehaviour##ATSTARTUP"


# add the required .NET assembly:
Add-Type -AssemblyName System.Windows.Forms
# show the MsgBox:
$result = [System.Windows.Forms.MessageBox]::Show('SideCar PowerShell Script! ##ATSTARTUP', 'Warning', 'Ok', 'Warning')
