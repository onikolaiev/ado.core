﻿---
external help file: ado.core-help.xml
Module Name: ado.core
online version:
schema: 2.0.0
---

# Move-ADOWorkItemTypeGroupToSection

## SYNOPSIS
Moves a group to a different section.

## SYNTAX

```
Move-ADOWorkItemTypeGroupToSection [-Organization] <String> [-Token] <String> [-ProcessId] <String>
 [-WitRefName] <String> [-PageId] <String> [-SectionId] <String> [-GroupId] <String>
 [-RemoveFromSectionId] <String> [-Body] <String> [[-ApiVersion] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This function uses the \`Invoke-ADOApiRequest\` function to call the Azure DevOps REST API and move a group to a new section in a specified work item type.

## EXAMPLES

### EXAMPLE 1
```
$body = @"
{
    "id": "faf0f718-776c-422a-9424-3c5f7952901c",
    "label": "NewGroup1",
    "controls": null,
    "order": 1,
    "visible": true,
    "contribution": null,
    "isContribution": false,
    "height": null
}
"@
```

Move-ADOWorkItemTypeGroupToSection -Organization "fabrikam" -Token "my-token" -ProcessId "906c7065-2a04-4f61-aac1-b5da9cef040b" -WitRefName "MyNewAgileProcess.ChangeRequest" -PageId "page-id" -SectionId "new-section-id" -GroupId "group-id" -RemoveFromSectionId "old-section-id" -Body $body

Moves the specified group to a new section.

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

### -ProcessId
The ID of the process.

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

### -WitRefName
The reference name of the work item type.

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

### -PageId
The ID of the page the group is in.

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

### -SectionId
The ID of the section to move the group to.

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

### -GroupId
The ID of the group to move.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoveFromSectionId
The ID of the section to remove the group from.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
The JSON string containing the properties for the group to move.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiVersion
The version of the Azure DevOps REST API to use.
Default is "7.1".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
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
