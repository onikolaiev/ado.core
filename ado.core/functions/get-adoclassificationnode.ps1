
<#
    .SYNOPSIS
        Gets a classification node (Area or Iteration).
    .DESCRIPTION
        Uses the Azure DevOps Work Item Tracking REST API (Classification Nodes - Get) to
        retrieve a classification node for a given path. Supports fetching child nodes
        at specified depths for hierarchical navigation.
    .OUTPUTS
        ADO.TOOLS.WorkItem.ClassificationNode
    .PARAMETER Organization
        Azure DevOps organization name (e.g. contoso).
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        Personal Access Token (PAT) with vso.work scope.
    .PARAMETER StructureGroup
        Areas | Iterations - specifies whether to retrieve Area or Iteration nodes.
    .PARAMETER Path
        Path of the classification node to retrieve (e.g. 'ParentArea\ChildArea').
        Leave empty to get the root node.
    .PARAMETER Depth
        Depth of children to fetch (optional). Specify a number to include child nodes
        in the response hierarchy.
    .PARAMETER ApiVersion
        API version (default 7.2-preview.2).
    .EXAMPLE
        PS> Get-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Areas
        Gets the root Areas node.
    .EXAMPLE
        PS> Get-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Iterations -Path "Sprint 1"
        Gets the "Sprint 1" iteration node.
    .EXAMPLE
        PS> Get-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Areas -Path "Development" -Depth 2
        Gets the "Development" area node including 2 levels of child nodes.
    .EXAMPLE
        PS> Get-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Iterations -Depth 1
        Gets the root Iterations node with immediate children.
    .LINK
        https://learn.microsoft.com/azure/devops
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Get-ADOClassificationNode {
    [CmdletBinding()]
    [OutputType('ADO.TOOLS.WorkItem.ClassificationNode')]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Organization,

        [Parameter(Mandatory=$true)]
        [string]$Project,

        [Parameter(Mandatory=$true)]
        [string]$Token,

        [Parameter(Mandatory=$true)]
        [ValidateSet('Areas','Iterations')]
        [string]$StructureGroup,

        [Parameter()]
        [string]$Path,

        [Parameter()]
        [int]$Depth,

        [Parameter()]
        [string]$ApiVersion = '7.2-preview.2'
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting retrieval of classification node (Group: $StructureGroup, Path: '$Path') (Org: $Organization / Project: $Project)"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            # Build API URI with encoded path
            $basePath = "$Project/_apis/wit/classificationnodes/$StructureGroup"
            if ($Path) {
                # URL encode the path segments
                $pathSegments = $Path.Split('\', [StringSplitOptions]::RemoveEmptyEntries)
                $encodedSegments = $pathSegments | ForEach-Object { [System.Uri]::EscapeDataString($_) }
                $basePath += '/' + ($encodedSegments -join '/')
            }

            # Add query parameters
            $query = @{}
            if ($Depth -gt 0) {
                $query['$depth'] = $Depth
            }

            $apiUri = $basePath
            if ($query.Count -gt 0) {
                $pairs = foreach ($kv in $query.GetEnumerator()) { "{0}={1}" -f $kv.Key,$kv.Value }
                $apiUri += '?' + ($pairs -join '&')
            }

            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"

            # Make API call
            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method 'GET' `
                                             -Headers @{'Content-Type' = 'application/json'} `
                                             -ApiVersion $ApiVersion

            if ($response.Results) {
                Write-PSFMessage -Level Verbose -Message "Successfully retrieved classification node (ID: $($response.Results.id), Name: '$($response.Results.name)')"
                return $response.Results | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.ClassificationNode'
            }
            else {
                Write-PSFMessage -Level Warning -Message "No classification node found for the specified path"
                return $null
            }
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to retrieve classification node: $($_.Exception.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -Target $PSCmdlet.MyInvocation.MyCommand.Name -ErrorRecord $_
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed classification node retrieval operation"
        Invoke-TimeSignal -End
    }
}