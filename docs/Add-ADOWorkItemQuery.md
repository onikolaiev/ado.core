---
external help file: ado.core-help.xml
Module Name: ado.core
online version:
schema: 2.0.0
---

# Add-ADOWorkItemQuery

## SYNOPSIS
Creates (folder/query) or moves an existing work item query.

## SYNTAX

### Create (Default)
```
Add-ADOWorkItemQuery -Organization <String> -Project <String> -Token <String> -ParentPath <String>
 -Name <String> [-Folder] [-Wiql <String>] [-QueryType <String>] [-Columns <String[]>]
 [-SortColumns <String[]>] [-Public] [-ValidateWiqlOnly] [-ApiVersion <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Move
```
Add-ADOWorkItemQuery -Organization <String> -Project <String> -Token <String> -ParentPath <String> -Id <String>
 [-ValidateWiqlOnly] [-ApiVersion <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Wraps Azure DevOps Queries - Create endpoint (POST wit/queries/{parent}).
Parameter set Create: supply -Name (and optionally -Wiql for a query or -Folder for a folder).
Parameter set Move: supply -Id of existing query/folder to move under -ParentPath.
Use -ValidateWiqlOnly to validate WIQL without creating.

## EXAMPLES

### EXAMPLE 1
```
Add-ADOWorkItemQuery -Organization org -Project proj -Token $pat -ParentPath 'Shared Queries' -Name 'All Bugs' -Wiql "Select ..." -Columns System.Id,System.Title,System.State
```

### EXAMPLE 2
```
Add-ADOWorkItemQuery -Organization org -Project proj -Token $pat -ParentPath 'My Queries' -Name 'Team' -Folder
```

### EXAMPLE 3
```
Add-ADOWorkItemQuery -Organization org -Project proj -Token $pat -ParentPath 'My Queries' -Id 8a8c8212-15ca-41ed-97aa-1d6fbfbcd581
```

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

### -ParentPath
Parent folder path or id where the item is created/moved (e.g.
'Shared Queries' or 'Shared Queries/Team').

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

### -Name
Name of new folder/query (Create set).

```yaml
Type: String
Parameter Sets: Create
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Folder
Create a folder instead of a WIQL query.

```yaml
Type: SwitchParameter
Parameter Sets: Create
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wiql
WIQL text for query (omit for folders).

```yaml
Type: String
Parameter Sets: Create
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -QueryType
flat | tree | oneHop (optional hint; usually inferred).

```yaml
Type: String
Parameter Sets: Create
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Columns
One or more field reference names to include as columns.

```yaml
Type: String[]
Parameter Sets: Create
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortColumns
Sort definitions.
Format: FieldRefName or FieldRefName:desc

```yaml
Type: String[]
Parameter Sets: Create
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Public
Make created item public (isPublic=true).

```yaml
Type: SwitchParameter
Parameter Sets: Create
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Existing query/folder id to move (Move set).

```yaml
Type: String
Parameter Sets: Move
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValidateWiqlOnly
Only validate WIQL (no creation).
Returns validation result (HTTP still POST).

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
Position: Named
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
