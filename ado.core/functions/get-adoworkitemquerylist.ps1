
<#
    .SYNOPSIS
        Retrieves root work item queries (and optional descendants).
    .DESCRIPTION
        Wraps Azure DevOps Queries - List endpoint. Supports depth, expansion, and inclusion of
        deleted queries/folders. By default returns typed QueryHierarchyItem objects.
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        Personal Access Token (PAT).
    .PARAMETER Depth
        Return child queries/folders to this depth.
    .PARAMETER Expand
        none | wiql | clauses | all | minimal (query details expansion).
    .PARAMETER IncludeDeleted
        Include deleted queries/folders.
    .PARAMETER Raw
        Return raw result object (with count/value) instead of flattened items.
    .PARAMETER ApiVersion
        API version (default 7.1).
    .EXAMPLE
        Get-ADOWorkItemQueryList -Organization org -Project proj -Token $pat -Depth 1
    .EXAMPLE
        Get-ADOWorkItemQueryList -Organization org -Project proj -Token $pat -Expand wiql -IncludeDeleted
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Get-ADOWorkItemQueryList {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)] [string]$Organization,
        [Parameter(Mandatory = $true)] [string]$Project,
        [Parameter(Mandatory = $true)] [string]$Token,

        [Parameter()] [int]$Depth,
        [Parameter()] [ValidateSet('none','wiql','clauses','all','minimal')] [string]$Expand = 'none',
        [Parameter()] [switch]$IncludeDeleted,
        [Parameter()] [switch]$Raw,
        [Parameter()] [string]$ApiVersion = '7.1'
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting retrieval of query hierarchy (Org: $Organization / Project: $Project)"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            $apiUri = "$Project/_apis/wit/queries"
            $q = @{}
            if ($Depth)              { $q['$depth'] = $Depth }
            if ($Expand -and $Expand -ne 'none') { $q['$expand'] = $Expand }
            if ($IncludeDeleted)     { $q['$includeDeleted'] = 'true' }
            if ($q.Count -gt 0) {
                $apiUri += '?' + ($q.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" } -join '&')
            }

            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"

            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method 'GET' `
                                             -Headers @{'Content-Type'='application/json'} `
                                             -ApiVersion $ApiVersion

            $result = $response.Results
            if ($Raw) {
                Write-PSFMessage -Level Verbose -Message "Returning raw query hierarchy payload"
                return $result
            }

            $items = @()
            if ($result) {
                if ($result.value) {
                    foreach ($itm in $result.value) {
                        $items += ($itm | Select-PSFObject * -TypeName 'ADO.TOOLS.QueryHierarchyItem')
                    }
                }
                elseif ($result.id) {
                    $items += ($result | Select-PSFObject * -TypeName 'ADO.TOOLS.QueryHierarchyItem')
                }
            }

            Write-PSFMessage -Level Verbose -Message "Retrieved $($items.Count) query hierarchy item(s)"
            return $items
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to retrieve query hierarchy: $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed retrieval of query hierarchy"
        Invoke-TimeSignal -End
    }
}