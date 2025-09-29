
<#
    .SYNOPSIS
        Deletes a work item tag from a project.
    .DESCRIPTION
        Calls Azure DevOps Work Item Tracking REST API (Tags - Delete). Deleting a tag removes it
        from all work items and pull requests in the project.
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        Personal Access Token (PAT) with vso.work_write scope.
    .PARAMETER Tag
        Tag id (GUID) or tag name to delete.
    .PARAMETER PassThru
        Return the tag identifier supplied if deletion succeeds (when API returns no body).
    .PARAMETER ApiVersion
        API version (default 7.1).
    .EXAMPLE
        Remove-ADOWorkItemTag -Organization org -Project proj -Token $pat -Tag "obsolete-tag" -Confirm:$false
    .EXAMPLE
        Remove-ADOWorkItemTag -Organization org -Project proj -Token $pat -Tag 18090594-b371-4140-99d2-fc93bcbcddec -PassThru -Confirm:$false
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Remove-ADOWorkItemTag {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)] [string]$Organization,
        [Parameter(Mandatory = $true)] [string]$Project,
        [Parameter(Mandatory = $true)] [string]$Token,
        [Parameter(Mandatory = $true)] [string]$Tag,
        [Parameter()] [switch]$PassThru,
        [Parameter()] [string]$ApiVersion = '7.1'
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting deletion of tag '$Tag' (Org: $Organization / Project: $Project)"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        if (-not $PSCmdlet.ShouldProcess("Tag '$Tag'","Delete")) { return }
        try {
            $encoded = [System.Uri]::EscapeDataString($Tag)
            $apiUri = "$Project/_apis/wit/tags/$encoded"
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"

            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method 'DELETE' `
                                             -Headers @{'Content-Type'='application/json'} `
                                             -ApiVersion $ApiVersion

            Write-PSFMessage -Level Verbose -Message "Successfully deleted tag '$Tag'"

            if ($response -and $response.Results) {
                return $response.Results | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.TagDefinition'
            }
            elseif ($PassThru) {
                return $Tag
            }
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to delete tag '$Tag' : $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed deletion of tag '$Tag'"
        Invoke-TimeSignal -End
    }
}