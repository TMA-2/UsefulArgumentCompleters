using module .\Classes\CompletionHelper.psm1

Register-ArgumentCompleter -CommandName Get-Variable,Set-Variable,New-Variable,Clear-Variable,Remove-Variable -ParameterName Scope -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    $Scopes = [string[]]@('Global', 'Local', 'Script', '0', '1', '2')

    $WildcardInput = [CompletionHelper]::TrimQuotes($wordToComplete) + '*'
    $SelectedScope = $Scopes -like $WildcardInput

    if($SelectedScope) {
        Return [CompletionHelper]::NewParamCompletionResult($SelectedScope)
    }

}