@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in :setting_Proxy & :setting_FFmpeg
:: Please make sure that: only call this batch when %cd% is %root%; call "res\scripts\lang_*.bat" before calling this batch.
:: e.g. 
:: call res\scripts\Config.bat Language zh
:: call res\scripts\Config.bat Region origin
:: call res\scripts\Config.bat ProxyHint
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


:Config_Common
cd res
if NOT exist %cfg_File% (
    :: Set to default
    echo # NEVER EDIT THIS FILE.> %cfg_File%
    echo Language: %_Language_%>> %cfg_File%
    echo Region: %_Region_%>> %cfg_File%
    echo ProxyHint: disable>> %cfg_File%
    echo FFmpeg: enable>> %cfg_File%
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


rem ================= End of File =================