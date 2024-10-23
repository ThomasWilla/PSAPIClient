function Get-APIoAuth2SessionInformation {
    [CmdletBinding()]
    param (

    )

    DynamicParam {
        # ArrayList mit erlaubten Werten für das ValidateSet
        $validateList = get-APIRunningInstanceOAuth2
    
        # Dynamische Parameter-Definition
        $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
    
        # Erstellen des Parameter-Attributes inklusive ValidateSet
        $attributes = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $paramAttribute = New-Object System.Management.Automation.ParameterAttribute
        $paramAttribute.Mandatory = $true
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

        $instance = $($PSCmdlet.MyInvocation.BoundParameters['SelectRunningInstance'])

        $APICLIENT = get-APIInstanceObjectOAuth2 -instance $instance
        $result = [PSCustomObject]@{
            oAutth2APIConfig = $APICLIENT.oAutth2APIConfig
            oAuth2TokenInformation = $APICLIENT.oAuth2TokenInformation
            SessionInformation = $APICLIENT.SessionInformation
        }
        
        
    }
    
    process {
        
    }
    
    end {
        return $Result
    }
}