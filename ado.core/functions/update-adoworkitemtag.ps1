
<#
    .SYNOPSIS
        Renames an existing work item tag.
    .DESCRIPTION
        PATCH wrapper for Tags - Update endpoint.
    .OUTPUTS
        ADO.TOOLS.WorkItem.TagDefinition
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        PAT (vso.work_write scope).
    .PARAMETER Tag
        Existing tag id or name.
    .PARAMETER NewName
        New tag name.
    .PARAMETER ApiVersion
        API version (default 7.1).
    .PARAMETER Confirm
        Confirmation prompt.
    .PARAMETER WhatIf
        Show what would happen.
    .EXAMPLE
        PS> Update-ADOWorkItemTag -Organization org -Project proj -Token $pat -Tag old -NewName new
    .EXAMPLE
        PS> Update-ADOWorkItemTag -Organization org -Project proj -Token $pat -Tag 18090594-b371-4140-99d2-fc93bcbcddec -NewName standardized
    .LINK
        https://learn.microsoft.com/azure/devops
#>
function Update-ADOWorkItemTag {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)] [string]$Organization,
        [Parameter(Mandatory = $true)] [string]$Project,
        [Parameter(Mandatory = $true)] [string]$Token,
        [Parameter(Mandatory = $true)] [string]$Tag,
        [Parameter(Mandatory = $true)] [ValidateNotNullOrEmpty()] [string]$NewName,
        [Parameter()] [string]$ApiVersion = '7.1'
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting update of tag '$Tag' -> '$NewName' (Org: $Organization / Project: $Project)"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        if (-not $PSCmdlet.ShouldProcess("Tag '$Tag'","Rename to '$NewName'")) { return }
        try {
            $encoded = [System.Uri]::EscapeDataString($Tag)
            $apiUri = "$Project/_apis/wit/tags/$encoded"
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"

            $bodyHash = @{
                name = $NewName
            }
            if ($Tag -match '^[0-9a-fA-F-]{36}$') {
                $bodyHash.id = $Tag
            }
            $body = $bodyHash | ConvertTo-Json -Depth 3
            Write-PSFMessage -Level Verbose -Message "Payload properties: $($bodyHash.Keys -join ', ')"

            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method 'PATCH' `
                                             -Body $body `
                                             -Headers @{'Content-Type'='application/json'} `
                                             -ApiVersion $ApiVersion

            Write-PSFMessage -Level Verbose -Message "Successfully updated tag '$Tag' to '$NewName'"
            return $response.Results | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.TagDefinition'
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to update tag '$Tag' : $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed update of tag '$Tag'"
        Invoke-TimeSignal -End
    }
}