
<#
    .SYNOPSIS
        Gets information on a specific field.
        
    .DESCRIPTION
        This function uses the `Invoke-ADOApiRequest` function to call the Azure DevOps REST API and retrieve metadata for a specific field in the specified organization and project.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Token
        The authentication token for accessing Azure DevOps.
        
    .PARAMETER FieldNameOrRefName
        The simple name or reference name of the field to retrieve.
        
    .PARAMETER Project
        The ID or name of the project. This parameter is optional.
        
    .PARAMETER ApiVersion
        The version of the Azure DevOps REST API to use. Default is "7.2-preview.3".
        
    .EXAMPLE
        Get-ADOWitField -Organization "fabrikam" -Token "my-token" -FieldNameOrRefName "System.IterationPath"
        
        Retrieves metadata for the specified field in the organization.
        
    .EXAMPLE
        Get-ADOWitField -Organization "fabrikam" -Token "my-token" -FieldNameOrRefName "System.IterationPath" -Project "MyProject"
        
        Retrieves metadata for the specified field in the specified project.
        
    .NOTES
        This function follows PSFramework best practices for logging and error handling.
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Get-ADOWitField {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter(Mandatory = $true)]
        [string]$FieldNameOrRefName,

        [Parameter()]
        [string]$Project = $null,

        [Parameter()]
        [string]$ApiVersion = $Script:ADOApiVersion
    )

    begin {
        Invoke-TimeSignal -Start
        # Log the start of the operation
        Write-PSFMessage -Level Verbose -Message "Starting retrieval of field '$FieldNameOrRefName' for Organization: $Organization"
        if ($Project) {
            Write-PSFMessage -Level Verbose -Message "Project: $Project"
        }
    }

process {
        if (Test-PSFFunctionInterrupt) { return }      
        try {
            # Build the API URI
            $apiUri = if ($Project) {
                "$Project/_apis/wit/fields/$FieldNameOrRefName"
            } else {
                "_apis/wit/fields/$FieldNameOrRefName"
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
            Write-PSFMessage -Level Verbose -Message "Successfully retrieved field '$FieldNameOrRefName' for Organization: $Organization"
            return $response.Results | Select-PSFObject * -TypeName "ADO.CORE.WorkItemField2"
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to retrieve field: $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed retrieval of field '$FieldNameOrRefName' for Organization: $Organization"
        Invoke-TimeSignal -End
    }
}