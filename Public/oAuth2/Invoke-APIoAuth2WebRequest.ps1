function Invoke-APIoAuth2WebRequest {
    [CmdletBinding()]
    param (
        # Der API-Endpunkt
        [Parameter(Mandatory = $true)]
        [string]
        $ResourcePath,
        # Standardmethode GET
        [Parameter(Mandatory = $false)]
        [string]
        $Method = 'GET',
        # Optionaler Body für POST/PUT
        [Parameter(Mandatory = $false)]
        [hashtable]
        $Body = @{},
        # Add Custom Setting to Header
        [Parameter(Mandatory = $false)]
        [hashtable]
        $AddCustomHeaderSettings
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
        $instance = $($PSCmdlet.MyInvocation.BoundParameters['SelectRunningInstance'])
        $APICLIENT = get-APIInstanceObjectOAuth2 -instance $instance
    }
    
    process {

        Confirm-APIoAuth2Token

        try {
            $header = @{
                Authorization = "$($APICLIENT.oAuth2TokenInformation.TokenType) $($APICLIENT.oAuth2TokenInformation.AccessToken)"
            }
            #check if we have custom Header Settings
            if ($AddCustomHeaderSettings.Count -gt 0) {
                $header += $AddCustomHeaderSettings
            }            

            #check Powershell Version
            if ($APICLIENT.SessionInformation.PSMajorVersion -gt 5) {
                $response = Invoke-RestMethod -Uri "$($APICLIENT.oAutth2APIConfig.ApiEndpoint)/$ResourcePath" -Method $Method -Headers $header -Body $Body -ContentType "application/json"  -Proxy $APICLIENT.SessionInformation.ProxyURL -ProxyUseDefaultCredentials:$APICLIENT.SessionInformation.ProxyUseDefaultCredentials
            }
            else {
                $response = Invoke-RestMethod -Uri "$($APICLIENT.oAutth2APIConfig.ApiEndpoint)/$ResourcePath" -Method $Method -Headers $header -Body $Body -ContentType "application/json" -UseBasicParsing  -Proxy $APICLIENT.SessionInformation.ProxyURL -ProxyUseDefaultCredentials:$APICLIENT.SessionInformation.ProxyUseDefaultCredentials
            }
        }
        catch {
            Write-Error "Fehler beim API Aufruf: $_"
            $response = $_
        }
        
        
    }
    
    end {
        return $response
    }
}