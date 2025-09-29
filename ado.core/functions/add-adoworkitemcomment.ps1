
<#
    .SYNOPSIS
        Adds a comment to an Azure DevOps work item.
    .DESCRIPTION
        Uses the Work Item Tracking REST API (Comments - Add Comment) to create a new comment
        on the specified work item.
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        Personal Access Token (PAT) with vso.work_write scope.
    .PARAMETER WorkItemId
        Target work item id.
    .PARAMETER Text
        Comment text (markdown supported).
    .PARAMETER Format
        Comment format to send (markdown or html). Required by API. Default markdown.
    .PARAMETER ApiVersion
        API version (default 7.1-preview.4).
    .EXAMPLE
        Add-ADOWorkItemComment -Organization org -Project proj -Token $pat -WorkItemId 299 -Text "Deployment approved."
    .EXAMPLE
        Add-ADOWorkItemComment -Organization org -Project proj -Token $pat -WorkItemId 299 -Text "<b>Bold</b>" -Format html
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Add-ADOWorkItemComment {
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
        [ValidateNotNullOrEmpty()]
        [string]$Text,

        [Parameter(Mandatory = $false)]
        [ValidateSet('markdown','html')]
        [string]$Format = 'markdown',

        [Parameter(Mandatory = $false)]
        [string]$ApiVersion = '7.1-preview.4'
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting add comment to WorkItem $WorkItemId (Org: $Organization / Project: $Project)"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            # Build API Uri with required format query parameter
            $apiUri = "$Project/_apis/wit/workItems/$WorkItemId/comments?format=$Format"
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"

            $body = @{ text = $Text } | ConvertTo-Json -Depth 4

            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method 'POST' `
                                             -Body $body `
                                             -Headers @{'Content-Type'='application/json'} `
                                             -ApiVersion $ApiVersion

            Write-PSFMessage -Level Verbose -Message "Successfully added comment to WorkItem $WorkItemId"
            return $response.Results | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.Comment'
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to add comment to WorkItem $WorkItemId : $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed add comment operation for WorkItem $WorkItemId"
        Invoke-TimeSignal -End
    }
}