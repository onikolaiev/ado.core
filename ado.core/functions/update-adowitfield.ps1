
<#
    .SYNOPSIS
        Updates a field in Azure DevOps.
        
    .DESCRIPTION
        This function updates a specified field in Azure DevOps. It supports optional parameters to lock or unlock the field and to restore or delete the field.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Project
        (Optional) The name or ID of the Azure DevOps project.
        
    .PARAMETER Token
        The personal access token (PAT) used for authentication.
        
    .PARAMETER FieldNameOrRefName
        The name or reference name of the field to update.
        
    .PARAMETER IsLocked
        (Optional) Indicates whether the field should be locked for editing.
        
    .PARAMETER IsDeleted
        (Optional) Indicates whether the field should be restored or deleted.
        
    .PARAMETER ApiVersion
        (Optional) The API version to use. Default is `7.1`.
        
    .EXAMPLE
        # Example 1: Lock a field
        
        Update-ADOWitField -Organization "my-org" -Token "my-token" -FieldNameOrRefName "Custom.TestField" -IsLocked $true
        
    .EXAMPLE
        # Example 2: Restore a deleted field
        
        Update-ADOWitField -Organization "my-org" -Token "my-token" -FieldNameOrRefName "Custom.TestField" -IsDeleted $false
        
    .NOTES
        This function is part of the ADO Tools module and adheres to the conventions used in the module for logging, error handling, and API interaction.
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>

function Update-ADOWitField {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $false)]
        [string]$Project,

        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter(Mandatory = $true)]
        [string]$FieldNameOrRefName,

        [Parameter(Mandatory = $false)]
        [switch]$IsLocked,

        [Parameter(Mandatory = $false)]
        [switch]$IsDeleted,

        [Parameter(Mandatory = $false)]
        [string]$ApiVersion = $Script:ADOApiVersion
    )

    begin {
        # Log the start of the operation
        Write-PSFMessage -Level Verbose -Message "Starting update of field: $FieldNameOrRefName in Organization: $Organization"
        Invoke-TimeSignal -Start
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            # Build the API URI
            $apiUri = "_apis/wit/fields/$FieldNameOrRefName"
            if ($Project) { $apiUri = "$Project/$apiUri" }

            # Build the request body
            $body = @{}
            if ($IsLocked.IsPresent) { $body.isLocked = $IsLocked }
            if ($IsDeleted.IsPresent) { $body.isDeleted = $IsDeleted }
            $body = $body | ConvertTo-Json -Depth 10

            # Log the request details
            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"
            Write-PSFMessage -Level Verbose -Message "Request Body: $body"

            # Call the Invoke-ADOApiRequest function
            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method "PATCH" `
                                             -Headers @{"Content-Type" = "application/json"} `
                                             -Body $body `
                                             -ApiVersion $ApiVersion

            # Log the successful response
            Write-PSFMessage -Level Verbose -Message "Successfully updated field: $FieldNameOrRefName in Organization: $Organization"
            return $response | Select-PSFObject * -TypeName "ADO.TOOLS.WorkItemField2"
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to update field: $FieldNameOrRefName : $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed update of field: $FieldNameOrRefName in Organization: $Organization"
        Invoke-TimeSignal -End
    }
}