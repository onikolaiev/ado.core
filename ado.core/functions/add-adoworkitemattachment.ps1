
<#
    .SYNOPSIS
        Uploads (creates) a work item attachment.
    .DESCRIPTION
        Wraps Work Item Tracking Attachments - Create endpoint.
        Supports:
            - Simple upload of a local file (-FilePath)
            - Upload from provided text (-Content)
            - Upload from an existing stream (-Stream)
            - Start of a chunked upload session (-UploadType Chunked) – only starts the session; subsequent chunk upload API not implemented here.
        Returns the attachment reference (id and URL).
    .OUTPUTS
        ADO.TOOLS.WorkItem.Attachment
    .PARAMETER Organization
        Azure DevOps organization name.
    .PARAMETER Project
        (Optional) Project name or id.
    .PARAMETER Token
        Personal Access Token (PAT) with vso.work_write scope.
    .PARAMETER FilePath
        Path to a local file to upload.
    .PARAMETER Content
        Text content to upload as a file (UTF8).
    .PARAMETER Stream
    .NET stream containing data to upload.
    .PARAMETER FileName
        Target file name (defaults to leaf name of FilePath or 'content.txt' when using -Content).
    .PARAMETER UploadType
        Simple | Chunked (default Simple). Chunked here only initiates the session (no chunk data yet).
    .PARAMETER AreaPath
        Optional area path (areaPath query parameter).
    .PARAMETER ApiVersion
        API version (default 7.1).
    .EXAMPLE
        PS> Add-ADOWorkItemAttachment -Organization org -Project proj -Token $pat -FilePath .\readme.md
        
        Uploads readme.md as an attachment.
    .EXAMPLE
        PS> Add-ADOWorkItemAttachment -Organization org -Project proj -Token $pat -Content "Run log $(Get-Date -Format o)" -FileName runlog.txt
        
        Uploads generated text as runlog.txt.
    .EXAMPLE
        PS> Add-ADOWorkItemAttachment -Organization org -Token $pat -FilePath .\large.zip -UploadType Chunked
        
        Starts a chunked upload session for large.zip (no data chunks uploaded yet).
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