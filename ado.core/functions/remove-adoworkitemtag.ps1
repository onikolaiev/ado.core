
<#
    .SYNOPSIS
        Deletes a work item tag.
    .DESCRIPTION
        Wraps Tags - Delete endpoint. Removes tag from all work items and PRs. Returns tag definition
        if API supplies body; otherwise returns identifier with -PassThru.
    .OUTPUTS
        ADO.TOOLS.WorkItem.TagDefinition
        System.String
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        PAT (vso.work_write scope).
    .PARAMETER Tag
        Tag name or GUID.
    .PARAMETER PassThru
        Return identifier when no body.
    .PARAMETER ApiVersion
        API version (default 7.1).
    .PARAMETER Confirm
        Confirmation prompt.
    .PARAMETER WhatIf
        Simulation only.
    .EXAMPLE
        PS> Remove-ADOWorkItemTag -Organization org -Project proj -Token $pat -Tag obsolete -Confirm:$false
        
        Deletes the tag by name.
    .EXAMPLE
        PS> Remove-ADOWorkItemTag -Organization org -Project proj -Token $pat -Tag 18090594-b371-4140-99d2-fc93bcbcddec -PassThru -Confirm:$false
        
        Deletes the tag by GUID and returns the GUID when successful.
    .LINK
        https://learn.microsoft.com/azure/devops
#>
function Remove-ADOWorkItemTag {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    [OutputType('ADO.TOOLS.WorkItem.TagDefinition',[string])]
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