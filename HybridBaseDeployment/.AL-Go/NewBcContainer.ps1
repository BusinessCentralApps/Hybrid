Param(
    [Hashtable]$parameters
)

$parameters.multitenant = $false
$parameters.RunSandboxAsOnPrem = $true
#if ("$env:GITHUB_RUN_ID" -eq "") {
#    $parameters.includeAL = $true
#    $parameters.doNotExportObjectsToText = $true
#    $parameters.shortcuts = "none"
#}

New-BcContainer @parameters

$installedApps = Get-BcContainerAppInfo -containerName $containerName -tenantSpecificProperties -sort DependenciesLast | Where-Object { $_.appid -eq "58623bfa-0559-4bc2-ae1c-0979c29fd9e0" }
$installedApps | ForEach-Object {
    Write-Host "Removing $($_.Name)"
    Unpublish-BcContainerApp -containerName $parameters.ContainerName -name $_.Name -unInstall -doNotSaveData -doNotSaveSchema -force
}

Invoke-ScriptInBcContainer -containerName $parameters.ContainerName -scriptblock { $progressPreference = 'SilentlyContinue' }
