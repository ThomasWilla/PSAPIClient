function Get-APIoAuth2AccessToken {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $RefreshToken
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
        $APICLIENT = get-APIInstanceObjectOAuth2 -instance $Instance

        $body = @{
            grant_type    = "refresh_token"
            refresh_token = $RefreshToken
            client_id     = $APICLIENT.oAutth2APIConfig.ClientId
            client_secret = $APICLIENT.oAutth2APIConfig.ClientSecret
        }
        
    }
    
    process {

        try {
            #check Powershell Version
            if ($APICLIENT.SessionInformation.PSMajorVersion  -gt 5) {
                $response = Invoke-RestMethod -Uri $APICLIENT.oAutth2APIConfig.TokenEndpoint -Method Post -Body $body -ContentType "application/x-www-form-urlencoded" -Proxy $APICLIENT.SessionInformation.ProxyURL -UseDefaultCredentials:$APICLIENT.SessionInformation.ProxyUseDefaultCredentials
            }
            else {
                $response = Invoke-RestMethod -Uri $APICLIENT.oAutth2APIConfig.TokenEndpoint -Method Post -Body $body -ContentType "application/x-www-form-urlencoded" -UseBasicParsing  -Proxy $APICLIENT.SessionInformation.ProxyURL  -UseDefaultCredentials:$APICLIENT.SessionInformation.ProxyUseDefaultCredentials
            }            
            $APICLIENT.oAuth2TokenInformation = @{
                AccessToken  = $response.access_token
                RefreshToken = $response.refresh_token
                TokenType    = $response.token_type
                ExpiresAt    = (Get-Date).AddSeconds($response.expires_in)
            }
        }
        catch {
            Write-Error "Fehler beim Abrufen des Tokens: $_" 
        }
        
    }
    
    end {
        
    }
}