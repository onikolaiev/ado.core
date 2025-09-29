---
external help file: ado.core-help.xml
Module Name: ado.core
online version: https://learn.microsoft.com/azure/devops/boards/queries/wiql-syntax
schema: 2.0.0
---

# Add-ADOWorkItemQuery

## SYNOPSIS
Creates a new work item query/folder or moves an existing one.

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
Wraps the Azure DevOps Queries - Create endpoint to:
    - Create a folder ( -Folder )
    - Create a WIQL query ( -Wiql provided, not -Folder )
    - Move an existing query/folder ( -Id parameter set )
    - Validate WIQL only ( -ValidateWiqlOnly )

## EXAMPLES

### EXAMPLE 1
```
Add-ADOWorkItemQuery -Organization org -Project proj -Token $pat -ParentPath 'Shared Queries' -Name 'All Bugs' -Wiql "Select ..."
Creates a flat WIQL query under Shared Queries.
```

### EXAMPLE 2
```
Add-ADOWorkItemQuery -Organization org -Project proj -Token $pat -ParentPath 'Shared Queries' -Name 'Release' -Folder
Creates a folder named 'Release'.
```

### EXAMPLE 3
```
Add-ADOWorkItemQuery -Organization org -Project proj -Token $pat -ParentPath 'My Queries' -Id 8a8c8212-...-d581
Moves an existing folder/query to My Queries.
```

### EXAMPLE 4
```
Add-ADOWorkItemQuery -Organization org -Project proj -Token $pat -ParentPath 'Shared Queries' -Name 'Check' -Wiql 'Select ...' -ValidateWiqlOnly
Validates WIQL without creating the query.
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
Destination parent path (e.g.
'Shared Queries' or 'My Queries/Sub').

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
Name of the new query/folder (Create set).

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
Switch indicating a folder should be created.

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
WIQL text for the query (omit when creating a folder).

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
flat | tree | oneHop (optional override).

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
Field reference names for query columns.

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
Sort definitions (Field or Field:desc).

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
Make the created item public.

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
Validate WIQL without persisting the query.

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

### ADO.TOOLS.QueryHierarchyItem
## NOTES
Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS

[https://learn.microsoft.com/azure/devops/boards/queries/wiql-syntax](https://learn.microsoft.com/azure/devops/boards/queries/wiql-syntax)

