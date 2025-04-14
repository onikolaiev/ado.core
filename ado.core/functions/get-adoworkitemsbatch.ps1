
<#
    .SYNOPSIS
        Retrieves a batch of work items from Azure DevOps by their IDs.
        
    .DESCRIPTION
        This function retrieves a batch of work items from Azure DevOps using their IDs.
        It supports optional parameters to specify fields, expand attributes, control error policy, and retrieve work items as of a specific date.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Project
        (Optional) The name or ID of the Azure DevOps project.
        
    .PARAMETER Token
        The personal access token (PAT) used for authentication.
        
    .PARAMETER Ids
        The list of work item IDs to retrieve (maximum 200).
        
    .PARAMETER Fields
        (Optional) A list of fields to include in the response.
        
    .PARAMETER Expand
        (Optional) Specifies the expand parameters for work item attributes. Possible values are `None`, `Relations`, `Fields`, `Links`, or `All`.
        
    .PARAMETER AsOf
        (Optional) The UTC date-time string to retrieve the work items as of a specific date.
        
    .PARAMETER ErrorPolicy
        (Optional) The error policy for the request. Possible values are `Fail` or `Omit`.
        
    .PARAMETER ApiVersion
        (Optional) The API version to use. Default is `7.1`.
        
    .EXAMPLE
        # Example 1: Retrieve a batch of work items by IDs
        
        Get-ADOWorkItemsBatch -Organization "my-org" -Token "my-token" -Ids @(297, 299, 300)
        
    .EXAMPLE
        # Example 2: Retrieve a batch of work items with specific fields and expand attributes
        
        Get-ADOWorkItemsBatch -Organization "my-org" -Token "my-token" -Ids @(297, 299, 300) -Fields @("System.Id", "System.Title") -Expand "Relations"
        
    .NOTES
        This function is part of the ADO Tools module and adheres to the conventions used in the module for logging, error handling, and API interaction.
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>

function Get-ADOWorkItemsBatch {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $false)]
        [string]$Project,

        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter(Mandatory = $true)]
        [string[]]$Ids,

        [Parameter(Mandatory = $false)]
        [string[]]$Fields,

        [Parameter(Mandatory = $false)]
        [ValidateSet("None", "Relations", "Fields", "Links", "All")]
        [string]$Expand = "None",

        [Parameter(Mandatory = $false)]
        [datetime]$AsOf,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Fail", "Omit")]
        [string]$ErrorPolicy = "Fail",

        [Parameter(Mandatory = $false)]
        [string]$ApiVersion = $Script:ADOApiVersion
    )

    begin {
        # Log the start of the operation
        Write-PSFMessage -Level Verbose -Message "Starting retrieval of work items batch in Organization: $Organization"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            # Build the API URI
            $apiUri = "_apis/wit/workitemsbatch"
            if ($Project) { $apiUri = "$Project/$apiUri" }

            # Build the request body
            $body = @{
                ids = $Ids
            }
            if ($Fields) { $body.fields = $Fields }
            if ($Expand -ne "None") { $body.'$expand' = $Expand }
            if ($AsOf) { $body.asOf = $AsOf.ToString("yyyy-MM-ddTHH:mm:ssZ") }
            if ($ErrorPolicy) { $body.errorPolicy = $ErrorPolicy }
            $body = $body | ConvertTo-Json -Depth 10

            # Log the request details
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"
            Write-PSFMessage -Level Verbose -Message "Request Body: $body"

            # Call the Invoke-ADOApiRequest function
            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method "POST" `
                                             -Headers @{"Content-Type" = "application/json"} `
                                             -Body $body `
                                             -ApiVersion $ApiVersion

            # Log the successful response
            Write-PSFMessage -Level Verbose -Message "Successfully retrieved work items batch in Organization: $Organization"
            return $response.Results | Select-PSFObject * -TypeName "ADO.TOOLS.WorkItemBatch"
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to retrieve work items batch: $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed retrieval of work items batch in Organization: $Organization"
        Invoke-TimeSignal -End
    }
}