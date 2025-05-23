
<#
    .SYNOPSIS
        Disables throwing of exceptions
        
    .DESCRIPTION
        Restore the default exception behavior of the module to not support throwing exceptions
        
        Useful when the default behavior was changed with Enable-ADOException and the default behavior should be restored
        
    .EXAMPLE
        Disable-ADOException
        
        This will restore the default behavior of the module to not support throwing exceptions.
        
    .NOTES
        Tags: Exception, Exceptions, Warning, Warnings
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
    .LINK
        Enable-ADOException
#>

function Disable-ADOException {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param ()

    Write-PSFMessage -Level Verbose -Message "Disabling exception across the entire module." -Target $configurationValue

    Set-PSFFeature -Name 'PSFramework.InheritEnableException' -Value $false -ModuleName "ado.core"
    Set-PSFFeature -Name 'PSFramework.InheritEnableException' -Value $false -ModuleName "PSOAuthHelper"
    $PSDefaultParameterValues['*:EnableException'] = $false
}