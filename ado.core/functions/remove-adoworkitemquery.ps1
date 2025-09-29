
<#
    .SYNOPSIS
        Deletes a work item query or folder.
    .DESCRIPTION
        Calls the Azure DevOps Work Item Tracking REST API (Queries - Delete) to remove a query
        or folder specified by path or id. Deletion also removes any permission changes; those
        cannot be restored by undelete.
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        Personal Access Token (PAT) with vso.work_write scope.
    .PARAMETER Query
        Query path (e.g. 'Shared Queries/Team/All Bugs') or query/folder id (GUID).
    .PARAMETER ApiVersion
        API version (default 7.1).
    .PARAMETER PassThru
        Return the provided Query value on success.
    .EXAMPLE
        Remove-ADOWorkItemQuery -Organization org -Project proj -Token $pat -Query 'Shared Queries/Old Folder' -Confirm:$false
    .EXAMPLE
        Remove-ADOWorkItemQuery -Organization org -Project proj -Token $pat -Query 342f0f44-4069-46b1-a940-3d0468979ceb -PassThru
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Remove-ADOWorkItemQuery {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
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