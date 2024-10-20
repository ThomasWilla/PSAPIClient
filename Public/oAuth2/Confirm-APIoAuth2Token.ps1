function Confirm-APIoAuth2Token {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        if ([string]::IsNullOrEmpty($Global:oAuth2TokenInformation) -or (Get-Date) -ge $Global:oAuth2TokenInformation.ExpiresAt) {
            
            Get-oAuth2APIAccessToken -RefreshToken $Global:oAuth2TokenInformation.refresh_token
        }
    }
    
    end {
        
    }
}