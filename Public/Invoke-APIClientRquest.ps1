function Invoke-APIClientRquest {
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
        $Body = @{}
    )
    
    begin {
        
    }
    
    process {

        Confirm-APIoAuth2Token

        try {
            $header = @{
                Authorization = "$($Global:oAuth2TokenInformation.TokenType) $($Global:oAuth2TokenInformation.AccessToken)"
            }
            #check Powershell Version
            if ($psversiontable.PSVersion.Major -gt 5){
                $response = Invoke-RestMethod -Uri "$($Global:oAutth2APIConfig.ApiEndpoint)/$ResourcePath" -Method $Method -Headers $header -Body $Body -ContentType "application/json"
            }
            else {
                $response = Invoke-RestMethod -Uri "$($Global:oAutth2APIConfig.ApiEndpoint)/$ResourcePath" -Method $Method -Headers $header -Body $Body -ContentType "application/json" -UseBasicParsing
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