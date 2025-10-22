
<#
    .SYNOPSIS
        Gets classification nodes (Areas/Iterations) by IDs or root nodes.
    .DESCRIPTION
        Uses the Azure DevOps Work Item Tracking REST API (Classification Nodes - Get Classification Nodes)
        to retrieve multiple classification nodes. Supports:
            - Getting specific nodes by providing a list of IDs
            - Getting root nodes when no IDs are provided
            - Fetching child nodes at specified depths
            - Error handling policies (Fail or Omit) for invalid node IDs
    .OUTPUTS
        ADO.TOOLS.WorkItem.ClassificationNode[]
    .PARAMETER Organization
        Azure DevOps organization name (e.g. contoso).
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        Personal Access Token (PAT) with vso.work scope.
    .PARAMETER Ids
        Array of classification node IDs to retrieve. If not provided, returns root nodes.
    .PARAMETER Depth
        Depth of children to fetch (optional). Specify a number to include child nodes
        in the response hierarchy.
    .PARAMETER ErrorPolicy
        fail | omit - How to handle errors when getting some nodes. 'fail' throws an error,
        'omit' returns null for invalid IDs but continues processing valid ones.
    .PARAMETER ApiVersion
        API version (default 7.2-preview.2).
    .EXAMPLE
        PS> Get-ADOClassificationNodeList -Organization contoso -Project WebApp -Token $pat
        Gets all root classification nodes (both Areas and Iterations).
    .EXAMPLE
        PS> Get-ADOClassificationNodeList -Organization contoso -Project WebApp -Token $pat -Ids 1,3,5
        Gets classification nodes with IDs 1, 3, and 5.
    .EXAMPLE
        PS> Get-ADOClassificationNodeList -Organization contoso -Project WebApp -Token $pat -Depth 2
        Gets root nodes including 2 levels of child nodes.
    .EXAMPLE
        PS> Get-ADOClassificationNodeList -Organization contoso -Project WebApp -Token $pat -Ids 1,999 -ErrorPolicy omit
        Gets node ID 1 and returns null for invalid ID 999 (instead of failing).
    .LINK
        https://learn.microsoft.com/azure/devops
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Get-ADOClassificationNodeList {
    [CmdletBinding()]
    [OutputType('ADO.TOOLS.WorkItem.ClassificationNode[]')]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Organization,

        [Parameter(Mandatory=$true)]
        [string]$Project,

        [Parameter(Mandatory=$true)]
        [string]$Token,

        [Parameter()]
        [int[]]$Ids,

        [Parameter()]
        [int]$Depth,

        [Parameter()]
        [ValidateSet('fail','omit')]
        [string]$ErrorPolicy,

        [Parameter()]
        [string]$ApiVersion = '7.2-preview.2'
    )

    begin {
        $idsText = if ($Ids) { "IDs: $($Ids -join ',')" } else { "root nodes" }
        Write-PSFMessage -Level Verbose -Message "Starting retrieval of classification nodes ($idsText) (Org: $Organization / Project: $Project)"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            # Build API URI
            $basePath = "$Project/_apis/wit/classificationnodes"

            # Add query parameters
            $query = @{}
            
            if ($Ids -and $Ids.Count -gt 0) {
                $query['ids'] = ($Ids -join ',')
            }
            
            if ($Depth -gt 0) {
                $query['$depth'] = $Depth
            }
            
            if ($ErrorPolicy) {
                $query['errorPolicy'] = $ErrorPolicy
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
                # Handle different response formats
                $nodes = @()
                
                if ($response.Results.value) {
                    # Array response (when IDs provided)
                    $nodes = $response.Results.value
                    Write-PSFMessage -Level Verbose -Message "Retrieved $($nodes.Count) classification nodes from array response"
                }
                elseif ($response.Results.id) {
                    # Single node response (root nodes)
                    $nodes = @($response.Results)
                    Write-PSFMessage -Level Verbose -Message "Retrieved single root classification node (ID: $($response.Results.id))"
                }
                else {
                    Write-PSFMessage -Level Warning -Message "Unexpected response format from classification nodes API"
                    return @()
                }

                # Process and return nodes with type information
                $result = @()
                foreach ($node in $nodes) {
                    if ($node) {
                        $result += ($node | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.ClassificationNode')
                    }
                    else {
                        # Handle null entries (from omit error policy)
                        $result += $null
                    }
                }

                return $result
            }
            else {
                Write-PSFMessage -Level Warning -Message "No classification nodes found"
                return @()
            }
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to retrieve classification nodes: $($_.Exception.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -Target $PSCmdlet.MyInvocation.MyCommand.Name -ErrorRecord $_
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed classification nodes retrieval operation"
        Invoke-TimeSignal -End
    }
}