
<#
    .SYNOPSIS
        Updates columns on a specific board in an Azure DevOps team.
        
    .DESCRIPTION
        This function uses the `Invoke-ADOApiRequest` function to call the Azure DevOps Work REST API (7.2-preview.1) and update columns on a specific board in a team project. Requires vso.work_write scope.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Project
        Project ID or project name.
        
    .PARAMETER Board
        Name or ID of the specific board.
        
    .PARAMETER Body
        The JSON string containing the array of board columns to update.
        
    .PARAMETER Team
        Team ID or team name (optional).
        
    .PARAMETER Token
        The authentication token for accessing Azure DevOps.
        
    .PARAMETER ApiVersion
        The version of the Azure DevOps REST API to use. Default is "7.2-preview.1".
        
    .EXAMPLE
        $columns = @"
        [
        {
            "id": "12eed5fb-8af3-47bb-9d2a-058fbe7e1196",
            "name": "New",
            "itemLimit": 0,
            "stateMappings": {
                "Product Backlog Item": "New",
                "Bug": "New"
            },
            "columnType": "incoming"
        },
        {
            "id": "5f72391d-af1c-4754-9459-23138eba13e3",
            "name": "Approved",
            "itemLimit": 10,
            "stateMappings": {
                "Product Backlog Item": "Approved",
                "Bug": "Approved"
            },
            "isSplit": false,
            "description": "Updated description",
            "columnType": "inProgress"
        }
        ]
        "@
        
        Update-ADOBoardColumnList -Organization "fabrikam" -Project "WebApp" -Team "Quality Assurance" -Board "Stories" -Body $columns -Token $token
        
        Updates columns on the "Stories" board for the "Quality Assurance" team.
        
    .NOTES
        This function follows PSFramework best practices for logging and error handling.
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Update-ADOBoardColumnList {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Project,

        [Parameter(Mandatory = $true)]
        [string]$Board,

        [Parameter(Mandatory = $true)]
        [string]$Body,

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
            Write-PSFMessage -Level Verbose -Message "Starting update of columns on board '$Board' for team '$Team' in project '$Project' for Organization: $Organization"
        } else {
            Write-PSFMessage -Level Verbose -Message "Starting update of columns on board '$Board' for project '$Project' for Organization: $Organization"
        }
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }      
        try {
            # Build the API URI
            if ($Team) {
                $apiUri = "$Project/$Team/_apis/work/boards/$Board/columns"
            } else {
                $apiUri = "$Project/_apis/work/boards/$Board/columns"
            }

            # Log the request details
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"
            Write-PSFMessage -Level Verbose -Message "Request Body: $Body"

            # Call the Invoke-ADOApiRequest function
            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method "PUT" `
                                             -Body $Body `
                                             -Headers @{"Content-Type" = "application/json"} `
                                             -ApiVersion $ApiVersion

            # Log the successful response
            if ($Team) {
                Write-PSFMessage -Level Verbose -Message "Successfully updated columns on board '$Board' for team '$Team' in project '$Project' for Organization: $Organization"
            } else {
                Write-PSFMessage -Level Verbose -Message "Successfully updated columns on board '$Board' for project '$Project' for Organization: $Organization"
            }
            return $response.Results | Select-PSFObject * -TypeName "ADO.CORE.BoardColumnObject"
        } catch {
            # Log the error
            if ($Team) {
                Write-PSFMessage -Level Error -Message "Failed to update columns on board '$Board' for team '$Team' in project '$Project': $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            } else {
                Write-PSFMessage -Level Error -Message "Failed to update columns on board '$Board' for project '$Project': $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            }
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        if ($Team) {
            Write-PSFMessage -Level Verbose -Message "Completed update of columns on board '$Board' for team '$Team' in project '$Project' for Organization: $Organization"
        } else {
            Write-PSFMessage -Level Verbose -Message "Completed update of columns on board '$Board' for project '$Project' for Organization: $Organization"
        }
        Invoke-TimeSignal -End
    }
}