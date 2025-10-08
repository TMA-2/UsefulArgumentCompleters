using module .\Classes\CompletionHelper.psm1

$ScriptBlock = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    $CommandToFind = if ($CommandName -eq 'Register-ArgumentCompleter')
    {
        $fakeBoundParameters['CommandName']
    }
    elseif ($CommandName -eq 'Get-Help')
    {
        $fakeBoundParameters['Name']
    }

    if ([string]::IsNullOrEmpty($CommandToFind))
    {
        return
    }

    $CommandInfo = Get-Command -Name $CommandToFind
    $WildcardInput = [CompletionHelper]::TrimQuotes($wordToComplete) + '*'
    foreach ($Key in $CommandInfo.Parameters.Keys)
    {
        if ($Key -notlike $WildcardInput)
        {
            continue
        }

        [CompletionHelper]::NewParamCompletionResult($Key)
    }
}

Register-ArgumentCompleter -CommandName Register-ArgumentCompleter -ParameterName ParameterName -ScriptBlock $ScriptBlock
Register-ArgumentCompleter -CommandName Get-Help -ParameterName Parameter -ScriptBlock $ScriptBlock