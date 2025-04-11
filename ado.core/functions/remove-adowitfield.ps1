
<#
    .SYNOPSIS
        Deletes a field.
        
    .DESCRIPTION
        This function uses the `Invoke-ADOApiRequest` function to call the Azure DevOps REST API and delete a specific field in the specified organization and project.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Token
        The authentication token for accessing Azure DevOps.
        
    .PARAMETER FieldNameOrRefName
        The simple name or reference name of the field to delete.
        
    .PARAMETER Project
        The ID or name of the project. This parameter is optional.
        
    .PARAMETER ApiVersion
        The version of the Azure DevOps REST API to use. Default is "7.2-preview.3".
        
    .EXAMPLE
        Remove-ADOWitField -Organization "fabrikam" -Token "my-token" -FieldNameOrRefName "System.IterationPath"
        
        Deletes the specified field in the organization.
        
    .EXAMPLE
        Remove-ADOWitField -Organization "fabrikam" -Token "my-token" -FieldNameOrRefName "System.IterationPath" -Project "MyProject"
        
        Deletes the specified field in the specified project.
        
    .NOTES
        This function follows PSFramework best practices for logging and error handling.
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Remove-ADOWitField {
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
        Write-PSFMessage -Level Verbose -Message "Starting deletion of field '$FieldNameOrRefName' for Organization: $Organization"
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
            $null = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method "DELETE" `
                                             -Headers @{"Content-Type" = "application/json"} `
                                             -ApiVersion $ApiVersion

            # Log the successful response
            Write-PSFMessage -Level Verbose -Message "Successfully deleted field '$FieldNameOrRefName' for Organization: $Organization"
            return
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to delete field: $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed deletion of field '$FieldNameOrRefName' for Organization: $Organization"
        Invoke-TimeSignal -End
    }
}