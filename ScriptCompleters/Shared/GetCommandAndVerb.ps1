using module .\Classes\CompletionHelper.psm1

Register-ArgumentCompleter -CommandName Get-Command -ParameterName ParameterName -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $WildcardInput = [CompletionHelper]::TrimQuotes($wordToComplete) + '*'

    if ($fakeBoundParameters.ContainsKey('ParameterName'))
    {
        $fakeBoundParameters.Remove('ParameterName')
    }

    if ($fakeBoundParameters.Count -eq 0)
    {
        return
    }

    foreach ($ParameterName in (Get-Command @fakeBoundParameters).Parameters.Keys | Sort-Object -Unique)
    {
        if ($parameterName -like $WildcardInput)
        {
            [CompletionHelper]::NewParamCompletionResult($parameterName)
        }
    }
}