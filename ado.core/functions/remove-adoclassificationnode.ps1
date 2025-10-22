
<#
    .SYNOPSIS
        Deletes a classification node (Area or Iteration).
    .DESCRIPTION
        Uses the Azure DevOps Work Item Tracking REST API (Classification Nodes - Delete) to
        permanently remove a classification node. Supports optional reclassification of work items
        to a different node before deletion. This operation cannot be undone.
    .OUTPUTS
        System.String
    .PARAMETER Organization
        Azure DevOps organization name (e.g. contoso).
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        Personal Access Token (PAT) with vso.work_write scope.
    .PARAMETER StructureGroup
        Areas | Iterations - specifies whether this is an Area or Iteration node.
    .PARAMETER Path
        Path of the classification node to delete (e.g. 'ParentArea\ChildArea').
        Leave empty to target root level nodes.
    .PARAMETER ReclassifyId
        Optional ID of target classification node for reclassifying work items before deletion.
        If not provided, work items may lose their area/iteration assignment.
    .PARAMETER PassThru
        Return the deleted path when deletion succeeds.
    .PARAMETER ApiVersion
        API version (default 7.2-preview.2).
    .PARAMETER Confirm
        Confirmation prompt (SupportsShouldProcess).
    .PARAMETER WhatIf
        Show what would happen without deleting.
    .EXAMPLE
        PS> Remove-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Areas -Path "Frontend Team" -Confirm:$false
        Deletes the "Frontend Team" area node without confirmation.
    .EXAMPLE
        PS> Remove-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Iterations -Path "Old Sprint" -ReclassifyId 12345 -PassThru
        Deletes "Old Sprint" iteration after reclassifying work items to node ID 12345, returns the deleted path.
    .EXAMPLE
        PS> Remove-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Areas -Path "Development\Legacy" -WhatIf
        Shows what would be deleted without actually performing the deletion.
    .LINK
        https://learn.microsoft.com/azure/devops
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Remove-ADOClassificationNode {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    [OutputType([string])]
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

        [Parameter(Mandatory=$true)]
        [string]$Path,

        [Parameter()]
        [int]$ReclassifyId,

        [Parameter()]
        [switch]$PassThru,

        [Parameter()]
        [string]$ApiVersion = '7.2-preview.2'
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting deletion of classification node '$Path' (Group: $StructureGroup) (Org: $Organization / Project: $Project)"
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
            if ($ReclassifyId) {
                $query['$reclassifyId'] = $ReclassifyId
            }

            $apiUri = $basePath
            if ($query.Count -gt 0) {
                $pairs = foreach ($kv in $query.GetEnumerator()) { "{0}={1}" -f $kv.Key,$kv.Value }
                $apiUri += '?' + ($pairs -join '&')
            }

            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"

            # Confirmation prompt
            $target = "$StructureGroup node '$Path'"
            if ($ReclassifyId) {
                $target += " (reclassifying work items to ID $ReclassifyId)"
            }
            
            if ($PSCmdlet.ShouldProcess($target, "Delete classification node")) {
                # Make API call
                $response = Invoke-ADOApiRequest -Organization $Organization `
                                                 -Token $Token `
                                                 -ApiUri $apiUri `
                                                 -Method 'DELETE' `
                                                 -Headers @{'Content-Type' = 'application/json'} `
                                                 -ApiVersion $ApiVersion

                Write-PSFMessage -Level Verbose -Message "Successfully deleted classification node '$Path'"

                if ($PassThru) {
                    return $Path
                }
            }
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to delete classification node '$Path': $($_.Exception.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -Target $PSCmdlet.MyInvocation.MyCommand.Name -ErrorRecord $_
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed classification node deletion operation"
        Invoke-TimeSignal -End
    }
}