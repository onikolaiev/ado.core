
<#
    .SYNOPSIS
        Retrieves a list of work items by their IDs.
        
    .DESCRIPTION
        This function uses the `Invoke-ADOApiRequest` function to call the Azure DevOps REST API and retrieve a list of work items based on their IDs.
        Additional parameters allow filtering by fields, expanding attributes, and specifying error handling policies.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Token
        The authentication token for accessing Azure DevOps.
        
    .PARAMETER Project
        The ID or name of the project. This parameter is optional.
        
    .PARAMETER Ids
        A comma-separated list of work item IDs to retrieve (maximum 200 IDs).
        
    .PARAMETER Fields
        A comma-separated list of requested fields. This parameter is optional.
        
    .PARAMETER Expand
        Optional parameter to expand specific attributes of the work items (e.g., None, Relations, Fields, Links, All).
        
    .PARAMETER AsOf
        Optional parameter to specify the UTC date-time string for retrieving work items as of a specific time.
        
    .PARAMETER ErrorPolicy
        Optional parameter to specify the error policy (e.g., Fail, Omit).
        
    .PARAMETER ApiVersion
        (Optional) The API version to use. Default is `7.1`.
        
    .EXAMPLE
        Get-ADOWorkItemsList -Organization "fabrikam" -Token "my-token" -Ids "297,299,300"
        
        Retrieves the specified work items by their IDs.
        
    .EXAMPLE
        Get-ADOWorkItemsList -Organization "fabrikam" -Token "my-token" -Ids "297,299,300" -Fields "System.Id,System.Title,System.WorkItemType" -Expand "Fields"
        
        Retrieves the specified work items with specific fields expanded.
        
    .NOTES
        This function follows PSFramework best practices for logging and error handling.
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Get-ADOWorkItemsList {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter()]
        [string]$Project = $null,

        [Parameter(Mandatory = $true)]
        [string]$Ids,

        [Parameter()]
        [string]$Fields = $null,

        [Parameter()]
        [ValidateSet("None", "Relations", "Fields", "Links", "All")]
        [string]$Expand = $null,

        [Parameter()]
        [string]$AsOf = $null,

        [Parameter()]
        [ValidateSet("Fail", "Omit")]
        [string]$ErrorPolicy = $null,

        [Parameter()]
        [string]$ApiVersion = $Script:ADOApiVersion
    )

    begin {
        Invoke-TimeSignal -Start
        # Log the start of the operation
        Write-PSFMessage -Level Verbose -Message "Starting retrieval of work items for Organization: $Organization"
        if ($Project) {
            Write-PSFMessage -Level Verbose -Message "Project: $Project"
        }
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }      
        try {
            # Build the API URI with optional parameters
            $apiUri = if ($Project) {
                "$Project/_apis/wit/workitems?ids=$Ids"
            } else {
                "_apis/wit/workitems?ids=$Ids"
            }

            if ($Fields) {
                $apiUri += "&fields=$Fields"
            }
            if ($Expand) {
                $apiUri += "&`$expand=$Expand"
            }
            if ($AsOf) {
                $apiUri += "&asOf=$AsOf"
            }
            if ($ErrorPolicy) {
                $apiUri += "&errorPolicy=$ErrorPolicy"
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
            Write-PSFMessage -Level Verbose -Message "Successfully retrieved work items for Organization: $Organization"
            return $response.Results | Select-PSFObject * -TypeName "ADO.TOOLS.WorkItem"
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to retrieve work items: $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed retrieval of work items for Organization: $Organization"
        Invoke-TimeSignal -End
    }
}