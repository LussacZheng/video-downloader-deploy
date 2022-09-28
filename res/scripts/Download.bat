@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in :InitDeploy-* & :Upgrade & :Update
:: Please make sure that: only call this batch when %cd% is "res\"; call "res\scripts\lang_*.bat" before calling this batch.
:: e.g.
:: call scripts\Download.bat main
:: call scripts\Download.bat dependency
:: call scripts\Download.bat wget
:: call scripts\Download.bat preparation

@echo off
call :Download_%~1
goto :eof


rem ================= FUNCTIONS =================


:Download_main
call :Download_preparation
call :Download_wget
echo %str_downloading%...
call :Download_7za
:: %_Region_% was set in res\scripts\lang_%_Language_%.bat
call scripts\SourcesSelector.bat sources.txt %DeployMode% %_Region_% %_SystemType_% download\to-be-downloaded.txt
:: https://stackoverflow.com/questions/4686464/how-to-show-wget-progress-bar-only
wget %_WgetOptions_% -i download\to-be-downloaded.txt -P download
:: if exist .wget-hsts del .wget-hsts
goto :eof


:: Make sure the existence of "res\wget.exe" and import %_WgetOptions_%
:Download_wget
if NOT exist wget.exe (
    echo %str_downloading% "wget.exe", %str_please-wait%...
    REM :: use ^) instead of )
    REM powershell (New-Object Net.WebClient^).DownloadFile('%_RemoteRes_%/wget.exe', 'wget.exe'^)
    powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (new-object System.Net.WebClient).DownloadFile('%_RemoteRes_%/wget.exe','wget.exe')"
)
call scripts\Getter.bat WgetOptions
goto :eof


:: Make sure the existence of "res\7za.exe" and "res\download\7za.exe"
:: call :Download_wget before calling this function.
:Download_7za
if NOT exist 7za.exe (
    wget %_WgetOptions_% %_RemoteRes_%/7za.exe
)
if NOT exist download\7za.exe (
    xcopy 7za.exe download\ > NUL
)
goto :eof


:Download_dependency
call :Download_wget
call :Download_7za
goto :eof


:: %cd%: No limit
:: Move the existing files, which are manually downloaded, from "%root%" into "res\download\"
:Download_preparation
pushd "%root%"
setlocal EnableDelayedExpansion
set /a dl_Count=0
for /f "delims=" %%i in ('dir /b /a-d ^| findstr "\.zip$ \.tar\.gz$ \.7z$"') do ( set /a dl_Count=!dl_Count!+1 )
if NOT "%dl_Count%"=="0" (
    echo %str_manually-downloaded% %dl_Count% %str_manually-downloaded2%...
    echo.
    if NOT exist res\download\ md res\download
    if exist python*embed*.zip ( move /Y python*embed*.zip res\download\ > NUL )
    if exist you-get*.tar.gz ( move /Y you-get*.tar.gz res\download\ > NUL )
    REM For "youtube-dl*.tar.gz" downloaded from Lanzou Netdisk, complete the filename.
    REM   "-dl-2020.03.24.tar.gz" -> "youtube-dl-2020.03.24.tar.gz"
    REM   "_dl-2020.3.24.tar.gz" -> "youtube_dl-2020.3.24.tar.gz"
    if exist -dl*.tar.gz (
        for /f "delims=" %%i in ('dir /b /a-d /o:d -dl*.tar.gz') do ( set "dl_Filename=%%i" )
        move /Y !dl_Filename! youtube!dl_Filename! > NUL
    )
    if exist _dl*.tar.gz (
        for /f "delims=" %%i in ('dir /b /a-d /o:d _dl*.tar.gz') do ( set "dl_Filename=%%i" )
        move /Y !dl_Filename! youtube!dl_Filename! > NUL
    )
    if exist youtube*dl*.tar.gz ( move /Y youtube*dl*.tar.gz res\download\ > NUL )
    if exist lux*Windows*.zip ( move /Y lux*Windows*.zip res\download\ > NUL )
    if exist annie*Windows*.zip ( move /Y annie*Windows*.zip res\download\ > NUL )
    if exist ffmpeg*.zip ( move /Y ffmpeg*.zip res\download\ > NUL )
    if exist ffmpeg*.7z ( move /Y ffmpeg*.7z res\download\ > NUL )
    echo.
)
endlocal
popd
goto :eof


rem ================= End of File =================
