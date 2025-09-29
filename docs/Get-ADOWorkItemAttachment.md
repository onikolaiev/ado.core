---
external help file: ado.core-help.xml
Module Name: ado.core
online version:
schema: 2.0.0
---

# Get-ADOWorkItemAttachment

## SYNOPSIS
Downloads a work item attachment.

## SYNTAX

### Default (Default)
```
Get-ADOWorkItemAttachment -Organization <String> [-Project <String>] -Token <String> -Id <Guid>
 [-FileName <String>] [-Download] [-OutFile <String>] [-ApiVersion <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### String
```
Get-ADOWorkItemAttachment -Organization <String> [-Project <String>] -Token <String> -Id <Guid>
 [-FileName <String>] [-Download] [-OutFile <String>] [-AsString] [-ApiVersion <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Bytes
```
Get-ADOWorkItemAttachment -Organization <String> [-Project <String>] -Token <String> -Id <Guid>
 [-FileName <String>] [-Download] [-OutFile <String>] [-AsBytes] [-ApiVersion <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Wraps the Work Item Tracking Attachments - Get endpoint.
Supports returning bytes (default),
text (UTF8), or saving directly to a file.
Optional query parameters: fileName, download=true.

## EXAMPLES

### EXAMPLE 1
```
Get-ADOWorkItemAttachment -Organization org -Token $pat -Id 11111111-2222-3333-4444-555555555555 -OutFile .\image.png
```

Downloads the attachment to image.png.

### EXAMPLE 2
```
Get-ADOWorkItemAttachment -Organization org -Token $pat -Id $attId -AsString
```

Returns the attachment content as a UTF8 string.

### EXAMPLE 3
```
Get-ADOWorkItemAttachment -Organization org -Project proj -Token $pat -Id $attId -FileName report.txt -Download -AsBytes
```

Returns the attachment as byte\[\] (default) using specified fileName and download parameters.

## PARAMETERS

### -Organization
Azure DevOps organization name.

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
Personal Access Token (PAT) (vso.work scope).

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

### -Id
Attachment Id (GUID).

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileName
Desired file name (adds fileName query parameter; does not auto-save unless -OutFile specified).

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

### -Download
Force download semantics (adds download=true query parameter).

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutFile
Path to write attachment content.
Creates directories if needed.
Returns FileInfo.

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

### -AsString
Return UTF8 string content (cannot be combined with -OutFile or -AsBytes).

```yaml
Type: SwitchParameter
Parameter Sets: String
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AsBytes
Return raw byte\[\] (default behavior; explicit for clarity).

```yaml
Type: SwitchParameter
Parameter Sets: Bytes
Aliases:

Required: False
Position: Named
Default value: False
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

### System.IO.FileInfo (when -OutFile)
### System.String      (when -AsString)
### System.Byte[]      (default or -AsBytes)
## NOTES
Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
