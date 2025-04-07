function Confirm-APIoAuth2Token {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        if ([string]::IsNullOrEmpty($APICLIENT.oAuth2TokenInformation.RefreshToken) -or (Get-Date) -ge $APICLIENT.oAuth2TokenInformation.ExpiresAt) {
            
            Get-APIoAuth2AccessToken -RefreshToken $APICLIENT.oAuth2TokenInformation.RefreshToken -SelectRunningInstance $APICLIENT.SessionInformation.APIClientInstanceName
        }
    }
    
    end {
        
    }
}