
<#
    .SYNOPSIS
        Deletes a work item comment.
    .DESCRIPTION
        Wraps Comments - Delete endpoint. Returns the updated (isDeleted=true) comment object.
    .OUTPUTS
        ADO.TOOLS.WorkItem.Comment
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        PAT (vso.work_write scope).
    .PARAMETER WorkItemId
        Work item id.
    .PARAMETER CommentId
        Comment id to delete.
    .PARAMETER ApiVersion
        API version (default 7.1-preview.4 or current module default if different).
    .PARAMETER Confirm
        Confirmation prompt (SupportsShouldProcess).
    .PARAMETER WhatIf
        Show what would happen without deleting.
    .EXAMPLE
        PS> Remove-ADOWorkItemComment -Organization org -Project proj -Token $pat -WorkItemId 100 -CommentId 42 -Confirm:$false
        
        Deletes comment 42 on work item 100.
    .LINK
        https://learn.microsoft.com/azure/devops
#>
function Remove-ADOWorkItemComment {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    [OutputType('ADO.TOOLS.WorkItem.Comment')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Project,

        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter(Mandatory = $true)]
        [int]$WorkItemId,

        [Parameter(Mandatory = $true)]
        [int]$CommentId,

        [Parameter(Mandatory = $false)]
        [string]$ApiVersion = '7.1-preview.4'
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting delete of comment $CommentId for WorkItem $WorkItemId (Org: $Organization / Project: $Project)"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        if (-not $PSCmdlet.ShouldProcess("WorkItem $WorkItemId Comment $CommentId","Delete")) { return }
        try {
            $apiUri = "$Project/_apis/wit/workItems/$WorkItemId/comments/$CommentId"
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"

            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method 'DELETE' `
                                             -Headers @{'Content-Type'='application/json'} `
                                             -ApiVersion $ApiVersion

            Write-PSFMessage -Level Verbose -Message "Successfully deleted comment $CommentId on WorkItem $WorkItemId"
            return $response.Results | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.Comment'
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to delete comment $CommentId on WorkItem $WorkItemId : $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed delete operation for comment $CommentId on WorkItem $WorkItemId"
        Invoke-TimeSignal -End
    }
}