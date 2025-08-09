@{
    # https://learn.microsoft.com/en-us/powershell/utility-modules/psscriptanalyzer/rules/readme?view=ps-modules
    IncludeRules = @(
        'PSAlignAssignmentStatement'
        'PSPlaceCloseBrace'
        'PSPlaceOpenBrace'
        'PSUseConsistentWhitespace'
        'PSUseConsistentIndentation'
        'PSAvoidUsingInvokeExpression'
        'PSAvoidUsingEmptyCatchBlock'
    )

    Rules = @{
        IncludeDefaultRules = $true

        PSAlignAssignmentStatement = @{
            Enable = $true
        }

        PSAvoidExclaimOperator = @{
            Enable = $false
        }

        PSPlaceCloseBrace = @{
            Enabled            = $true
            NoEmptyLineBefore  = $true
            IgnoreOneLineBlock = $true
            NewLineAfter       = $true
        }

        PSPlaceOpenBrace = @{
            Enable             = $true
            OnSameLine         = $false
            IgnoreOneLineBlock = $true
            NewLineAfter       = $true
        }

        PSUseConsistentIndentation = @{
            Enable = $true
            IndentationSize = 4
            PipelineIndentation = 'IncreaseIndentationForFirstPipeline'
            Kind = 'space'
        }

        PSUseConsistentWhitespace = @{
            Enable                                  = $true
            CheckInnerBrace                         = $true
            CheckOpenBrace                          = $true
            CheckOpenParen                          = $true
            CheckOperator                           = $true
            CheckPipe                               = $true
            CheckPipeForRedundantWhitespace         = $true
            CheckSeparator                          = $true
            CheckParameter                          = $true
            IgnoreAssignmentOperatorInsideHashTable = $true
        }
    }
}
