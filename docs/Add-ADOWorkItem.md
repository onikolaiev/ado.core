---
external help file: ado.core-help.xml
Module Name: ado.core
online version:
schema: 2.0.0
---

# Add-ADOWorkItem

## SYNOPSIS
Creates a new work item in Azure DevOps.

## SYNTAX

```
Add-ADOWorkItem [-Organization] <String> [-Project] <String> [-Token] <String> [-Type] <String>
 [-Body] <String> [-ValidateOnly] [-BypassRules] [-SuppressNotifications] [[-Expand] <String>]
 [[-ApiVersion] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function creates a new work item in a specified Azure DevOps project using the provided parameters.
It supports optional parameters to bypass rules, suppress notifications, validate changes, and expand additional attributes of the work item.

## EXAMPLES

### EXAMPLE 1
```
# Example 1: Create a new Task work item
$body = @"
{
"op": "add",
"path": "/fields/System.Title",
"value": "Sales Order Process",
}
"@
```

Add-ADOWorkItem -Organization "my-org" -Project "my-project" -Token "my-token" -Type "Task" -Body $body

### EXAMPLE 2
```
# Example 2: Create a new Bug work item with validation only
$body = @"
{
"op": "add",
"path": "/fields/System.Title",
"value": "Sample Bug",
}
"@
Add-ADOWorkItem -Organization "my-org" -Project "my-project" -Token "my-token" -Type "Bug" -Body $body -ValidateOnly $true
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
The name or ID of the Azure DevOps project where the work item will be created.

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

### -Type
The type of the work item to create (e.g., Task, Bug, User Story).

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

### -Body
The JSON Patch document containing the fields and values for the work item.

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

### -ValidateOnly
(Optional) Indicates if you only want to validate the changes without saving the work item.
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

### -BypassRules
(Optional) Indicates if work item type rules should be bypassed.
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

### -SuppressNotifications
(Optional) Indicates if notifications should be suppressed for this change.
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

### -ApiVersion
(Optional) The API version to use.
Default is \`$Script:ADOApiVersion\`.

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
