function Get-APIoAuth2AccessToken {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $RefreshToken
    )
    
    begin {
        $body = @{
            grant_type    = "refresh_token"
            refresh_token = $RefreshToken
            client_id     = $Global:oAutth2APIConfig.ClientId
            client_secret = $Global:oAutth2APIConfig.ClientSecret
        }
    }
    
    process {

        try {
            #check Powershell Version
            if ($psversiontable.PSVersion.Major -gt 5){
                $response = Invoke-RestMethod -Uri $Global:APIConfig.TokenEndpoint -Method Post -Body $body -ContentType "application/x-www-form-urlencoded"
            }
            else {
                $response = Invoke-RestMethod -Uri $Global:APIConfig.TokenEndpoint -Method Post -Body $body -ContentType "application/x-www-form-urlencoded" -UseBasicParsing
            }            
            $Global:oAuth2TokenInformation = @{
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