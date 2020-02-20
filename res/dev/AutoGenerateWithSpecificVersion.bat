@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Set the Specific Version Instead of Latest Version While Calling "AutoGenerateLatestSourcesLists.bat"
:: Author: Lussac (https://blog.lussac.net)
:: Last updated: 2020-02-04
:: >>> Configure by editing "AutoGenerateWithSpecificVersion.settings". Directly click to start. <<<
:: >>> Make sure the existence of "AutoGenerateLatestSourcesLists.bat". <<<
:: >>> Get updated from: https://github.com/LussacZheng/video-downloader-deploy/tree/master/res/dev <<<
:: >>> EDIT AT YOUR OWN RISK. <<<
@echo off


rem ================= Configuration =================


:: Read the configuration file
set "_config=%~n0.settings"

if NOT exist %_config% (
    ( echo # EDIT AT YOUR OWN RISK.
    echo.
    echo # Regex of version number : ^^3\.\d+^(\.\d+^)?$
    echo # Right : "3.7", "3.7.1", "3.4";
    echo # Wrong: "3", "3.99", "2", "2.7".
    echo # See the comments in "AutoGenerateLatestSourcesLists.bat" for details.
    echo PythonSpecificVersion: 3.7
    echo.
    echo # "enable" or "disable"
    echo GlobalProxy: disable
    echo ProxyHost: http://127.0.0.1
    echo HttpPort: 1080
    echo HttpsPort: 1080) > %_config%
    echo.
    echo * You'd better close this window and edit the configuration file "%_config%" first.
    echo.
    pause & cls
)
:: Set a specific version for Python
for /f "tokens=2 delims= " %%i in ('findstr /i "PythonSpecificVersion" %_config%') do ( set "_pythonSpecificVersion=%%i" )
:: Set proxy for CMD console window
for /f "tokens=2 delims= " %%i in ('findstr /i "GlobalProxy" %_config%') do ( set "state_globalProxy=%%i" )
for /f "tokens=2 delims= " %%i in ('findstr /i "ProxyHost" %_config%') do ( set "_proxyHost=%%i" )
for /f "tokens=2 delims= " %%i in ('findstr /i "HttpPort" %_config%') do ( set "_httpPort=%%i" )
for /f "tokens=2 delims= " %%i in ('findstr /i "HttpsPort" %_config%') do ( set "_httpsPort=%%i" )
if "%state_globalProxy%"=="enable" (
    set "http_proxy=%_proxyHost%:%_httpPort%"
    set "https_proxy=%_proxyHost%:%_httpsPort%"
)


rem ================= Call =================


echo. & echo  * Auto-Generate Latest Sources List with Specific Version *
echo.
echo PythonSpecificVersion: %_pythonSpecificVersion%
echo GlobalProxy: %state_globalProxy%
echo.
REM call AutoGenerateLatestSourcesLists.bat --python=3.7
call AutoGenerateLatestSourcesLists.bat --python=%_pythonSpecificVersion%
