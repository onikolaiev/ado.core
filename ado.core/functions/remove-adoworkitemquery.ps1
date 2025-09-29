
<#
    .SYNOPSIS
        Deletes a work item query or folder.
    .DESCRIPTION
        Wraps Queries - Delete endpoint. Permanently removes the item and its permission changes.
    .OUTPUTS
        System.String
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        PAT (vso.work_write scope).
    .PARAMETER Query
        Query path or GUID.
    .PARAMETER PassThru
        Return the supplied path/id when deletion succeeds.
    .PARAMETER ApiVersion
        API version (default 7.1).
    .PARAMETER Confirm
        Confirmation prompt.
    .PARAMETER WhatIf
        Simulation only.
    .EXAMPLE
        PS> Remove-ADOWorkItemQuery -Organization org -Project proj -Token $pat -Query 'Shared Queries/Old' -Confirm:$false
        
        Deletes the query or folder by path.
    .EXAMPLE
        PS> Remove-ADOWorkItemQuery -Organization org -Project proj -Token $pat -Query 8a8c8212-15ca-41ed-97aa-1d6fbfbcd581 -PassThru -Confirm:$false
        
        Deletes the query by id and returns the id when successful.
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