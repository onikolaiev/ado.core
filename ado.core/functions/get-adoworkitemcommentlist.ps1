
<#
    .SYNOPSIS
        Retrieves comments for an Azure DevOps work item.
    .DESCRIPTION
        Retrieves a (pageable) list of comments for the specified work item. Supports server paging
        via -Top and -ContinuationToken or automatic full retrieval with -All. Can include deleted,
        expand rendered text or reactions, and control sort order.
    .OUTPUTS
        ADO.TOOLS.WorkItem.Comment
        ADO.TOOLS.WorkItem.CommentList (when -Raw)
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        Personal Access Token (PAT).
    .PARAMETER WorkItemId
        Target work item id.
    .PARAMETER Top
        Maximum number of comments to return in a single page ($top).
    .PARAMETER ContinuationToken
        Token returned from a previous page to continue listing.
    .PARAMETER IncludeDeleted
        Include deleted comments.
    .PARAMETER Expand
        Additional data options: none, reactions, renderedText, renderedTextOnly, all.
    .PARAMETER Order
        asc or desc.
    .PARAMETER All
        Retrieve and aggregate all pages (ignores provided -ContinuationToken; still honors -Top as page size if set).
    .PARAMETER Raw
        Return raw API payload objects instead of flattened comments.
    .PARAMETER ApiVersion
        API version (default 7.1-preview.4).
    .EXAMPLE
        Get-ADOWorkItemCommentList -Organization org -Project proj -Token $pat -WorkItemId 123
    .EXAMPLE
        Get-ADOWorkItemCommentList -Organization org -Project proj -Token $pat -WorkItemId 123 -Top 50 -All
    .EXAMPLE
        Get-ADOWorkItemCommentList -Organization org -Project proj -Token $pat -WorkItemId 123 -Expand renderedText -Order desc
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Get-ADOWorkItemCommentList {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding(DefaultParameterSetName = 'Paged')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Project,

        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter(Mandatory = $true)]
        [int]$WorkItemId,

        [Parameter(Mandatory = $false)]
        [int]$Top,

        [Parameter(Mandatory = $false, ParameterSetName = 'Paged')]
        [string]$ContinuationToken,

        [Parameter(Mandatory = $false)]
        [switch]$IncludeDeleted,

        [Parameter(Mandatory = $false)]
        [ValidateSet('none','reactions','renderedText','renderedTextOnly','all')]
        [string]$Expand = 'none',

        [Parameter(Mandatory = $false)]
        [ValidateSet('asc','desc')]
        [string]$Order = 'asc',

        [Parameter(Mandatory = $false)]
        [switch]$All,

        [Parameter(Mandatory = $false)]
        [switch]$Raw,

        [Parameter(Mandatory = $false)]
        [string]$ApiVersion = '7.1-preview.4'
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting retrieval of comments for WorkItemId: $WorkItemId (Org: $Organization, Project: $Project)"
        Invoke-TimeSignal -Start
        $baseApiUri = "$Project/_apis/wit/workItems/$WorkItemId/comments"
        $aggregate = @()
        $pageCount = 0
        $effectiveContinuation = $ContinuationToken
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            do {
                $query = @{}
                if ($Top)                { $query['$top'] = $Top }
                if ($effectiveContinuation) { $query['continuationToken'] = $effectiveContinuation }
                if ($IncludeDeleted)     { $query['includeDeleted'] = 'true' }
                if ($Expand -ne 'none')  { $query['$expand'] = $Expand }
                if ($Order)              { $query['order'] = $Order }

                $apiUri = $baseApiUri
                if ($query.Count -gt 0) {
                    $apiUri += '?' + ($query.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" } -join '&')
                }

                Write-PSFMessage -Level Verbose -Message "Requesting comments page (page index: $pageCount) URI: $apiUri"

                $response = Invoke-ADOApiRequest -Organization $Organization `
                                                 -Token $Token `
                                                 -ApiUri $apiUri `
                                                 -Method "GET" `
                                                 -Headers @{'Content-Type'='application/json'} `
                                                 -ApiVersion $ApiVersion

                $payload = $response.Results
                $pageCount++
                $currentComments = @()
                if ($payload -and $payload.comments) {
                    $currentComments = $payload.comments
                }

                if ($Raw) {
                    # Raw mode: accumulate raw payload pages
                    $aggregate += $payload
                }
                else {
                    foreach ($c in $currentComments) {
                        $aggregate += ($c | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.Comment')
                    }
                }

                $effectiveContinuation = $payload.continuationToken
                $hasMore = [string]::IsNullOrWhiteSpace($effectiveContinuation) -eq $false
                if (-not $All) { $hasMore = $false } # Only continue automatically if -All
            } while ($hasMore)

            if ($Raw) {
                Write-PSFMessage -Level Verbose -Message "Successfully retrieved $pageCount page(s) of comment payload(s)"
                return $aggregate | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.CommentList'
            }
            else {
                Write-PSFMessage -Level Verbose -Message "Successfully retrieved $($aggregate.Count) comment(s) across $pageCount page(s)"
                return $aggregate
            }
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to retrieve comments for WorkItemId: $WorkItemId : $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed retrieval of comments for WorkItemId: $WorkItemId"
        Invoke-TimeSignal -End
    }
}