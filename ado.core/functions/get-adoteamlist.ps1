<#
    .SYNOPSIS
        Gets a list of all teams in an Azure DevOps organization.
        
    .DESCRIPTION
        This function uses the `Invoke-ADOApiRequest` function to call the Azure DevOps Core REST API (7.2-preview.3) and retrieve all teams in the specified organization. Supports optional filtering and paging parameters.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Token
        The authentication token for accessing Azure DevOps.
        
    .PARAMETER Mine
        If set, returns only teams the requesting user is a member of.
        
    .PARAMETER Top
        Maximum number of teams to return.
        
    .PARAMETER Skip
        Number of teams to skip.
        
    .PARAMETER ExpandIdentity
        If set, expands identity information in the result.
        
    .PARAMETER ApiVersion
        The version of the Azure DevOps REST API to use. Default is "7.2-preview.3".
        
    .EXAMPLE
        Get-ADOTeamList -Organization "fabrikam" -Token $token
        
        Gets all teams in the 'fabrikam' organization.
        
    .EXAMPLE
        Get-ADOTeamList -Organization "fabrikam" -Token $token -Mine -Top 10
        
        Gets up to 10 teams the current user is a member of in the 'fabrikam' organization.
        
    .NOTES
        This function follows PSFramework best practices for logging and error handling.
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Get-ADOTeamList {
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter()]
        [switch]$Mine,

        [Parameter()]
        [int]$Top,

        [Parameter()]
        [int]$Skip,

        [Parameter()]
        [switch]$ExpandIdentity,

        [Parameter()]
        [string]$ApiVersion = "7.2-preview.3"
    )

    begin {
        Invoke-TimeSignal -Start
        # Log the start of the operation
        Write-PSFMessage -Level Verbose -Message "Starting retrieval of all teams for Organization: $Organization"
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }      
        try {
            # Build the API URI
            $apiUri = "_apis/teams"
            
            # Build query parameters
            $queryParams = @{}
            if ($Mine) { $queryParams['$mine'] = 'true' }
            if ($PSBoundParameters.ContainsKey('Top')) { $queryParams['$top'] = $Top }
            if ($PSBoundParameters.ContainsKey('Skip')) { $queryParams['$skip'] = $Skip }
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
            Write-PSFMessage -Level Verbose -Message "Successfully retrieved teams for Organization: $Organization"
            return $response.Results | Select-PSFObject * -TypeName "ADO.CORE.TeamObject"
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to get teams: $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed retrieval of teams for Organization: $Organization"
        Invoke-TimeSignal -End
    }
}
