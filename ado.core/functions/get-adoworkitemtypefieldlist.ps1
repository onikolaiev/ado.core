
<#
    .SYNOPSIS
        Retrieves a list of all fields in a work item type.
        
    .DESCRIPTION
        This function uses the `Invoke-ADOApiRequest` function to call the Azure DevOps REST API and retrieve all fields in a specified work item type.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Token
        The authentication token for accessing Azure DevOps.
        
    .PARAMETER ProcessId
        The ID of the process where the work item type exists.
        
    .PARAMETER WitRefName
        The reference name of the work item type.
        
    .PARAMETER ApiVersion
        The version of the Azure DevOps REST API to use. Default is "7.1".
        
    .EXAMPLE
        Get-ADOWorkItemTypeFieldList -Organization "fabrikam" -Token "my-token" -ProcessId "c5ef8a1b-4f0d-48ce-96c4-20e62993c218" -WitRefName "MyNewAgileProcess.ChangeRequest"
        
        Retrieves all fields in the specified work item type.
        
    .NOTES
        This function follows PSFramework best practices for logging and error handling.
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Get-ADOWorkItemTypeFieldList {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter(Mandatory = $true)]
        [string]$ProcessId,

        [Parameter(Mandatory = $true)]
        [string]$WitRefName,

        [Parameter()]
        [string]$ApiVersion = $Script:ADOApiVersion
    )

    begin {
        Invoke-TimeSignal -Start
        # Log the start of the operation
        Write-PSFMessage -Level Verbose -Message "Starting retrieval of fields for work item type '$WitRefName' in ProcessId: $ProcessId for Organization: $Organization"
    }

process {
        if (Test-PSFFunctionInterrupt) { return }      
        try {
            # Build the API URI
            $apiUri = "_apis/work/processes/$ProcessId/workItemTypes/$WitRefName/fields"

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
            Write-PSFMessage -Level Verbose -Message "Successfully retrieved fields for work item type '$WitRefName' in ProcessId: $ProcessId"
            return $response.Results | Select-PSFObject * -TypeName "ADO.CORE.WorkItemTypeFieldObject"
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to retrieve fields: $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed retrieval of fields for work item type '$WitRefName' in ProcessId: $ProcessId"
        Invoke-TimeSignal -End
    }
}