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
echo :: ^>^>^> EDIT AT YOUR OWN RISK. ^<^<^<>%dl-bat-filename%
echo @echo off>>%dl-bat-filename%
echo.>>%dl-bat-filename%
echo if NOT exist usr\ (>>%dl-bat-filename%
echo     echo. ^& echo %str_dl-bat-moved%>>%dl-bat-filename%
echo     pause ^> NUL ^& exit>>%dl-bat-filename%
echo )>>%dl-bat-filename%
echo color F0>>%dl-bat-filename%
echo.>>%dl-bat-filename%
echo if exist res\deploy.settings (>>%dl-bat-filename%
echo     for /f "tokens=2 delims= " %%%%i in ('findstr /i "ProxyHint" res\deploy.settings') do ( set "state_proxyHint=%%%%i" )>>%dl-bat-filename%
echo     for /f "tokens=2 delims= " %%%%i in ('findstr /i "FFmpeg" res\deploy.settings') do ( set "state_ffmpeg=%%%%i" )>>%dl-bat-filename%
echo     for /f "tokens=2 delims= " %%%%i in ('findstr /i "GlobalProxy" res\deploy.settings') do ( set "state_globalProxy=%%%%i" )>>%dl-bat-filename%
echo     for /f "tokens=2 delims= " %%%%i in ('findstr /i "ProxyHost" res\deploy.settings') do ( set "_proxyHost=%%%%i" )>>%dl-bat-filename%
echo     for /f "tokens=2 delims= " %%%%i in ('findstr /i "HttpPort" res\deploy.settings') do ( set "_httpPort=%%%%i" )>>%dl-bat-filename%
echo     for /f "tokens=2 delims= " %%%%i in ('findstr /i "HttpsPort" res\deploy.settings') do ( set "_httpsPort=%%%%i" )>>%dl-bat-filename%
echo ) else ( set "state_proxyHint=disable" ^&^& set "state_ffmpeg=enable" ^&^& set "state_globalProxy=disable" )>>%dl-bat-filename%
echo.>>%dl-bat-filename%
echo set "root=%%cd%%">>%dl-bat-filename%
echo set "pyBin=%%root%%\usr\python-embed">>%dl-bat-filename%
echo set "ygBin=%%root%%\usr\you-get">>%dl-bat-filename%
echo set "ydBin=%%root%%\usr\youtube-dl">>%dl-bat-filename%
echo set "anBin=%%root%%\usr">>%dl-bat-filename%
echo if "%%state_ffmpeg%%"=="enable" ( set "ffBin=%%root%%\usr\ffmpeg\bin;" )>>%dl-bat-filename%
echo set "PATH=%%root%%\usr\command;%%pyBin%%;%%pyBin%%\Scripts;%%anBin%%;%%ffBin%%%%PATH%%">>%dl-bat-filename%
echo.>>%dl-bat-filename%
echo if NOT exist usr\command md usr\command>>%dl-bat-filename%
echo del /Q usr\command\*.cmd ^>NUL 2^>NUL>>%dl-bat-filename%
goto :eof


