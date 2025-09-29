<#
    .SYNOPSIS
        Deletes a query or folder.
    .DESCRIPTION
        Wraps Queries - Delete. Removes the item and its permission changes irreversibly.
    .OUTPUTS
        System.String (when -PassThru)
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        PAT.
    .PARAMETER Query
        Query path or id.
    .PARAMETER PassThru
        Emit the deleted identifier/path.
    .PARAMETER ApiVersion
        API version (default 7.1).
    .PARAMETER Confirm
        Confirmation control (SupportsShouldProcess).
    .PARAMETER WhatIf
        Simulation only.
    .EXAMPLE
        PS> Remove-ADOWorkItemQuery -Organization org -Project proj -Token $pat -Query 'Shared Queries/Old' -Confirm:$false
    .LINK
        https://learn.microsoft.com/azure/devops
#>
function Remove-ADOWorkItemQuery {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)] [string]$Organization,
        [Parameter(Mandatory = $true)] [string]$Project,
        [Parameter(Mandatory = $true)] [string]$Token,
        [Parameter(Mandatory = $true)] [string]$Query,
        [Parameter(Mandatory = $false)] [string]$ApiVersion = '7.1',
        [Parameter(Mandatory = $false)] [switch]$PassThru
    )
    begin {
        Write-PSFMessage -Level Verbose -Message "Starting delete of query '$Query' (Org: $Organization / Project: $Project)"
        Invoke-TimeSignal -Start
    }
    process {
        if (Test-PSFFunctionInterrupt) { return }
        if (-not $PSCmdlet.ShouldProcess("Query '$Query'","Delete")) { return }
        try {
            # Encode path segments unless it's a pure GUID (keep as-is)
            if ($Query -match '^[0-9a-fA-F-]{36}$') {
                $encoded = $Query
            }
            else {
                $encoded = ($Query -split '/' | ForEach-Object { [System.Uri]::EscapeDataString($_) }) -join '/'
            }
            $apiUri = "$Project/_apis/wit/queries/$encoded"
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"

            $null = Invoke-ADOApiRequest -Organization $Organization `
                                          -Token $Token `
                                          -ApiUri $apiUri `
                                          -Method 'DELETE' `
                                          -Headers @{'Content-Type'='application/json'} `
                                          -ApiVersion $ApiVersion

            Write-PSFMessage -Level Verbose -Message "Successfully deleted query '$Query'"
            if ($PassThru) { return $Query }
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to delete query '$Query' : $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
        }
    }
    end {
        Write-PSFMessage -Level Verbose -Message "Completed delete operation for query '$Query'"
        Invoke-TimeSignal -End
    }
}