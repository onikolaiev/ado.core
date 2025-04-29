
<#
    .SYNOPSIS
        Creates a new work item in Azure DevOps.
        
    .DESCRIPTION
        This function creates a new work item in a specified Azure DevOps project using the provided parameters.
        It supports optional parameters to bypass rules, suppress notifications, validate changes, and expand additional attributes of the work item.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Project
        The name or ID of the Azure DevOps project where the work item will be created.
        
    .PARAMETER Token
        The personal access token (PAT) used for authentication.
        
    .PARAMETER Type
        The type of the work item to create (e.g., Task, Bug, User Story).
        
    .PARAMETER Body
        The JSON Patch document containing the fields and values for the work item.
        
    .PARAMETER ValidateOnly
        (Optional) Indicates if you only want to validate the changes without saving the work item. Default is `$false`.
        
    .PARAMETER BypassRules
        (Optional) Indicates if work item type rules should be bypassed. Default is `$false`.
        
    .PARAMETER SuppressNotifications
        (Optional) Indicates if notifications should be suppressed for this change. Default is `$false`.
        
    .PARAMETER Expand
        (Optional) Specifies the expand parameters for work item attributes. Possible values are `None`, `Relations`, `Fields`, `Links`, or `All`.
        
    .PARAMETER ApiVersion
        (Optional) The API version to use. Default is `$Script:ADOApiVersion`.
        
    .EXAMPLE
        # Example 1: Create a new Task work item
        $body = @"
        {
            "op": "add",
            "path": "/fields/System.Title",
            "value": "Sales Order Process",
        }
        "@
        
        Add-ADOWorkItem -Organization "my-org" -Project "my-project" -Token "my-token" -Type "Task" -Body $body
        
    .EXAMPLE
        # Example 2: Create a new Bug work item with validation only
        $body = @"
        {
            "op": "add",
            "path": "/fields/System.Title",
            "value": "Sample Bug",
        }
        "@
        Add-ADOWorkItem -Organization "my-org" -Project "my-project" -Token "my-token" -Type "Bug" -Body $body -ValidateOnly $true
        
    .NOTES
        This function is part of the ADO Tools module and adheres to the conventions used in the module for logging, error handling, and API interaction.
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>

function Add-ADOWorkItem {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Project,

        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter(Mandatory = $true)]
        [string]$Type,

        [Parameter(Mandatory = $true)]
        [string]$Body,

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
        Write-PSFMessage -Level Verbose -Message "Starting creation of a new work item in Project: $Project, Organization: $Organization"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            # Build the API URI
            $apiUri = "$Project/_apis/wit/workitems/$Type"

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
                                             -Method "POST" `
                                             -Headers @{"Content-Type" = "application/json-patch+json"} `
                                             -Body $Body `
                                             -ApiVersion $ApiVersion

            # Log the successful response
            Write-PSFMessage -Level Verbose -Message "Successfully created work item in Project: $Project, Organization: $Organization"
            return $response.Results | Select-PSFObject * -TypeName "ADO.TOOLS.WorkItem"
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to create work item: $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed creation of work item in Project: $Project, Organization: $Organization"
        Invoke-TimeSignal -End
    }
}