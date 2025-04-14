---
external help file: ado.core-help.xml
Module Name: ado.core
online version:
schema: 2.0.0
---

# Remove-ADOWorkItem

## SYNOPSIS
Deletes a work item in Azure DevOps.

## SYNTAX

```
Remove-ADOWorkItem [-Organization] <String> [[-Project] <String>] [-Token] <String> [-Id] <Int32> [-Destroy]
 [[-ApiVersion] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function deletes a specified work item in Azure DevOps and sends it to the Recycle Bin.
Optionally, the work item can be permanently destroyed if the \`Destroy\` parameter is set to \`$true\`.
**WARNING**: If \`Destroy\` is set to \`$true\`, the deletion is permanent and cannot be undone.

## EXAMPLES

### EXAMPLE 1
```
# Example 1: Delete a work item and send it to the Recycle Bin
```

Remove-ADOWorkItem -Organization "my-org" -Project "my-project" -Token "my-token" -Id 12345

### EXAMPLE 2
```
# Example 2: Permanently delete a work item
```

Remove-ADOWorkItem -Organization "my-org" -Project "my-project" -Token "my-token" -Id 12345 -Destroy $true

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
The ID of the work item to delete.

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

### -Destroy
(Optional) Indicates if the work item should be permanently destroyed.
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

### -ApiVersion
(Optional) The API version to use.
Default is \`$Script:ADOApiVersion\`.

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
Author: Oleksandr Nikolaiev (@onikolaiev)

This function is part of the ADO Tools module and adheres to the conventions used in the module for logging, error handling, and API interaction.

## RELATED LINKS
