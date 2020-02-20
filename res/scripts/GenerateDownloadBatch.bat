@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in :Create_Download-bat
:: Please make sure that: only call this batch when %cd% is %root%; call "res\scripts\lang_*.bat" before calling this batch.
:: e.g.
:: call res\scripts\GenerateDownloadBatch.bat portable

@echo off
set "dl-bat-filename=%str_dl-bat%.bat"
REM if "%DeployMode%"=="unknown" exit
call :GenerateDownloadBatch_Common
call :GenerateDownloadBatch-%~1
call :GenerateDownloadBatch_Common2
goto :eof


rem ================= FUNCTIONS =================


:GenerateDownloadBatch_Common
( echo :: ^>^>^> EDIT AT YOUR OWN RISK. ^<^<^<
echo @echo off
echo.

:: %_Version__% was set in Deploy.bat
echo set "_versionAtCreation=%_Version_%"
echo if NOT exist res\scripts\CurrentVersion goto next
echo set /p _versionCurrent=^<res\scripts\CurrentVersion
echo if NOT "%%_versionAtCreation%%"=="%%_versionCurrent%%" ^(
echo     echo. ^& echo %str_dl-bat-reset%
echo     pause ^& cls
echo ^)
echo :next
echo if NOT exist usr\ ^(
echo     echo. ^& echo %str_dl-bat-moved%
echo     pause ^> NUL ^& exit
echo ^)
echo.

echo color F0
echo.

echo if exist res\deploy.settings ^(
echo     for /f "tokens=2 delims= " %%%%i in ^('findstr /i "ProxyHint" res\deploy.settings'^) do ^( set "state_proxyHint=%%%%i" ^)
echo     for /f "tokens=2 delims= " %%%%i in ^('findstr /i "FFmpeg" res\deploy.settings'^) do ^( set "state_ffmpeg=%%%%i" ^)
echo     for /f "tokens=2 delims= " %%%%i in ^('findstr /i "GlobalProxy" res\deploy.settings'^) do ^( set "state_globalProxy=%%%%i" ^)
echo     for /f "tokens=2 delims= " %%%%i in ^('findstr /i "ProxyHost" res\deploy.settings'^) do ^( set "_proxyHost=%%%%i" ^)
echo     for /f "tokens=2 delims= " %%%%i in ^('findstr /i "HttpPort" res\deploy.settings'^) do ^( set "_httpPort=%%%%i" ^)
echo     for /f "tokens=2 delims= " %%%%i in ^('findstr /i "HttpsPort" res\deploy.settings'^) do ^( set "_httpsPort=%%%%i" ^)
echo ^) else ^( set "state_proxyHint=disable" ^&^& set "state_ffmpeg=enable" ^&^& set "state_globalProxy=disable" ^)
echo.

echo set "root=%%cd%%"
echo set "pyBin=%%root%%\usr\python-embed"
echo set "ygBin=%%root%%\usr\you-get"
echo set "ydBin=%%root%%\usr\youtube-dl"
echo set "anBin=%%root%%\usr"
echo if "%%state_ffmpeg%%"=="enable" ^( set "ffBin=%%root%%\usr\ffmpeg\bin;" ^)
echo set "PATH=%%root%%\usr\command;%%pyBin%%;%%pyBin%%\Scripts;%%anBin%%;%%ffBin%%%%PATH%%"
echo.

echo if NOT exist usr\command md usr\command
echo del /Q usr\command\*.cmd ^>NUL 2^>NUL) > %dl-bat-filename%
goto :eof


