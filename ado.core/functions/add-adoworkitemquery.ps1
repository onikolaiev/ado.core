
<#
    .SYNOPSIS
        Creates (folder/query) or moves an existing work item query.
    .DESCRIPTION
        Wraps Azure DevOps Queries - Create endpoint (POST wit/queries/{parent}).
        Parameter set Create: supply -Name (and optionally -Wiql for a query or -Folder for a folder).
        Parameter set Move: supply -Id of existing query/folder to move under -ParentPath.
        Use -ValidateWiqlOnly to validate WIQL without creating.
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        Personal Access Token (PAT) with vso.work_write scope.
    .PARAMETER ParentPath
        Parent folder path or id where the item is created/moved (e.g. 'Shared Queries' or 'Shared Queries/Team').
    .PARAMETER Name
        Name of new folder/query (Create set).
    .PARAMETER Folder
        Create a folder instead of a WIQL query.
    .PARAMETER Wiql
        WIQL text for query (omit for folders).
    .PARAMETER QueryType
        flat | tree | oneHop (optional hint; usually inferred).
    .PARAMETER Columns
        One or more field reference names to include as columns.
    .PARAMETER SortColumns
        Sort definitions. Format: FieldRefName or FieldRefName:desc
    .PARAMETER Public
        Make created item public (isPublic=true).
    .PARAMETER Id
        Existing query/folder id to move (Move set).
    .PARAMETER ValidateWiqlOnly
        Only validate WIQL (no creation). Returns validation result (HTTP still POST).
    .PARAMETER ApiVersion
        API version (default 7.1).
    .EXAMPLE
        Add-ADOWorkItemQuery -Organization org -Project proj -Token $pat -ParentPath 'Shared Queries' -Name 'All Bugs' -Wiql "Select ..." -Columns System.Id,System.Title,System.State
    .EXAMPLE
        Add-ADOWorkItemQuery -Organization org -Project proj -Token $pat -ParentPath 'My Queries' -Name 'Team' -Folder
    .EXAMPLE
        Add-ADOWorkItemQuery -Organization org -Project proj -Token $pat -ParentPath 'My Queries' -Id 8a8c8212-15ca-41ed-97aa-1d6fbfbcd581
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Add-ADOWorkItemQuery {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
    [CmdletBinding(DefaultParameterSetName='Create')]
    param(
        [Parameter(Mandatory=$true)] [string]$Organization,
        [Parameter(Mandatory=$true)] [string]$Project,
        [Parameter(Mandatory=$true)] [string]$Token,

        [Parameter(Mandatory=$true)] [string]$ParentPath,

        # Create
        [Parameter(Mandatory=$true, ParameterSetName='Create')]
        [string]$Name,
        [Parameter(ParameterSetName='Create')]
        [switch]$Folder,
        [Parameter(ParameterSetName='Create')]
        [string]$Wiql,
        [Parameter(ParameterSetName='Create')]
        [ValidateSet('flat','tree','oneHop')]
        [string]$QueryType,
        [Parameter(ParameterSetName='Create')]
        [string[]]$Columns,
        [Parameter(ParameterSetName='Create')]
        [string[]]$SortColumns,
        [Parameter(ParameterSetName='Create')]
        [switch]$Public,

        # Move
        [Parameter(Mandatory=$true, ParameterSetName='Move')]
        [string]$Id,

        # Common
        [Parameter()] [switch]$ValidateWiqlOnly,
        [Parameter()] [string]$ApiVersion = '7.1'
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting Add/Move WorkItem Query (Set: $($PSCmdlet.ParameterSetName)) Parent: $ParentPath Project: $Project"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            # Encode each path segment but preserve '/'
            $escapedParent = ($ParentPath -split '/' | ForEach-Object { [System.Uri]::EscapeDataString($_) }) -join '/'
            $apiUri = "$Project/_apis/wit/queries/$escapedParent"
            if ($ValidateWiqlOnly) { $apiUri += "?validateWiqlOnly=true" }

            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"

            $bodyHash = @{}
            if ($PSCmdlet.ParameterSetName -eq 'Move') {
                $bodyHash.id = $Id
            }
            else {
                $bodyHash.name = $Name
                if ($Folder) {
                    $bodyHash.isFolder = $true
                }
                else {
                    if ($Wiql) { $bodyHash.wiql = $Wiql }
                    if ($QueryType) { $bodyHash.queryType = $QueryType }
                    if ($Columns) {
                        $bodyHash.columns = @()
                        foreach ($col in $Columns) {
                            $bodyHash.columns += @{ referenceName = $col }
                        }
                    }
                    if ($SortColumns) {
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
                }
                if ($Public) { $bodyHash.isPublic = $true }
            }

            $body = $bodyHash | ConvertTo-Json -Depth 6

            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method 'POST' `
                                             -Body $body `
                                             -Headers @{'Content-Type'='application/json'} `
                                             -ApiVersion $ApiVersion

            Write-PSFMessage -Level Verbose -Message "Successfully processed query operation (Set: $($PSCmdlet.ParameterSetName))"
            return $response.Results | Select-PSFObject * -TypeName 'ADO.TOOLS.QueryHierarchyItem'
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to process query operation: $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed Add/Move WorkItem Query operation"
        Invoke-TimeSignal -End
    }
}