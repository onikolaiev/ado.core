---
external help file: ado.core-help.xml
Module Name: ado.core
online version: https://learn.microsoft.com/azure/devops
schema: 2.0.0
---

# Remove-ADOTeam

## SYNOPSIS
Deletes a team from an Azure DevOps project.

## SYNTAX

```
Remove-ADOTeam [-Organization] <String> [-ProjectId] <String> [-TeamId] <String> [-Token] <String>
 [[-ApiVersion] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function uses the \`Invoke-ADOApiRequest\` function to call the Azure DevOps Core REST API (7.2-preview.3) and delete a team from a specified project.
Requires vso.project_manage scope for the Personal Access Token.

## EXAMPLES

### EXAMPLE 1
```
Remove-ADOTeam -Organization "fabrikam" -ProjectId "WebApp" -TeamId "Quality Assurance" -Token $token
```

Deletes the "Quality Assurance" team from the "WebApp" project.

### EXAMPLE 2
```
Remove-ADOTeam -Organization "fabrikam" -ProjectId "8e5a3cfb-fed3-46f3-8657-e3b175cd0305" -TeamId "564e8204-a90b-4432-883b-d4363c6125ca" -Token $token
```

Deletes a specific team by GUID from the specified project.

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
The name or ID (GUID) of the team project containing the team to delete.

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

### -TeamId
The name or ID of the team to delete.

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

### -Token
The authentication token for accessing Azure DevOps.

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

### -ApiVersion
The version of the Azure DevOps REST API to use.
Default is "7.2-preview.3".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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

## NOTES
This function follows PSFramework best practices for logging and error handling.

Possible failure scenarios:
    - Invalid project name/ID (project doesn't exist): 404
    - Invalid team name/ID (team doesn't exist): 404
    - Insufficient privileges: 403

Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
