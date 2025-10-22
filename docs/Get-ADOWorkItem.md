---
external help file: ado.core-help.xml
Module Name: ado.core
online version: https://learn.microsoft.com/azure/devops
schema: 2.0.0
---

# Get-ADOWorkItem

## SYNOPSIS
Retrieves a single work item from Azure DevOps.

## SYNTAX

```
Get-ADOWorkItem [-Organization] <String> [[-Project] <String>] [-Token] <String> [-Id] <Int32>
 [[-Fields] <String>] [[-Expand] <String>] [[-AsOf] <DateTime>] [[-ApiVersion] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function retrieves a single work item from Azure DevOps using its ID.
It supports optional parameters to specify fields, expand attributes, and retrieve the work item as of a specific date.

## EXAMPLES

### EXAMPLE 1
```
# Example 1: Retrieve a work item by ID
```

Get-ADOWorkItem -Organization "my-org" -Token "my-token" -Id 12345

### EXAMPLE 2
```
# Example 2: Retrieve a work item with specific fields and expand attributes
```

Get-ADOWorkItem -Organization "my-org" -Token "my-token" -Id 12345 -Fields "System.Title,System.State" -Expand "Relations"

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

### -Token
The personal access token (PAT) used for authentication.

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

### -Id
The ID of the work item to retrieve.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fields
(Optional) A comma-separated list of fields to include in the response.

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

### -Expand
(Optional) Specifies the expand parameters for work item attributes.
Possible values are \`None\`, \`Relations\`, \`Fields\`, \`Links\`, or \`All\`.

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

### -AsOf
(Optional) The UTC date-time string to retrieve the work item as of a specific date.

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

### -ApiVersion
(Optional) The API version to use.
Default is \`7.1\`.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
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