:GenerateDownloadBatch_Common2
( echo.
echo if NOT exist Download md Download
echo cd Download
echo.

echo title %str_dl-bat%
echo echo * %str_dl-guide1%
echo echo     %str_dl-guide2%
echo echo   %str_dl-guide3%
echo echo     you-get https://v.youku.com/v_show/id_aBCdefGh.html
echo echo     youtube-dl https://www.youtube.com/watch?v=aBCdefGh
echo echo     annie https://www.bilibili.com/video/av12345678
echo echo.
echo echo * %str_dl-guide4%
echo echo.
echo echo * %str_dl-guide5%
echo echo     you-get:    https://github.com/soimort/you-get/wiki/%str_dl-guide_wiki%
echo echo     youtube-dl: https://github.com/ytdl-org/youtube-dl/blob/master/README.md
echo echo     annie:      https://github.com/iawia002/annie/blob/master/README.md
echo echo. ^& echo ----- ^& echo.

echo echo * %str_opt6%
echo echo     ^(%str_dl-guide6%^)
echo echo.
echo echo [3/4] %str_dl-guide7%
echo echo.

echo if "%%state_globalProxy%%"=="enable" ^(
echo     set "http_proxy=%%_proxyHost%%:%%_httpPort%%"
echo     set "https_proxy=%%_proxyHost%%:%%_httpsPort%%"
echo     echo [3] %str_current-globalProxy-cmd%
echo     echo       HTTP_PROXY  = %%_proxyHost%%:%%_httpPort%%
echo     echo       HTTPS_PROXY = %%_proxyHost%%:%%_httpsPort%%
echo     echo.
echo ^)

echo if "%%state_proxyHint%%"=="enable" ^(
echo     echo [4] %str_proxyHint-option%
echo     echo       you-get -x 127.0.0.1:1080 https://www.youtube.com/watch?v=Ie5qE1EHm_w
echo     echo       youtube-dl --proxy socks5://127.0.0.1:1080 https://www.youtube.com/watch?v=Ie5qE1EHm_w
echo     echo       * %str_proxyHint_annie1%
echo     echo         %str_proxyHint_annie2%
echo     echo       set "HTTP_PROXY=socks5://127.0.0.1:1080" ^^^& annie https://www.youtube.com/watch?v=Ie5qE1EHm_w
echo     echo.
echo ^)

echo if "%%state_ffmpeg%%"=="disable" ^( echo [5] %str_ffmpeg-disabled% ^& echo. ^)

echo echo.
echo.
echo PROMPT $P$_$G$G$G
::PROMPT [$D $T$h$h$h$h$h$h]$_$P$_$G$G$G
echo cmd /Q /K) >> %dl-bat-filename%
goto :eof


:GenerateDownloadBatch-portable
:: OR  echo @python ..\usr\you-get\you-get %%*> usr\command\you-get.cmd
( echo echo @"%%pyBin%%\python.exe" "%%ygBin%%\you-get" %%%%*^> usr\command\you-get.cmd
echo echo @"%%pyBin%%\python.exe" "%%ydBin%%\youtube-dl" %%%%*^> usr\command\youtube-dl.cmd) >> %dl-bat-filename%
goto :eof


:GenerateDownloadBatch-quickstart
echo echo @"%%pyBin%%\python.exe" "%%ygBin%%\you-get" %%%%*^> usr\command\you-get.cmd>> %dl-bat-filename%
goto :eof


:GenerateDownloadBatch-withpip
( echo echo @"%%pyBin%%\python.exe" "%%pyBin%%\Scripts\pip3.exe" %%%%*^> usr\command\pip3.cmd
echo echo @"%%pyBin%%\python.exe" "%%pyBin%%\Scripts\pip.exe" %%%%*^> usr\command\pip.cmd
echo echo @"%%pyBin%%\python.exe" "%%pyBin%%\Scripts\wheel.exe" %%%%*^> usr\command\wheel.cmd
echo echo @"%%pyBin%%\python.exe" "%%pyBin%%\Scripts\easy_install.exe" %%%%*^> usr\command\easy_install.cmd
echo echo @"%%pyBin%%\python.exe" "%%pyBin%%\Scripts\you-get.exe" %%%%*^> usr\command\you-get.cmd
echo echo @"%%pyBin%%\python.exe" "%%pyBin%%\Scripts\youtube-dl.exe" %%%%*^> usr\command\youtube-dl.cmd) >> %dl-bat-filename%
goto :eof


rem ================= End of File =================
