# using module .\Classes\CompletionHelper.psm1

Register-ArgumentCompleter -CommandName Get-Help -ParameterName Parameter -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    # Check that the command name exists
    if($fakeBoundParameters.ContainsKey('Name') -and $fakeBoundParameters['Name'] -notmatch '^about_')
    {
        $Command = $fakeBoundParameters['Name']
    }
    else
    {
        return $null
    }

    # does the command exist?
    $CommandInfo = Get-Command -Name $Command -ErrorAction SilentlyContinue
    if (-not $CommandInfo)
    {
        return $null
    }

    # define common parameters to exclude
    $CommonParameters = @('Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction', 'ProgressAction', 'ErrorVariable', 'WarningVariable', 'InformationVariable', 'OutVariable', 'OutBuffer', 'PipelineVariable')
    
    # does the command have a matching parameter?
    # $WildcardInput = [CompletionHelper]::TrimQuotes($wordToComplete) + '*'
    $WildcardInput = "$wordToComplete*"
    
    # get matching parameter names
    # exclude common params (they won't match get-help anyway): ParameterType ~= 'ActionPreference', Attributes ~= 'CommonParameters'
    $ParameterInfo = $CommandInfo.Parameters.GetEnumerator() | Where-Object { $_.Key -ilike $WildcardInput -and $_.Key -notin $CommonParameters} | Sort-Object Key -Unique | Select-Object -ExpandProperty Key

    foreach ($Param in $ParameterInfo)
    {
        # [CompletionResult]::new($Param)
        # [CompletionHelper]::NewParamCompletionResult($Param)
        
        # we could add a tooltip using Get-Help... but that's a bit much, added to which it isn't working.
        try {
            $ParamHelp = Get-Help -Name $Command -Parameter $Param
            $ParamSynopsis = $ParamHelp.Description[0].Text -replace '[ \n]+$'
            $ParamType = $ParamHelp.parameterValue
            $ParamDefault = $ParamHelp.defaultValue
            if($ParamDefault -eq 'None')
            {
                $ParamTooltip = "-{0} <{1}>`n    {2}" -f $Param, $ParamType, $ParamSynopsis
            }
            else
            {
                $ParamTooltip = "-{0} <{1}> = {2}`n    {3}" -f $Param, $ParamType, $ParamDefault, $ParamSynopsis
            }
            [CompletionResult]::new($Param, $Param, 'ParameterValue', $ParamTooltip)
            # [CompletionHelper]::NewParamCompletionResult($Param, $ParamTooltip)
        }
        catch {
            [CompletionResult]::new($Param)            
        }
        #>
    }
}