---
external help file: ado.core-help.xml
Module Name: ado.core
online version: https://learn.microsoft.com/azure/devops
schema: 2.0.0
---

# Get-ADOClassificationNode

## SYNOPSIS
Gets a classification node (Area or Iteration).

## SYNTAX

```
Get-ADOClassificationNode [-Organization] <String> [-Project] <String> [-Token] <String>
 [-StructureGroup] <String> [[-Path] <String>] [[-Depth] <Int32>] [[-ApiVersion] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Uses the Azure DevOps Work Item Tracking REST API (Classification Nodes - Get) to
retrieve a classification node for a given path.
Supports fetching child nodes
at specified depths for hierarchical navigation.

## EXAMPLES

### EXAMPLE 1
```
Get-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Areas
Gets the root Areas node.
```

### EXAMPLE 2
```
Get-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Iterations -Path "Sprint 1"
Gets the "Sprint 1" iteration node.
```

### EXAMPLE 3
```
Get-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Areas -Path "Development" -Depth 2
Gets the "Development" area node including 2 levels of child nodes.
```

### EXAMPLE 4
```
Get-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Iterations -Depth 1
Gets the root Iterations node with immediate children.
```

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

### -StructureGroup
Areas | Iterations - specifies whether to retrieve Area or Iteration nodes.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Path of the classification node to retrieve (e.g.
'ParentArea\ChildArea').
Leave empty to get the root node.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
Position: 6
Default value: 0
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

### ADO.TOOLS.WorkItem.ClassificationNode
## NOTES
Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS

[https://learn.microsoft.com/azure/devops](https://learn.microsoft.com/azure/devops)

