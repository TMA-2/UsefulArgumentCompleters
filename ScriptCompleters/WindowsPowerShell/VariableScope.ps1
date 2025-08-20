using module .\Classes\CompletionHelper.psm1

Register-ArgumentCompleter -CommandName Clear-Variable,Get-Variable,New-Variable,Remove-Variable,Set-Variable -ParameterName Scope -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    $WildcardInput = [CompletionHelper]::TrimQuotes($wordToComplete) + '*'
    foreach ($Scope in "Global", "Local", "Script" )
    {
        if ($Scope -like $WildcardInput)
        {
            [CompletionHelper]::NewParamCompletionResult($Scope)
        }
    }
}