
<#
    .SYNOPSIS
        Creates a new work item query/folder or moves an existing one.
    .DESCRIPTION
        Wraps the Azure DevOps Queries - Create endpoint to:
            - Create a folder ( -Folder )
            - Create a WIQL query ( -Wiql provided, not -Folder )
            - Move an existing query/folder ( -Id parameter set )
            - Validate WIQL only ( -ValidateWiqlOnly )
    .OUTPUTS
        ADO.TOOLS.QueryHierarchyItem
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        Personal Access Token (PAT) with vso.work_write scope.
    .PARAMETER ParentPath
        Destination parent path (e.g. 'Shared Queries' or 'My Queries/Sub').
    .PARAMETER Name
        Name of the new query/folder (Create set).
    .PARAMETER Folder
        Switch indicating a folder should be created.
    .PARAMETER Wiql
        WIQL text for the query (omit when creating a folder).
    .PARAMETER QueryType
        flat | tree | oneHop (optional override).
    .PARAMETER Columns
        Field reference names for query columns.
    .PARAMETER SortColumns
        Sort definitions (Field or Field:desc).
    .PARAMETER Public
        Make the created item public.
    .PARAMETER Id
        Existing query/folder id to move (Move set).
    .PARAMETER ValidateWiqlOnly
        Validate WIQL without persisting the query.
    .PARAMETER ApiVersion
        API version (default 7.1).
    .EXAMPLE
        PS> Add-ADOWorkItemQuery -Organization org -Project proj -Token $pat -ParentPath 'Shared Queries' -Name 'All Bugs' -Wiql "Select ..."
        
        Creates a flat WIQL query under Shared Queries.
    .EXAMPLE
        PS> Add-ADOWorkItemQuery -Organization org -Project proj -Token $pat -ParentPath 'Shared Queries' -Name 'Release' -Folder
        
        Creates a folder named 'Release'.
    .EXAMPLE
        PS> Add-ADOWorkItemQuery -Organization org -Project proj -Token $pat -ParentPath 'My Queries' -Id 8a8c8212-...-d581
       
        Moves an existing folder/query to My Queries.
    .EXAMPLE
        PS> Add-ADOWorkItemQuery -Organization org -Project proj -Token $pat -ParentPath 'Shared Queries' -Name 'Check' -Wiql 'Select ...' -ValidateWiqlOnly
        
        Validates WIQL without creating the query.
    .LINK
        https://learn.microsoft.com/azure/devops/boards/queries/wiql-syntax
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