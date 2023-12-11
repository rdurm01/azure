connect-AzureAD


$users= Get-AzureADUser -All $true | where {$_.userPrincipalName -like "*EXT*"}

$users = Get-AzureADUser -All:$true | Where-Object { $_.AccountEnabled -eq $true }
$dd = get-AzureADUser -ObjectId 27a00e17-f7fc-472f-91f3-adab5e85199c
$ee = Get-AzureADUserExtension -ObjectId 27a00e17-f7fc-472f-91f3-adab5e85199c #).Get_Item("createdDateTime") 
$dd | fl
$dd.ExtensionProperty
$dd.UserType
$dd.UserState
$dd.



-identy  27a00e17-f7fc-472f-91f3-adab5e85199c
 

$inactiveUsers = $users | Where-Object {

    $_.SignInActivity.DateTime -lt (Get-Date).AddDays(-180)

} | Select-Object DisplayName, UserPrincipalName, UserType, CreationType

$users.count
$inactiveUsers.count 

$inactiveUsers 
foreach ($user in $users){
$user

}

$User |fl
$user.SignInActivity.DateTime



#Install-Module -Name MSOnline
#
#import-Module -Name MSOnline

Install-Module -Name azureAD

import-Module -Name MSOnline

Connect-MgGraph -Scopes "AuditLog.Read.All"
Select-MgProfile -Name "beta"

$Inactiveusers= get-MgUser -Property DisplayName, UserPrincipalName, SignInActivity, UserType
$Inactiveusers | Where-Object {($_.SignInActivity.LastSignInDateTime -le $((Get-Date).AddDays(-30))) -and ($_.UserType -eq "Guest")}



$guestuserIDs= (Get-AzureADUser -Filter "UserType eq 'Guest'" | Select-Object ObjectId).ObjectId
$guestuserIDs= Get-AzureADUser -All $true | where {$_.userPrincipalName -like "*EXT*"}
$guestuserIDs.count


$users= Get-AzureADUser -All $true | where {$_.userPrincipalName -like "*EXT*"}

$startTime = (get-date).AddDays(-30).ToString("yyyy-MM-dd")

foreach($guestUserID in $guestuserIDs){
    Get-AzureADAuditSignInLogs -Filter "createdDateTime gt $startTime and UserId eq '$guestUserID'" |Select-Object UserId,UserDisplayName,CreatedDateTime 
}

27a00e17-f7fc-472f-91f3-adab5e85199c