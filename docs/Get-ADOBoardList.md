---
external help file: ado.core-help.xml
Module Name: ado.core
online version:
schema: 2.0.0
---

# Get-ADOBoardList

## SYNOPSIS
Gets a list of boards from an Azure DevOps team.

## SYNTAX

```
Get-ADOBoardList [-Organization] <String> [-Project] <String> [[-Team] <String>] [-Token] <String>
 [[-ApiVersion] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function uses the \`Invoke-ADOApiRequest\` function to call the Azure DevOps Work REST API (7.2-preview.1) and retrieve boards for a specified team in a project.

## EXAMPLES

### EXAMPLE 1
```
Get-ADOBoardList -Organization "fabrikam" -Project "WebApp" -Team "Quality Assurance" -Token $token
```

Gets all boards for the "Quality Assurance" team in the "WebApp" project.

### EXAMPLE 2
```
Get-ADOBoardList -Organization "fabrikam" -Project "eb6e4656-77fc-42a1-9181-4c6d8e9da5d1" -Token $token
```

Gets all boards for the default team in the specified project.

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

### -Team
Team ID or team name (optional).

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
Default is "7.2-preview.1".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
