---
external help file: ado.core-help.xml
Module Name: ado.core
online version: https://learn.microsoft.com/azure/devops
schema: 2.0.0
---

# Add-ADOWorkItemComment

## SYNOPSIS
Adds a comment to an Azure DevOps work item.

## SYNTAX

```
Add-ADOWorkItemComment [-Organization] <String> [-Project] <String> [-Token] <String> [-WorkItemId] <Int32>
 [-Text] <String> [[-Format] <String>] [[-ApiVersion] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Uses the Work Item Tracking REST API (Comments - Add Comment) to create a new comment
on the specified work item.
Supports markdown or html format.
Returns the created
comment object.

## EXAMPLES

### EXAMPLE 1
```
Add-ADOWorkItemComment -Organization org -Project proj -Token $pat -WorkItemId 299 -Text "Deployment approved."
```

Creates a markdown comment on work item 299.

### EXAMPLE 2
```
Add-ADOWorkItemComment -Organization org -Project proj -Token $pat -WorkItemId 299 -Text "<b>Bold</b>" -Format html
```

Creates an HTML formatted comment.

### EXAMPLE 3
```
"Automated run $(Get-Date -Format o)" | Add-ADOWorkItemComment -Organization org -Project proj -Token $pat -WorkItemId 299 -Format markdown
```

Pipes text into the cmdlet to create a timestamped comment.

## PARAMETERS

### -Organization
Azure DevOps organization name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Project
Project name or id.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Token
Personal Access Token (PAT) with vso.work_write scope.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkItemId
Target work item id.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Text
Comment text (markdown supported).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Format
Comment format to send (markdown or html).
Required by API.
Default markdown.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: Markdown
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiVersion
API version (default 7.1-preview.4).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 7.1-preview.4
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

### ADO.TOOLS.WorkItem.Comment
## NOTES
Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS

[https://learn.microsoft.com/azure/devops](https://learn.microsoft.com/azure/devops)

