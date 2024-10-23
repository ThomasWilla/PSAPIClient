# PSAPIClient

This Powershell module is a wrapper for the use of one or more API(s). Each API can be configured and addressed independently. This allows easy use of multiple APIs within a session.

## Current support :
- Dynamic selection of initialized APIs
- oAuth2 (incl. automatic refresh when the token expires)

## Planned extension
- Basic Auth
- Proxy Function
- Logging

## Use this Module

**Download this Module**
```
git clone https://github.com/ThomasWilla/PSAPIClient.git
```

**Import Module**
```
import-module  'PATH TO MODULE\PSAPIClient\PSAPIClient.psd1'
```

**Initial one ore more API Instance**
```
Set-APIoAuth2Configuration -ClientID YOUR_CLIENT_ID -ClientSecret YOUR_CLIENT_SECRET -TokenEndpoint YOUR_TOKEN_ENDPOINT_URL -APIEndpoint YOUR_API_ENDPOINT_URL -Instance YOUR_INSTANCE_NAME
```

**Get the Access Token from API Instance**
```
Get-APIoAuth2AccessToken -SelectRunningInstance SELECT_YOUR_INSTANCE -RefreshToken YOUR_TOKEN
```

**Invoke Rest Call to the API Instance**
```
Invoke-APIClientRquest -SelectRunningInstance SELECT_YOUR_INSTANCE -Method GET/POST/PUT -ResourcePath "api/v2/anyressource" -Body YOUR_CUSTOM_BODY_WHEN_REQUIRED
```

**Get any Session, Token and API Information from the API Instance**

Get-APIoAuth2SessionInformation -SelectRunningInstance SELECT_YOUR_INSTANCE 
