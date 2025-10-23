---
external help file: ado.core-help.xml
Module Name: ado.core
online version:
schema: 2.0.0
---

# Get-ADOBoardColumnList

## SYNOPSIS
Gets columns from a specific board in an Azure DevOps team.

## SYNTAX

```
Get-ADOBoardColumnList [-Organization] <String> [-Project] <String> [-Board] <String> [[-Team] <String>]
 [-Token] <String> [[-ApiVersion] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function uses the \`Invoke-ADOApiRequest\` function to call the Azure DevOps Work REST API (7.2-preview.1) and retrieve columns from a specific board in a team project.

## EXAMPLES

### EXAMPLE 1
```
Get-ADOBoardColumnList -Organization "fabrikam" -Project "WebApp" -Team "Quality Assurance" -Board "Stories" -Token $token
```

Gets all columns from the "Stories" board for the "Quality Assurance" team in the "WebApp" project.

### EXAMPLE 2
```
Get-ADOBoardColumnList -Organization "fabrikam" -Project "Fabrikam" -Board "12345678-1234-1234-1234-123456789012" -Token $token
```

Gets columns from a specific board by GUID for the default team in the specified project.

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

### -Team
Team ID or team name (optional).

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

### -Token
The authentication token for accessing Azure DevOps.

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

### -ApiVersion
The version of the Azure DevOps REST API to use.
Default is "7.2-preview.1".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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
