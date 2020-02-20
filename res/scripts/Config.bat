@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in :setting_Proxy & :setting_FFmpeg
:: Please make sure that: only call this batch when %cd% is %root%; call "res\scripts\lang_*.bat" before calling this batch.
:: e.g.
:: call res\scripts\Config.bat Language zh
:: call res\scripts\Config.bat Region origin
:: call res\scripts\Config.bat SystemType
:: call res\scripts\Config.bat ProxyHost http://127.0.0.1
:: call res\scripts\Config.bat FFmpeg

@echo off
setlocal EnableDelayedExpansion
set "cfg_File=deploy.settings"
set "cfg_Extra=%~2"
call :Config_Common
call :Config_%~1
call :Config_Common2
goto :eof


rem ================= FUNCTIONS =================


:: Using the `::` to comment in `if` or `for` structure will cause unpredictable error. Use `REM` instead.


:Config_Common
cd res
if NOT exist %cfg_File% (
    REM Set to default
    ( echo # NEVER EDIT THIS FILE.
    echo Language: %_Language_%
    echo Region: %_Region_%
    echo SystemType: %_SystemType_%
    echo ProxyHint: disable
    echo FFmpeg: enable
    echo NetTest: enable
    echo UpgradeOnlyViaGitHub: disable
    echo GlobalProxy: disable
    echo {
    echo     ProxyHost: http://127.0.0.1
    echo     HttpPort: 1080
    echo     HttpsPort: 1080
    echo })> %cfg_File%
)
copy %cfg_File% %cfg_File%.bak > NUL
type NUL > %cfg_File%
goto :eof


:Config_Common2
del /Q %cfg_File%.bak >NUL 2>NUL
cd ..
goto :eof


:Config_Language
for /f "delims=" %%i in (%cfg_File%.bak) do (
    set "cfg_Content=%%i"
    echo %%i | findstr "Language" >NUL && ( set "cfg_Content=Language: %cfg_Extra%" )
    echo !cfg_Content!>>%cfg_File%
)
call scripts\lang_%cfg_Extra%.bat
echo %str_language-set-to% %cfg_Extra%
echo %str_please-rerun%
goto :eof


:Config_Region
for /f "delims=" %%i in (%cfg_File%.bak) do (
    set "cfg_Content=%%i"
    echo %%i | findstr "Region" >NUL && ( set "cfg_Content=Region: %cfg_Extra%" )
    echo !cfg_Content!>>%cfg_File%
)
echo %str_region-set-to% %cfg_Extra%
echo %str_please-rerun%
goto :eof


:Config_SystemType
for /f "delims=" %%i in (%cfg_File%.bak) do (
    set "cfg_Temp=%%i"
    set "cfg_Content=!cfg_Temp!"
    if "!cfg_Temp!"=="SystemType: 64" ( set "cfg_Content=SystemType: 32" && set "cfg_State=32" )
    if "!cfg_Temp!"=="SystemType: 32" ( set "cfg_Content=SystemType: 64" && set "cfg_State=64" )
    echo !cfg_Content!>>%cfg_File%
)
if "%cfg_State%"=="32" (
    echo %str_systemType-set-to% 32bit
) else echo %str_systemType-set-to% 64bit
goto :eof



:Config_GlobalProxy
for /f "delims=" %%i in (%cfg_File%.bak) do (
    set "cfg_Temp=%%i"
    set "cfg_Content=!cfg_Temp!"
    if "!cfg_Temp!"=="GlobalProxy: disable" ( set "cfg_Content=GlobalProxy: enable" && set "cfg_State=enable" )
    if "!cfg_Temp!"=="GlobalProxy: enable" ( set "cfg_Content=GlobalProxy: disable" && set "cfg_State=disable" )
    echo !cfg_Content!>>%cfg_File%
)
if "%cfg_State%"=="enable" (
    echo %str_globalProxy-enabled%
) else echo %str_globalProxy-disabled%
goto :eof


