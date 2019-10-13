@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in :InitDeploy-* & :Upgrade-*
:: Please make sure that: only call this batch when %cd% is "res\"; call "res\scripts\lang_*.bat" before calling this batch.
:: e.g. 
:: call scripts\DoDeploy.bat Setup youget
:: call scripts\DoDeploy.bat Upgrade youtubedl

@echo off
set "dd_Type=%~1"
set "dd_Tool=%~2"
call :DoDeploy-%dd_Type%
goto :eof


rem ================= Deploy Types =================


:DoDeploy-Setup
cd download
call :Setup_%dd_Tool%
cd ..
goto :eof


:DoDeploy-Upgrade
call :Upgrade_%dd_Tool%
goto :eof


rem ================= FUNCTIONS =================


:Setup_python
:: Get the full name of "python-3.x.x-embed*.zip" -> %pyZip%
for /f "delims=" %%i in ('dir /b /a:a python*embed*.zip') do ( set "pyZip=%%i" )
echo %str_unzipping% %pyZip%...
:: https://superuser.com/questions/331148/7-zip-command-line-extract-silently-quietly
7za x %pyZip% -o"%pyBin%" > NUL
echo Python-embed %str_already-deploy%
goto :eof


:Setup_youget
for /f "delims=" %%i in ('dir /b /a:a you-get*.tar.gz') do ( set "ygZip=%%i" )
echo %str_unzipping% %ygZip%...
:: https://superuser.com/questions/80019/how-can-i-unzip-a-tar-gz-in-one-step-using-7-zip
7za x %ygZip% -so | 7za x -aoa -si -ttar > NUL
set ygDir=%ygZip:~0,-7%
move %ygDir% "%ygBin%" > NUL
echo You-Get %str_already-deploy%
goto :eof


:Setup_youtubedl
for /f "delims=" %%i in ('dir /b /a:a youtube-dl*.tar.gz') do ( set "ydZip=%%i" )
echo %str_unzipping% %ydZip%...
7za x %ydZip% -so | 7za x -aoa -si -ttar > NUL
set ydDir=youtube-dl
move %ydDir% "%ydBin%" > NUL
echo Youtube-dl %str_already-deploy%
goto :eof


:Setup_annie
for /f "delims=" %%i in ('dir /b /a:a annie*Windows*.zip') do ( set "anZip=%%i" )
echo %str_unzipping% %anZip%...
7za x %anZip% -o"%anBin%" > NUL
echo Annie %str_already-deploy%
goto :eof


:Setup_ffmpeg
for /f "delims=" %%i in ('dir /b /a:a ffmpeg*.zip') do ( set "ffZip=%%i" )
echo %str_unzipping% %ffZip% ...
7za x %ffZip% > NUL
set "ffDir=%ffZip:~0,-4%"
move %ffDir% "%root%\usr\ffmpeg" > NUL
goto :eof


:Upgrade_youget
echo %str_upgrading% you-get...
:: %ygCurrentVersion% was set in res\scripts\CheckUpdate.bat :CheckUpdate_youget
del /Q download\you-get-%ygCurrentVersion%.tar.gz >NUL 2>NUL
del /Q sources.txt >NUL 2>NUL
wget %_WgetOptions_% %_RemoteRes_%/sources.txt
call scripts\SourcesSelector.bat sources.txt youget %_Region_% %_SystemType_% download\to-be-downloaded.txt
wget %_WgetOptions_% -i download\to-be-downloaded.txt -P download
rd /S /Q "%ygBin%" >NUL 2>NUL
cd download && call :Setup_youget
cd .. && echo You-Get %str_already-upgrade%
goto :eof


:Upgrade_youtubedl
echo %str_upgrading% youtube-dl...
:: %ydCurrentVersion% and %ydLatestVersion% were set in res\scripts\CheckUpdate.bat :CheckUpdate_youtubedl
del /Q download\youtube-dl-%ydCurrentVersion%.tar.gz >NUL 2>NUL
set "ydLatestVersion_Url=https://github.com/ytdl-org/youtube-dl/releases/download/%ydLatestVersion%/youtube-dl-%ydLatestVersion%.tar.gz"
echo %ydLatestVersion_Url%>> download\to-be-downloaded.txt
wget %_WgetOptions_% %ydLatestVersion_Url% -P download
rd /S /Q "%ydBin%" >NUL 2>NUL
cd download && call :Setup_youtubedl
cd .. && echo Youtube-dl %str_already-upgrade%
goto :eof


:Upgrade_annie
echo %str_upgrading% annie...
:: %anCurrentVersion% and %anLatestVersion% were set in res\scripts\CheckUpdate.bat :CheckUpdate_annie
del /Q download\annie_%anCurrentVersion%_Windows*.zip >NUL 2>NUL
set "anLatestVersion_Url=https://github.com/iawia002/annie/releases/download/%anLatestVersion%/annie_%anLatestVersion%_Windows_%_SystemType_%-bit.zip"
echo %anLatestVersion_Url%>> download\to-be-downloaded.txt
wget %_WgetOptions_% %anLatestVersion_Url% -P download
del /Q "%anBin%\annie.exe" >NUL 2>NUL
cd download && call :Setup_annie
cd .. && echo Annie %str_already-upgrade%
goto :eof


rem ================= End of File =================