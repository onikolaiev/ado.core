---
external help file: ado.core-help.xml
Module Name: ado.core
online version:
schema: 2.0.0
---

# Get-ADOSourceWorkItemsList

## SYNOPSIS
Retrieves and processes work items from a source Azure DevOps project.

## SYNTAX

```
Get-ADOSourceWorkItemsList [-SourceOrganization] <String> [-SourceProjectName] <String> [-SourceToken] <String>
 [[-Fields] <Array>] [[-ApiVersion] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function retrieves work items from a source Azure DevOps project using a WIQL query, splits them into batches of 200, and processes them to extract detailed information.

## EXAMPLES

### EXAMPLE 1
```
# Example: Retrieve and process work items from a source project
```

Get-ADOSourceWorkItemsList -SourceOrganization "source-org" -SourceProjectName "source-project" -SourceToken "source-token"

## PARAMETERS

### -SourceOrganization
The name of the source Azure DevOps organization.

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

### -SourceProjectName
The name of the source Azure DevOps project.

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

### -SourceToken
The personal access token (PAT) for the source Azure DevOps organization.

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

### -Fields
(Optional) The fields to retrieve for each work item.
Default is a set of common fields including ID, Title, Description, WorkItemType, State, and Parent.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: @("System.Id", "System.Title", "System.Description", "System.WorkItemType", "System.State", "System.Parent")
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiVersion
(Optional) The API version to use.
Default is \`7.1\`.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 7.1
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
This function is part of the ADO Tools module and adheres to the conventions used in the module for logging, error handling, and API interaction.

Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
