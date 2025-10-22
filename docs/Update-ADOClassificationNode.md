---
external help file: ado.core-help.xml
Module Name: ado.core
online version: https://learn.microsoft.com/azure/devops
schema: 2.0.0
---

# Update-ADOClassificationNode

## SYNOPSIS
Updates a classification node (Area or Iteration).

## SYNTAX

```
Update-ADOClassificationNode [-Organization] <String> [-Project] <String> [-Token] <String>
 [-StructureGroup] <String> [[-Path] <String>] [[-Name] <String>] [[-StartDate] <DateTime>]
 [[-FinishDate] <DateTime>] [[-Attributes] <Hashtable>] [[-ApiVersion] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Uses the Azure DevOps Work Item Tracking REST API (Classification Nodes - Update) to
update an existing classification node.
Supports:
    - Renaming nodes by providing a new Name
    - Updating iteration dates (StartDate/FinishDate)
    - Setting custom attributes via hashtable

## EXAMPLES

### EXAMPLE 1
```
Update-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Areas -Path "Frontend Team" -Name "UI Team"
Renames the "Frontend Team" area to "UI Team".
```

### EXAMPLE 2
```
Update-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Iterations -Path "Sprint 1" -StartDate "2024-01-01T00:00:00Z" -FinishDate "2024-01-15T00:00:00Z"
Updates Sprint 1 iteration with new start and finish dates.
```

### EXAMPLE 3
```
Update-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Iterations -Path "Current Sprint" -Attributes @{ startDate = "2024-02-01T00:00:00Z"; finishDate = "2024-02-14T00:00:00Z" }
Updates iteration dates using the Attributes hashtable.
```

### EXAMPLE 4
```
Update-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Areas -Name "New Root Area Name"
Renames the root Areas node.
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

### -StructureGroup
Areas | Iterations - specifies whether this is an Area or Iteration node.

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
Path of the classification node to update (e.g.
'ParentArea\ChildArea').
Leave empty to update the root node.

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

### -Name
New name for the classification node (optional).

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

### -StartDate
New start date for Iteration nodes (ISO 8601 format, e.g.
'2024-10-27T00:00:00Z').

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FinishDate
New finish date for Iteration nodes (ISO 8601 format, e.g.
'2024-10-31T00:00:00Z').

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Attributes
Hashtable of attributes to update (alternative to individual date parameters).

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
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
Position: 10
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

