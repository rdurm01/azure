Get-TeamUser -GroupId feff5659-9989-4e1c-af8c-250bc99742d7 -Role Owner


Set-TeamArchivedState -GroupId 105b16e2-dc55-4f37-a922-97551e9e862d -Archived:$true

Remove-Team -GroupId 31f1ff6c-d48c-4f8a-b2e1-abca7fd399df


Connect-MicrosoftTeams


Install-Module -Name MicrosoftTeams
Import-Module -Name MicrosoftTeams