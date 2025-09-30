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
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        try {
            if (-not $FileName) {
                switch ($PSCmdlet.ParameterSetName) {
                    'File'    { $FileName = [System.IO.Path]::GetFileName($FilePath) }
                    'Content' { $FileName = 'content.txt' }
                    'Stream'  { $FileName = "stream-$([guid]::NewGuid()).bin" }
                }
            }

            $basePath = if ($Project) { "$Project/_apis/wit/attachments" } else { "_apis/wit/attachments" }

            $query = @{}
            if ($FileName)   { $query['fileName']   = [System.Uri]::EscapeDataString($FileName) }
            if ($UploadType) { $query['uploadType'] = $UploadType.ToLower() }
            if ($AreaPath)   { $query['areaPath']   = [System.Uri]::EscapeDataString($AreaPath) }

            $apiUri = $basePath
            if ($query.Count -gt 0) {
                $apiUri += '?' + ($query.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" } -join '&')
            }

            # Add api-version (not relying on wrapper anymore)
            $apiUri += ($(if ($apiUri -match '\?') { '&' } else { '?' }) + "api-version=$ApiVersion")

            Write-PSFMessage -Level Verbose -Message "API URI (direct HTTP): $apiUri"

            # Prepare body (only for simple upload)
            $bodyBytes = $null
            if ($UploadType -ieq 'Simple') {
                switch ($PSCmdlet.ParameterSetName) {
                    'File' {
                        $resolved = (Resolve-Path $FilePath).ProviderPath
                        $bodyBytes = [System.IO.File]::ReadAllBytes($resolved)
                    }
                    'Content' {
                        $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($Content)
                    }
                    'Stream' {
                        $ms = New-Object System.IO.MemoryStream
                        $Stream.CopyTo($ms)
                        $bodyBytes = $ms.ToArray()
                        $ms.Dispose()
                    }
                }
                Write-PSFMessage -Level Verbose -Message "Prepared body bytes length: $($bodyBytes.Length)"
            }
            else {
                Write-PSFMessage -Level Verbose -Message "Chunked upload session initiation (no payload)."
            }

            # Direct HTTP call (bypassing Invoke-ADOApiRequest to avoid binding issues with binary data)
            $baseUrl = "https://dev.azure.com/$Organization/"
            $fullUrl = "$baseUrl$apiUri"

            $authHeader = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$Token"))

            $handler = [System.Net.Http.HttpClientHandler]::new()
            $client  = [System.Net.Http.HttpClient]::new($handler)
            $client.DefaultRequestHeaders.Authorization = [System.Net.Http.Headers.AuthenticationHeaderValue]::new("Basic", $authHeader)

            if ($UploadType -ieq 'Simple') {
                $content = [System.Net.Http.ByteArrayContent]::new($bodyBytes)
                $content.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse("application/octet-stream")
                $httpResponse = $client.PostAsync($fullUrl, $content).Result
                $content.Dispose()
            }
            else {
                # No body for starting a chunked upload
                $httpResponse = $client.PostAsync($fullUrl, $null).Result
            }

            $rawResponse = $httpResponse.Content.ReadAsStringAsync().Result
            $client.Dispose()

            if (-not $httpResponse.IsSuccessStatusCode) {
                Write-PSFMessage -Level Error -Message "HTTP error $([int]$httpResponse.StatusCode) : $($httpResponse.ReasonPhrase) - Body: $rawResponse"
                throw "Attachment upload failed (HTTP $([int]$httpResponse.StatusCode))."
            }

            if ([string]::IsNullOrWhiteSpace($rawResponse)) {
                throw "Empty response received from attachment endpoint."
            }

            $json = $null
            try {
                $json = $rawResponse | ConvertFrom-Json
            }
            catch {
                throw "Failed to parse JSON response: $rawResponse"
            }

            if (-not $json.id -or -not $json.url) {
                Write-PSFMessage -Level Warning -Message "Response JSON missing expected properties: $rawResponse"
            }

            Write-PSFMessage -Level Verbose -Message "Attachment upload succeeded (Id: $($json.id))"
            $json | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.Attachment'
        }
        catch {
            Write-PSFMessage -Level Error -Message "Attachment upload failed: $($_.Exception.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed attachment upload operation"
        Invoke-TimeSignal -End
    }
}