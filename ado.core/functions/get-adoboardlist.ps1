
<#
    .SYNOPSIS
        Gets a list of boards from an Azure DevOps team.
        
    .DESCRIPTION
        This function uses the `Invoke-ADOApiRequest` function to call the Azure DevOps Work REST API (7.2-preview.1) and retrieve boards for a specified team in a project.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Project
        Project ID or project name.
        
    .PARAMETER Team
        Team ID or team name (optional).
        
    .PARAMETER Token
        The authentication token for accessing Azure DevOps.
        
    .PARAMETER ApiVersion
        The version of the Azure DevOps REST API to use. Default is "7.2-preview.1".
        
    .EXAMPLE
        Get-ADOBoardList -Organization "fabrikam" -Project "WebApp" -Team "Quality Assurance" -Token $token
        
        Gets all boards for the "Quality Assurance" team in the "WebApp" project.
        
    .EXAMPLE
        Get-ADOBoardList -Organization "fabrikam" -Project "eb6e4656-77fc-42a1-9181-4c6d8e9da5d1" -Token $token
        
        Gets all boards for the default team in the specified project.
        
    .NOTES
        This function follows PSFramework best practices for logging and error handling.
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Get-ADOBoardList {
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Project,

        [Parameter()]
        [string]$Team,

        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter()]
        [string]$ApiVersion = "7.2-preview.1"
    )

    begin {
        Invoke-TimeSignal -Start
        # Log the start of the operation
        if ($Team) {
            Write-PSFMessage -Level Verbose -Message "Starting retrieval of boards for team '$Team' in project '$Project' for Organization: $Organization"
        } else {
            Write-PSFMessage -Level Verbose -Message "Starting retrieval of boards for project '$Project' for Organization: $Organization"
        }
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }      
        try {
            # Build the API URI
            if ($Team) {
                $apiUri = "$Project/$Team/_apis/work/boards"
            } else {
                $apiUri = "$Project/_apis/work/boards"
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
            if ($Team) {
                Write-PSFMessage -Level Verbose -Message "Successfully retrieved boards for team '$Team' in project '$Project' for Organization: $Organization"
            } else {
                Write-PSFMessage -Level Verbose -Message "Successfully retrieved boards for project '$Project' for Organization: $Organization"
            }
            return $response.Results | Select-PSFObject * -TypeName "ADO.CORE.BoardObject"
        } catch {
            # Log the error
            if ($Team) {
                Write-PSFMessage -Level Error -Message "Failed to get boards for team '$Team' in project '$Project': $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            } else {
                Write-PSFMessage -Level Error -Message "Failed to get boards for project '$Project': $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            }
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        if ($Team) {
            Write-PSFMessage -Level Verbose -Message "Completed retrieval of boards for team '$Team' in project '$Project' for Organization: $Organization"
        } else {
            Write-PSFMessage -Level Verbose -Message "Completed retrieval of boards for project '$Project' for Organization: $Organization"
        }
        Invoke-TimeSignal -End
    }
}