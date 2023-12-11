Install-Module -Name Az -Repository PSGallery -Force

Install-Module -Name AzureAD
Install-Module -Name Microsoft.Online.SharePoint.PowerShell
Install-Module ExchangeOnlineManagement

#teams:
Install-Module -Name PowerShellGet -Force -AllowClobber
Install-Module -Name MicrosoftTeams -Force -AllowClobber

#msGraph
Install-Module Microsoft.Graph



import-Module -Name Az 

import-Module -Name AzureAD
import-Module -Name Microsoft.Online.SharePoint.PowerShell
import-Module ExchangeOnlineManagement

#teams:
import-Module -Name PowerShellGet
import-Module -Name MicrosoftTeams
#msGraph
import-Module Microsoft.Graph
Select-MgProfile -Name "beta"
# To switch back to production use:
Select-MgProfile -Name "v1.0"
Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All"  #scope ist notwendig
