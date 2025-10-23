---
external help file: ado.core-help.xml
Module Name: ado.core
online version: https://learn.microsoft.com/azure/devops
schema: 2.0.0
---

# Get-ADOTeamList

## SYNOPSIS
Gets a list of all teams in an Azure DevOps organization.

## SYNTAX

```
Get-ADOTeamList [-Organization] <String> [-Token] <String> [-Mine] [[-Top] <Int32>] [[-Skip] <Int32>]
 [-ExpandIdentity] [[-ApiVersion] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function uses the \`Invoke-ADOApiRequest\` function to call the Azure DevOps Core REST API (7.2-preview.3) and retrieve all teams in the specified organization.
Supports optional filtering and paging parameters.

## EXAMPLES

### EXAMPLE 1
```
Get-ADOTeamList -Organization "fabrikam" -Token $token
```

Gets all teams in the 'fabrikam' organization.

### EXAMPLE 2
```
Get-ADOTeamList -Organization "fabrikam" -Token $token -Mine -Top 10
```

Gets up to 10 teams the current user is a member of in the 'fabrikam' organization.

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

### -Mine
If set, returns only teams the requesting user is a member of.

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

### -Top
Maximum number of teams to return.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Skip
Number of teams to skip.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExpandIdentity
If set, expands identity information in the result.

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

### System.Object[]
## NOTES
This function follows PSFramework best practices for logging and error handling.

Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
