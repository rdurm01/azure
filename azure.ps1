Install-Module Microsoft.Graph
import-Module Microsoft.Graph
$users = Get-MgUser -All:$true -Property Id, DisplayName, UserPrincipalName, UserType, SignInActivity | Where-Object { $_.AccountEnabled -eq $true }