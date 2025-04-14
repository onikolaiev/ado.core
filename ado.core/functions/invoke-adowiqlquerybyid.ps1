
<#
    .SYNOPSIS
        Executes a WIQL query in Azure DevOps using a query ID and retrieves the results.
        
    .DESCRIPTION
        This function allows you to execute a WIQL query in Azure DevOps by providing the query ID.
        It supports optional parameters to limit the number of results, enable time precision, and specify a team context.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Project
        (Optional) The name or ID of the Azure DevOps project.
        
    .PARAMETER Team
        (Optional) The name or ID of the Azure DevOps team.
        
    .PARAMETER Token
        The personal access token (PAT) used for authentication.
        
    .PARAMETER QueryId
        The ID of the WIQL query to execute.
        
    .PARAMETER TimePrecision
        (Optional) Whether or not to use time precision. Default is `$false`.
        
    .PARAMETER Top
        (Optional) The maximum number of results to return.
        
    .PARAMETER ApiVersion
        (Optional) The API version to use. Default is `7.1`.
        
    .EXAMPLE
        # Example 1: Execute a WIQL query by ID
        
        Invoke-ADOWiqlQueryById -Organization "my-org" -Project "my-project" -Token "my-token" -QueryId "12345678-1234-1234-1234-123456789abc"
        
    .EXAMPLE
        # Example 2: Execute a WIQL query by ID with time precision and limit results to 10
        
        Invoke-ADOWiqlQueryById -Organization "my-org" -Project "my-project" -Token "my-token" -QueryId "12345678-1234-1234-1234-123456789abc" -TimePrecision $true -Top 10
        
    .NOTES
        This function is part of the ADO Tools module and adheres to the conventions used in the module for logging, error handling, and API interaction.
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>

function Invoke-ADOWiqlQueryById {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $false)]
        [string]$Project,

        [Parameter(Mandatory = $false)]
        [string]$Team,

        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter(Mandatory = $true)]
        [string]$QueryId,

        [Parameter(Mandatory = $false)]
        [switch]$TimePrecision,

        [Parameter(Mandatory = $false)]
        [int]$Top,

        [Parameter(Mandatory = $false)]
        [string]$ApiVersion = $Script:ADOApiVersion
    )

    begin {
        # Log the start of the operation
        Write-PSFMessage -Level Verbose -Message "Starting WIQL query execution by ID in Organization: $Organization, Project: $Project"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            # Build the API URI with optional parameters
            $apiUri = "_apis/wit/wiql/$QueryId"
            if ($Project) { $apiUri = "$Project/$apiUri" }
            if ($Team) { $apiUri = "$Team/$apiUri" }

            # Append query parameters directly to the URI
            $queryParams = @()
            if ($TimePrecision) { $queryParams += "timePrecision=$TimePrecision" }
            if ($Top) { $queryParams += "`$top=$Top" }
            if ($queryParams.Count -gt 0) {
                $apiUri += "?" + ($queryParams -join "&")
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
            Write-PSFMessage -Level Verbose -Message "Successfully executed WIQL query by ID in Organization: $Organization, Project: $Project"
            return $response.Results | Select-PSFObject * -TypeName "ADO.TOOLS.WorkItemQueryResult"
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to execute WIQL query by ID: $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed WIQL query execution by ID in Organization: $Organization, Project: $Project"
        Invoke-TimeSignal -End
    }
}