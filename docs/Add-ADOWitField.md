---
external help file: ado.core-help.xml
Module Name: ado.core
online version: https://learn.microsoft.com/azure/devops
schema: 2.0.0
---

# Add-ADOWitField

## SYNOPSIS
Creates a new field.

## SYNTAX

```
Add-ADOWitField [-Organization] <String> [-Token] <String> [-Body] <String> [[-Project] <String>]
 [[-ApiVersion] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function uses the \`Invoke-ADOApiRequest\` function to call the Azure DevOps REST API and create a new field in the specified organization and project.

## EXAMPLES

### EXAMPLE 1
```
$body = @"
{
    "name": "New Work Item Field",
    "referenceName": "SupportedOperations.GreaterThanEquals",
    "description": null,
    "type": "string",
    "usage": "workItem",
    "readOnly": false,
    "canSortBy": true,
    "isQueryable": true,
    "supportedOperations": [
    {
        "referenceName": "SupportedOperations.Equals",
        "name": "="
    }
    ],
    "isIdentity": true,
    "isPicklist": false,
    "isPicklistSuggested": false,
    "url": null
}
"@
```

Add-ADOWitField -Organization "fabrikam" -Token "my-token" -Body $body -Project "MyProject"

Creates a new field in the specified project.

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

### -Token
The authentication token for accessing Azure DevOps.

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

### -Body
The JSON string containing the properties for the field to create.

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

### -Project
The ID or name of the project.
This parameter is optional.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiVersion
The version of the Azure DevOps REST API to use.
Default is "7.2-preview.3".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
This function follows PSFramework best practices for logging and error handling.

Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
