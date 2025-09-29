---
external help file: ado.core-help.xml
Module Name: ado.core
online version: https://learn.microsoft.com/azure/devops
schema: 2.0.0
---

# Update-ADOWorkItemComment

## SYNOPSIS
Updates (PATCH) an existing work item comment.

## SYNTAX

```
Update-ADOWorkItemComment [-Organization] <String> [-Project] <String> [-Token] <String> [-WorkItemId] <Int32>
 [-CommentId] <Int32> [-Text] <String> [[-Format] <String>] [[-ApiVersion] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Wraps Comments - Update Work Item Comment endpoint.
Allows changing text and format.

## EXAMPLES

### EXAMPLE 1
```
Update-ADOWorkItemComment -Organization org -Project proj -Token $pat -WorkItemId 100 -CommentId 42 -Text "Corrected"
```

Updates comment 42 on work item 100.

### EXAMPLE 2
```
Update-ADOWorkItemComment -Organization org -Project proj -Token $pat -WorkItemId 100 -CommentId 42 -Text "<b>Updated</b>" -Format html
```

Updates comment 42 with HTML formatted text.

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
PAT (vso.work_write scope).

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
Work item id owning the comment.

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

### -CommentId
Comment id to update.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Text
New comment text.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Format
markdown | html

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
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
Position: 8
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

## RELATED LINKS

[https://learn.microsoft.com/azure/devops](https://learn.microsoft.com/azure/devops)

