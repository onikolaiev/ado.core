
<#
    .SYNOPSIS
        Deletes a work item in Azure DevOps.
        
    .DESCRIPTION
        This function deletes a specified work item in Azure DevOps and sends it to the Recycle Bin.
        Optionally, the work item can be permanently destroyed if the `Destroy` parameter is set to `$true`.
        **WARNING**: If `Destroy` is set to `$true`, the deletion is permanent and cannot be undone.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Project
        (Optional) The name or ID of the Azure DevOps project.
        
    .PARAMETER Token
        The personal access token (PAT) used for authentication.
        
    .PARAMETER Id
        The ID of the work item to delete.
        
    .PARAMETER Destroy
        (Optional) Indicates if the work item should be permanently destroyed. Default is `$false`.
        
    .PARAMETER ApiVersion
        (Optional) The API version to use. Default is `$Script:ADOApiVersion`.
        
    .EXAMPLE
        # Example 1: Delete a work item and send it to the Recycle Bin
        Remove-ADOWorkItem -Organization "my-org" -Project "my-project" -Token "my-token" -Id 12345
        
    .EXAMPLE
        # Example 2: Permanently delete a work item
        Remove-ADOWorkItem -Organization "my-org" -Project "my-project" -Token "my-token" -Id 12345 -Destroy $true
        
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
        This function is part of the ADO Tools module and adheres to the conventions used in the module for logging, error handling, and API interaction.
#>

function Remove-ADOWorkItem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $false)]
        [string]$Project,

        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter(Mandatory = $true)]
        [int]$Id,

        [Parameter(Mandatory = $false)]
        [switch]$Destroy,

        [Parameter(Mandatory = $false)]
        [string]$ApiVersion = $Script:ADOApiVersion
    )

    begin {
        # Log the start of the operation
        Write-PSFMessage -Level Verbose -Message "Starting deletion of work item ID: $Id in Organization: $Organization"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            # Build the API URI
            $apiUri = "_apis/wit/workitems/$Id"
            if ($Project) { $apiUri = "$Project/$apiUri" }

            # Append query parameters
            if ($Destroy) {
                $apiUri += "?destroy=$Destroy"
            }

            # Log the request details
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"

            # Call the Invoke-ADOApiRequest function
            $null = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method "DELETE" `
                                             -ApiVersion $ApiVersion

            # Log the successful response
            Write-PSFMessage -Level Verbose -Message "Successfully deleted work item ID: $Id in Organization: $Organization"
            return
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to delete work item ID: $Id : $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed deletion of work item ID: $Id in Organization: $Organization"
        Invoke-TimeSignal -End
    }
}