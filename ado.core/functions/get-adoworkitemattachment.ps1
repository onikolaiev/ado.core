
<#
    .SYNOPSIS
        Downloads a work item attachment.
    .DESCRIPTION
        Wraps the Work Item Tracking Attachments - Get endpoint. Supports returning bytes (default),
        text (UTF8), or saving directly to a file. Optional query parameters: fileName, download=true.
    .OUTPUTS
        System.IO.FileInfo (when -OutFile)
        System.String      (when -AsString)
        System.Byte[]      (default or -AsBytes)
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        (Optional) Project name or id.
    .PARAMETER Token
        Personal Access Token (PAT) (vso.work scope).
    .PARAMETER Id
        Attachment Id (GUID).
    .PARAMETER FileName
        Desired file name (adds fileName query parameter; does not auto-save unless -OutFile specified).
    .PARAMETER Download
        Force download semantics (adds download=true query parameter).
    .PARAMETER OutFile
        Path to write attachment content. Creates directories if needed. Returns FileInfo.
    .PARAMETER AsString
        Return UTF8 string content (cannot be combined with -OutFile or -AsBytes).
    .PARAMETER AsBytes
        Return raw byte[] (default behavior; explicit for clarity).
    .PARAMETER ApiVersion
        API version (default 7.1).
    .EXAMPLE
        PS> Get-ADOWorkItemAttachment -Organization org -Token $pat -Id 11111111-2222-3333-4444-555555555555 -OutFile .\image.png
        
        Downloads the attachment to image.png.
    .EXAMPLE
        PS> Get-ADOWorkItemAttachment -Organization org -Token $pat -Id $attId -AsString
        
        Returns the attachment content as a UTF8 string.
    .EXAMPLE
        PS> Get-ADOWorkItemAttachment -Organization org -Project proj -Token $pat -Id $attId -FileName report.txt -Download -AsBytes
        
        Returns the attachment as byte[] (default) using specified fileName and download parameters.
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Get-ADOWorkItemAttachment {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
    [CmdletBinding(DefaultParameterSetName='Default')]
    [OutputType([System.IO.FileInfo])]
    [OutputType([string])]
    [OutputType([byte[]])]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Organization,

        [Parameter()]
        [string]$Project,

        [Parameter(Mandatory=$true)]
        [string]$Token,

        [Parameter(Mandatory=$true)]
        [Guid]$Id,

        [Parameter()]
        [string]$FileName,

        [Parameter()]
        [switch]$Download,

        [Parameter()]
        [string]$OutFile,

        [Parameter(ParameterSetName='String')]
        [switch]$AsString,

        [Parameter(ParameterSetName='Bytes')]
        [switch]$AsBytes,

        [Parameter()]
        [string]$ApiVersion = '7.1'
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting download of attachment $Id (Org: $Organization / Project: $Project)"
        Invoke-TimeSignal -Start
        if ($AsString -and $OutFile) { throw "Parameters -AsString and -OutFile cannot be combined." }
        if ($AsString -and $AsBytes) { throw "Parameters -AsString and -AsBytes cannot be combined." }
        if ($AsBytes -and $OutFile)  { throw "Parameters -AsBytes and -OutFile cannot be combined (byte[] is implied without -OutFile)." }
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            $basePath = if ($Project) { "$Project/_apis/wit/attachments/$Id" } else { "_apis/wit/attachments/$Id" }

            $q = @{}
            if ($FileName) { $q['fileName'] = [System.Uri]::EscapeDataString($FileName) }
            if ($Download) { $q['download'] = 'true' }

            $apiUri = $basePath
            if ($q.Count -gt 0) {
                $apiUri += '?' + ($q.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" } -join '&')
            }

            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"

            # Use Invoke-ADOApiRequest expecting raw byte content. If helper returns object, fall back to manual.
            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method 'GET' `
                                             -Headers @{ 'Accept' = 'application/octet-stream' } `
                                             -ApiVersion $ApiVersion

            $data = $null
            if ($response -and $response.Results -is [byte[]]) {
                $data = $response.Results
            }
            elseif ($response -and $response.Results -and ($response.Results.GetType().Name -eq 'String')) {
                # Might already be a string (text attachment)
                $data = [System.Text.Encoding]::UTF8.GetBytes([string]$response.Results)
            }
            elseif ($response -and $response.Results) {
                # Try to coerce unknown object to string then bytes
                $data = [System.Text.Encoding]::UTF8.GetBytes([string]$response.Results)
            }
            else {
                # Fallback: attempt direct download using WebRequest if data missing
                Write-PSFMessage -Level Verbose -Message "Fallback direct download for attachment $Id"
                $baseUrl = "https://dev.azure.com/$Organization/"
                $authToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$Token"))
                $headers = @{ Authorization = "Basic $authToken"; Accept = 'application/octet-stream' }
                $fullUrl = "$baseUrl$apiUri?api-version=$ApiVersion"
                $raw = Invoke-WebRequest -Uri $fullUrl -Headers $headers -Method GET -UseBasicParsing
                $data = $raw.ContentBytes
            }

            if ($OutFile) {
                $dir = Split-Path -Path $OutFile -Parent
                if ($dir -and -not (Test-Path $dir)) {
                    Write-PSFMessage -Level Verbose -Message "Creating directory $dir"
                    New-Item -ItemType Directory -Force -Path $dir | Out-Null
                }
                [System.IO.File]::WriteAllBytes($OutFile, $data)
                $fi = Get-Item -LiteralPath $OutFile
                Write-PSFMessage -Level Verbose -Message "Attachment saved to $OutFile"
                return $fi
            }

            if ($AsString) {
                $text = [System.Text.Encoding]::UTF8.GetString($data)
                Write-PSFMessage -Level Verbose -Message "Returning attachment as string"
                return $text
            }

            # Default: bytes
            Write-PSFMessage -Level Verbose -Message "Returning attachment as byte array (Length=$($data.Length))"
            return $data
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to download attachment $Id : $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed download of attachment $Id"
        Invoke-TimeSignal -End
    }
}