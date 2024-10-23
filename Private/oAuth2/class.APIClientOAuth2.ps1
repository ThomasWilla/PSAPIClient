class APIClientOAuth2 {

    #properties
    [hashtable]$oAutth2APIConfig = @{
        ClientId      = ''
        ClientSecret  = ''
        TokenEndpoint = ''
        ApiEndpoint   = ''
    }

    [hashtable]$oAuth2TokenInformation = @{
        AccessToken  = ''
        RefreshToken = ''
        TokenType    = ''
        ExpiresAt    = ''
    }

    [hashtable]$SessionInformation = @{
        PSMajorVersion = ''
        APIClientInstanceName = ''
    }

    #Constructor
    APIClientOAuth2() {
        $this.SessionInformation.PSMajorVersion = (Get-Host).Version.Major #$PSVersionTable not working in Class
    }
    
    #Methods

    [void]SetAPIoAuth2Configuration(
        [string]$ClientID,
        [string]$ClientSecret,
        [string]$TokenEndpoint,
        [string]$APIEndpoint
    ) {
    
        $this.oAutth2APIConfig = @{
            ClientId      = $ClientId
            ClientSecret  = $ClientSecret
            TokenEndpoint = $TokenEndpoint
            ApiEndpoint   = $APIEndpoint
        }

    }#end SetAPIoAuth2Configuration


    [void] GetAPIoAuth2AccessToken(
        [string]$RefreshToken
    ) {

        [hashtable]$body = @{
            grant_type    = "refresh_token"
            refresh_token = $RefreshToken
            client_id     = $this.oAutth2APIConfig.ClientId
            client_secret = $this.oAutth2APIConfig.ClientSecret
        }
    
        try {
            #check Powershell Version
            if (($this.SessionInformation.PSMajorVersion) -gt 5) {
                $response = Invoke-RestMethod -Uri $this.oAutth2APIConfig.TokenEndpoint -Method Post -Body $body -ContentType "application/x-www-form-urlencoded"  -ErrorAction  Stop
                if ([string]::IsNullOrEmpty($response.access_token)) {
                    throw
                }
            }
            else {
                $response = Invoke-RestMethod -Uri $this.oAutth2APIConfig.TokenEndpoint -Method Post -Body $body -ContentType "application/x-www-form-urlencoded" -UseBasicParsing  -ErrorAction  Stop
                if ([string]::IsNullOrEmpty($response.access_token)) {
                    throw
                }
            }            

            $this.oAuth2TokenInformation = @{
                AccessToken  = $response.access_token
                RefreshToken = $response.refresh_token
                TokenType    = $response.token_type
                ExpiresAt    = (Get-Date).AddSeconds($response.expires_in)
            }
        }
        catch {
            Write-Error "Fehler beim Abrufen des Tokens: $($_.Exception)" 
        }


    }#end GetAPIoAuth2AccessToken

    [void]ConfirmAPIoAuth2Token() {
        if ([string]::IsNullOrEmpty($this.oAuth2TokenInformation) -or (Get-Date) -ge $this.oAuth2TokenInformation.ExpiresAt) {
            
            Get-APIoAuth2AccessToken -RefreshToken $this.oAuth2TokenInformation.RefreshToken
        }

    }


    [PSCustomObject]InvokeAPIClientRquest(
        [string]$ResourcePath,
        [string]$Method = 'GET',
        $Body = @{}
    ) {

        try {
            $header = @{
                Authorization = "$($this.oAuth2TokenInformation.TokenType) $($this.oAuth2TokenInformation.AccessToken)"
            }
            #check Powershell Version
            if ($this.SessionInformation.PSMajorVersion -gt 5) {
                $response = Invoke-RestMethod -Uri "$($this.oAutth2APIConfig.ApiEndpoint)/$ResourcePath" -Method $Method -Headers $header -Body $Body -ContentType "application/json" -ErrorAction Stop
            }
            else {
                $response = Invoke-RestMethod -Uri "$($this.oAutth2APIConfig.ApiEndpoint)/$ResourcePath" -Method $Method -Headers $header -Body $Body -ContentType "application/json" -UseBasicParsing -ErrorAction Stop
            }
        }
        catch {
            Write-Error "Fehler beim API Aufruf: $_"
            $response = $_
        }

        return $response

    }


}#end class