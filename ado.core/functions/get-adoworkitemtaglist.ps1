
<#
    .SYNOPSIS
        Lists all work item tags in a project.
    .DESCRIPTION
        Wraps Tags - List endpoint. Returns all tag definitions or raw payload.
    .OUTPUTS
        ADO.TOOLS.WorkItem.TagDefinition
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        PAT.
    .PARAMETER Raw
        Return raw payload.
    .PARAMETER ApiVersion
        API version (default 7.1).
    .EXAMPLE
        PS> Get-ADOWorkItemTagList -Organization org -Project proj -Token $pat
    .EXAMPLE
        PS> Get-ADOWorkItemTagList -Organization org -Project proj -Token $pat -Raw
    .LINK
        https://learn.microsoft.com/azure/devops
#>
function Get-ADOWorkItemTagList {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)] [string]$Organization,
        [Parameter(Mandatory = $true)] [string]$Project,
        [Parameter(Mandatory = $true)] [string]$Token,
        [Parameter()] [switch]$Raw,
        [Parameter()] [string]$ApiVersion = '7.1'
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting retrieval of tag list (Org: $Organization / Project: $Project)"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            $apiUri = "$Project/_apis/wit/tags"
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"

            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method 'GET' `
                                             -Headers @{'Content-Type'='application/json'} `
                                             -ApiVersion $ApiVersion

            $payload = $response.Results
            if ($Raw) {
                Write-PSFMessage -Level Verbose -Message "Returning raw tag list payload"
                return $payload
            }

            $tags = @()
            if ($payload) {
                if ($payload.value) {
                    foreach ($t in $payload.value) {
                        $tags += ($t | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.TagDefinition')
                    }
                }
                elseif ($payload -is [System.Collections.IEnumerable]) {
                    foreach ($item in $payload) {
                        if ($item.value) {
                            foreach ($t in $item.value) {
                                $tags += ($t | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.TagDefinition')
                            }
                        }
                        elseif ($item.id) {
                            $tags += ($item | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.TagDefinition')
                        }
                    }
                }
                elseif ($payload.id) {
                    $tags += ($payload | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.TagDefinition')
                }
            }

            Write-PSFMessage -Level Verbose -Message "Retrieved $($tags.Count) tag(s)"
            return $tags
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to retrieve tag list: $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed retrieval of tag list"
        Invoke-TimeSignal -End
    }
}