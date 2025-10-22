---
external help file: ado.core-help.xml
Module Name: ado.core
online version: https://learn.microsoft.com/azure/devops
schema: 2.0.0
---

# Remove-ADOClassificationNode

## SYNOPSIS
Deletes a classification node (Area or Iteration).

## SYNTAX

```
Remove-ADOClassificationNode [-Organization] <String> [-Project] <String> [-Token] <String>
 [-StructureGroup] <String> [-Path] <String> [[-ReclassifyId] <Int32>] [-PassThru] [[-ApiVersion] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Uses the Azure DevOps Work Item Tracking REST API (Classification Nodes - Delete) to
permanently remove a classification node.
Supports optional reclassification of work items
to a different node before deletion.
This operation cannot be undone.

## EXAMPLES

### EXAMPLE 1
```
Remove-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Areas -Path "Frontend Team" -Confirm:$false
```

Deletes the "Frontend Team" area node without confirmation.

### EXAMPLE 2
```
Remove-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Iterations -Path "Old Sprint" -ReclassifyId 12345 -PassThru
```

Deletes "Old Sprint" iteration after reclassifying work items to node ID 12345, returns the deleted path.

### EXAMPLE 3
```
Remove-ADOClassificationNode -Organization contoso -Project WebApp -Token $pat -StructureGroup Areas -Path "Development\Legacy" -WhatIf
```

Shows what would be deleted without actually performing the deletion.

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
Path of the classification node to delete (e.g.
'ParentArea\ChildArea').
Leave empty to target root level nodes.

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

### -ReclassifyId
Optional ID of target classification node for reclassifying work items before deletion.
If not provided, work items may lose their area/iteration assignment.

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

### -PassThru
Return the deleted path when deletion succeeds.

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

### -WhatIf
Show what would happen without deleting.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Confirmation prompt (SupportsShouldProcess).

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
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

### System.String
## NOTES
Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS

[https://learn.microsoft.com/azure/devops](https://learn.microsoft.com/azure/devops)

