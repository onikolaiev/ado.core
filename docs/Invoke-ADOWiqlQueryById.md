﻿---
external help file: ado.core-help.xml
Module Name: ado.core
online version:
schema: 2.0.0
---

# Invoke-ADOWiqlQueryById

## SYNOPSIS
Executes a WIQL query in Azure DevOps using a query ID and retrieves the results.

## SYNTAX

```
Invoke-ADOWiqlQueryById [-Organization] <String> [[-Project] <String>] [[-Team] <String>] [-Token] <String>
 [-QueryId] <String> [-TimePrecision] [[-Top] <Int32>] [[-ApiVersion] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function allows you to execute a WIQL query in Azure DevOps by providing the query ID.
It supports optional parameters to limit the number of results, enable time precision, and specify a team context.

## EXAMPLES

### EXAMPLE 1
```
# Example 1: Execute a WIQL query by ID
```

Invoke-ADOWiqlQueryById -Organization "my-org" -Project "my-project" -Token "my-token" -QueryId "12345678-1234-1234-1234-123456789abc"

### EXAMPLE 2
```
# Example 2: Execute a WIQL query by ID with time precision and limit results to 10
```

Invoke-ADOWiqlQueryById -Organization "my-org" -Project "my-project" -Token "my-token" -QueryId "12345678-1234-1234-1234-123456789abc" -TimePrecision $true -Top 10

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

### -QueryId
The ID of the WIQL query to execute.

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
This function is part of the ADO Tools module and adheres to the conventions used in the module for logging, error handling, and API interaction.

Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
