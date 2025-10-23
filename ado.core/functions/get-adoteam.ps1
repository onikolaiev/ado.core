<#
    .SYNOPSIS
        Gets a specific team from an Azure DevOps project.
        
    .DESCRIPTION
        This function uses the `Invoke-ADOApiRequest` function to call the Azure DevOps Core REST API (7.2-preview.3) and retrieve a specific team by its ID or name from a project.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER ProjectId
        The name or ID (GUID) of the team project containing the team.
        
    .PARAMETER TeamId
        The name or ID (GUID) of the team.
        
    .PARAMETER Token
        The authentication token for accessing Azure DevOps.
        
    .PARAMETER ExpandIdentity
        If set, expands identity information in the result WebApiTeam object.
        
    .PARAMETER ApiVersion
        The version of the Azure DevOps REST API to use. Default is "7.2-preview.3".
        
    .EXAMPLE
        Get-ADOTeam -Organization "fabrikam" -ProjectId "WebApp" -TeamId "Quality assurance" -Token $token
        
        Gets the "Quality assurance" team from the "WebApp" project in the "fabrikam" organization.
        
    .EXAMPLE
        Get-ADOTeam -Organization "fabrikam" -ProjectId "eb6e4656-77fc-42a1-9181-4c6d8e9da5d1" -TeamId "564e8204-a90b-4432-883b-d4363c6125ca" -Token $token -ExpandIdentity
        
        Gets a specific team by GUID with expanded identity information.
        
    .NOTES
        This function follows PSFramework best practices for logging and error handling.
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Get-ADOTeam {
    [CmdletBinding()]
    [OutputType([System.Object])]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$ProjectId,

        [Parameter(Mandatory = $true)]
        [string]$TeamId,

        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter()]
        [switch]$ExpandIdentity,

        [Parameter()]
        [string]$ApiVersion = "7.2-preview.3"
    )

    begin {
        Invoke-TimeSignal -Start
        # Log the start of the operation
        Write-PSFMessage -Level Verbose -Message "Starting retrieval of team '$TeamId' from project '$ProjectId' for Organization: $Organization"
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }      
        try {
            # Build the API URI
            $apiUri = "_apis/projects/$ProjectId/teams/$TeamId"
            
            # Build query parameters
            $queryParams = @{}
            if ($ExpandIdentity) { $queryParams['$expandIdentity'] = 'true' }

            # Log the request details
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"

            # Call the Invoke-ADOApiRequest function
            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method "GET" `
                                             -QueryParameters $queryParams `
                                             -ApiVersion $ApiVersion

            # Log the successful response
            Write-PSFMessage -Level Verbose -Message "Successfully retrieved team '$TeamId' from project '$ProjectId' for Organization: $Organization"
            return $response.Results | Select-PSFObject * -TypeName "ADO.CORE.TeamObject"
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to get team '$TeamId' from project '$ProjectId': $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed retrieval of team '$TeamId' from project '$ProjectId' for Organization: $Organization"
        Invoke-TimeSignal -End
    }
}