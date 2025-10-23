---
external help file: ado.core-help.xml
Module Name: ado.core
online version: https://learn.microsoft.com/azure/devops
schema: 2.0.0
---

# Update-ADOBoardColumnList

## SYNOPSIS
Updates columns on a specific board in an Azure DevOps team.

## SYNTAX

```
Update-ADOBoardColumnList [-Organization] <String> [-Project] <String> [-Board] <String> [-Body] <String>
 [[-Team] <String>] [-Token] <String> [[-ApiVersion] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This function uses the \`Invoke-ADOApiRequest\` function to call the Azure DevOps Work REST API (7.2-preview.1) and update columns on a specific board in a team project.
Requires vso.work_write scope.

## EXAMPLES

### EXAMPLE 1
```
$columns = @"
[
{
    "id": "12eed5fb-8af3-47bb-9d2a-058fbe7e1196",
    "name": "New",
    "itemLimit": 0,
    "stateMappings": {
        "Product Backlog Item": "New",
        "Bug": "New"
    },
    "columnType": "incoming"
},
{
    "id": "5f72391d-af1c-4754-9459-23138eba13e3",
    "name": "Approved",
    "itemLimit": 10,
    "stateMappings": {
        "Product Backlog Item": "Approved",
        "Bug": "Approved"
    },
    "isSplit": false,
    "description": "Updated description",
    "columnType": "inProgress"
}
]
"@
```

Update-ADOBoardColumnList -Organization "fabrikam" -Project "WebApp" -Team "Quality Assurance" -Board "Stories" -Body $columns -Token $token

Updates columns on the "Stories" board for the "Quality Assurance" team.

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
Project ID or project name.

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

### -Board
Name or ID of the specific board.

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

### -Body
The JSON string containing the array of board columns to update.

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

### -Team
Team ID or team name (optional).

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

### -Token
The authentication token for accessing Azure DevOps.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiVersion
The version of the Azure DevOps REST API to use.
Default is "7.2-preview.1".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 7.2-preview.1
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

### System.Object[]
## NOTES
This function follows PSFramework best practices for logging and error handling.

Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
