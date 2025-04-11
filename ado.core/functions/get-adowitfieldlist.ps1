
<#
    .SYNOPSIS
        Retrieves information for all fields.
        
    .DESCRIPTION
        This function uses the `Invoke-ADOApiRequest` function to call the Azure DevOps REST API and retrieve metadata for all fields in the specified organization and project.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Token
        The authentication token for accessing Azure DevOps.
        
    .PARAMETER Project
        The ID or name of the project. This parameter is optional.
        
    .PARAMETER Expand
        Optional parameter to expand specific properties of the fields (e.g., extensionFields, includeDeleted, none).
        
    .PARAMETER ApiVersion
        The version of the Azure DevOps REST API to use. Default is "7.2-preview.3".
        
    .EXAMPLE
        Get-ADOWitFieldList  -Organization "fabrikam" -Token "my-token"
        
        Retrieves metadata for all fields in the specified organization.
        
    .EXAMPLE
        Get-ADOWitFieldList  -Organization "fabrikam" -Token "my-token" -Project "MyProject" -Expand "extensionFields"
        
        Retrieves metadata for all fields in the specified project with extension fields expanded.
        
    .NOTES
        This function follows PSFramework best practices for logging and error handling.
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Get-ADOWitFieldList {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter()]
        [string]$Project = $null,

        [Parameter()]
        [ValidateSet("extensionFields", "includeDeleted", "none")]
        [string]$Expand = $null,

        [Parameter()]
        [string]$ApiVersion = $Script:ADOApiVersion
    )

    begin {
        Invoke-TimeSignal -Start
        # Log the start of the operation
        Write-PSFMessage -Level Verbose -Message "Starting retrieval of fields for Organization: $Organization"
        if ($Project) {
            Write-PSFMessage -Level Verbose -Message "Project: $Project"
        }
    }

process {
        if (Test-PSFFunctionInterrupt) { return }      
        try {
            # Build the API URI with optional parameters
            $apiUri = if ($Project) {
                "$Project/_apis/wit/fields?"
            } else {
                "_apis/wit/fields?"
            }

            if ($Expand) {
                $apiUri += "`$expand=$Expand&"
            }

            # Remove trailing '&' or '?' if present
            $apiUri = $apiUri.TrimEnd('&', '?')

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
            Write-PSFMessage -Level Verbose -Message "Successfully retrieved fields for Organization: $Organization"
            return $response.Results | Select-PSFObject * -TypeName "ADO.CORE.WorkItemField2"
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to retrieve fields: $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed retrieval of fields for Organization: $Organization"
        Invoke-TimeSignal -End
    }
}