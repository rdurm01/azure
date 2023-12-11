# Set script parameters
[CmdletBinding()]
#param (
    #[int]$InactivityPeriod = 30,
    #[switch]$ExportCSV,
    #[string]$ExportFilePath = "$env:TEMP\$(Get-Date -Format "yyyy_MM_dd")InactiveTeams.csv"
#)

$InactivityPeriod = 0
$ExportCSV = 1
$ExportFilePath = "c:\daten\ps\Teams_Inactive_$(Get-Date -Format "yyyy_MM_dd")_Period_$($InactivityPeriod).csv"

# Check or install Microsoft Graph Reports module
if ($null -eq (Get-Module -ListAvailable Microsoft.Graph.Reports)) {
    try {
        Write-Output "Microsoft Graph Reports module not found. Trying to install"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null
        Install-Module Microsoft.Graph.Reports -Force | Out-Null
        Write-Output "Microsoft Graph Reports module installed"
    }
    catch {
        Write-Output "Unable to install Microsoft Graph Reports module. $($Error[0].Exception.Message)"
        Return
    }
}

Import-Module Microsoft.Graph.Authentication

# Connect to M365
try {
    Write-Output "Connecting Microsoft Graph"
    #Select-MgProfile -Name "beta"
    Connect-MgGraph -Scopes Reports.Read.All | Out-Null
}
catch {
    Write-Output "Unable to connect to M365. $($Error[0].Exception.Message)"
    Return
}

# Get activity report
try {
    Get-MgReportTeamActivityDetail -Period "All" -OutFile "c:\daten\ps\teamsactivityreport.csv"
    #Get-MgReportTeamActivityDetail -Period 
}
catch {
    Write-Output "Unable to get activity report. $($Error[0].Exception.Message)"
    Return
}

# Read the report for filtering
#$xx = Get-Content -Raw "c:\daten\ps\teamsactivityreport.json"

$AllTeamActivity = import-csv -Delimiter "," "c:\daten\ps\teamsactivityreport.csv"
$AllTeamActivity.count


#$AllTeamActivity = (Get-Content -Raw "c:\daten\ps\teamsactivityreport.json" |  ConvertFrom-Json).Value 
#Get-Content  "c:\daten\ps\teamsactivityreport.json" | ConvertFrom-Json
# Check each team and build a report 
$FinalReport = @()
foreach ($SingleTeamActivity in $AllTeamActivity) {
    if ($SingleTeamActivity."last Activity Date") {
        if ($SingleTeamActivity."Report Period" -eq 180){
        $lastActivityDate = Get-Date -Date $SingleTeamActivity."last Activity Date"
        if ($lastActivityDate -le $((Get-Date).AddDays(-$InactivityPeriod))) {
            $TeamActivityObject = [PSCustomObject]@{
                TeamId           = $SingleTeamActivity."team Id"
                TeamName         = $SingleTeamActivity."team Name"
                LastActivityDate = $SingleTeamActivity."last Activity Date"
            }
            $FinalReport += $TeamActivityObject
        }
        }
    }
    else {
        if ($SingleTeamActivity."Report Period" -eq 180){
        $TeamActivityObject = [PSCustomObject]@{
            TeamId           = $SingleTeamActivity."team Id"
            TeamName         = $SingleTeamActivity."team Name"
            LastActivityDate = "No activity found"
        }
        $FinalReport += $TeamActivityObject
    }
    }
}

# Print result to the screen
Write-Output $FinalReport | Format-Table

# Export result to CSV file if needed
if ($ExportCSV) {
    $FinalReport | Export-Csv -Path $ExportFilePath -NoTypeInformation -Delimiter ";" -Encoding UTF8
    Write-Output "Report saved to $ExportFilePath"
}

# Stop before closing powershell window
Read-Host "Script completed. Press 'Enter' to finish"