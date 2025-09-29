Describe "Add-ADOWorkItemQuery Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Add-ADOWorkItemQuery).ParameterSets.Name | Should -Be 'Create', 'Move'
		}
		
		It 'Should have the expected parameter Organization' {
			$parameter = (Get-Command Add-ADOWorkItemQuery).Parameters['Organization']
			$parameter.Name | Should -Be 'Organization'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Project' {
			$parameter = (Get-Command Add-ADOWorkItemQuery).Parameters['Project']
			$parameter.Name | Should -Be 'Project'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Token' {
			$parameter = (Get-Command Add-ADOWorkItemQuery).Parameters['Token']
			$parameter.Name | Should -Be 'Token'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter ParentPath' {
			$parameter = (Get-Command Add-ADOWorkItemQuery).Parameters['ParentPath']
			$parameter.Name | Should -Be 'ParentPath'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Name' {
			$parameter = (Get-Command Add-ADOWorkItemQuery).Parameters['Name']
			$parameter.Name | Should -Be 'Name'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Create'
			$parameter.ParameterSets.Keys | Should -Contain 'Create'
			$parameter.ParameterSets['Create'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Create'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Create'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Create'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Create'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Folder' {
			$parameter = (Get-Command Add-ADOWorkItemQuery).Parameters['Folder']
			$parameter.Name | Should -Be 'Folder'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Create'
			$parameter.ParameterSets.Keys | Should -Contain 'Create'
			$parameter.ParameterSets['Create'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Create'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Create'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Create'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Create'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Wiql' {
			$parameter = (Get-Command Add-ADOWorkItemQuery).Parameters['Wiql']
			$parameter.Name | Should -Be 'Wiql'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Create'
			$parameter.ParameterSets.Keys | Should -Contain 'Create'
			$parameter.ParameterSets['Create'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Create'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Create'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Create'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Create'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter QueryType' {
			$parameter = (Get-Command Add-ADOWorkItemQuery).Parameters['QueryType']
			$parameter.Name | Should -Be 'QueryType'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Create'
			$parameter.ParameterSets.Keys | Should -Contain 'Create'
			$parameter.ParameterSets['Create'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Create'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Create'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Create'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Create'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Columns' {
			$parameter = (Get-Command Add-ADOWorkItemQuery).Parameters['Columns']
			$parameter.Name | Should -Be 'Columns'
			$parameter.ParameterType.ToString() | Should -Be System.String[]
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Create'
			$parameter.ParameterSets.Keys | Should -Contain 'Create'
			$parameter.ParameterSets['Create'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Create'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Create'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Create'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Create'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter SortColumns' {
			$parameter = (Get-Command Add-ADOWorkItemQuery).Parameters['SortColumns']
			$parameter.Name | Should -Be 'SortColumns'
			$parameter.ParameterType.ToString() | Should -Be System.String[]
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Create'
			$parameter.ParameterSets.Keys | Should -Contain 'Create'
			$parameter.ParameterSets['Create'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Create'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Create'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Create'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Create'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Public' {
			$parameter = (Get-Command Add-ADOWorkItemQuery).Parameters['Public']
			$parameter.Name | Should -Be 'Public'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Create'
			$parameter.ParameterSets.Keys | Should -Contain 'Create'
			$parameter.ParameterSets['Create'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['Create'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Create'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Create'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Create'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Id' {
			$parameter = (Get-Command Add-ADOWorkItemQuery).Parameters['Id']
			$parameter.Name | Should -Be 'Id'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Move'
			$parameter.ParameterSets.Keys | Should -Contain 'Move'
			$parameter.ParameterSets['Move'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Move'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Move'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Move'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Move'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter ValidateWiqlOnly' {
			$parameter = (Get-Command Add-ADOWorkItemQuery).Parameters['ValidateWiqlOnly']
			$parameter.Name | Should -Be 'ValidateWiqlOnly'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.SwitchParameter
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter ApiVersion' {
			$parameter = (Get-Command Add-ADOWorkItemQuery).Parameters['ApiVersion']
			$parameter.Name | Should -Be 'ApiVersion'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter ProgressAction' {
			$parameter = (Get-Command Add-ADOWorkItemQuery).Parameters['ProgressAction']
			$parameter.Name | Should -Be 'ProgressAction'
			$parameter.ParameterType.ToString() | Should -Be System.Management.Automation.ActionPreference
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be '__AllParameterSets'
			$parameter.ParameterSets.Keys | Should -Contain '__AllParameterSets'
			$parameter.ParameterSets['__AllParameterSets'].IsMandatory | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].Position | Should -Be -2147483648
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['__AllParameterSets'].ValueFromRemainingArguments | Should -Be $False
		}
	}
	
	Describe "Testing parameterset Create" {
		<#
		Create -Organization -Project -Token -ParentPath -Name
		Create -Organization -Project -Token -ParentPath -Name -Folder -Wiql -QueryType -Columns -SortColumns -Public -ValidateWiqlOnly -ApiVersion -ProgressAction
		#>
	}
 	Describe "Testing parameterset Move" {
		<#
		Move -Organization -Project -Token -ParentPath -Id
		Move -Organization -Project -Token -ParentPath -Id -ValidateWiqlOnly -ApiVersion -ProgressAction
		#>
	}

}