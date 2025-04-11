
<#
    .SYNOPSIS
        Hides a state definition in the work item type of the process.
        
    .DESCRIPTION
        This function uses the `Invoke-ADOApiRequest` function to call the Azure DevOps REST API and hide a state definition in a specified work item type of a process.
        Only states with `customizationType: System` can be hidden.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Token
        The authentication token for accessing Azure DevOps.
        
    .PARAMETER ProcessId
        The ID of the process.
        
    .PARAMETER WitRefName
        The reference name of the work item type.
        
    .PARAMETER StateId
        The ID of the state to hide.
        
    .PARAMETER Hidden
        Boolean value indicating whether the state should be hidden.
        
    .PARAMETER ApiVersion
        The version of the Azure DevOps REST API to use. Default is "7.1".
        
    .EXAMPLE
        $body = @"
        {
        "hidden": "true"
        }
        "@
        
        Hide-ADOWorkItemTypeState -Organization "fabrikam" -Token "my-token" -ProcessId "a6c1d9b6-ea27-407d-8c40-c9b7ab112bb6" -WitRefName "Agile1.Bug" -StateId "f36cfea7-889a-448e-b5d1-fbc9b134ec82" -Hidden $true
        
        Hides the specified state definition in the work item type of the process.
        
    .NOTES
        This function follows PSFramework best practices for logging and error handling.
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Hide-ADOWorkItemTypeState {
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

        [Parameter(Mandatory = $true)]
        [string]$StateId,

        [Parameter(Mandatory = $true)]
        [ValidateSet("true", "false")]
        [string]$Hidden,

        [Parameter()]
        [string]$ApiVersion = $Script:ADOApiVersion
    )

    begin {
        Invoke-TimeSignal -Start
        # Log the start of the operation
        Write-PSFMessage -Level Verbose -Message "Starting to hide state definition '$StateId' for work item type '$WitRefName' in ProcessId: $ProcessId for Organization: $Organization"
    }

process {
        if (Test-PSFFunctionInterrupt) { return }      
        try {
            # Build the API URI
            $apiUri = "_apis/work/processes/$ProcessId/workItemTypes/$WitRefName/states/$StateId"

            # Build the request body
            $body = @{
                hidden = $Hidden
            } | ConvertTo-Json -Depth 10

            # Log the request details
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"
            Write-PSFMessage -Level Verbose -Message "Request Body: $body"

            # Call the Invoke-ADOApiRequest function
            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method "PUT" `
                                             -Body $body `
                                             -Headers @{"Content-Type" = "application/json"} `
                                             -ApiVersion $ApiVersion

            # Log the successful response
            Write-PSFMessage -Level Verbose -Message "Successfully hid state definition '$StateId' for work item type '$WitRefName' in ProcessId: $ProcessId"
            return $response.Results | Select-PSFObject * -TypeName "ADO.CORE.WorkItemTypeStateObject"
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to hide state definition: $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed hiding of state definition '$StateId' for work item type '$WitRefName' in ProcessId: $ProcessId"
        Invoke-TimeSignal -End
    }
}