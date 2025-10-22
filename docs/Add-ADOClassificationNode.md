---
external help file: ado.core-help.xml
Module Name: ado.core
online version: https://learn.microsoft.com/azure/devops
schema: 2.0.0
---

# Add-ADOClassificationNode

## SYNOPSIS
Creates or updates a classification node (Area or Iteration).

## SYNTAX

### CreateByName (Default)
```
Add-ADOClassificationNode -Organization <String> -Project <String> -Token <String> -StructureGroup <String>
 [-Path <String>] -Name <String> [-StartDate <DateTime>] [-FinishDate <DateTime>] [-Attributes <Hashtable>]
 [-ApiVersion <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### MoveById
```
Add-ADOClassificationNode -Organization <String> -Project <String> -Token <String> -StructureGroup <String>
 [-Path <String>] -Id <Int32> [-StartDate <DateTime>] [-FinishDate <DateTime>] [-Attributes <Hashtable>]
 [-ApiVersion <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Uses the Azure DevOps Work Item Tracking REST API (Classification Nodes - Create Or Update)
to create new or update existing classification nodes.
Supports:
    - Creating new Area or Iteration nodes with optional attributes
    - Moving existing nodes by providing their ID
    - Setting start/finish dates for Iteration nodes
    - Specifying parent path for hierarchical organization

## EXAMPLES

### EXAMPLE 1
```
Add-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Areas -Name "Frontend Team"
Creates a new Area node named "Frontend Team" at the root level.
```

### EXAMPLE 2
```
Add-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Iterations -Name "Sprint 1" -StartDate "2024-01-01T00:00:00Z" -FinishDate "2024-01-15T00:00:00Z"
Creates a new Iteration with start and finish dates.
```

### EXAMPLE 3
```
Add-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Areas -Path "Development\Backend" -Name "API Team"
Creates "API Team" area under Development\Backend path.
```

### EXAMPLE 4
```
Add-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Areas -Path "NewParent" -Id 126391
Moves existing area node (ID 126391) under "NewParent" path.
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
Personal Access Token (PAT) with vso.work_write scope.

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

### -StructureGroup
Areas | Iterations - specifies whether this is an Area or Iteration node.

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

### -Path
Optional path of the classification node.
Use for creating nodes under a specific parent
(e.g.
'ParentArea\ChildArea') or leave empty to create at root level.

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

### -Name
Name of the new classification node (required for creating new nodes).

```yaml
Type: String
Parameter Sets: CreateByName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
ID of an existing node to move (use instead of -Name for move operations).

```yaml
Type: Int32
Parameter Sets: MoveById
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDate
Start date for Iteration nodes (ISO 8601 format, e.g.
'2024-10-27T00:00:00Z').

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FinishDate
Finish date for Iteration nodes (ISO 8601 format, e.g.
'2024-10-31T00:00:00Z').

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Attributes
Hashtable of additional attributes (alternative to individual date parameters).

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
Position: Named
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

