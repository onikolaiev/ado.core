
<#
    .SYNOPSIS
        Deletes a work item tag.
    .DESCRIPTION
        Removes the tag from the project and all associated work items / PRs.
    .OUTPUTS
        ADO.TOOLS.WorkItem.TagDefinition, or System.String (with -PassThru and empty body).
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        PAT (vso.work_write scope).
    .PARAMETER Tag
        Tag id or name to delete.
    .PARAMETER PassThru
        Return supplied tag identifier if no body returned.
    .PARAMETER ApiVersion
        API version (default 7.1).
    .PARAMETER Confirm
        Confirmation prompt.
    .PARAMETER WhatIf
        Show action without performing it.
    .EXAMPLE
        PS> Remove-ADOWorkItemTag -Organization org -Project proj -Token $pat -Tag obsolete -Confirm:$false
    .LINK
        https://learn.microsoft.com/azure/devops
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