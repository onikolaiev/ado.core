---
external help file: ado.core-help.xml
Module Name: ado.core
online version:
schema: 2.0.0
---

# Invoke-ADOWiqlQueryByWiql

## SYNOPSIS
Executes a WIQL (Work Item Query Language) query in Azure DevOps and retrieves the results.

## SYNTAX

```
Invoke-ADOWiqlQueryByWiql [-Organization] <String> [[-Project] <String>] [[-Team] <String>] [-Token] <String>
 [-Query] <String> [-TimePrecision] [[-Top] <Int32>] [[-ApiVersion] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function allows you to execute a WIQL query in Azure DevOps to retrieve work items or work item links.
It supports optional parameters to limit the number of results, enable time precision, and specify a team context.

## EXAMPLES

### EXAMPLE 1
```
# Example 1: Execute a WIQL query to retrieve all active tasks
$query = "Select [System.Id], [System.Title], [System.State] From WorkItems Where [System.WorkItemType] = 'Task' AND [State] <> 'Closed' order by [System.CreatedDate] desc"
Invoke-ADOWiqlQueryByWiql -Organization "my-org" -Project "my-project" -Token "my-token" -Query $query
```

### EXAMPLE 2
```
# Example 2: Execute a WIQL query with time precision and limit results to 10
$query = "Select [System.Id], [System.Title] From WorkItems Where [System.WorkItemType] = 'Bug'"
Invoke-ADOWiqlQueryByWiql -Organization "my-org" -Project "my-project" -Token "my-token" -Query $query -TimePrecision $true -Top 10
```

## PARAMETERS

### -Organization
The name of the Azure DevOps organization.

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
(Optional) The name or ID of the Azure DevOps project.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Team
(Optional) The name or ID of the Azure DevOps team.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Token
The personal access token (PAT) used for authentication.

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

### -Query
The WIQL query string to execute.

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

### -TimePrecision
(Optional) Whether or not to use time precision.
Default is \`$false\`.

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

### -Top
(Optional) The maximum number of results to return.

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
(Optional) The API version to use.
Default is \`7.1\`.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: $Script:ADOApiVersion
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
This function is part of the ADO Tools module and adheres to the conventions used in the module for logging, error handling, and API interaction.

## RELATED LINKS
