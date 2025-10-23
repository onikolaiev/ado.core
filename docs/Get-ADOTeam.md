---
external help file: ado.core-help.xml
Module Name: ado.core
online version: https://learn.microsoft.com/azure/devops
schema: 2.0.0
---

# Get-ADOTeam

## SYNOPSIS
Gets a specific team from an Azure DevOps project.

## SYNTAX

```
Get-ADOTeam [-Organization] <String> [-ProjectId] <String> [-TeamId] <String> [-Token] <String>
 [-ExpandIdentity] [[-ApiVersion] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function uses the \`Invoke-ADOApiRequest\` function to call the Azure DevOps Core REST API (7.2-preview.3) and retrieve a specific team by its ID or name from a project.

## EXAMPLES

### EXAMPLE 1
```
Get-ADOTeam -Organization "fabrikam" -ProjectId "WebApp" -TeamId "Quality assurance" -Token $token
```

Gets the "Quality assurance" team from the "WebApp" project in the "fabrikam" organization.

### EXAMPLE 2
```
Get-ADOTeam -Organization "fabrikam" -ProjectId "eb6e4656-77fc-42a1-9181-4c6d8e9da5d1" -TeamId "564e8204-a90b-4432-883b-d4363c6125ca" -Token $token -ExpandIdentity
```

Gets a specific team by GUID with expanded identity information.

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
The name or ID (GUID) of the team project containing the team.

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
The name or ID (GUID) of the team.

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

### -ExpandIdentity
If set, expands identity information in the result WebApiTeam object.

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

### System.Object
## NOTES
This function follows PSFramework best practices for logging and error handling.

Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
