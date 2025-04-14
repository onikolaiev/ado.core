
<#
    .SYNOPSIS
        Retrieves a single work item from Azure DevOps.
        
    .DESCRIPTION
        This function retrieves a single work item from Azure DevOps using its ID.
        It supports optional parameters to specify fields, expand attributes, and retrieve the work item as of a specific date.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Project
        (Optional) The name or ID of the Azure DevOps project.
        
    .PARAMETER Token
        The personal access token (PAT) used for authentication.
        
    .PARAMETER Id
        The ID of the work item to retrieve.
        
    .PARAMETER Fields
        (Optional) A comma-separated list of fields to include in the response.
        
    .PARAMETER Expand
        (Optional) Specifies the expand parameters for work item attributes. Possible values are `None`, `Relations`, `Fields`, `Links`, or `All`.
        
    .PARAMETER AsOf
        (Optional) The UTC date-time string to retrieve the work item as of a specific date.
        
    .PARAMETER ApiVersion
        (Optional) The API version to use. Default is `7.1`.
        
    .EXAMPLE
        # Example 1: Retrieve a work item by ID
        Get-ADOWorkItem -Organization "my-org" -Token "my-token" -Id 12345
        
    .EXAMPLE
        # Example 2: Retrieve a work item with specific fields and expand attributes
        Get-ADOWorkItem -Organization "my-org" -Token "my-token" -Id 12345 -Fields "System.Title,System.State" -Expand "Relations"
        
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
        This function is part of the ADO Tools module and adheres to the conventions used in the module for logging, error handling, and API interaction.
#>

function Get-ADOWorkItem {
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

        [Parameter(Mandatory = $false)]
        [string]$Fields,

        [Parameter(Mandatory = $false)]
        [ValidateSet("None", "Relations", "Fields", "Links", "All")]
        [string]$Expand = "None",

        [Parameter(Mandatory = $false)]
        [datetime]$AsOf,

        [Parameter(Mandatory = $false)]
        [string]$ApiVersion = $Script:ADOApiVersion
    )

    begin {
        # Log the start of the operation
        Write-PSFMessage -Level Verbose -Message "Starting retrieval of work item ID: $Id in Organization: $Organization"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            # Build the API URI
            $apiUri = "_apis/wit/workitems/$Id"
            if ($Project) { $apiUri = "$Project/$apiUri" }

            # Append query parameters
            if ($Fields) {
                $apiUri += "?fields=$Fields"
            }
            if ($Expand -ne "None") {
                $apiUri += if ($apiUri.Contains("?")) { "&`$expand=$Expand" } else { "?`$expand=$Expand" }
            }
            if ($AsOf) {
                $asOfString = $AsOf.ToString("yyyy-MM-ddTHH:mm:ssZ")
                $apiUri += if ($apiUri.Contains("?")) { "&asOf=$asOfString" } else { "?asOf=$asOfString" }
            }

            # Log the request details
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"

            # Call the Invoke-ADOApiRequest function
            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method "GET" `
                                             -Headers @{"Content-Type" = "application/json"} `
                                             -ApiVersion $ApiVersion

            # Log the successful response
            Write-PSFMessage -Level Verbose -Message "Successfully retrieved work item ID: $Id in Organization: $Organization"
            return $response.Results | Select-PSFObject * -TypeName "ADO.TOOLS.WorkItem"
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to retrieve work item ID: $Id : $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed retrieval of work item ID: $Id in Organization: $Organization"
        Invoke-TimeSignal -End
    }
}