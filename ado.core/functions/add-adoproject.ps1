
<#
    .SYNOPSIS
        Queues a project to be created.
        
    .DESCRIPTION
        This function uses the `Invoke-ADOApiRequest` function to call the Azure DevOps REST API and queue a new project creation in the specified organization.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Token
        The authentication token for accessing Azure DevOps.
        
    .PARAMETER Body
        The JSON string containing the properties for the project to create.
        
    .PARAMETER ApiVersion
        The version of the Azure DevOps REST API to use. Default is "7.1".
        
    .EXAMPLE
        $body = @"
        {
        "name": "FabrikamTravel",
        "description": "Fabrikam travel app for Windows Phone",
        "capabilities": {
        "versioncontrol": {
        "sourceControlType": "Git"
        },
        "processTemplate": {
        "templateTypeId": "6b724908-ef14-45cf-84f8-768b5384da45"
        }
        }
        }
        "@
        
        Add-ADOProject -Organization "fabrikam" -Token "my-token" -Body $body
        
        Queues a new project creation in the specified organization.
        
    .NOTES
        This function follows PSFramework best practices for logging and error handling.
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Add-ADOProject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter(Mandatory = $true)]
        [string]$Body,

        [Parameter()]
        [string]$ApiVersion = $Script:ADOApiVersion
    )

    begin {
        Invoke-TimeSignal -Start
        # Log the start of the operation
        Write-PSFMessage -Level Verbose -Message "Starting creation of a new project for Organization: $Organization"
    }

process {
        if (Test-PSFFunctionInterrupt) { return }      
        try {
            # Build the API URI
            $apiUri = "_apis/projects"

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
            Write-PSFMessage -Level Verbose -Message "Successfully queued project creation for Organization: $Organization"
            return $response.Results | Select-PSFObject * -TypeName "ADO.CORE.ProjectObject"
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to queue project creation: $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed queuing of project creation for Organization: $Organization"
        Invoke-TimeSignal -End
    }
}