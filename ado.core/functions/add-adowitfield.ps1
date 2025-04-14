
<#
    .SYNOPSIS
        Creates a new field.
        
    .DESCRIPTION
        This function uses the `Invoke-ADOApiRequest` function to call the Azure DevOps REST API and create a new field in the specified organization and project.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Token
        The authentication token for accessing Azure DevOps.
        
    .PARAMETER Body
        The JSON string containing the properties for the field to create.
        
    .PARAMETER Project
        The ID or name of the project. This parameter is optional.
        
    .PARAMETER ApiVersion
        The version of the Azure DevOps REST API to use. Default is "7.2-preview.3".
        
    .EXAMPLE
        $body = @"
        {
        "name": "New Work Item Field",
        "referenceName": "SupportedOperations.GreaterThanEquals",
        "description": null,
        "type": "string",
        "usage": "workItem",
        "readOnly": false,
        "canSortBy": true,
        "isQueryable": true,
        "supportedOperations": [
        {
        "referenceName": "SupportedOperations.Equals",
        "name": "="
        }
        ],
        "isIdentity": true,
        "isPicklist": false,
        "isPicklistSuggested": false,
        "url": null
        }
        "@
        
        Add-ADOWitField -Organization "fabrikam" -Token "my-token" -Body $body -Project "MyProject"
        
        Creates a new field in the specified project.
        
    .NOTES
        This function follows PSFramework best practices for logging and error handling.
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Add-ADOWitField {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter(Mandatory = $true)]
        [string]$Body,

        [Parameter()]
        [string]$Project = $null,

        [Parameter()]
        [string]$ApiVersion = $Script:ADOApiVersion
    )

    begin {
        Invoke-TimeSignal -Start
        # Log the start of the operation
        Write-PSFMessage -Level Verbose -Message "Starting creation of a new field for Organization: $Organization"
        if ($Project) {
            Write-PSFMessage -Level Verbose -Message "Project: $Project"
        }
    }

process {
        if (Test-PSFFunctionInterrupt) { return }      
        try {
            # Build the API URI
            $apiUri = if ($Project) {
                "$Project/_apis/wit/fields"
            } else {
                "_apis/wit/fields"
            }

            # Log the request details
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"
            Write-PSFMessage -Level Verbose -Message "Request Body: $Body"

            # Call the Invoke-ADOApiRequest function
            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method "POST" `
                                             -Body $Body `
                                             -Headers @{"Content-Type" = "application/json"} `
                                             -ApiVersion $ApiVersion

            # Log the successful response
            Write-PSFMessage -Level Verbose -Message "Successfully created a new field for Organization: $Organization"
            return $response.Results | Select-PSFObject * -TypeName "ADO.CORE.WorkItemField2"
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to create field: $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed creation of a new field for Organization: $Organization"
        Invoke-TimeSignal -End
    }
}