using module .\Classes\CompletionHelper.psm1
using namespace System.Management.Automation

Register-ArgumentCompleter -CommandName @(
    'Get-ADComputer'
    'Get-ADFineGrainedPasswordPolicy'
    'Get-ADGroup'
    'Get-ADObject'
    'Get-ADOptionalFeature'
    'Get-ADOrganizationalUnit'
    'Get-ADServiceAccount'
    'Get-ADUser'
    'Search-ADAccount'
) -ParameterName SearchBase -ScriptBlock {
    #This is not actually an argument completer, it's more like a CLI container navigator
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    $Prefix = 'Microsoft.ActiveDirectory.Management.dll\ActiveDirectory:://RootDSE/'
    $TrimmedWord = [CompletionHelper]::TrimQuotes($wordToComplete)
    $PathsToSearch = if ($TrimmedWord.Length -eq 0)
    {
        [CompletionHelper]::GetCachedResults('(Get-ADDomain).DistinguishedName', $false) | ForEach-Object -Process {
            if ($null -ne $_)
            {
                $Prefix + $_
            }
        }
    }
    else
    {
        $Prefix + $TrimmedWord.Trim('/','\')
    }

    foreach ($Item in Get-ChildItem -LiteralPath $PathsToSearch)
    {
        if ($Item.PSIsContainer)
        {
            # ParameterValue is used over ProviderContainer because otherwise PSReadLine will add a trailing slash
            [CompletionResult]::new(
                "'$($Item.distinguishedName)'",
                $Item.Name,
                [CompletionResultType]::ParameterValue,
                $Item.DistinguishedName
            )
        }
    }
}