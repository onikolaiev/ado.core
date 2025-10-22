
<#
    .SYNOPSIS
        Creates or updates a classification node (Area or Iteration).
    .DESCRIPTION
        Uses the Azure DevOps Work Item Tracking REST API (Classification Nodes - Create Or Update)
        to create new or update existing classification nodes. Supports:
            - Creating new Area or Iteration nodes with optional attributes
            - Moving existing nodes by providing their ID
            - Setting start/finish dates for Iteration nodes
            - Specifying parent path for hierarchical organization
    .OUTPUTS
        ADO.TOOLS.WorkItem.ClassificationNode
    .PARAMETER Organization
        Azure DevOps organization name (e.g. contoso).
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        Personal Access Token (PAT) with vso.work_write scope.
    .PARAMETER StructureGroup
        Areas | Iterations - specifies whether this is an Area or Iteration node.
    .PARAMETER Path
        Optional path of the classification node. Use for creating nodes under a specific parent
        (e.g. 'ParentArea\ChildArea') or leave empty to create at root level.
    .PARAMETER Name
        Name of the new classification node (required for creating new nodes).
    .PARAMETER Id
        ID of an existing node to move (use instead of -Name for move operations).
    .PARAMETER StartDate
        Start date for Iteration nodes (ISO 8601 format, e.g. '2024-10-27T00:00:00Z').
    .PARAMETER FinishDate
        Finish date for Iteration nodes (ISO 8601 format, e.g. '2024-10-31T00:00:00Z').
    .PARAMETER Attributes
        Hashtable of additional attributes (alternative to individual date parameters).
    .PARAMETER ApiVersion
        API version (default 7.2-preview.2).
    .EXAMPLE
        PS> Add-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Areas -Name "Frontend Team"
        
        Creates a new Area node named "Frontend Team" at the root level.
        
    .EXAMPLE
        PS> Add-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Iterations -Name "Sprint 1" -StartDate "2024-01-01T00:00:00Z" -FinishDate "2024-01-15T00:00:00Z"
        
        Creates a new Iteration with start and finish dates.
        
    .EXAMPLE
        PS> Add-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Areas -Path "Development\Backend" -Name "API Team"
        
        Creates "API Team" area under Development\Backend path.
        
    .EXAMPLE
        PS> Add-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Areas -Path "NewParent" -Id 126391
        
        Moves existing area node (ID 126391) under "NewParent" path.
        
    .LINK
        https://learn.microsoft.com/azure/devops
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Add-ADOClassificationNode {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
    [CmdletBinding(DefaultParameterSetName='CreateByName')]
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

        [Parameter(Mandatory=$true, ParameterSetName='CreateByName')]
        [string]$Name,

        [Parameter(Mandatory=$true, ParameterSetName='MoveById')]
        [int]$Id,

        [Parameter()]
        [datetime]$StartDate,

        [Parameter()]
        [datetime]$FinishDate,

        [Parameter()]
        [hashtable]$Attributes,

        [Parameter()]
        [string]$ApiVersion = '7.2-preview.2'
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting classification node operation (Group: $StructureGroup) (Org: $Organization / Project: $Project)"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            # Build API URI
            $basePath = "$Project/_apis/wit/classificationnodes/$StructureGroup"
            if ($Path) {
                # URL encode the path segments
                $pathSegments = $Path.Split('\', [StringSplitOptions]::RemoveEmptyEntries)
                $encodedSegments = $pathSegments | ForEach-Object { [System.Uri]::EscapeDataString($_) }
                $basePath += '/' + ($encodedSegments -join '/')
            }

            Write-PSFMessage -Level Verbose -Message "API path: $basePath"

            # Prepare request body
            $body = @{}

            if ($PSCmdlet.ParameterSetName -eq 'CreateByName') {
                $body['name'] = $Name
                Write-PSFMessage -Level Verbose -Message "Creating new node: $Name"
            }
            else {
                $body['id'] = $Id
                Write-PSFMessage -Level Verbose -Message "Moving existing node ID: $Id"
            }

            # Handle attributes (dates for iterations)
            $nodeAttributes = @{}
            
            if ($StartDate) {
                $nodeAttributes['startDate'] = $StartDate.ToString('yyyy-MM-ddTHH:mm:ssZ')
            }
            
            if ($FinishDate) {
                $nodeAttributes['finishDate'] = $FinishDate.ToString('yyyy-MM-ddTHH:mm:ssZ')
            }

            # Merge with provided attributes hashtable
            if ($Attributes) {
                foreach ($key in $Attributes.Keys) {
                    $nodeAttributes[$key] = $Attributes[$key]
                }
            }

            if ($nodeAttributes.Count -gt 0) {
                $body['attributes'] = $nodeAttributes
                Write-PSFMessage -Level Verbose -Message "Added $($nodeAttributes.Count) attribute(s)"
            }

            # Convert to JSON
            $jsonBody = $body | ConvertTo-Json -Depth 10 -Compress
            Write-PSFMessage -Level Verbose -Message "Request body: $jsonBody"

            # Make API call
            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $basePath `
                                             -Method 'POST' `
                                             -Body $jsonBody `
                                             -Headers @{'Content-Type' = 'application/json'} `
                                             -ApiVersion $ApiVersion

            Write-PSFMessage -Level Verbose -Message "Successfully processed classification node (ID: $($response.Results.id))"
            return $response.Results | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.ClassificationNode'
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to process classification node: $($_.Exception.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -Target $PSCmdlet.MyInvocation.MyCommand.Name -ErrorRecord $_
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed classification node operation"
        Invoke-TimeSignal -End
    }
}