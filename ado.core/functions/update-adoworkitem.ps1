
<#
    .SYNOPSIS
        Updates a work item in Azure DevOps.
        
    .DESCRIPTION
        This function updates a specified work item in Azure DevOps using a JSON Patch document.
        It supports optional parameters to validate changes, bypass rules, suppress notifications, and expand additional attributes of the work item.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Project
        (Optional) The name or ID of the Azure DevOps project.
        
    .PARAMETER Token
        The personal access token (PAT) used for authentication.
        
    .PARAMETER Id
        The ID of the work item to update.
        
    .PARAMETER Body
        The JSON Patch document containing the fields and values to update.
        
    .PARAMETER ValidateOnly
        (Optional) Indicates if you only want to validate the changes without saving the work item. Default is `$false`.
        
    .PARAMETER BypassRules
        (Optional) Indicates if work item type rules should be bypassed. Default is `$false`.
        
    .PARAMETER SuppressNotifications
        (Optional) Indicates if notifications should be suppressed for this change. Default is `$false`.
        
    .PARAMETER Expand
        (Optional) Specifies the expand parameters for work item attributes. Possible values are `None`, `Relations`, `Fields`, `Links`, or `All`.
        
    .PARAMETER ApiVersion
        (Optional) The API version to use. Default is `7.1`.
        
    .EXAMPLE
        # Example 1: Update a work item by ID
        $body = @(
            @{
                op    = "add"
                path  = "/fields/System.Title"
                value = "Updated Title"
            }
        )

        Update-ADOWorkItem -Organization "my-org" -Project "my-project" -Token "my-token" -Id 12345 -Body $body
        
    .EXAMPLE
        # Example 2: Validate an update without saving
        $body = @(
            @{
                op    = "add"
                path  = "/fields/System.History"
                value = "Adding a comment for context"
            }
        )
        
        Update-ADOWorkItem -Organization "my-org" -Project "my-project" -Token "my-token" -Id 12345 -Body $body -ValidateOnly $true
        
    .NOTES
        This function is part of the ADO Tools module and adheres to the conventions used in the module for logging, error handling, and API interaction.
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>

function Update-ADOWorkItem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $false)]
        [string]$Project,

        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter(Mandatory = $true)]
        [int]$Id,

        [Parameter(Mandatory = $true)]
        [PSCustomObject[]]$Body,

        [Parameter(Mandatory = $false)]
        [switch]$ValidateOnly,

        [Parameter(Mandatory = $false)]
        [switch]$BypassRules,

        [Parameter(Mandatory = $false)]
        [switch]$SuppressNotifications,

        [Parameter(Mandatory = $false)]
        [ValidateSet("None", "Relations", "Fields", "Links", "All")]
        [string]$Expand = "None",

        [Parameter(Mandatory = $false)]
        [string]$ApiVersion = $Script:ADOApiVersion
    )

    begin {
        # Log the start of the operation
        Write-PSFMessage -Level Verbose -Message "Starting update of work item ID: $Id in Organization: $Organization"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            # Build the API URI
            $apiUri = "_apis/wit/workitems/$Id"
            if ($Project) { $apiUri = "$Project/$apiUri" }

            # Append query parameters
            if ($ValidateOnly) {
                $apiUri += "?validateOnly=$ValidateOnly"
            }
            if ($BypassRules) {
                $apiUri += if ($apiUri.Contains("?")) { "&bypassRules=$BypassRules" } else { "?bypassRules=$BypassRules" }
            }
            if ($SuppressNotifications) {
                $apiUri += if ($apiUri.Contains("?")) { "&suppressNotifications=$SuppressNotifications" } else { "?suppressNotifications=$SuppressNotifications" }
            }
            if ($Expand -ne "None") {
                $apiUri += if ($apiUri.Contains("?")) { "&`$expand=$Expand" } else { "?`$expand=$Expand" }
            }

            # Log the request details
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"

            # Call the Invoke-ADOApiRequest function
            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method "PATCH" `
                                             -Headers @{"Content-Type" = "application/json-patch+json"} `
                                             -Body $Body `
                                             -ApiVersion $ApiVersion

            # Log the successful response
            Write-PSFMessage -Level Verbose -Message "Successfully updated work item ID: $Id in Organization: $Organization"
            return $response | Select-PSFObject * -TypeName "ADO.TOOLS.WorkItem"
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to update work item ID: $Id : $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed update of work item ID: $Id in Organization: $Organization"
        Invoke-TimeSignal -End
    }
}