:Config_ProxyHost
for /f "delims=" %%i in (%cfg_File%.bak) do (
    set "cfg_Content=%%i"
    echo %%i | findstr "ProxyHost" >NUL && ( set "cfg_Content=    ProxyHost: %cfg_Extra%" )
    echo !cfg_Content!>>%cfg_File%
)
goto :eof


:Config_HttpPort
for /f "delims=" %%i in (%cfg_File%.bak) do (
    set "cfg_Content=%%i"
    echo %%i | findstr "HttpPort" >NUL && ( set "cfg_Content=    HttpPort: %cfg_Extra%" )
    echo !cfg_Content!>>%cfg_File%
)
goto :eof


:Config_HttpsPort
for /f "delims=" %%i in (%cfg_File%.bak) do (
    set "cfg_Content=%%i"
    echo %%i | findstr "HttpsPort" >NUL && ( set "cfg_Content=    HttpsPort: %cfg_Extra%" )
    echo !cfg_Content!>>%cfg_File%
)
goto :eof


:Config_ProxyHint
for /f "delims=" %%i in (%cfg_File%.bak) do (
    set "cfg_Temp=%%i"
    set "cfg_Content=!cfg_Temp!"
    if "!cfg_Temp!"=="ProxyHint: disable" ( set "cfg_Content=ProxyHint: enable" && set "cfg_State=enable" )
    if "!cfg_Temp!"=="ProxyHint: enable" ( set "cfg_Content=ProxyHint: disable" && set "cfg_State=disable" )
    echo !cfg_Content!>>%cfg_File%
)
if "%cfg_State%"=="enable" (
    echo %str_proxyHint-enabled%
) else echo %str_proxyHint-disabled%
echo %str_please-rerun-dlbat%
goto :eof


:Config_FFmpeg
for /f "delims=" %%i in (%cfg_File%.bak) do (
    set "cfg_Temp=%%i"
    set "cfg_Content=!cfg_Temp!"
    if "!cfg_Temp!"=="FFmpeg: disable" ( set "cfg_Content=FFmpeg: enable" && set "cfg_State=enable" )
    if "!cfg_Temp!"=="FFmpeg: enable" ( set "cfg_Content=FFmpeg: disable" && set "cfg_State=disable" )
    echo !cfg_Content!>>%cfg_File%
)
if "%cfg_State%"=="enable" (
    echo %str_ffmpeg-enabled%
) else echo %str_ffmpeg-disabled%
echo %str_please-rerun-dlbat%
goto :eof


:Config_NetTest
for /f "delims=" %%i in (%cfg_File%.bak) do (
    set "cfg_Temp=%%i"
    set "cfg_Content=!cfg_Temp!"
    if "!cfg_Temp!"=="NetTest: disable" ( set "cfg_Content=NetTest: enable" && set "cfg_State=enable" )
    if "!cfg_Temp!"=="NetTest: enable" ( set "cfg_Content=NetTest: disable" && set "cfg_State=disable" )
    echo !cfg_Content!>>%cfg_File%
)
if "%cfg_State%"=="enable" (
    echo %str_netTest-enabled%
) else echo %str_netTest-disabled%
goto :eof


:Config_UpgradeOnlyViaGitHub
for /f "delims=" %%i in (%cfg_File%.bak) do (
    set "cfg_Temp=%%i"
    set "cfg_Content=!cfg_Temp!"
    if "!cfg_Temp!"=="UpgradeOnlyViaGitHub: disable" ( set "cfg_Content=UpgradeOnlyViaGitHub: enable" && set "cfg_State=enable" )
    if "!cfg_Temp!"=="UpgradeOnlyViaGitHub: enable" ( set "cfg_Content=UpgradeOnlyViaGitHub: disable" && set "cfg_State=disable" )
    echo !cfg_Content!>>%cfg_File%
)
if "%cfg_State%"=="enable" (
    echo %str_upgradeOnlyViaGitHub-enabled%
) else echo %str_upgradeOnlyViaGitHub-disabled%
goto :eof


rem ================= End of File =================
