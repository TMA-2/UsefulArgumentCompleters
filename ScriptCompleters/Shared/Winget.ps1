using module .\Classes\CompletionHelper.psm1
using namespace System
using namespace System.Collections.Generic
using namespace System.Management.Automation


Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $word = [CompletionHelper]::TrimQuotes($wordToComplete)
    $ast = $commandAst.ToString().Replace('"', '""')
    $ParameterNames = [HashSet[string]]::new(
        [string[]]('install', 'show', 'source', 'search', 'list', 'upgrade', 'uninstall', 'hash', 'validate', 'settings', 'features', 'experimental', 'complete', 'export', 'import', 'pin', 'configure', 'download', 'error', 'resume', 'repair', 'font', 'dscv3'),
        [StringComparer]::OrdinalIgnoreCase
    )

    foreach ($Item in winget.exe complete --word="$word" --commandline $ast --position $cursorPosition)
    {
        $Kind = if ($ParameterNames.Contains($Item) -or $Item.StartsWith('--'))
        {
            [CompletionResultType]::ParameterName
        }
        else
        {
            [CompletionResultType]::ParameterValue
        }

        [CompletionResult]::new($Item, $Item, $Kind, $Item)
    }
}