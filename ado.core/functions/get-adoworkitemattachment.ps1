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
        if ($AsString -and $OutFile) { throw "-AsString and -OutFile cannot be combined." }
        if ($AsString -and $AsBytes) { throw "-AsString and -AsBytes cannot be combined." }
        if ($AsBytes -and $OutFile)  { throw "-AsBytes and -OutFile cannot be combined (bytes implied when not saving)." }
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            # -------- Build URL (direct REST call to avoid encoding issues) --------
            $rel = if ($Project) { "$Project/_apis/wit/attachments/$Id" } else { "_apis/wit/attachments/$Id" }
            $q = @{}
            if ($FileName) { $q['fileName'] = [System.Uri]::EscapeDataString($FileName) }
            if ($Download) { $q['download'] = 'true' }
            $q['api-version'] = $ApiVersion
            $pairs = foreach ($kv in $q.GetEnumerator()) { "{0}={1}" -f $kv.Key,$kv.Value }
            $url = "https://dev.azure.com/$Organization/$rel" + '?' + ($pairs -join '&')
            Write-PSFMessage -Level Verbose -Message "Downloading from $url"

            # -------- Auth header (Basic with PAT) --------
            $auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$Token"))
            $headers = @{ Authorization = "Basic $auth" }

            if ($OutFile) {
                $dir = Split-Path -Path $OutFile -Parent
                if ($dir -and -not (Test-Path $dir)) {
                    New-Item -ItemType Directory -Path $dir -Force | Out-Null
                }
                $resp = Invoke-WebRequest -Uri $url -Headers $headers -Method Get -OutFile $OutFile -UseBasicParsing -ErrorAction Stop
                # Validate file not HTML error
                $firstBytes = [System.IO.File]::ReadAllBytes($OutFile)[0..([Math]::Min(255, ([System.IO.File]::ReadAllBytes($OutFile).Length - 1)))]
                $asTextSample = [System.Text.Encoding]::UTF8.GetString($firstBytes)
                if ($asTextSample -match '<html' -and $asTextSample -match 'Sign In') {
                    Remove-Item -LiteralPath $OutFile -ErrorAction SilentlyContinue
                    throw "Received HTML sign-in page. Check PAT scope/org/project."
                }
                $fi = Get-Item -LiteralPath $OutFile
                Write-PSFMessage -Level Verbose -Message "Saved attachment to $OutFile (Size: $($fi.Length) bytes)"
                return $fi
            }
            else {
                $resp = Invoke-WebRequest -Uri $url -Headers $headers -Method Get -UseBasicParsing -ErrorAction Stop
                # RawContentStream -> MemoryStream -> bytes
                $rawStream = $resp.RawContentStream
                $ms = New-Object System.IO.MemoryStream
                $rawStream.Position = 0
                $rawStream.CopyTo($ms)
                $bytes = $ms.ToArray()
                $ms.Dispose()

                if ($bytes.Length -eq 0) { throw "Downloaded content is empty." }

                # Detect HTML (auth failure)
                $sample = [System.Text.Encoding]::UTF8.GetString($bytes,0,[Math]::Min(300,$bytes.Length))
                if ($sample -match '<html' -and $sample -match 'Sign In') {
                    throw "Received HTML sign-in page. Authentication failed (invalid PAT or missing scope)."
                }

                if ($AsString) {
                    $text = [System.Text.Encoding]::UTF8.GetString($bytes)
                    Write-PSFMessage -Level Verbose -Message "Returning attachment as string (Length: $($text.Length))"
                    return $text
                }
                # default / -AsBytes
                Write-PSFMessage -Level Verbose -Message "Returning attachment as byte[] (Length: $($bytes.Length))"
                return $bytes
            }
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to download attachment $Id : $($_.Exception.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed download of attachment $Id"
        Invoke-TimeSignal -End
    }
}