@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in =Preparation= & :Upgrade & :Reset_dl-bat & :setting_GlobalProxy & :setting_Wget ;
:: Used for "res\scripts\Download.bat" in :Download_wget
:: Pay attention to %cd% limit according to each Function.
:: e.g.
:: call res\scripts\Getter.bat GlobalProxy
:: call res\scripts\Getter.bat InfoOpt6
:: call scripts\Getter.bat DeployMode
:: call scripts\Getter.bat WgetOptions

@echo off
call :Get_%~1
goto :eof


rem ================= FUNCTIONS =================


:: %cd%: "%root%"
:: Get %_Language_% , %_Region_% , %_SystemType_%
:Get_Main
:: 1. Get customized %_Language_%, or decided by "LanguageSelector"
if exist res\deploy.settings (
    for /f "tokens=2 delims= " %%i in ('findstr /i "Language" res\deploy.settings') do ( set "_Language_=%%i" )
) else ( call res\scripts\LanguageSelector.bat )
:: 2. Import translation text, and set the default %_Region_%
call res\scripts\lang_%_Language_%.bat
:: 3. Get %_SystemType_% by "SystemTypeSelector"
call res\scripts\SystemTypeSelector.bat
:: 4. Overwrite the default %_Region_% and %_SystemType_% if customized
if exist res\deploy.settings (
    for /f "tokens=2 delims= " %%i in ('findstr /i "Region" res\deploy.settings') do ( set "_Region_=%%i" )
    for /f "tokens=2 delims= " %%i in ('findstr /i "SystemType" res\deploy.settings') do ( set "_SystemType_=%%i" )
)
goto :eof


:: %cd%: "%root%"
:: Get the proxy settings of CMD from "res\deploy.settings"
:Get_GlobalProxy
if exist res\deploy.settings (
    for /f "tokens=2 delims= " %%i in ('findstr /i "GlobalProxy" res\deploy.settings') do ( set "state_globalProxy=%%i" )
    for /f "tokens=2 delims= " %%i in ('findstr /i "ProxyHost" res\deploy.settings') do ( set "_proxyHost=%%i" )
    for /f "tokens=2 delims= " %%i in ('findstr /i "HttpPort" res\deploy.settings') do ( set "_httpPort=%%i" )
    for /f "tokens=2 delims= " %%i in ('findstr /i "HttpsPort" res\deploy.settings') do ( set "_httpsPort=%%i" )
) else ( set "state_globalProxy=disable" )
goto :eof


:: %cd%: "res\"
:: Get %DeployMode% from "res\deploy.log"
:Get_DeployMode
if exist deploy.log (
    for /f "tokens=2 delims= " %%i in ('findstr /i "DeployMode" deploy.log') do ( set "DeployMode=%%i" )
) else ( set "DeployMode=unknown" )
goto :eof


:: %cd%: "res\"
:: Get default options for 'wget.exe' from "res\wget.opt" -> %_WgetOptions_%
:Get_WgetOptions
if exist wget.opt (
    for /f "eol=# delims=" %%i in (wget.opt) do ( set "_WgetOptions_=%%i" && goto :eof )
) else ( set "_WgetOptions_=-q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc" )
goto :eof


:: %cd%: "%root%"
:: Get %opt3_info% according to "res\deploy.log"
:Get_InfoOpt3
set "opt3_info="
if exist res\deploy.log (
    pushd res && call :Get_DeployMode && popd
    if "!DeployMode!"=="portable" set "opt3_info=(you-get,youtube-dl,lux)"
    if "!DeployMode!"=="quickstart" set "opt3_info=(you-get)"
    if "!DeployMode!"=="withpip" set "opt3_info=(you-get,youtube-dl,lux)"
)
goto :eof


:: %cd%: "%root%"
:: Get %opt4_info% according to "Download_Video.bat"
:: call "res\scripts\lang_*.bat" before calling this function.
:Get_InfoOpt4
set "opt4_info="
if exist %str_dl-bat%.bat (
    for /f "tokens=2 delims==" %%i in ('findstr /i "_versionAtCreation=" %str_dl-bat%.bat') do ( set "_versionAtCreation=%%~i" )
    set "_versionAtCreation=!_versionAtCreation:~0,-1!"
    REM If "_versionAtCreation" is not found, "%_versionAtCreation%" will be "~0,-1".  Next statement will still be executed.
    if NOT "!_versionAtCreation!"=="%_Version_%" ( set "opt4_info=%str_please-perform-after-update%" )
)
goto :eof


:: %cd%: No limit
:: Get %opt6_info% according to :Get_GlobalProxy ; Apply the proxy settings if GlobalProxy is enabled.
:: call :Get_GlobalProxy and "res\scripts\lang_*.bat" before calling this function.
:Get_InfoOpt6
if "%state_globalProxy%"=="enable" (
    set "http_proxy=%_proxyHost%:%_httpPort%"
    set "https_proxy=%_proxyHost%:%_httpsPort%"
    set "opt6_info=(%str_globalProxy-enabled%)"
) else ( set "opt6_info=" )
goto :eof


rem ================= End of File =================
