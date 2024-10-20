function Validate-APIoAuth2Token {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        if ($Global:oAuth2TokenInformation -eq $null -or (Get-Date) -ge $Global:oAuth2TokenInformation.ExpiresAt) {
            
            Get-oAuth2APIAccessToken -RefreshToken $Global:oAuth2TokenInformation.refresh_token
        }
    }
    
    end {
        
    }
}