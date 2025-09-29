
<#
    .SYNOPSIS
        Removes (deletes) a work item comment.
    .DESCRIPTION
        Calls Azure DevOps Work Item Tracking REST API (Comments - Delete) to delete a specific
        comment. The API returns the (now marked deleted) comment object (isDeleted = true).
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        Personal Access Token (PAT) with vso.work_write scope.
    .PARAMETER WorkItemId
        Work item id owning the comment.
    .PARAMETER CommentId
        Comment id to delete.
    .PARAMETER ApiVersion
        API version (default 7.1-preview.4).
    .EXAMPLE
        Remove-ADOWorkItemComment -Organization org -Project proj -Token $pat -WorkItemId 299 -CommentId 50 -Confirm:$false
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Remove-ADOWorkItemComment {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
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