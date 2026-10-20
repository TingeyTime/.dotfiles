# PSScriptAnalyzer settings, also picked up by the VS Code PowerShell extension.
@{
    Severity     = 'Error', 'Warning'
    ExcludeRules = @(
        # install.ps1 prints progress for a person, like install.sh's echo
        'PSAvoidUsingWriteHost'
        # starship's documented setup is Invoke-Expression (& starship init powershell)
        'PSAvoidUsingInvokeExpression'
    )
}
