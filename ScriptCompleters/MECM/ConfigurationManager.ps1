using module .\Classes\CompletionHelper.psm1

function CheckCMDrive {
    $ErrorActionSave = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'
    # Check if the ConfigMgr drive is available
    $CMDrive = Get-PSDrive -PSProvider CMSite
    if (-not $CMDrive) {
        # If not, check if the ConfigMgr provider is available
        $CMProvider = Get-PSProvider -Name CMSite
        if ($CMProvider) {
            # Try to get the CM server via registry or WMI. Both methods require admin rights.
            $CMServer = Get-ItemPropertyValue 'HKLM:\SOFTWARE\Microsoft\CCM\FSP' -Name IntranetHostname
            if(!$CMServer) {
                $CMServer = Invoke-CimMethod -Namespace root\ccm -ClassName SMS_Client -MethodName GetAssignedSite | Select-Object -ExpandProperty sSiteCode
                if(!$CMServer) {
                    Throw "Couldn't find the CM server name. Please verify you're on a device with CM installed and running as admin."
                }
            }
            # Create a new PSDrive for ConfigMgr
            New-PSDrive -Name $CMSiteCode -PSProvider CMSite -Root $CMServer | Out-Null
            Return $CMSiteCode
        } else {
            throw "Couldn't find the CMSite provider. Please verify the ConfigurationManager module is imported."
        }
    }
    $ErrorActionPreference = $ErrorActionSave
}

$script:CMCmdlets = [string[]]@(
    "Export-CMApplication"                    # Param: Name, Aliases: LocalizedDisplayName
    "Get-CMApplication"                       # Param: Name, Aliases: {LocalizedDisplayName, ApplicationName}
    "New-CMApplication"                       # Param: Name, Aliases: LocalizedDisplayName
    "Set-CMApplication"                       # Param: Name, Aliases: {LocalizedDisplayName, ApplicationName}
    "Remove-CMApplication"                    # Param: Name, Aliases: {LocalizedDisplayName, ApplicationName}
    "Suspend-CMApplication"                   # Param: Name, Aliases: {LocalizedDisplayName, ApplicationName}
    "Resume-CMApplication"                    # Param: Name, Aliases: LocalizedDisplayName

    "Start-CMApplicationDeployment"           # Param: Name, Aliases: LocalizedDisplayName
    "New-CMApplicationDeployment"             # Param: Name, Aliases: {LocalizedDisplayName, ApplicationName}

    "Start-CMApplicationDeploymentSimulation" # Param: Name, Aliases: LocalizedDisplayName

    "Remove-CMApplicationRevisionHistory"     # Param: Name, Aliases: LocalizedDisplayName
    "Get-CMApplicationRevisionHistory"        # Param: Name, Aliases: LocalizedDisplayName
    "Restore-CMApplicationRevisionHistory"    # Param: Name, Aliases: LocalizedDisplayName

    "Update-CMApplicationStatistic"           # Param: Name, Aliases: {LocalizedDisplayName, ApplicationName}

    "Set-CMApplicationSupersedence"           # Param: Name, Aliases: {ApplicationName, LocalizedDisplayName, CurrentApplicationName, CurrentApplicationLocalizedDisplayName}

    "Get-CMApplicationDeployment"
    "New-CMApplicationDeployment"
    "Remove-CMApplicationDeployment"
    "Start-CMApplicationDeployment"

    "Get-CMApplicationGroup"
    "New-CMApplicationGroup"
    "Remove-CMApplicationGroup"
    "Set-CMApplicationGroup"

    "Get-CMApplicationGroupDeployment"
    "New-CMApplicationGroupDeployment"
    "Remove-CMApplicationGroupDeployment"

    "Get-CMApplicationPhasedDeployment"
    "Remove-CMApplicationPhasedDeployment"
    "Set-CMApplicationPhasedDeployment"

    "Get-CMApplicationRevisionHistory"
    "Remove-CMApplicationRevisionHistory"
    "Restore-CMApplicationRevisionHistory"

    "Update-CMApplicationStatistic"

    "Set-CMApplicationSupersedence"
)

$script:CMCmdlets2 = [string[]]@(
    "Get-CMApplicationDeployment"
    "New-CMApplicationDeployment"
    "Remove-CMApplicationDeployment"
    "Set-CMApplicationDeployment"

    "Get-CMApplicationPhasedDeployment"
    "Remove-CMApplicationPhasedDeployment"
    "New-CMApplicationAutoPhasedDeployment"

    "Set-CMApplicationSupersedence"

    "Update-CMApplicationStatistic"
)

Register-ArgumentCompleter -CommandName $script:CMCmdlets -ParameterName Name -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    try {
        # ConfigMgr commands must be run from the site code drive
        $CMSiteCode = CheckCMDrive
        if($CMSiteCode) {
            Push-Location "${CMSiteCode}:"
        } else {
            Throw "Couldn't set location to the CM site code. Make sure you're on a device with CM installed and the ConfigurationManager module is loaded."
        }
    } catch {
        $Err = $_
        Throw "Exception $($Err.Exception.HResult) setting CM Site Code > $($Err.Exception.Message)"
    }

    $WildcardInput = [CompletionHelper]::TrimQuotes($wordToComplete) + '*'

    # This query, for roughly ~1,000 apps, takes me 5-10s.
    foreach ($CMApp in [CompletionHelper]::GetCachedResults('Get-CMApplication -Fast | Where-Object {$_.IsEnabled -and -not $_.IsExpired} | Select-Object LocalizedDisplayName,Manufacturer', $false)) {
        if ($null -eq $CMApp) {
            continue
        }
        $CMAppName = $CMApp.LocalizedDisplayName
        $CMAppManufacturer = $CMApp.Manufacturer
        if ($CMAppName -like $WildcardInput) {
            [CompletionHelper]::NewParamCompletionResult($CMAppName, "$CMAppManufacturer $CMAppName")
        }
    }

    # return to the previous location
    Pop-Location
}
