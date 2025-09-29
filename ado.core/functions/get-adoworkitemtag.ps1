<#
    .SYNOPSIS
        Retrieves a single work item tag definition.
    .DESCRIPTION
        Wraps Tags - Get endpoint. Accepts tag GUID or name.
    .OUTPUTS
        ADO.TOOLS.WorkItem.TagDefinition
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        Project name or id.
    .PARAMETER Token
        PAT (vso.work scope).
    .PARAMETER Tag
        Tag GUID or name.
    .PARAMETER ApiVersion
        API version (default 7.1).
    .EXAMPLE
        PS> Get-ADOWorkItemTag -Organization org -Project proj -Token $pat -Tag "my-first-tag"
        
        Retrieves tag by name.
    .EXAMPLE
        PS> Get-ADOWorkItemTag -Organization org -Project proj -Token $pat -Tag 18090594-b371-4140-99d2-fc93bcbcddec
        
        Retrieves tag by GUID.
    .LINK
        https://learn.microsoft.com/azure/devops
#>
function Get-ADOWorkItemTag {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
    [CmdletBinding()]
    [OutputType('ADO.TOOLS.WorkItem.TagDefinition')]
    param(
        [Parameter(Mandatory = $true)] [string]$Organization,
        [Parameter(Mandatory = $true)] [string]$Project,
        [Parameter(Mandatory = $true)] [string]$Token,
        [Parameter(Mandatory = $true)] [string]$Tag,
        [Parameter()] [string]$ApiVersion = '7.1'
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting retrieval of tag '$Tag' (Org: $Organization / Project: $Project)"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            $encodedTag = [System.Uri]::EscapeDataString($Tag)
            $apiUri = "$Project/_apis/wit/tags/$encodedTag"
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"

            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method 'GET' `
                                             -Headers @{'Content-Type'='application/json'} `
                                             -ApiVersion $ApiVersion

            Write-PSFMessage -Level Verbose -Message "Successfully retrieved tag '$Tag'"
            return $response.Results | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.TagDefinition'
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to retrieve tag '$Tag' : $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed retrieval of tag '$Tag'"
        Invoke-TimeSignal -End
    }
}