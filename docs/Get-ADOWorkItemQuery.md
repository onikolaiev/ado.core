---
external help file: ado.core-help.xml
Module Name: ado.core
online version:
schema: 2.0.0
---

# Get-ADOWorkItemQuery

## SYNOPSIS
Retrieves a single work item query (and optional descendants).

## SYNTAX

```
Get-ADOWorkItemQuery [-Organization] <String> [-Project] <String> [-Token] <String> [-Query] <String>
 [[-Depth] <Int32>] [[-Expand] <String>] [-IncludeDeleted] [-UseIsoDateFormat] [-Raw] [[-ApiVersion] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Wraps Azure DevOps Queries - Get endpoint.
Supports depth, expansion of WIQL/clauses,
inclusion of deleted queries, and ISO date formatting for DateTime clauses.

## EXAMPLES

### EXAMPLE 1
```
Get-ADOWorkItemQuery -Organization org -Project proj -Token $pat -Query 'Shared Queries/All Bugs'
```

### EXAMPLE 2
```
Get-ADOWorkItemQuery -Organization org -Project proj -Token $pat -Query 342f0f44-4069-46b1-a940-3d0468979ceb -Expand wiql
```

### EXAMPLE 3
```
Get-ADOWorkItemQuery -Organization org -Project proj -Token $pat -Query 'Shared Queries/Folder' -Depth 2 -Expand clauses
```

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
Personal Access Token (PAT).

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

### -Query
Query path (e.g.
'Shared Queries/Website team/All Bugs') or query GUID.

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

### -Depth
Return child queries/folders to this depth (for folders).

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

### -Expand
none | wiql | clauses | all | minimal

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

### -IncludeDeleted
Include deleted queries/folders.

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

### -UseIsoDateFormat
Format DateTime clauses using ISO 8601.

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
Return raw response object instead of typed item.

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
API version (default 7.1).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
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

## NOTES
Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
