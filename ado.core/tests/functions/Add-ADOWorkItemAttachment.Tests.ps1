Describe "Add-ADOWorkItemAttachment Unit Tests" -Tag "Unit" {
	BeforeAll {
		# Place here all things needed to prepare for the tests
	}
	AfterAll {
		# Here is where all the cleanup tasks go
	}
	
	Describe "Ensuring unchanged command signature" {
		It "should have the expected parameter sets" {
			(Get-Command Add-ADOWorkItemAttachment).ParameterSets.Name | Should -Be 'File', 'Content', 'Stream'
		}
		
		It 'Should have the expected parameter Organization' {
			$parameter = (Get-Command Add-ADOWorkItemAttachment).Parameters['Organization']
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
			$parameter = (Get-Command Add-ADOWorkItemAttachment).Parameters['Project']
			$parameter.Name | Should -Be 'Project'
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
		It 'Should have the expected parameter Token' {
			$parameter = (Get-Command Add-ADOWorkItemAttachment).Parameters['Token']
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
		It 'Should have the expected parameter FilePath' {
			$parameter = (Get-Command Add-ADOWorkItemAttachment).Parameters['FilePath']
			$parameter.Name | Should -Be 'FilePath'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'File'
			$parameter.ParameterSets.Keys | Should -Contain 'File'
			$parameter.ParameterSets['File'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['File'].Position | Should -Be -2147483648
			$parameter.ParameterSets['File'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['File'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['File'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Content' {
			$parameter = (Get-Command Add-ADOWorkItemAttachment).Parameters['Content']
			$parameter.Name | Should -Be 'Content'
			$parameter.ParameterType.ToString() | Should -Be System.String
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Content'
			$parameter.ParameterSets.Keys | Should -Contain 'Content'
			$parameter.ParameterSets['Content'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Content'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Content'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Content'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Content'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter Stream' {
			$parameter = (Get-Command Add-ADOWorkItemAttachment).Parameters['Stream']
			$parameter.Name | Should -Be 'Stream'
			$parameter.ParameterType.ToString() | Should -Be System.IO.Stream
			$parameter.IsDynamic | Should -Be $False
			$parameter.ParameterSets.Keys | Should -Be 'Stream'
			$parameter.ParameterSets.Keys | Should -Contain 'Stream'
			$parameter.ParameterSets['Stream'].IsMandatory | Should -Be $True
			$parameter.ParameterSets['Stream'].Position | Should -Be -2147483648
			$parameter.ParameterSets['Stream'].ValueFromPipeline | Should -Be $False
			$parameter.ParameterSets['Stream'].ValueFromPipelineByPropertyName | Should -Be $False
			$parameter.ParameterSets['Stream'].ValueFromRemainingArguments | Should -Be $False
		}
		It 'Should have the expected parameter FileName' {
			$parameter = (Get-Command Add-ADOWorkItemAttachment).Parameters['FileName']
			$parameter.Name | Should -Be 'FileName'
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
		It 'Should have the expected parameter UploadType' {
			$parameter = (Get-Command Add-ADOWorkItemAttachment).Parameters['UploadType']
			$parameter.Name | Should -Be 'UploadType'
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
		It 'Should have the expected parameter AreaPath' {
			$parameter = (Get-Command Add-ADOWorkItemAttachment).Parameters['AreaPath']
			$parameter.Name | Should -Be 'AreaPath'
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
		It 'Should have the expected parameter ApiVersion' {
			$parameter = (Get-Command Add-ADOWorkItemAttachment).Parameters['ApiVersion']
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
			$parameter = (Get-Command Add-ADOWorkItemAttachment).Parameters['ProgressAction']
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
	
	Describe "Testing parameterset File" {
		<#
		File -Organization -Token -FilePath
		File -Organization -Project -Token -FilePath -FileName -UploadType -AreaPath -ApiVersion -ProgressAction
		#>
	}
 	Describe "Testing parameterset Content" {
		<#
		Content -Organization -Token -Content
		Content -Organization -Project -Token -Content -FileName -UploadType -AreaPath -ApiVersion -ProgressAction
		#>
	}
 	Describe "Testing parameterset Stream" {
		<#
		Stream -Organization -Token -Stream
		Stream -Organization -Project -Token -Stream -FileName -UploadType -AreaPath -ApiVersion -ProgressAction
		#>
	}

}