using module .\Classes\CompletionHelper.psm1

$ScriptBlock = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $WildcardInput = [CompletionHelper]::TrimQuotes($wordToComplete) + '*'

    foreach ($Repository in Get-PSRepository -Name $WildcardInput)
    {
        [CompletionHelper]::NewParamCompletionResult($Repository.Name, $Repository.SourceLocation)
    }
}
Register-ArgumentCompleter -ScriptBlock $ScriptBlock -ParameterName Name -CommandName Set-PSRepository