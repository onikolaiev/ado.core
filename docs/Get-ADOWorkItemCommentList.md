---
external help file: ado.core-help.xml
Module Name: ado.core
online version: https://learn.microsoft.com/azure/devops
schema: 2.0.0
---

# Get-ADOWorkItemCommentList

## SYNOPSIS
Retrieves comments for an Azure DevOps work item.

## SYNTAX

```
Get-ADOWorkItemCommentList -Organization <String> -Project <String> -Token <String> -WorkItemId <Int32>
 [-Top <Int32>] [-ContinuationToken <String>] [-IncludeDeleted] [-Expand <String>] [-Order <String>] [-All]
 [-Raw] [-ApiVersion <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves a (pageable) list of comments for the specified work item.
Supports server paging
via -Top and -ContinuationToken or automatic full retrieval with -All.
Can include deleted,
expand rendered text or reactions, and control sort order.

## EXAMPLES

### EXAMPLE 1
```
Get-ADOWorkItemCommentList -Organization org -Project proj -Token $pat -WorkItemId 123
```

Retrieves the first page of comments for work item 123.

### EXAMPLE 2
```
Get-ADOWorkItemCommentList -Organization org -Project proj -Token $pat -WorkItemId 123 -Top 50 -All
```

Retrieves all comments for work item 123 in pages of up to 50 comments.

### EXAMPLE 3
```
Get-ADOWorkItemCommentList -Organization org -Project proj -Token $pat -WorkItemId 123 -Expand renderedText -Order desc
```

Retrieves all comments including rendered HTML, sorted descending by id.

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
Project name or id.

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

### -Token
Personal Access Token (PAT).

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

### -WorkItemId
Target work item id.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Top
Maximum number of comments to return in a single page ($top).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContinuationToken
Token returned from a previous page to continue listing.

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

### -IncludeDeleted
Include deleted comments.

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

### -Expand
Additional data options: none, reactions, renderedText, renderedTextOnly, all.

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

### -Order
asc or desc.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Asc
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
Retrieve and aggregate all pages (ignores provided -ContinuationToken; still honors -Top as page size if set).

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

### -Raw
Return raw API payload objects instead of flattened comments.

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

### -ApiVersion
API version (default 7.1-preview.4).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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

### System.Management.Automation.PSObject[]
## NOTES
Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
