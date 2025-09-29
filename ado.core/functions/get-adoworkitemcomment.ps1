
<#
    .SYNOPSIS
        Retrieves a single comment for a work item.
    .DESCRIPTION
        Calls the Azure DevOps Work Item Tracking REST API (Comments - Get Comment) to return a single comment.
        Supports expanding reactions or rendered text and optionally including deleted comment.
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        Personal Access Token (PAT).
    .PARAMETER WorkItemId
        Work item id owning the comment.
    .PARAMETER CommentId
        Comment id to retrieve.
    .PARAMETER IncludeDeleted
        Include deleted comment (if deleted).
    .PARAMETER Expand
        none | reactions | renderedText | renderedTextOnly | all
    .PARAMETER ApiVersion
        API version. Default 7.1-preview.4
    .EXAMPLE
        Get-ADOWorkItemComment -Organization org -Project proj -Token $pat -WorkItemId 299 -CommentId 42
    .EXAMPLE
        Get-ADOWorkItemComment -Organization org -Project proj -Token $pat -WorkItemId 299 -CommentId 42 -Expand renderedText
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Get-ADOWorkItemComment {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
    [CmdletBinding()]
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
        [switch]$IncludeDeleted,

        [Parameter(Mandatory = $false)]
        [ValidateSet('none','reactions','renderedText','renderedTextOnly','all')]
        [string]$Expand = 'none',

        [Parameter(Mandatory = $false)]
        [string]$ApiVersion = '7.1-preview.4'
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting retrieval of comment $CommentId for WorkItem $WorkItemId (Org: $Organization / Project: $Project)"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            $apiUri = "$Project/_apis/wit/workItems/$WorkItemId/comments/$CommentId"

            $queryParams = @{}
            if ($IncludeDeleted) { $queryParams['includeDeleted'] = 'true' }
            if ($Expand -ne 'none') { $queryParams['$expand'] = $Expand }

            if ($queryParams.Count -gt 0) {
                $apiUri += '?' + ($queryParams.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" } -join '&')
            }

            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"

            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method 'GET' `
                                             -Headers @{'Content-Type'='application/json'} `
                                             -ApiVersion $ApiVersion

            Write-PSFMessage -Level Verbose -Message "Successfully retrieved comment $CommentId on WorkItem $WorkItemId"
            return $response.Results | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.Comment'
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to retrieve comment $CommentId on WorkItem $WorkItemId : $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed retrieval of comment $CommentId on WorkItem $WorkItemId"
        Invoke-TimeSignal -End
    }
}