
<#
    .SYNOPSIS
        Gets root classification nodes (Areas and Iterations).
    .DESCRIPTION
        Uses the Azure DevOps Work Item Tracking REST API (Classification Nodes - Get Root Nodes)
        to retrieve root classification nodes under the project. Returns both Areas and Iterations
        root nodes with optional child hierarchy depth.
    .OUTPUTS
        ADO.TOOLS.WorkItem.ClassificationNode[]
    .PARAMETER Organization
        Azure DevOps organization name (e.g. contoso).
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        Personal Access Token (PAT) with vso.work scope.
    .PARAMETER Depth
        Depth of children to fetch (optional). Specify a number to include child nodes
        in the response hierarchy.
    .PARAMETER ApiVersion
        API version (default 7.2-preview.2).
    .EXAMPLE
        PS> Get-ADOClassificationNodeRoot -Organization contoso -Project WebApp -Token $pat
        Gets both root Areas and Iterations nodes.
    .EXAMPLE
        PS> Get-ADOClassificationNodeRoot -Organization contoso -Project WebApp -Token $pat -Depth 2
        Gets root nodes including 2 levels of child nodes for both Areas and Iterations.
    .EXAMPLE
        PS> $roots = Get-ADOClassificationNodeRoot -Organization contoso -Project WebApp -Token $pat -Depth 1
        PS> $areas = $roots | Where-Object { $_.structureType -eq 'area' }
        PS> $iterations = $roots | Where-Object { $_.structureType -eq 'iteration' }
        Gets root nodes with immediate children and separates Areas from Iterations.
    .LINK
        https://learn.microsoft.com/azure/devops
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Get-ADOClassificationNodeRoot {
    [CmdletBinding()]
    [OutputType('ADO.TOOLS.WorkItem.ClassificationNode[]')]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Organization,

        [Parameter(Mandatory=$true)]
        [string]$Project,

        [Parameter(Mandatory=$true)]
        [string]$Token,

        [Parameter()]
        [int]$Depth,

        [Parameter()]
        [string]$ApiVersion = '7.2-preview.2'
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting retrieval of root classification nodes (Org: $Organization / Project: $Project)"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            # Build API URI - this endpoint returns both Areas and Iterations root nodes
            $basePath = "$Project/_apis/wit/classificationnodes"

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
                # The API returns an array of root nodes (Areas and Iterations)
                $nodes = @()
                
                if ($response.Results -is [System.Array]) {
                    $nodes = $response.Results
                }
                else {
                    # Single result wrapped as array
                    $nodes = @($response.Results)
                }

                Write-PSFMessage -Level Verbose -Message "Retrieved $($nodes.Count) root classification nodes"

                # Process and return nodes with type information
                $result = @()
                foreach ($node in $nodes) {
                    if ($node) {
                        $result += ($node | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.ClassificationNode')
                    }
                }

                return $result
            }
            else {
                Write-PSFMessage -Level Warning -Message "No root classification nodes found"
                return @()
            }
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to retrieve root classification nodes: $($_.Exception.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -Target $PSCmdlet.MyInvocation.MyCommand.Name -ErrorRecord $_
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed root classification nodes retrieval operation"
        Invoke-TimeSignal -End
    }
}