using module .\Classes\CompletionHelper.psm1

Register-ArgumentCompleter -CommandName New-Object -ParameterName ComObject -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $WildcardInput = [CompletionHelper]::TrimQuotes($wordToComplete) + '*'

    foreach ($Item in [CompletionHelper]::GetCachedResults("Get-CimInstance -ClassName Win32_ClassicCOMClassSetting -Filter 'VersionIndependentProgId is not null or ProgId is not null' -Property ProgId, VersionIndependentProgId, Caption", $false))
    {
        $Id = if (![string]::IsNullOrEmpty($Item.VersionIndependentProgId))
        {
            $Item.VersionIndependentProgId
        }
        else
        {
            $Item.ProgId
        }

        $Tooltip = if (![string]::IsNullOrEmpty($Item.Caption))
        {
            $Item.Caption
        }
        else
        {
            $Id
        }

        if ($Id -like $WildcardInput)
        {
            [CompletionHelper]::NewParamCompletionResult($Id, $Tooltip)
        }
    }
}