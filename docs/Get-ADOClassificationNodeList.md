---
external help file: ado.core-help.xml
Module Name: ado.core
online version: https://learn.microsoft.com/azure/devops
schema: 2.0.0
---

# Get-ADOClassificationNodeList

## SYNOPSIS
Gets classification nodes (Areas/Iterations) by IDs or root nodes.

## SYNTAX

```
Get-ADOClassificationNodeList [-Organization] <String> [-Project] <String> [-Token] <String> [[-Ids] <Int32[]>]
 [[-Depth] <Int32>] [[-ErrorPolicy] <String>] [[-ApiVersion] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Uses the Azure DevOps Work Item Tracking REST API (Classification Nodes - Get Classification Nodes)
to retrieve multiple classification nodes.
Supports:
    - Getting specific nodes by providing a list of IDs
    - Getting root nodes when no IDs are provided
    - Fetching child nodes at specified depths
    - Error handling policies (Fail or Omit) for invalid node IDs

## EXAMPLES

### EXAMPLE 1
```
Get-ADOClassificationNodeList -Organization contoso -Project WebApp -Token $pat
```

Gets all root classification nodes (both Areas and Iterations).

### EXAMPLE 2
```
Get-ADOClassificationNodeList -Organization contoso -Project WebApp -Token $pat -Ids 1,3,5
```

Gets classification nodes with IDs 1, 3, and 5.

### EXAMPLE 3
```
Get-ADOClassificationNodeList -Organization contoso -Project WebApp -Token $pat -Depth 2
```

Gets root nodes including 2 levels of child nodes.

### EXAMPLE 4
```
Get-ADOClassificationNodeList -Organization contoso -Project WebApp -Token $pat -Ids 1,999 -ErrorPolicy omit
```

Gets node ID 1 and returns null for invalid ID 999 (instead of failing).

## PARAMETERS

### -Organization
Azure DevOps organization name (e.g.
contoso).

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
Personal Access Token (PAT) with vso.work scope.

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

### -Ids
Array of classification node IDs to retrieve.
If not provided, returns root nodes.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Depth
Depth of children to fetch (optional).
Specify a number to include child nodes
in the response hierarchy.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ErrorPolicy
fail | omit - How to handle errors when getting some nodes.
'fail' throws an error,
'omit' returns null for invalid IDs but continues processing valid ones.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiVersion
API version (default 7.2-preview.2).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 7.2-preview.2
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

### ADO.TOOLS.WorkItem.ClassificationNode[]
## NOTES
Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS

[https://learn.microsoft.com/azure/devops](https://learn.microsoft.com/azure/devops)

