<#
    .SYNOPSIS
        Lists root query folders (optionally expanding details).
    .DESCRIPTION
        Wraps Queries - List endpoint. Supports depth, expand, include deleted and raw return.
    .OUTPUTS
        ADO.TOOLS.QueryHierarchyItem
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        PAT (vso.work scope).
    .PARAMETER Depth
        Depth of child retrieval.
    .PARAMETER Expand
        none | wiql | clauses | all | minimal
    .PARAMETER IncludeDeleted
        Include deleted queries.
    .PARAMETER Raw
        Return raw response (count/value).
    .PARAMETER ApiVersion
        API version (default 7.1).
    .EXAMPLE
        PS> Get-ADOWorkItemQueryList -Organization org -Project proj -Token $pat
        
        Returns root folders only.
    .EXAMPLE
        PS> Get-ADOWorkItemQueryList -Organization org -Project proj -Token $pat -Depth 1
        
        Returns root plus one level of children.
    .EXAMPLE
        PS> Get-ADOWorkItemQueryList -Organization org -Project proj -Token $pat -Expand wiql
        
        Includes WIQL text for each query.
    .LINK
        https://learn.microsoft.com/azure/devops
#>
function Get-ADOWorkItemQueryList {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
    [CmdletBinding()]
    [OutputType('ADO.TOOLS.QueryHierarchyItem')]
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