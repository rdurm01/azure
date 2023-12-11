#Install-Module Microsoft.Graph
import-module Microsoft.Graph
Connect-MgGraph -Scopes "user.Read.All"


$ExportCSV = 1
$InactivityPeriod = 180

$ExportFilePath = "c:\daten\ps\AzureAD_User_Inactive_$(Get-Date -Format "yyyy_MM_dd")_Period_$($InactivityPeriod).csv"

$inactiveDate = (Get-Date).AddDays(-$InactivityPeriod)

#$users = Get-MgUser -All:$true -Property Id, DisplayName, UserPrincipalName, UserType, SignInActivity | Where-Object { $_.AccountEnabled -eq $true }
$users = Get-MgUser -All:$true -Property Id, DisplayName, UserPrincipalName, UserType, SignInActivity | where {$_.userPrincipalName -like "*EXT*"} 
#$users = Get-MgUser -All:$true -Property *| where {$_.userPrincipalName -like "*EXT*"} 

$users.count

$inactiveUsers = $users | Where-Object {
    $_.SignInActivity.LastSignInDateTime -lt $inactiveDate
}# | Select-Object DisplayName, UserPrincipalName, UserType, 

$inactiveUsers
$inactiveUsers.count

 $FinalReport =@()
foreach ($user in $inactiveUsers){
$userxt = Get-AzureADUserExtension -ObjectId "$($user.id)"
write-host "$($user.id) $($user.SignInActivity.LastSignInDateTime)"
        $userObject = [PSCustomObject]@{
                UserId             = $user.Id
                Displayname        = $user.Displayname
                LastActivityDate   = $user.SignInActivity.LastSignInDateTime
                UserPrincipalName  = $user.UserPrincipalName
                mail               = $user.mail
                UserType           = $user.UserType
                CreatedDateTime    = $userxt.createdDateTime
            }
            $FinalReport += $userObject





}

# Export result to CSV file if needed
if ($ExportCSV) {
    $FinalReport | Export-Csv -Path $ExportFilePath -NoTypeInformation -Delimiter ";" -Encoding UTF8
    Write-Output "Report saved to $ExportFilePath"
}

# Stop before closing powershell window
Read-Host "Script completed. Press 'Enter' to finish"

