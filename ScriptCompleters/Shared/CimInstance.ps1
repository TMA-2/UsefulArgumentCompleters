using module .\Classes\CompletionHelper.psm1

Register-ArgumentCompleter -CommandName Get-CimInstance -ParameterName QueryDialect -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    $Dialects = @{
        'WQL' = "Windows Query Language"
        'CQL' = "CIM Query Language"
    }

    $WildcardInput = [CompletionHelper]::TrimQuotes($wordToComplete) + "*"
    $Dialects.GetEnumerator() | Where-Object { $_.Key -like $WildcardInput } | ForEach-Object {
        [CompletionHelper]::NewParamCompletionResult($_.Key, "$($_.Key) [$($_.Value)]")
    }
}