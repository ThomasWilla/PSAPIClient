function Set-APIoAuth2Configuration {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $ClientID,
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $ClientSecret, 
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $TokenEndpoint,
        # Parameter help description
        [Parameter(Mandatory = $false)]
        [string]
        $APIEndpoint
    )
    
    begin {
        $Global:oAutth2APIConfig = @{
            ClientId      = $ClientId
            ClientSecret  = $ClientSecret
            TokenEndpoint = $TokenEndpoint
            ApiEndpoint   = $APIEndpoint
        }


    }
    
    process {
        
        
    }
    
    end {
        
    }
}