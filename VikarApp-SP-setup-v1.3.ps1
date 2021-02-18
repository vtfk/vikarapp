<#
Created sharepoint site and lists used by the app.
Remember to keep note of the site url as it will be used when provisioning the logic apps

1. Install pnp (install-module pnp.PowerShell)
2. Edit "setup" variables
3. run script

#>

#Setup
$sharepointRootUrl = "https://<tenant>.sharepoint.com"
$siteName = "VikarApp"
$siteUrl = "$sharepointRootUrl/sites/$siteName"
$siteOwnerUpn = "<user upn>"

#Connect and create site
connect-pnponline -Url $sharepointRootUrl -Interactive

$newSite = New-PnPSite -Type TeamSite -Title $siteName -Alias $siteName -Owners $siteOwnerUpn

connect-pnponline -url $siteUrl -interactive


#Add lists to the sharepoint site:

# Create ACL list
$listName = "ACLList"
New-PnPList -Title $listName -Template GenericList
Set-PnPField -List $listName -Identity Title -Values @{Required=$false}
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName name -InternalName name 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName userUpn -InternalName userUpn 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName admin -InternalName admin 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName teacher -InternalName teacher 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName groupAdmin -InternalName groupAdmin 

# Create appArchive list
$listName = "AppArchive"
New-PnPList -Title $listName -Template GenericList
Set-PnPField -List $listName -Identity Title -Values @{Required=$false}
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName substituteFor -InternalName substituteFor 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName substituteUpn -InternalName substituteUpn 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName teamName -InternalName teamName 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName school -InternalName school 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName teamId -InternalName teamId 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName status -InternalName status 
Add-PnPField -list $listName -type DateTime -AddToDefaultView -DisplayName accessibleFrom -InternalName accessibleFrom 
Add-PnPField -list $listName -type DateTime -AddToDefaultView -DisplayName accessibleTo -InternalName accessibleTo 

# Create AppQueue list
$listName = "AppQueue"
New-PnPList -Title $listName -Template GenericList
Set-PnPField -List $listName -Identity Title -Values @{Required=$false}
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName requester -InternalName requester 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName searchedUser -InternalName searchedUser 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName requestId -InternalName requestId 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName school -InternalName school 

# Create AppQueueResponses list
$listName = "AppQueueResponses"
New-PnPList -Title $listName -Template GenericList
Set-PnPField -List $listName -Identity Title -Values @{Required=$false}
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName requestId -InternalName requestId 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName searchedUser -InternalName searchedUser 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName requester -InternalName requester
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName teamId -InternalName teamId 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName teamName -InternalName teamName 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName school -InternalName school

# Create AppRequests list
$listName = "AppRequests"
New-PnPList -Title $listName -Template GenericList
Set-PnPField -List $listName -Identity Title -Values @{Required=$false}
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName substituteFor -InternalName substituteFor 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName substituteUpn -InternalName substituteUpn 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName teamName -InternalName teamName
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName teamId -InternalName teamId 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName status -InternalName status 
Add-PnPField -list $listName -type DateTime -AddToDefaultView -DisplayName accessibleFrom -InternalName accessibleFrom 
Add-PnPField -list $listName -type DateTime -AddToDefaultView -DisplayName accessibleTo -InternalName accessibleTo
Add-PnPField -list $listName -type DateTime -AddToDefaultView -DisplayName extendTo -InternalName extendTo
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName school -InternalName school
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName isNew -InternalName isNew
Add-PnPField -list $listName -type Number -AddToDefaultView -DisplayName timesExtended -InternalName timesExtended

# Create AppSchoolAccess list
$listName = "AppSchoolAccess"
New-PnPList -Title $listName -Template GenericList
Set-PnPField -List $listName -Identity Title -Values @{Required=$false}
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName schoolName -InternalName schoolName
Add-PnPField -list $listName -type Note -AddToDefaultView -DisplayName hasAccessTo -InternalName hasAccessTo

# Create AppSchoolAccess list
$listName = "AppSchoolDisplayName"
New-PnPList -Title $listName -Template GenericList
Set-PnPField -List $listName -Identity Title -Values @{Required=$false}
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName schoolGroupName -InternalName schoolGroupName 
Add-PnPField -list $listName -type Text -AddToDefaultView -DisplayName schoolDisplayName -InternalName schoolDisplayName 

Disconnect-PnPOnline
