---
external help file: ado.core-help.xml
Module Name: ado.core
online version: https://learn.microsoft.com/azure/devops
schema: 2.0.0
---

# Get-ADOClassificationNodeRoot

## SYNOPSIS
Gets root classification nodes (Areas and Iterations).

## SYNTAX

```
Get-ADOClassificationNodeRoot [-Organization] <String> [-Project] <String> [-Token] <String> [[-Depth] <Int32>]
 [[-ApiVersion] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Uses the Azure DevOps Work Item Tracking REST API (Classification Nodes - Get Root Nodes)
to retrieve root classification nodes under the project.
Returns both Areas and Iterations
root nodes with optional child hierarchy depth.

## EXAMPLES

### EXAMPLE 1
```
Get-ADOClassificationNodeRoot -Organization contoso -Project WebApp -Token $pat
```

Gets both root Areas and Iterations nodes.

### EXAMPLE 2
```
Get-ADOClassificationNodeRoot -Organization contoso -Project WebApp -Token $pat -Depth 2
```

Gets root nodes including 2 levels of child nodes for both Areas and Iterations.

### EXAMPLE 3
```
$roots = Get-ADOClassificationNodeRoot -Organization contoso -Project WebApp -Token $pat -Depth 1
PS> $areas = $roots | Where-Object { $_.structureType -eq 'area' }
PS> $iterations = $roots | Where-Object { $_.structureType -eq 'iteration' }
```

Gets root nodes with immediate children and separates Areas from Iterations.

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

### -Depth
Depth of children to fetch (optional).
Specify a number to include child nodes
in the response hierarchy.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
Position: 5
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

