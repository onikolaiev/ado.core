
<#
    .SYNOPSIS
        Uploads (creates) a work item attachment.
    .DESCRIPTION
        Uses the Azure DevOps Work Item Tracking REST API (Attachments - Create) to upload an attachment.
        Supports three content sources (separate parameter sets):
            - File:    Provide a local file path via -FilePath
            - Content: Provide text via -Content (converted to UTF8 bytes)
            - Stream:  Provide an open System.IO.Stream via -Stream
        Also supports initiating a chunked upload session with -UploadType Chunked (no data chunks
        are uploaded in this initial request). For chunked transfers you must later call the chunk
        upload APIs (not implemented here).
        Returns the attachment reference object (id, url) as type ADO.TOOLS.WorkItem.Attachment.
    .OUTPUTS
        ADO.TOOLS.WorkItem.Attachment
    .PARAMETER Organization
        Azure DevOps organization name (e.g. contoso).
    .PARAMETER Project
        (Optional) Project name or id. If omitted, the attachment is uploaded at the account level.
    .PARAMETER Token
        Personal Access Token (PAT) with vso.work_write (or broader) scope.
    .PARAMETER FilePath
        Path to an existing local file to upload (File parameter set).
    .PARAMETER Content
        Plain text content to upload (Content parameter set). Encoded as UTF8.
    .PARAMETER Stream
        Open readable System.IO.Stream to upload (Stream parameter set). Entire stream is buffered.
    .PARAMETER FileName
        Target file name to store in Azure DevOps. Defaults to the leaf name of FilePath, 'content.txt'
        for -Content, or a generated name for -Stream when not specified.
    .PARAMETER UploadType
        simple | chunked. Default simple. chunked only starts a chunked upload session (no payload).
    .PARAMETER AreaPath
        Optional area path (areaPath query parameter) to associate with the upload.
    .PARAMETER ApiVersion
        API version (default 7.1).
    .EXAMPLE
        PS> Add-ADOWorkItemAttachment -Organization contoso -Project WebApp -Token $pat -FilePath .\readme.md
        
        Uploads readme.md using simple upload and returns the attachment reference.
    .EXAMPLE
        PS> Add-ADOWorkItemAttachment -Organization contoso -Project WebApp -Token $pat -Content "Log $(Get-Date -Format o)" -FileName runlog.txt
        
        Uploads generated text as runlog.txt.
    .EXAMPLE
        PS> $fs = [System.IO.File]::OpenRead('diagram.png')
        PS> Add-ADOWorkItemAttachment -Organization contoso -Project WebApp -Token $pat -Stream $fs -FileName diagram.png
        
        Uploads the stream content (diagram.png) then returns the attachment reference.
    .EXAMPLE
        PS> Add-ADOWorkItemAttachment -Organization contoso -Token $pat -FilePath .\large.zip -UploadType Chunked
        
        Initiates a chunked upload session for large.zip (no data chunks uploaded here).
    .LINK
        https://learn.microsoft.com/azure/devops
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Add-ADOWorkItemAttachment {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","")]
    [CmdletBinding(DefaultParameterSetName='File')]
    [OutputType('ADO.TOOLS.WorkItem.Attachment')]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Organization,

        [Parameter(Mandatory=$false)]
        [string]$Project,

        [Parameter(Mandatory=$true)]
        [string]$Token,

        [Parameter(Mandatory=$true, ParameterSetName='File')]
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [string]$FilePath,

        [Parameter(Mandatory=$true, ParameterSetName='Content')]
        [string]$Content,

        [Parameter(Mandatory=$true, ParameterSetName='Stream')]
        [System.IO.Stream]$Stream,

        [Parameter(Mandatory=$false)]
        [string]$FileName,

        [Parameter(Mandatory=$false)]
        [ValidateSet('Simple','Chunked')]
        [string]$UploadType = 'Simple',

        [Parameter(Mandatory=$false)]
        [string]$AreaPath,

        [Parameter(Mandatory=$false)]
        [string]$ApiVersion = '7.1'
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting attachment upload (Type: $UploadType) (Org: $Organization / Project: $Project)"
        Invoke-TimeSignal -Start

        # --- Basic PAT sanity checks (common cause of HTML login response) ---
        if ([string]::IsNullOrWhiteSpace($Token)) {
            Stop-PSFFunction -Message "Empty -Token value supplied. Provide a valid Azure DevOps PAT." -Target 'Add-ADOWorkItemAttachment'
            return
        }
        if ($Token -eq $Organization) {
            Stop-PSFFunction -Message "The -Token value equals the organization name ('$Organization'). You passed the org instead of a PAT." -Target 'Add-ADOWorkItemAttachment'
            return
        }
        if ($Token -match '\s') {
            Stop-PSFFunction -Message "The -Token contains whitespace which is invalid for a PAT." -Target 'Add-ADOWorkItemAttachment'
            return
        }
        if ($Token.Length -lt 30) {
            Write-PSFMessage -Level Warning -Message "PAT length ($($Token.Length)) looks short; a full PAT is usually > 30 chars. This may fail authentication."
        }
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            # ---------------- derive FileName ----------------
            if (-not $FileName) {
                switch ($PSCmdlet.ParameterSetName) {
                    'File'    { $FileName = [System.IO.Path]::GetFileName($FilePath) }
                    'Content' { $FileName = 'content.txt' }
                    'Stream'  { $FileName = "stream-$([guid]::NewGuid()).bin" }
                }
            }

            # ---------------- build relative API path & query ----------------
            $basePath = if ($Project) { "$Project/_apis/wit/attachments" } else { "_apis/wit/attachments" }

            $query = @{}
            if ($FileName)   { $query['fileName']   = [System.Uri]::EscapeDataString($FileName) }
            if ($UploadType) { $query['uploadType'] = $UploadType.ToLower() }
            if ($AreaPath)   { $query['areaPath']   = [System.Uri]::EscapeDataString($AreaPath) }

            $apiUri = $basePath
            if ($query.Count -gt 0) {
                $pairs = foreach ($kv in $query.GetEnumerator()) { "{0}={1}" -f $kv.Key, $kv.Value }
                $apiUri += '?' + ($pairs -join '&')
            }
            # Append api-version
            $apiUri += ($(if ($apiUri -match '\?') { '&' } else { '?' }) + "api-version=$ApiVersion")
            Write-PSFMessage -Level Verbose -Message "API relative URI: $apiUri"

            $baseUrl = "https://dev.azure.com/$Organization/"
            $fullUrl = "$baseUrl$apiUri"
            Write-PSFMessage -Level Verbose -Message "Full URL: $fullUrl"

            # ---------------- prepare body (simple upload only) ----------------
            $bodyBytes = $null
            if ($UploadType -ieq 'Simple') {
                switch ($PSCmdlet.ParameterSetName) {
                    'File' {
                        $resolved = (Resolve-Path $FilePath -ErrorAction Stop).ProviderPath
                        if (-not (Test-Path $resolved -PathType Leaf)) {
                            throw "File not found: $resolved"
                        }
                        $bodyBytes = [System.IO.File]::ReadAllBytes($resolved)
                    }
                    'Content' {
                        $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($Content)
                    }
                    'Stream' {
                        if (-not $Stream.CanRead) { throw "Provided stream is not readable." }
                        $ms = New-Object System.IO.MemoryStream
                        $Stream.CopyTo($ms)
                        $bodyBytes = $ms.ToArray()
                        $ms.Dispose()
                    }
                }
                if (-not $bodyBytes -or $bodyBytes.Length -eq 0) {
                    throw "Upload content is empty. Provide a non-empty file, content or stream."
                }
                Write-PSFMessage -Level Verbose -Message "Payload size (bytes): $($bodyBytes.Length)"
            }
            else {
                Write-PSFMessage -Level Verbose -Message "Initiating chunked upload session (no payload sent)."
            }

            # ---------------- perform request ----------------
            $authHeader = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$Token"))
            $headers = @{ Authorization = "Basic $authHeader" }

            if ($UploadType -ieq 'Simple') {
                # Use Invoke-RestMethod to let PowerShell handle response parsing
                $resultJson = Invoke-RestMethod -Method Post -Uri $fullUrl -Headers $headers -Body $bodyBytes -ContentType 'application/octet-stream' -ErrorAction Stop
            }
            else {
                # Start chunked session (no body)
                $resultJson = Invoke-RestMethod -Method Post -Uri $fullUrl -Headers $headers -ErrorAction Stop
            }

            if (-not $resultJson) { throw "Empty response received." }

            # If Invoke-RestMethod returned HTML (auth or sign-in page), treat as error
            if ($resultJson -is [string] -and $resultJson -match '<html' ) {
                $snippet = ($resultJson -replace '\r','' -replace '\n',' ' )
                if ($snippet.Length -gt 200) { $snippet = $snippet.Substring(0,200) + '...' }
                throw "Unexpected HTML response (probable authentication failure or wrong PAT). Verify -Token (PAT), -Organization, and scopes. Snippet: $snippet"
            }

            if (-not $resultJson.id -or -not $resultJson.url) {
                throw "Response missing expected properties (id/url). Raw: $($resultJson | ConvertTo-Json -Depth 4)"
            }

            Write-PSFMessage -Level Verbose -Message "Attachment upload succeeded (Id: $($resultJson.id))"
            $resultJson | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.Attachment'
        }
        catch {
            Write-PSFMessage -Level Error -Message "Attachment upload failed: $($_.Exception.Message)"
            Stop-PSFFunction -Message "Stopping because of errors" -Target $PSCmdlet.MyInvocation.MyCommand.Name -ErrorRecord $_
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed attachment upload operation"
        Invoke-TimeSignal -End
    }
}