:GenerateDownloadBatch_Common2
echo.>>%dl-bat-filename%
echo if NOT exist Download md Download>>%dl-bat-filename%
echo cd Download>>%dl-bat-filename%
echo.>>%dl-bat-filename%
echo title %str_dl-bat%>>%dl-bat-filename%
echo echo %str_dl-guide1%>>%dl-bat-filename%
echo echo %str_dl-guide2%>>%dl-bat-filename%
echo echo.>>%dl-bat-filename%
echo echo %str_dl-guide3%>>%dl-bat-filename%
echo echo you-get https://v.youku.com/v_show/id_aBCdefGh.html>>%dl-bat-filename%
echo echo youtube-dl https://www.youtube.com/watch?v=aBCdefGh>>%dl-bat-filename%
echo echo annie https://www.bilibili.com/video/av12345678>>%dl-bat-filename%
echo echo.>>%dl-bat-filename%
echo echo %str_dl-guide4%>>%dl-bat-filename%
echo echo. ^& echo.>>%dl-bat-filename%
echo echo %str_dl-guide5%>>%dl-bat-filename%
echo echo you-get:    https://github.com/soimort/you-get/wiki/%str_dl-guide_wiki%>>%dl-bat-filename%
echo echo youtube-dl: https://github.com/ytdl-org/youtube-dl/blob/master/README.md>>%dl-bat-filename%
echo echo annie:      https://github.com/iawia002/annie/blob/master/README.md>>%dl-bat-filename%
echo echo. ^& echo.>>%dl-bat-filename%
echo if "%%state_ffmpeg%%"=="disable" ( echo %str_ffmpeg-disabled% ^& echo. ^& echo. )>>%dl-bat-filename%
echo if "%%state_proxyHint%%"=="enable" (>>%dl-bat-filename%
echo     echo %str_proxyHint-setting%>>%dl-bat-filename%
echo     echo you-get -x 127.0.0.1:1080 https://www.youtube.com/watch?v=Ie5qE1EHm_w>>%dl-bat-filename%
echo     echo youtube-dl --proxy socks5://127.0.0.1:1080/ https://www.youtube.com/watch?v=Ie5qE1EHm_w>>%dl-bat-filename%
echo     echo annie -x http://127.0.0.1:1080 https://www.youtube.com/watch?v=Ie5qE1EHm_w>>%dl-bat-filename%
echo     echo annie -s 127.0.0.1:1080 https://www.youtube.com/watch?v=Ie5qE1EHm_w>>%dl-bat-filename%
echo     echo. ^& echo.>>%dl-bat-filename%
echo )>>%dl-bat-filename%
echo if "%%state_globalProxy%%"=="enable" (>>%dl-bat-filename%
echo     set "http_proxy=%%_proxyHost%%:%%_httpPort%%">>%dl-bat-filename%
echo     set "https_proxy=%%_proxyHost%%:%%_httpsPort%%">>%dl-bat-filename%
echo     echo %str_current-globalProxy-cmd%>>%dl-bat-filename%
echo     echo     HTTP_PROXY  = %%_proxyHost%%:%%_httpPort%%>>%dl-bat-filename%
echo     echo     HTTPS_PROXY = %%_proxyHost%%:%%_httpsPort%%>>%dl-bat-filename%
echo     echo. ^& echo.>>%dl-bat-filename%
echo )>>%dl-bat-filename%
echo.>>%dl-bat-filename%
echo PROMPT $P$_$G$G$G>>%dl-bat-filename%
::PROMPT [$D $T$h$h$h$h$h$h]$_$P$_$G$G$G
echo cmd /Q /K>>%dl-bat-filename%
goto :eof


:GenerateDownloadBatch-portable
echo echo @"%%pyBin%%\python.exe" "%%ygBin%%\you-get" %%%%*^> usr\command\you-get.cmd>>%dl-bat-filename%
:: OR  echo @python ..\usr\you-get\you-get %%*> usr\command\you-get.cmd
echo echo @"%%pyBin%%\python.exe" "%%ydBin%%\youtube-dl" %%%%*^> usr\command\youtube-dl.cmd>>%dl-bat-filename%
goto :eof


:GenerateDownloadBatch-quickstart
echo echo @"%%pyBin%%\python.exe" "%%ygBin%%\you-get" %%%%*^> usr\command\you-get.cmd>>%dl-bat-filename%
goto :eof


:GenerateDownloadBatch-withpip
echo echo @"%%pyBin%%\python.exe" "%%pyBin%%\Scripts\pip3.exe" %%%%*^> usr\command\pip3.cmd>>%dl-bat-filename%
echo echo @"%%pyBin%%\python.exe" "%%pyBin%%\Scripts\pip.exe" %%%%*^> usr\command\pip.cmd>>%dl-bat-filename%
echo echo @"%%pyBin%%\python.exe" "%%pyBin%%\Scripts\wheel.exe" %%%%*^> usr\command\wheel.cmd>>%dl-bat-filename%
echo echo @"%%pyBin%%\python.exe" "%%pyBin%%\Scripts\easy_install.exe" %%%%*^> usr\command\easy_install.cmd>>%dl-bat-filename%
echo echo @"%%pyBin%%\python.exe" "%%pyBin%%\Scripts\you-get.exe" %%%%*^> usr\command\you-get.cmd>>%dl-bat-filename%
echo echo @"%%pyBin%%\python.exe" "%%pyBin%%\Scripts\youtube-dl.exe" %%%%*^> usr\command\youtube-dl.cmd>>%dl-bat-filename%
goto :eof


rem ================= End of File =================