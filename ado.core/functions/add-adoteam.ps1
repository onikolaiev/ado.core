
<#
    .SYNOPSIS
        Creates a new team in an Azure DevOps project.
        
    .DESCRIPTION
        This function uses the `Invoke-ADOApiRequest` function to call the Azure DevOps Core REST API (7.2-preview.3) and create a new team within a specified project. Requires vso.project_manage scope for the Personal Access Token.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER ProjectId
        The name or ID (GUID) of the team project in which to create the team.
        
    .PARAMETER Name
        The name of the new team.
        
    .PARAMETER Description
        Optional description for the team.
        
    .PARAMETER Token
        The authentication token for accessing Azure DevOps.
        
    .PARAMETER ApiVersion
        The version of the Azure DevOps REST API to use. Default is "7.2-preview.3".
        
    .EXAMPLE
        Add-ADOTeam -Organization "fabrikam" -ProjectId "WebApp" -Name "Quality Assurance" -Token $token
        
        Creates a new team named "Quality Assurance" in the "WebApp" project.
        
    .EXAMPLE
        Add-ADOTeam -Organization "fabrikam" -ProjectId "8e5a3cfb-fed3-46f3-8657-e3b175cd0305" -Name "My New Team" -Description "Development team for new features" -Token $token
        
        Creates a team with both name and description in the specified project.
        
    .NOTES
        This function follows PSFramework best practices for logging and error handling.
        
        Possible failure scenarios:
            - Invalid project name/ID (project doesn't exist): 404
            - Invalid team name or description: 400
            - Team already exists: 400
            - Insufficient privileges: 400
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Add-ADOTeam {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType([System.Object])]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$ProjectId,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter()]
        [string]$Description,

        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter()]
        [string]$ApiVersion = "7.2-preview.3"
    )

    begin {
        Invoke-TimeSignal -Start
        # Log the start of the operation
        Write-PSFMessage -Level Verbose -Message "Starting creation of team '$Name' in project '$ProjectId' for Organization: $Organization"
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }      
        try {
            # Build the API URI
            $apiUri = "_apis/projects/$ProjectId/teams"

            # Build request body
            $body = @{
                name = $Name
            }
            
            if ($PSBoundParameters.ContainsKey('Description')) {
                $body.description = $Description
            }
            
            $jsonBody = $body | ConvertTo-Json -Depth 10

            # Log the request details
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"
            Write-PSFMessage -Level Verbose -Message "Request Body: $jsonBody"

            # Call the Invoke-ADOApiRequest function
            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method "POST" `
                                             -Body $jsonBody `
                                             -Headers @{"Content-Type" = "application/json"} `
                                             -ApiVersion $ApiVersion

            # Log the successful response
            Write-PSFMessage -Level Verbose -Message "Successfully created team '$Name' in project '$ProjectId' for Organization: $Organization"
            return $response.Results | Select-PSFObject * -TypeName "ADO.CORE.TeamObject"
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to create team '$Name' in project '$ProjectId': $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed creation of team '$Name' in project '$ProjectId' for Organization: $Organization"
        Invoke-TimeSignal -End
    }
}