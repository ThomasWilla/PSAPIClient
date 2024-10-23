function Set-APIoAuth2Configuration {
    [CmdletBinding()]
    param (
        # Parameter help deprivateion
        [Parameter(Mandatory = $true)]
        [string]
        $ClientID,
        # Parameter help deprivateion
        [Parameter(Mandatory = $true)]
        [string]
        $ClientSecret, 
        # Parameter help deprivateion
        [Parameter(Mandatory = $true)]
        [string]
        $TokenEndpoint,
        # Parameter help deprivateion
        [Parameter(Mandatory = $false)]
        [string]
        $APIEndpoint,
        [Parameter(ParameterSetName = "create_new")]
        [string]
        $InstanceName = $null
    )
        
    DynamicParam {
        # ArrayList mit erlaubten Werten für das ValidateSet
        $validateList = get-APIRunningInstanceOAuth2
    
        # Dynamische Parameter-Definition
        $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
    
        # Erstellen des Parameter-Attributes inklusive ValidateSet
        $attributes = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $paramAttribute = New-Object System.Management.Automation.ParameterAttribute
        $paramAttribute.Mandatory = $false
        $paramAttribute.ParameterSetName = "select_one"
        $attributes.Add($paramAttribute)
    
        # ValidateSet aus den Werten der ArrayList erstellen
        $validateSet = New-Object System.Management.Automation.ValidateSetAttribute($validateList)
        $attributes.Add($validateSet)
        
        # Dynamischen Parameter definieren
        $dynamicParam = New-Object System.Management.Automation.RuntimeDefinedParameter(
            'SelectRunningInstance', # Name des Parameters
            [string], # Typ des Parameters
            $attributes      # Attribute des Parameters (ParameterAttribute + ValidateSet)
        )
    
        # Parameter zum Dictionary hinzufügen
        $paramDictionary.Add('SelectRunningInstance', $dynamicParam)
    
        return $paramDictionary
    }#End Dynamic Parameter
    
    
    begin {

        switch ($PSCmdlet.ParameterSetName) {
            "select_one" { $Instance =  $($PSCmdlet.MyInvocation.BoundParameters['SelectRunningInstance']);break }
            "create_new" { $Instance = "PSAPIClient_${InstanceName}"; break }
            Default { $Instance = "PSAPIClient_DEFAULT"}
        }
        
        #set Instance Variable Name with PSAPI-Prefix
      

        Write-Host $Instance

        # Check if exsits the Instance Session Variable

        try {
            Get-Variable -Scope global -name PSAPIClient_AvailablieInstanceOAUT2 -ErrorAction Stop
        }
        catch {
            $global:PSAPIClient_AvailablieInstanceOAUT2 = [System.Collections.ArrayList]::new()
        }
    }       
        

    
    process {

        if (!($global:PSAPIClient_AvailablieInstanceOAUT2.InstanceName -eq ${Instance})) {
            #Create Class Instance
            $APICLIENT = [APIClientOAuth2]::new()
            $APICLIENT.SessionInformation.APIClientInstanceName = $Instance
            $AddInstance = [pscustomobject]@{
                InstanceName   = ${Instance}
                InstanceObject = $APICLIENT 


            }

            $global:PSAPIClient_AvailablieInstanceOAUT2.add($AddInstance) | Out-Null
        }
        
        $APICLIENT = get-APIInstanceObjectOAuth2 -instance $Instance

        #Set Session Information
        $APICLIENT.SetAPIoAuth2Configuration($ClientID, $ClientSecret, $TokenEndpoint, $APIEndpoint)
        
    }
    
    end {
        
    }
}