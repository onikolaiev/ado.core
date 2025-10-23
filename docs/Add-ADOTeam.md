---
external help file: ado.core-help.xml
Module Name: ado.core
online version: https://learn.microsoft.com/azure/devops
schema: 2.0.0
---

# Add-ADOTeam

## SYNOPSIS
Creates a new team in an Azure DevOps project.

## SYNTAX

```
Add-ADOTeam [-Organization] <String> [-ProjectId] <String> [-Name] <String> [[-Description] <String>]
 [-Token] <String> [[-ApiVersion] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function uses the \`Invoke-ADOApiRequest\` function to call the Azure DevOps Core REST API (7.2-preview.3) and create a new team within a specified project.
Requires vso.project_manage scope for the Personal Access Token.

## EXAMPLES

### EXAMPLE 1
```
Add-ADOTeam -Organization "fabrikam" -ProjectId "WebApp" -Name "Quality Assurance" -Token $token
```

Creates a new team named "Quality Assurance" in the "WebApp" project.

### EXAMPLE 2
```
Add-ADOTeam -Organization "fabrikam" -ProjectId "8e5a3cfb-fed3-46f3-8657-e3b175cd0305" -Name "My New Team" -Description "Development team for new features" -Token $token
```

Creates a team with both name and description in the specified project.

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

### -ProjectId
The name or ID (GUID) of the team project in which to create the team.

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

### -Name
The name of the new team.

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

### -Description
Optional description for the team.

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
Default is "7.2-preview.3".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 7.2-preview.3
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

### System.Object
## NOTES
This function follows PSFramework best practices for logging and error handling.

Possible failure scenarios:
    - Invalid project name/ID (project doesn't exist): 404
    - Invalid team name or description: 400
    - Team already exists: 400
    - Insufficient privileges: 400

Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
