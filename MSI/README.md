# Ready to GO MSI Installer for Intune

- Add as a required app to a group of users
- remember to add the /quiet commandline parameter

## MSI Wrapper and Inno Setup configuration files

**If you want to save some time compiling your own installer.**

Gust grab Inno Setup here: http://www.jrsoftware.org/isdl.php
And the MSI Wrapper here: https://exemsi.com

The load in the configuration files.
Remember to have the PowerShell App Deployment toolkit handy for Inno Setup, as that it wat I am using so logging is available.
An example PSADT configuration is also available in the repo.
