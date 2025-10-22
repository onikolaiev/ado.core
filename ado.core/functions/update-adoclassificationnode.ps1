
<#
    .SYNOPSIS
        Updates a classification node (Area or Iteration).
    .DESCRIPTION
        Uses the Azure DevOps Work Item Tracking REST API (Classification Nodes - Update) to
        update an existing classification node. Supports:
            - Renaming nodes by providing a new Name
            - Updating iteration dates (StartDate/FinishDate)
            - Setting custom attributes via hashtable
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
        Path of the classification node to update (e.g. 'ParentArea\ChildArea').
        Leave empty to update the root node.
    .PARAMETER Name
        New name for the classification node (optional).
    .PARAMETER StartDate
        New start date for Iteration nodes (ISO 8601 format, e.g. '2024-10-27T00:00:00Z').
    .PARAMETER FinishDate
        New finish date for Iteration nodes (ISO 8601 format, e.g. '2024-10-31T00:00:00Z').
    .PARAMETER Attributes
        Hashtable of attributes to update (alternative to individual date parameters).
    .PARAMETER ApiVersion
        API version (default 7.2-preview.2).
    .EXAMPLE
        PS> Update-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Areas -Path "Frontend Team" -Name "UI Team"
        Renames the "Frontend Team" area to "UI Team".
    .EXAMPLE
        PS> Update-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Iterations -Path "Sprint 1" -StartDate "2024-01-01T00:00:00Z" -FinishDate "2024-01-15T00:00:00Z"
        Updates Sprint 1 iteration with new start and finish dates.
    .EXAMPLE
        PS> Update-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Iterations -Path "Current Sprint" -Attributes @{ startDate = "2024-02-01T00:00:00Z"; finishDate = "2024-02-14T00:00:00Z" }
        Updates iteration dates using the Attributes hashtable.
    .EXAMPLE
        PS> Update-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Areas -Name "New Root Area Name"
        Renames the root Areas node.
    .LINK
        https://learn.microsoft.com/azure/devops
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Update-ADOClassificationNode {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
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
        [string]$Name,

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
        Write-PSFMessage -Level Verbose -Message "Starting update of classification node '$Path' (Group: $StructureGroup) (Org: $Organization / Project: $Project)"
        Invoke-TimeSignal -Start

        # Validate that at least one update parameter is provided
        if (-not $Name -and -not $StartDate -and -not $FinishDate -and -not $Attributes) {
            Stop-PSFFunction -Message "At least one update parameter must be provided: Name, StartDate, FinishDate, or Attributes" -Target 'Update-ADOClassificationNode'
            return
        }
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

            Write-PSFMessage -Level Verbose -Message "API path: $basePath"

            # Prepare request body
            $body = @{}

            # Add name if provided
            if ($Name) {
                $body['name'] = $Name
                Write-PSFMessage -Level Verbose -Message "Updating name to: $Name"
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
                Write-PSFMessage -Level Verbose -Message "Updating $($nodeAttributes.Count) attribute(s)"
            }

            # Validate we have something to update
            if ($body.Count -eq 0) {
                throw "No valid update parameters provided"
            }

            # Convert to JSON
            $jsonBody = $body | ConvertTo-Json -Depth 10 -Compress
            Write-PSFMessage -Level Verbose -Message "Request body: $jsonBody"

            # Make API call
            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $basePath `
                                             -Method 'PATCH' `
                                             -Body $jsonBody `
                                             -Headers @{'Content-Type' = 'application/json'} `
                                             -ApiVersion $ApiVersion

            Write-PSFMessage -Level Verbose -Message "Successfully updated classification node (ID: $($response.Results.id))"
            return $response.Results | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.ClassificationNode'
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to update classification node '$Path': $($_.Exception.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -Target $PSCmdlet.MyInvocation.MyCommand.Name -ErrorRecord $_
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed classification node update operation"
        Invoke-TimeSignal -End
    }
}