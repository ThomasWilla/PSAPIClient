# PSAPIClient

This Powershell module is a wrapper for the use of one or more API(s). Each API can be configured and addressed independently. This allows easy use of multiple APIs within a session.

## Current support
- Dynamic selection of initialized APIs
- oAuth2 (incl. automatic refresh when the token expires)
- Proxy Function

## Planned extension (when i need)
- Basic Auth
- Logging

# Use this Module

**Download this Module**
```
git clone https://github.com/ThomasWilla/PSAPIClient.git -single-branch
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
Invoke-APIoAuth2WebRequest -SelectRunningInstance SELECT_YOUR_INSTANCE -Method GET/POST/PUT -ResourcePath "api/v2/anyressource" -Body YOUR_CUSTOM_BODY_WHEN_REQUIRED
```

**Get any Session, Token and API Information from the API Instance**
```
Get-APIoAuth2SessionInformation -SelectRunningInstance SELECT_YOUR_INSTANCE 
```

## Changelog
23.10.2024: oAuth2 Integration
26.10.2024: Proxy function

## Authors

* **Thomas Willa** - *Initial work* - [ThomasWilla](https://github.com/ThomasWilla)

See also the list of [contributors](https://github.com/ThomasWilla/PSHardwareMonitoring/graphs/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
