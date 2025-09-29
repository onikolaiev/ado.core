---
external help file: ado.core-help.xml
Module Name: ado.core
online version: https://learn.microsoft.com/azure/devops
schema: 2.0.0
---

# Update-ADOWorkItem

## SYNOPSIS
Updates a work item in Azure DevOps.

## SYNTAX

```
Update-ADOWorkItem [-Organization] <String> [[-Project] <String>] [-Token] <String> [-Id] <Int32>
 [-Body] <String> [-ValidateOnly] [-BypassRules] [-SuppressNotifications] [[-Expand] <String>]
 [[-ApiVersion] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function updates a specified work item in Azure DevOps using a JSON Patch document.
It supports optional parameters to validate changes, bypass rules, suppress notifications, and expand additional attributes of the work item.

## EXAMPLES

### EXAMPLE 1
```
# Example 1: Update a work item by ID
$body = @(
    @{
    op    = "add"
    path  = "/fields/System.Title"
    value = "Updated Title"
}
)
```

Update-ADOWorkItem -Organization "my-org" -Project "my-project" -Token "my-token" -Id 12345 -Body $body

### EXAMPLE 2
```
# Example 2: Validate an update without saving
$body = @(
    @{
    op    = "add"
    path  = "/fields/System.History"
    value = "Adding a comment for context"
}
)
```

Update-ADOWorkItem -Organization "my-org" -Project "my-project" -Token "my-token" -Id 12345 -Body $body -ValidateOnly $true

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
The ID of the work item to update.

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

### -Body
The JSON Patch document containing the fields and values to update.

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
