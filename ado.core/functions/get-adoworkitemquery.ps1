
<#
    .SYNOPSIS
        Retrieves a single query (and optional descendants).
    .DESCRIPTION
        Wraps Queries - Get endpoint with depth, expansion and deleted/ISO date options.
    .OUTPUTS
        ADO.TOOLS.QueryHierarchyItem
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        PAT (vso.work scope).
    .PARAMETER Query
        Query id or path.
    .PARAMETER Depth
        Child depth for folders.
    .PARAMETER Expand
        none | wiql | clauses | all | minimal
    .PARAMETER IncludeDeleted
        Include deleted queries.
    .PARAMETER UseIsoDateFormat
        Format date clauses in ISO 8601.
    .PARAMETER Raw
        Return raw object.
    .PARAMETER ApiVersion
        API version (default 7.1).
    .EXAMPLE
        PS> Get-ADOWorkItemQuery -Organization org -Project proj -Token $pat -Query 'Shared Queries/All Bugs'
    .EXAMPLE
        PS> Get-ADOWorkItemQuery -Organization org -Project proj -Token $pat -Query 342f0f44-... -Expand wiql
    .LINK
        https://learn.microsoft.com/azure/devops
#>
function Get-ADOWorkItemQuery {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)] [string]$Organization,
        [Parameter(Mandatory = $true)] [string]$Project,
        [Parameter(Mandatory = $true)] [string]$Token,
        [Parameter(Mandatory = $true)] [string]$Query,
        [Parameter()] [int]$Depth,
        [Parameter()] [ValidateSet('none','wiql','clauses','all','minimal')] [string]$Expand = 'none',
        [Parameter()] [switch]$IncludeDeleted,
        [Parameter()] [switch]$UseIsoDateFormat,
        [Parameter()] [switch]$Raw,
        [Parameter()] [string]$ApiVersion = '7.1'
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting retrieval of query '$Query' (Org: $Organization / Project: $Project)"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            # Encode path segments unless GUID
            if ($Query -match '^[0-9a-fA-F-]{36}$') {
                $encoded = $Query
            }
            else {
                $encoded = ($Query -split '/' | ForEach-Object { [System.Uri]::EscapeDataString($_) }) -join '/'
            }

            $apiUri = "$Project/_apis/wit/queries/$encoded"

            $q = @{}
            if ($Depth) { $q['$depth'] = $Depth }
            if ($Expand -and $Expand -ne 'none') { $q['$expand'] = $Expand }
            if ($IncludeDeleted) { $q['$includeDeleted'] = 'true' }
            if ($UseIsoDateFormat) { $q['$useIsoDateFormat'] = 'true' }

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
                Write-PSFMessage -Level Verbose -Message "Returning raw query object"
                return $result
            }

            Write-PSFMessage -Level Verbose -Message "Successfully retrieved query '$Query'"
            return $result | Select-PSFObject * -TypeName 'ADO.TOOLS.QueryHierarchyItem'
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to retrieve query '$Query' : $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed retrieval of query '$Query'"
        Invoke-TimeSignal -End
    }
}