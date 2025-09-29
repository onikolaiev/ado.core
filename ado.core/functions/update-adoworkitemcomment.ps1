
<#
    .SYNOPSIS
        Updates an existing comment on a work item.
    .DESCRIPTION
        Uses the Work Item Tracking REST API (Comments - Update Work Item Comment) to modify the
        text (and format) of a comment. Returns the updated comment object.
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        Personal Access Token (PAT) with vso.work_write scope.
    .PARAMETER WorkItemId
        Work item id that owns the comment.
    .PARAMETER CommentId
        Comment id to update.
    .PARAMETER Text
        New comment text.
    .PARAMETER Format
        Comment format to send (markdown or html). Default markdown.
    .PARAMETER ApiVersion
        API version (default 7.1-preview.4).
    .EXAMPLE
        Update-ADOWorkItemComment -Organization org -Project proj -Token $pat -WorkItemId 299 -CommentId 50 -Text "Updated text"
    .EXAMPLE
        Update-ADOWorkItemComment -Organization org -Project proj -Token $pat -WorkItemId 299 -CommentId 50 -Text "<b>HTML</b>" -Format html
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Update-ADOWorkItemComment {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)] [string]$Organization,
        [Parameter(Mandatory = $true)] [string]$Project,
        [Parameter(Mandatory = $true)] [string]$Token,
        [Parameter(Mandatory = $true)] [int]$WorkItemId,
        [Parameter(Mandatory = $true)] [int]$CommentId,
        [Parameter(Mandatory = $true)] [ValidateNotNullOrEmpty()] [string]$Text,
        [Parameter(Mandatory = $false)] [ValidateSet('markdown','html')] [string]$Format = 'markdown',
        [Parameter(Mandatory = $false)] [string]$ApiVersion = '7.1-preview.4'
    )
    begin {
        Write-PSFMessage -Level Verbose -Message "Starting update of comment $CommentId on WorkItem $WorkItemId (Org: $Organization / Project: $Project)"
        Invoke-TimeSignal -Start
    }
    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            $apiUri = "$Project/_apis/wit/workItems/$WorkItemId/comments/$CommentId?format=$Format"
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"
            $body = @{ text = $Text } | ConvertTo-Json -Depth 4
            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method 'PATCH' `
                                             -Body $body `
                                             -Headers @{'Content-Type'='application/json'} `
                                             -ApiVersion $ApiVersion
            Write-PSFMessage -Level Verbose -Message "Successfully updated comment $CommentId on WorkItem $WorkItemId"
            return $response.Results | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.Comment'
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to update comment $CommentId on WorkItem $WorkItemId : $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
        }
    }
    end {
        Write-PSFMessage -Level Verbose -Message "Completed update of comment $CommentId on WorkItem $WorkItemId"
        Invoke-TimeSignal -End
    }
}