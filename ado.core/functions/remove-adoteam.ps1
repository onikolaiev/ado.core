<#
    .SYNOPSIS
        Deletes a team from an Azure DevOps project.
        
    .DESCRIPTION
        This function uses the `Invoke-ADOApiRequest` function to call the Azure DevOps Core REST API (7.2-preview.3) and delete a team from a specified project. Requires vso.project_manage scope for the Personal Access Token.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER ProjectId
        The name or ID (GUID) of the team project containing the team to delete.
        
    .PARAMETER TeamId
        The name or ID of the team to delete.
        
    .PARAMETER Token
        The authentication token for accessing Azure DevOps.
        
    .PARAMETER ApiVersion
        The version of the Azure DevOps REST API to use. Default is "7.2-preview.3".
        
    .EXAMPLE
        Remove-ADOTeam -Organization "fabrikam" -ProjectId "WebApp" -TeamId "Quality Assurance" -Token $token
        
        Deletes the "Quality Assurance" team from the "WebApp" project.
        
    .EXAMPLE
        Remove-ADOTeam -Organization "fabrikam" -ProjectId "8e5a3cfb-fed3-46f3-8657-e3b175cd0305" -TeamId "564e8204-a90b-4432-883b-d4363c6125ca" -Token $token
        
        Deletes a specific team by GUID from the specified project.
        
    .NOTES
        This function follows PSFramework best practices for logging and error handling.
        
        Possible failure scenarios:
        - Invalid project name/ID (project doesn't exist): 404
        - Invalid team name/ID (team doesn't exist): 404
        - Insufficient privileges: 403
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Remove-ADOTeam {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
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
        [string]$ApiVersion = "7.2-preview.3"
    )

    begin {
        Invoke-TimeSignal -Start
        # Log the start of the operation
        Write-PSFMessage -Level Verbose -Message "Starting deletion of team '$TeamId' from project '$ProjectId' for Organization: $Organization"
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }      
        try {
            # Build the API URI
            $apiUri = "_apis/projects/$ProjectId/teams/$TeamId"

            # Log the request details
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"

            # Call the Invoke-ADOApiRequest function
            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method "DELETE" `
                                             -Headers @{"Content-Type" = "application/json"} `
                                             -ApiVersion $ApiVersion

            # Log the successful response
            Write-PSFMessage -Level Verbose -Message "Successfully deleted team '$TeamId' from project '$ProjectId' for Organization: $Organization"
            return $response.Results
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to delete team '$TeamId' from project '$ProjectId': $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed deletion of team '$TeamId' from project '$ProjectId' for Organization: $Organization"
        Invoke-TimeSignal -End
    }
}