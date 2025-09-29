
<#
    .SYNOPSIS
        Updates a work item query or folder (rename, WIQL, visibility, undelete).
    .DESCRIPTION
        PATCH wrapper for Queries - Update. Only provided properties are changed.
    .OUTPUTS
        ADO.TOOLS.QueryHierarchyItem
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        PAT (vso.work_write scope).
    .PARAMETER Query
        Query id or path.
    .PARAMETER Name
        New name (rename).
    .PARAMETER Wiql
        New WIQL text (queries only).
    .PARAMETER QueryType
        flat | tree | oneHop.
    .PARAMETER IsPublic
        Set public (true) or private (false).
    .PARAMETER IsDeleted
        Set deletion state (false to undelete).
    .PARAMETER Columns
        Replace columns (field reference names).
    .PARAMETER SortColumns
        Replace sort ordering (Field or Field:desc).
    .PARAMETER UndeleteDescendants
        Also undelete children (folder).
    .PARAMETER ApiVersion
        API version (default 7.1).
    .PARAMETER Confirm
        Confirmation prompt (SupportsShouldProcess).
    .PARAMETER WhatIf
        Show what would change without applying.
    .EXAMPLE
        PS> Update-ADOWorkItemQuery -Organization org -Project proj -Token $pat -Query 'Shared Queries/All Bugs' -Name 'Active Bugs'
        
        Renames the query.
    .EXAMPLE
        PS> Update-ADOWorkItemQuery -Organization org -Project proj -Token $pat -Query 342f0f44-... -Wiql "Select ..."
        
        Updates WIQL by id.
    .EXAMPLE
        PS> Update-ADOWorkItemQuery -Organization org -Project proj -Token $pat -Query 'Shared Queries/Folder' -IsDeleted:$false -UndeleteDescendants
        
        Undeletes a folder and its descendants.
    .LINK
        https://learn.microsoft.com/azure/devops
#>
function Update-ADOWorkItemQuery {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)] [string]$Organization,
        [Parameter(Mandatory = $true)] [string]$Project,
        [Parameter(Mandatory = $true)] [string]$Token,
        [Parameter(Mandatory = $true)] [string]$Query,

        [Parameter()] [string]$Name,
        [Parameter()] [string]$Wiql,
        [Parameter()] [ValidateSet('flat','tree','oneHop')] [string]$QueryType,
        [Parameter()] [bool]$IsPublic,
        [Parameter()] [bool]$IsDeleted,
        [Parameter()] [string[]]$Columns,
        [Parameter()] [string[]]$SortColumns,
        [Parameter()] [switch]$UndeleteDescendants,

        [Parameter()] [string]$ApiVersion = '7.1'
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting update of query '$Query' (Org: $Organization / Project: $Project)"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        if (-not $PSCmdlet.ShouldProcess("Query '$Query'","Update")) { return }
        try {
            # Encode path segments unless it's a GUID
            if ($Query -match '^[0-9a-fA-F-]{36}$') {
                $encoded = $Query
            }
            else {
                $encoded = ($Query -split '/' | ForEach-Object { [System.Uri]::EscapeDataString($_) }) -join '/'
            }

            $apiUri = "$Project/_apis/wit/queries/$encoded"
            if ($UndeleteDescendants) {
                $apiUri += "?`$undeleteDescendants=true"
            }

            $bodyHash = @{}
            if ($PSBoundParameters.ContainsKey('Name'))        { $bodyHash.name       = $Name }
            if ($PSBoundParameters.ContainsKey('Wiql'))        { $bodyHash.wiql       = $Wiql }
            if ($PSBoundParameters.ContainsKey('QueryType'))   { $bodyHash.queryType  = $QueryType }
            if ($PSBoundParameters.ContainsKey('IsPublic'))    { $bodyHash.isPublic   = $IsPublic }
            if ($PSBoundParameters.ContainsKey('IsDeleted'))   { $bodyHash.isDeleted  = $IsDeleted }

            if ($PSBoundParameters.ContainsKey('Columns')) {
                $bodyHash.columns = @()
                foreach ($c in $Columns) {
                    $bodyHash.columns += @{ referenceName = $c }
                }
            }

            if ($PSBoundParameters.ContainsKey('SortColumns')) {
                $bodyHash.sortColumns = @()
                foreach ($sc in $SortColumns) {
                    $parts = $sc.Split(':')
                    $ref = $parts[0]
                    $desc = ($parts.Count -gt 1 -and $parts[1].ToLower() -eq 'desc')
                    $bodyHash.sortColumns += @{
                        field = @{ referenceName = $ref }
                        descending = $desc
                    }
                }
            }

            if ($bodyHash.Count -eq 0) {
                Write-PSFMessage -Level Warning -Message "No updatable properties supplied. Nothing to do."
                return
            }

            $body = $bodyHash | ConvertTo-Json -Depth 6
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"
            Write-PSFMessage -Level Verbose -Message "Payload properties: $($bodyHash.Keys -join ', ')"

            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method 'PATCH' `
                                             -Body $body `
                                             -Headers @{'Content-Type'='application/json'} `
                                             -ApiVersion $ApiVersion

            Write-PSFMessage -Level Verbose -Message "Successfully updated query '$Query'"
            return $response.Results | Select-PSFObject * -TypeName 'ADO.TOOLS.QueryHierarchyItem'
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to update query '$Query' : $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed update of query '$Query'"
        Invoke-TimeSignal -End
    }
}