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
                    'Stream'  { $FileName = "stream-$([guid]::NewGuid().ToString()).bin" }
                }
            }

            $basePath = if ($Project) { "$Project/_apis/wit/attachments" } else { "_apis/wit/attachments" }

            $query = @{}
            if ($FileName)   { $query['fileName']   = [System.Uri]::EscapeDataString($FileName) }
            if ($UploadType) { $query['uploadType'] = $UploadType.ToLower() } # 'simple' or 'chunked'
            if ($AreaPath)   { $query['areaPath']   = [System.Uri]::EscapeDataString($AreaPath) }

            $apiUri = $basePath
            if ($query.Count -gt 0) {
                $apiUri += '?' + ($query.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" } -join '&')
            }

            Write-PSFMessage -Level Verbose -Message "API URI: $apiUri"

            $body = $null
            $headers = @{ 'Content-Type' = 'application/octet-stream' }

            if ($UploadType -eq 'Simple') {
                switch ($PSCmdlet.ParameterSetName) {
                    'File'    { $body = [System.IO.File]::ReadAllBytes((Resolve-Path $FilePath)) }
                    'Content' { $body = [System.Text.Encoding]::UTF8.GetBytes($Content) }
                    'Stream'  {
                        # Read entire stream into byte array
                        $ms = New-Object System.IO.MemoryStream
                        $Stream.CopyTo($ms)
                        $body = $ms.ToArray()
                        $ms.Dispose()
                    }
                }
            }
            else {
                # Chunked start: no body required (per API sample)
                $body = $null
                Write-PSFMessage -Level Verbose -Message "Initiating chunked upload session (no data body in this request)."
            }

            $response = Invoke-ADOApiRequest -Organization $Organization `
                                             -Token $Token `
                                             -ApiUri $apiUri `
                                             -Method 'POST' `
                                             -Body $body `
                                             -Headers $headers `
                                             -ApiVersion $ApiVersion

            Write-PSFMessage -Level Verbose -Message "Attachment upload succeeded (Type: $UploadType)"
            return $response.Results | Select-PSFObject * -TypeName 'ADO.TOOLS.WorkItem.Attachment'
        }
        catch {
            Write-PSFMessage -Level Error -Message "Attachment upload failed: $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Completed attachment upload operation"
        Invoke-TimeSignal -End
    }
}