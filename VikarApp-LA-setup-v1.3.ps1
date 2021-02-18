<#
This script creates a resource group and four logic apps

PS: app registration must have the following permissions: 
- group.readWrite.all
- GroupMember.readWrite.all
- user.read.all

1. Install az module (install-module az)
2. change directory (cd <path>) to logic app json template folder location
3. edit "setup" variables
4. run the script

#>

#setup
$pathToTemplates         = ""    #spesicy the folder path where the logic apps templates is located e.g. C:\someFolder\VikarAppStuff
$serviceUserPassword     = ""    # service user password
$serviceUserUPN          = ""    #service user UPN
$serviceUserNotification = ""    # service user to post teams messages
$sharepointSiteUrl       = "https://<tenant>.sharepoint.com/sites/VikarApp321"    # Sharepoint site URL
$tenantID                = ""    # Tenant ID
$appID                   = ""    # App ID
$appSecret               = ""    # App secret
$subsctiptionId          = ""    # Subscription ID
$classTeamIdentifier     = "Section_"    # Class team identifier. "use "Section_" for school data sync
$logicAppPrefix          = ""    # Logic Apps Prefix (optional)"
$rgPrefix                = ""    # Resource group prefix (optional)"
$resourceLocation        = "West Europe"    # Resource location (e.g. West Europe)"
$teacherGroupId          = ""    # teacher security group guid"
$adminGroupId            = ""    # admin security group guid"


#do not edit
$appVerion = "v2"
$nameAdd = $logicAppPrefix + "VikarApp-Add-" + $appVerion
$nameArchive = $logicAppPrefix + "VikarApp-archive-" + $appVerion
$nameQueue = $logicAppPrefix + "VikarApp-queue-" + $appVerion
$nameAcl = $logicAppPrefix + "VikarApp-AdminAcl-" + $appVerion
$resourceGroupName = $rgPrefix + "VikarApp"


if($pathToTemplates.Substring($pathToTemplates.Length-1) -eq "/" -or $pathToTemplates.Substring($pathToTemplates.Length-1) -eq "\"){
    $pathToTemplates = $pathToTemplates.Substring(0,$pathToTemplates.length-1)
}


if (Get-Module -ListAvailable -Name az.resources) {
    write-host "Az module already installed"
} 
else {
    Write-Host "Missing AZ module. Installing....."
    install-module az
}
write-host "Sign in..."
Connect-AzAccount
Set-AzContext -SubscriptionId $subsctiptionId

New-AzResourceGroup -name $resourceGroupName -location $resourceLocation
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -templateFile "$pathToTemplates\LA-WE-VikarApp-Add-v2.json" -logicAppName $nameAdd -paramadmin-securityGroup $adminGroupId -paramappID $appID -paramsecret $appSecret -paramserviceUser $serviceUserUPN -paramserviceUserNotifications $serviceUserNotification -paramsiteUrl $sharepointSiteUrl -paramteacher-securityGroup $teacherGroupId -paramteamIdentifier $classTeamIdentifier -paramtenantID $tenantID
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -templateFile "$pathToTemplates\LA-WE-VikarApp-archive-v2.json" -logicAppName $nameArchive -paramadmin-securityGroup $adminGroupId -paramappID $appID -paramsecret $appSecret -paramsiteURL $sharepointSiteUrl -paramteacher-securityGroup $teacherGroupId -paramteamIdentifier $classTeamIdentifier -paramtenantID $tenantID -azuread-1_displayName $serviceUserUPN
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -templateFile "$pathToTemplates\LA-WE-VikarApp-queue-v2.json" -logicAppName $nameQueue -paramappID $appID -paramclassTeamIdentifier $classTeamIdentifier -paramsecret $appSecret -paramsiteUrl $sharepointSiteUrl -paramtenantID $tenantID -paramusername $serviceUserUPN
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile "$pathToTemplates\LA-WE-VikarApp-AdminAcl-v2.json" -logicAppName $nameAcl -paramTeacherGroupId $teacherGroupId -paramadminGroupId $adminGroupId -paramsiteUrl $sharepointSiteUrl -azuread-1_token_TenantId $tenantID -azuread-1_displayName $serviceUserUPN