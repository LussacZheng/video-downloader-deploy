@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in :setting_Proxy & :setting_FFmpeg
:: Please make sure that: only call this batch when %cd% is %root%; call "res\scripts\lang_*.bat" before calling this batch.
:: e.g. 
:: call res\scripts\Config.bat Proxy
:: call res\scripts\Config.bat FFmpeg

@echo off
setlocal EnableDelayedExpansion
set "cfg_File=deploy.settings"
call :Config_Common
call :Config_%~1
call :Config_Common2
goto :eof


rem ================= FUNCTIONS =================


:Config_Common
cd usr
if NOT exist %cfg_File% (
    :: Set to default
    echo Proxy: disable> %cfg_File%
    echo FFmpeg: enable>> %cfg_File%
)
copy %cfg_File% %cfg_File%.bak > NUL
type NUL > %cfg_File%
goto :eof


:Config_Common2
del /Q %cfg_File%.bak >NUL 2>NUL
echo %str_please-rerun-dlbat%
cd ..
goto :eof


:Config_Proxy
for /f "delims=" %%i in (%cfg_File%.bak) do (
    set "cfg_Temp=%%i"
    set "cfg_Content=!cfg_Temp!" 
    if "!cfg_Temp!"=="Proxy: disable" ( set "cfg_Content=Proxy: enable" && set "cfg_State=enable" )
    if "!cfg_Temp!"=="Proxy: enable" ( set "cfg_Content=Proxy: disable" && set "cfg_State=disable" )
    echo !cfg_Content!>>%cfg_File%
)
if "%cfg_State%"=="enable" (
    echo %str_proxy-enabled%
) else echo %str_proxy-disabled%
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
goto :eof


rem ================= End of File =================