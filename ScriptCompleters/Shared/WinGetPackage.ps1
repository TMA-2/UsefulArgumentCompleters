using module .\Classes\CompletionHelper.psm1

$CommandNames = @(
    'Export-WinGetPackage',
    'Find-WinGetPackage',
    'Get-WinGetPackage',
    'Install-WinGetPackage',
    'Repair-WinGetPackage',
    'Uninstall-WinGetPackage',
    'Update-WinGetPackage'
)

Register-ArgumentCompleter -CommandName $CommandNames -ParameterName Source -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    $WildcardInput = [CompletionHelper]::TrimQuotes($wordToComplete) + '*'
    foreach ($Source in [CompletionHelper]::GetCachedResults('Get-WinGetSource | Sort-Object Name | Select-Object Name,Argument,Type', $false))
    {
        if ($null -eq $Source)
        {
            continue
        }
        if ($Source.Name -like $WildcardInput)
        {
            [CompletionHelper]::NewParamCompletionResult($Source.Name, "$($Source.Type) ($($Source.Type))") | Write-Output
        }
    }
}