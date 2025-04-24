using module .\Classes\CompletionHelper.psm1

Register-ArgumentCompleter -CommandName Update-Help,Save-Help -ParameterName Module -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    $WildcardInput = [CompletionHelper]::TrimQuotes($wordToComplete) + '*'
    foreach ($Module in [CompletionHelper]::GetCachedResults('Get-Module -ListAvailable | Where-Object {$null -ne $_.HelpInfoUri} | Sort-Object -Unique -Property Name | Select-Object Name,Version', $false))
    {
        if ($null -eq $Module)
        {
            continue
        }
        if ($Module.Name -like $WildcardInput)
        {
            [CompletionHelper]::NewParamCompletionResult($Module, $Module.Name + " v" + $Module.Version)
        }
    }
}