---
external help file: ado.core-help.xml
Module Name: ado.core
online version: https://learn.microsoft.com/azure/devops
schema: 2.0.0
---

# Add-ADOWorkItemAttachment

## SYNOPSIS
Uploads (creates) a work item attachment.

## SYNTAX

### File (Default)
```
Add-ADOWorkItemAttachment -Organization <String> [-Project <String>] -Token <String> -FilePath <String>
 [-FileName <String>] [-UploadType <String>] [-AreaPath <String>] [-ApiVersion <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Content
```
Add-ADOWorkItemAttachment -Organization <String> [-Project <String>] -Token <String> -Content <String>
 [-FileName <String>] [-UploadType <String>] [-AreaPath <String>] [-ApiVersion <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Stream
```
Add-ADOWorkItemAttachment -Organization <String> [-Project <String>] -Token <String> -Stream <Stream>
 [-FileName <String>] [-UploadType <String>] [-AreaPath <String>] [-ApiVersion <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Uses the Azure DevOps Work Item Tracking REST API (Attachments - Create) to upload an attachment.
Supports three content sources (separate parameter sets):
    - File:    Provide a local file path via -FilePath
    - Content: Provide text via -Content (converted to UTF8 bytes)
    - Stream:  Provide an open System.IO.Stream via -Stream
Also supports initiating a chunked upload session with -UploadType Chunked (no data chunks
are uploaded in this initial request).
For chunked transfers you must later call the chunk
upload APIs (not implemented here).
Returns the attachment reference object (id, url) as type ADO.TOOLS.WorkItem.Attachment.

## EXAMPLES

### EXAMPLE 1
```
Add-ADOWorkItemAttachment -Organization contoso -Project WebApp -Token $pat -FilePath .\readme.md
```

Uploads readme.md using simple upload and returns the attachment reference.

### EXAMPLE 2
```
Add-ADOWorkItemAttachment -Organization contoso -Project WebApp -Token $pat -Content "Log $(Get-Date -Format o)" -FileName runlog.txt
```

Uploads generated text as runlog.txt.

### EXAMPLE 3
```
$fs = [System.IO.File]::OpenRead('diagram.png')
PS> Add-ADOWorkItemAttachment -Organization contoso -Project WebApp -Token $pat -Stream $fs -FileName diagram.png
```

Uploads the stream content (diagram.png) then returns the attachment reference.

### EXAMPLE 4
```
Add-ADOWorkItemAttachment -Organization contoso -Token $pat -FilePath .\large.zip -UploadType Chunked
```

Initiates a chunked upload session for large.zip (no data chunks uploaded here).

## PARAMETERS

### -Organization
Azure DevOps organization name (e.g.
contoso).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Project
(Optional) Project name or id.
If omitted, the attachment is uploaded at the account level.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Token
Personal Access Token (PAT) with vso.work_write (or broader) scope.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilePath
Path to an existing local file to upload (File parameter set).

```yaml
Type: String
Parameter Sets: File
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Content
Plain text content to upload (Content parameter set).
Encoded as UTF8.

```yaml
Type: String
Parameter Sets: Content
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Stream
Open readable System.IO.Stream to upload (Stream parameter set).
Entire stream is buffered.

```yaml
Type: Stream
Parameter Sets: Stream
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileName
Target file name to store in Azure DevOps.
Defaults to the leaf name of FilePath, 'content.txt'
for -Content, or a generated name for -Stream when not specified.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UploadType
simple | chunked.
Default simple.
chunked only starts a chunked upload session (no payload).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Simple
Accept pipeline input: False
Accept wildcard characters: False
```

### -AreaPath
Optional area path (areaPath query parameter) to associate with the upload.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiVersion
API version (default 7.1).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 7.1
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### ADO.TOOLS.WorkItem.Attachment
## NOTES
Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS

[https://learn.microsoft.com/azure/devops](https://learn.microsoft.com/azure/devops)

