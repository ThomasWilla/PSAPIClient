function Invoke-ClientRquest {
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
        [string]
        $Body = $null
    )
    
    begin {
        
    }
    
    process {

        Validate-APIoAuth2Token

        try {
            $header = @{
                Authorization = "$($Global:oAuth2TokenInformation.TokenType) $($Global:oAuth2TokenInformation.access_token)"
            }

            $response = Invoke-RestMethod -Uri "$($Global:oAutth2APIConfig.ApiEndpoint)/$ResourcePath" -Method $Method -Headers $header -Body $Body -ContentType "application/json"
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