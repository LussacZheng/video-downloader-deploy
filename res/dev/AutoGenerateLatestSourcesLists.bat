@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Auto-Generate Sources Lists for "Video Downloaders One-Click Deployment Batch"
:: Author: Lussac (https://blog.lussac.net)
:: Last updated: 2022-09-28
:: >>> The extractor algorithm could be expired as the revision of websites. <<<
:: >>> Get updated from: https://github.com/LussacZheng/video-downloader-deploy/tree/master/res/dev <<<
:: >>> EDIT AT YOUR OWN RISK. <<<
@echo off
setlocal EnableDelayedExpansion
:: Read the comment at the 7th line of :WriteCommon (appr. Line#307) when EnableDelayedExpansion.


:: To set a certain version for Python instead of latest version, call this batch with additional options. Regex: ^3\.\d+(\.\d+)?$
:: e.g.
:: call AutoGenerateLatestSourcesLists.bat --python=3.7      ==>  latest version of Python as 3.7.x , for now(Jan,2020) is 3.7.6
:: call AutoGenerateLatestSourcesLists.bat --python=3.7.1    ==>  Specific version of Python at 3.7.1
:: call AutoGenerateLatestSourcesLists.bat --python=3.4      ==>  latest version of Python as 3.4.x , for now is 3.4.10
:: However, DON'T call like following!
:: call AutoGenerateLatestSourcesLists.bat --python=3     (At least write the "minor" part of version number as "major.minor.micro")
:: call AutoGenerateLatestSourcesLists.bat --python=3.99  (No such version so far)
:: call AutoGenerateLatestSourcesLists.bat --python=2     (Python 2 not supported)
:: call AutoGenerateLatestSourcesLists.bat --python=2.7   (Python 2 not supported)


rem ================= Preparation =================


:RequirementCheck
pushd "%~dp0"
if exist ..\wget.exe (
    set "wget=..\wget.exe"
) else if exist .\wget.exe (
    set "wget=.\wget.exe"
) else (
    where /Q $path:wget && set "isExternalWget=true"
    if "!isExternalWget!"=="true" (
        set "wget=wget"
    ) else (
        echo "wget.exe" not founded. Please download it from
        echo https://raw.githubusercontent.com/LussacZheng/video-downloader-deploy/master/res/wget.exe
        pause > NUL
        exit
    )
)


:DownloadWebPages
echo. & echo  * Auto-Generate Latest Sources List *
echo. & echo.
echo If the download process is interrupted, close this window and re-run.
echo Downloading web pages...
echo Please be patient while waiting for the download...
echo. & echo.
echo py=python, yg=you-get, yd=youtube-dl, lx=lux, ff=ffmpeg, pip=pip
echo.

if NOT exist .\temp md .\temp

set "_WgetOptions_=-q --show-progress --progress=bar:force:noscroll --no-check-certificate -np"
%wget% %_WgetOptions_% https://www.python.org/downloads/windows/ -O temp/pyLatestRelease.txt
%wget% %_WgetOptions_% https://pypi.org/project/you-get/ -O temp/ygLatestRelease.txt
%wget% %_WgetOptions_% https://github.com/ytdl-org/youtube-dl/releases/latest -O temp/ydLatestRelease.txt
%wget% %_WgetOptions_% https://pypi.org/project/youtube_dl/ -O temp/ydLatestRelease2.txt
%wget% %_WgetOptions_% https://github.com/iawia002/lux/releases/latest -O temp/lxLatestRelease.txt
%wget% %_WgetOptions_% https://www.gyan.dev/ffmpeg/builds/release-version -O temp/ffLatestVersion.txt
%wget% %_WgetOptions_% https://www.gyan.dev/ffmpeg/builds/last-build-update -O temp/ffLatestReleasedTime.txt
%wget% %_WgetOptions_% https://pypi.org/project/pip/ -O temp/pipLatestRelease.txt

cd temp
echo. & echo.


rem ================= Get Variables =================


:GetPythonLatestVersion
REM @param  %pyLatestVersion%,  %pyLatestReleasedTime%

:: The output of 'findstr /n /i /c:"Latest Python 3 Release" pyLatestRelease.txt' should be like:
::     505:            <li><a href="/downloads/release/python-381/">Latest Python 3 Release - Python 3.8.1</a></li>
for /f "tokens=10 delims=< " %%a in ('findstr /n /i /c:"Latest Python 3 Release" pyLatestRelease.txt') do ( set "pyLatestVersion=%%a" )

:: If there is no option(When this batch is directly clicked), set %pySpecificVersion% to the latest version.
if "%~1"=="--python" (
    set "pySpecificVersion=%~2"
    set "pyInfo1=pySpecificVersion"
    set "pyInfo2=pySpecificReleasedTime"
) else (
    set "pySpecificVersion=%pyLatestVersion%"
    set "pyInfo1=pyLatestVersion"
    set "pyInfo2=pyLatestReleasedTime"
)
:: If the %pyLatestVersion% is "3.8.x", and %pySpecificVersion% is also "3.8", skip the first line of output of next step.
if "%pySpecificVersion:~0,3%"=="%pyLatestVersion:~0,3%" (
    set "skipThisLoop=true"
) else ( set "skipThisLoop=false" )

:: 1. The output of 'findstr /n /i /c:"Python 3.7" pyLatestRelease.txt'
::               or 'findstr /n /i /c:"Python 3.7.6" pyLatestRelease.txt' should be like:
::     538:                        <a href="/downloads/release/python-376/">Python 3.7.6 - Dec. 18, 2019</a>
::     540:                        <p><strong>Note that Python 3.7.6 <em>cannot</em> be used on Windows XP or earlier.</strong></p>
::     ...etc...
:: 2. The output of 'findstr /n /i /c:"Python 3.8" pyLatestRelease.txt' should be like:
::     505:            <li><a href="/downloads/release/python-381/">Latest Python 3 Release - Python 3.8.1</a></li>
::     514:                        <a href="/downloads/release/python-381/">Python 3.8.1 - Dec. 18, 2019</a>
::     ...etc...
:: For 1, only the first line is wanted. Break after finishing the first loop;
:: For 2, just skip the first loop. Break at the second loop.
for /f "tokens=4-8 delims=< " %%a in ('findstr /n /i /c:"Python %pySpecificVersion%" pyLatestRelease.txt') do (
    if "!skipThisLoop!"=="false" (
        set "pyLatestVersion=%%a"
        echo %pyInfo1%: !pyLatestVersion!
        set "pyLatestReleasedTime_month=%%c" && set "pyLatestReleasedTime_day=%%d" && set "pyLatestReleasedTime_year=%%e"
        set "pyLatestReleasedTime=!pyLatestReleasedTime_year:"=!-!pyLatestReleasedTime_month:.=!-!pyLatestReleasedTime_day:,=!"
        echo %pyInfo2%: !pyLatestReleasedTime!
        echo.
        goto :GetYougetLatestVersion
    )
    set "skipThisLoop=false"
)


:GetYougetLatestVersion
REM @param  %ygUrl%,  %ygLatestVersion%,  %ygLatestReleasedTime%,  %ygBLAKE2%
REM Get %ygUrl% from https://pypi.org/project/you-get/

:: The output of 'findstr /n /i "files.pythonhosted.org.*tar.gz" ygLatestRelease.txt' should be like:
::     5899:  <a href="https://files.pythonhosted.org/packages/f1/e9/3b6f38f800602f9724b3e5b1bf0350e397a0092a3f1fa698e0aeb173122f/you-get-0.4.1555.tar.gz">
for /f "tokens=2 delims=>=" %%a in ('findstr /n /i "files.pythonhosted.org.*tar.gz" ygLatestRelease.txt') do ( set "ygUrl=%%a" )
REM for /f "tokens=2 delims=>=" %%a in ('findstr /n /i "you-get-" ygLatestRelease.txt') do ( set "ygUrl=%%a" && goto theNext )
set "ygUrl=%ygUrl:"=%"
:: Now %ygUrl% is like: https://files.pythonhosted.org/packages/fd/a5/c896dccb53f44f54c5c8bcfbc7b8d953289064bcfbf17cccb68136fde3bf/you-get-0.4.1328.tar.gz

:: Get the version number form %ygUrl%
for /f "tokens=3 delims=-" %%b in ("%ygUrl%") do ( set "ygLatestVersion=%%b")
set ygLatestVersion=%ygLatestVersion:.tar.gz=%
echo ygLatestVersion: %ygLatestVersion%

:: The output of 'findstr /n /i /c:"Released" ygLatestRelease.txt' should be like:
::     209:        Released: <time datetime="2019-12-28T20:35:55+0000" data-controller="localized-time" data-localized-time-relative="true" data-localized-time-show-time="false">
for /f "tokens=4 delims==:" %%c in ('findstr /n /i /c:"Released" ygLatestRelease.txt') do ( set "ygLatestReleasedTime=%%c" )
:: Now %ygLatestReleasedTime% is like: "2019-09-09T21
set "ygLatestReleasedTime=%ygLatestReleasedTime:~1,10%"
echo ygLatestReleasedTime: %ygLatestReleasedTime%

:: Get the "Hash digest" in BLAKE2-256(Algorithm) for "you-get-v.er.sion.tar.gz" from %ygUrl%
for /f "tokens=4-6 delims=/" %%x in ("%ygUrl%") do (
    set "ygUrl_BLAKE2_1=%%x" && set "ygUrl_BLAKE2_2=%%y" && set "ygUrl_BLAKE2_3=%%z"
)
set "ygBLAKE2=%ygUrl_BLAKE2_1%/%ygUrl_BLAKE2_2%/%ygUrl_BLAKE2_3%"
echo ygBLAKE2-256: %ygBLAKE2%
echo.


:GetYoutubedlLatestVersion
REM @param [1] %ydLatestVersion%, %ydLatestVersion_trimZero%,  %ydLatestReleasedTime%
REM @param [2] %ydUrl%,  %ydBLAKE2%
REM Get [1] from https://github.com/ytdl-org/youtube-dl/releases/latest
REM Get [2] from https://pypi.org/project/youtube_dl/

:: The output of 'findstr /n /i "<title>" ydLatestRelease.txt' should be like:
::     31:  <title>Release youtube-dl 2019.08.02 · ytdl-org/youtube-dl · GitHub</title>
for /f "tokens=4 delims= " %%a in ('findstr /n /i "<title>" ydLatestRelease.txt') do ( set "ydLatestVersion=%%a" )
echo ydLatestVersion: %ydLatestVersion%

:: Get the version number (zero trimmed)
:: If "%ydLatestVersion%" == "2020.11.01.1",
::    %ydLatestVersion_trimZero% will be "2020.11.1.1";
::    %ydLatestReleasedTime% will be "2020-11-01".
set "ydLatestVersion_trimZero=%ydLatestVersion:.0=.%"
set "ydLatestReleasedTime=%ydLatestVersion:~0,10%"
set "ydLatestReleasedTime=%ydLatestReleasedTime:.=-%"
echo ydLatestReleasedTime: %ydLatestReleasedTime%

:: The output of 'findstr /n /i "files.pythonhosted.org.*tar.gz" ydLatestRelease2.txt' should be like:
::     28578:  <a href="https://files.pythonhosted.org/packages/01/4f/ab0d0806f4d818168d0ec833df14078c9d1ddddb5c42fa7bfb6f15ecbfa7/youtube_dl-2021.12.17.tar.gz">
for /f "tokens=2 delims=>=" %%a in ('findstr /n /i "files.pythonhosted.org.*tar.gz" ydLatestRelease2.txt') do ( set "ydUrl=%%a" )
set "ydUrl=%ydUrl:"=%"
:: Now %ydUrl% is like: https://files.pythonhosted.org/packages/5d/25/862367e9ea163d43d384b80467dcdf0a79b993989b5baf976feaf5ca1d11/youtube_dl-2019.8.2.tar.gz

:: Get the "Hash digest" in BLAKE2-256(Algorithm) for "youtube_dl-vers.i.on.tar.gz" from %ydUrl%
for /f "tokens=4-6 delims=/" %%x in ("%ydUrl%") do (
    set "ydUrl_BLAKE2_1=%%x" && set "ydUrl_BLAKE2_2=%%y" && set "ydUrl_BLAKE2_3=%%z"
)
set "ydBLAKE2=%ydUrl_BLAKE2_1%/%ydUrl_BLAKE2_2%/%ydUrl_BLAKE2_3%"
echo ydBLAKE2-256: %ydBLAKE2%
echo.


:GetLuxLatestVersion
REM @param  %lxLatestVersion%,  %lxLatestReleasedTime%

:: The output of 'findstr /n /i "<title>" lxLatestRelease.txt' should be like:
::     57:  <title>Release v0.14.0 · iawia002/lux · GitHub</title>
for /f "tokens=3 delims= " %%a in ('findstr /n /i "<title>" lxLatestRelease.txt') do ( set "lxLatestVersion=%%a" )
set "lxLatestVersion_Tag=%lxLatestVersion%"
set "lxLatestVersion=%lxLatestVersion:v=%"
echo lxLatestVersion: %lxLatestVersion%

:: The output of 'findstr /n /i "datetime" lxLatestRelease.txt' should be like:
::     1014: <relative-time datetime="2022-05-05T03:11:51Z" class="no-wrap"></relative-time>
for /f "tokens=3 delims==:" %%b in ('findstr /n /i "datetime" lxLatestRelease.txt') do ( set "lxLatestReleasedTime=%%b" && goto :lx_next )
:lx_next
:: Now %lxLatestReleasedTime% is like: `"2022-05-05T03`
set "lxLatestReleasedTime=%lxLatestReleasedTime:~1,10%"
echo lxLatestReleasedTime: %lxLatestReleasedTime%
echo.


:GetFfmpegLatestVersion
REM @param  %ffLatestVersion%,  %ffLatestReleasedTime%

set /p ffLatestVersion=<ffLatestVersion.txt
set /p ffLatestReleasedTime=<ffLatestReleasedTime.txt
echo ffLatestVersion: %ffLatestVersion%
echo ffLatestReleasedTime: %ffLatestReleasedTime%
echo.


:GetPipLatestVersion
REM @param  %pipUrl%,  %pipLatestVersion%,  %pipLatestReleasedTime%
REM Get %pipUrl% from https://pypi.org/project/pip/

:: The output of 'findstr /n /i "files.pythonhosted.org.*tar.gz" pipLatestRelease.txt' should be like:
::     4362:  <a href="https://files.pythonhosted.org/packages/da/f6/c83229dcc3635cdeb51874184241a9508ada15d8baa337a41093fab58011/pip-21.3.1.tar.gz">
for /f "tokens=2 delims=>=" %%a in ('findstr /n /i "files.pythonhosted.org.*tar.gz" pipLatestRelease.txt') do ( set "pipUrl=%%a" )
set "pipUrl=%pipUrl:"=%"
:: Now %pipUrl% is like: https://files.pythonhosted.org/packages/00/9e/4c83a0950d8bdec0b4ca72afd2f9cea92d08eb7c1a768363f2ea458d08b4/pip-19.2.3.tar.gz

:: Get the version number form %pipUrl%
for /f "tokens=2 delims=-" %%b in ("%pipUrl%") do ( set "pipLatestVersion=%%b")
set pipLatestVersion=%pipLatestVersion:.tar.gz=%
echo pipLatestVersion: %pipLatestVersion%

:: The output of 'findstr /n /i /c:"Released" pipLatestRelease.txt' should be like:
::     209:        Released: <time datetime="2019-10-18T08:21:23+0000" data-controller="localized-time" data-localized-time-relative="true" data-localized-time-show-time="false">
::     580:<p>Updates are released regularly, with a new version every 3 months. More details can be found in our documentation:</p>
for /f "tokens=4 delims==:" %%c in ('findstr /n /i /c:"Released" pipLatestRelease.txt') do ( set "pipLatestReleasedTime=%%c" )
:: Now %pipLatestReleasedTime% is like: "2019-08-25T04
set "pipLatestReleasedTime=%pipLatestReleasedTime:~1,10%"
echo pipLatestReleasedTime: %pipLatestReleasedTime%


:DeleteWebPages
cd ..
rd /S /Q .\temp\ >NUL 2>NUL
if exist .\.wget-hsts del .\.wget-hsts
echo. & echo.


rem ================= Generate Sources Lists =================


:AutoGenerateSourcesLists
set "filePath=sources.txt"
call :WriteCommon
call :WritePython
call :WriteYouget
call :WriteYoutubedl
call :WriteLux
call :WritePip
call :WriteFfmpeg
echo "%filePath%" has been generated.
echo Finished.
pause

:: Diff
if exist ..\sources.txt (
    echo. & echo.
    echo  * Sources Lists Difference *
    echo. & echo.
    fc /N sources.txt ..\sources.txt
    echo. & echo.
    echo  * EOF *
)
popd
pause > NUL
exit


rem ================= FUNCTIONS =================


:GetDateTime
for /f %%a in ('WMIC OS GET LocalDateTime ^| find "."') do ( set "LDT=%%a" )
set "formattedDateTime=%LDT:~0,4%-%LDT:~4,2%-%LDT:~6,2% %LDT:~8,2%:%LDT:~10,2%:%LDT:~12,2%"
goto :eof


:WriteCommon
call :GetDateTime
( echo ## Sources List of "video-downloader-deploy"
echo ## https://github.com/LussacZheng/video-downloader-deploy/blob/master/res/sources.txt
echo ## For Initial Deployment; Deployment of FFmpeg; Upgrade of you-get and youtube-dl.
echo ## ^( Auto-Generated by "%~nx0" at %formattedDateTime% ^)
echo.
REM :: Use ^^! if EnableDelayedExpansion; use single ! if not EnableDelayedExpansion.
echo ^<^^!-- DO NOT EDIT THIS FILE unless you understand the EXAMPLE. --^>
echo.
echo EXAMPLE
echo ## Title or Info
echo     # Content that already downloaded or existing.
echo     Content to be downloaded.
echo     $ Another ^(optional^) source of the same content above. But the script will ignore this line. Exchange the URLs at your own risk.
echo Mirrors{
echo     [origin]
echo     URL of the content from original source. NO '@', called "switch on".
echo     [%%region1%%]
echo     @ URL of the content from mirror source in %%region1%%.
echo     $ "@ URL", that content will not to be downloaded by this URL, called "switch off".
echo     [%%region2%%]
echo     @ For a same content in { }, only one URL is switched on at one time.
echo }
echo.
echo ^<skip^>
echo.
echo.
echo [common]
echo ## wget.exe , v1.20.3 , win32
echo     # https://eternallybored.org/misc/wget/1.20.3/32/wget.exe
echo     $ https://raw.githubusercontent.com/LussacZheng/video-downloader-deploy/master/res/wget.exe
echo.
echo ## 7za.exe , v19.00 , win32
echo     # https://raw.githubusercontent.com/LussacZheng/video-downloader-deploy/master/res/7za.exe
echo [/common]
echo.
echo.) > %filePath%
goto :eof


:WritePython
( echo [portable][quickstart][withpip]
echo ## Release log - Python
echo ## https://www.python.org/downloads/   or   https://www.python.org/downloads/windows/
echo ## Last released: %pyLatestReleasedTime%
echo.
echo ## python-embed.zip , v%pyLatestVersion% , win32
echo Mirrors{
echo     [origin]
echo     https://www.python.org/ftp/python/%pyLatestVersion%/python-%pyLatestVersion%-embed-win32.zip
echo     [cn]
echo     @ https://mirrors.huaweicloud.com/python/%pyLatestVersion%/python-%pyLatestVersion%-embed-win32.zip
echo     $ https://npmmirror.com/mirrors/python/%pyLatestVersion%/python-%pyLatestVersion%-embed-win32.zip
echo     [test]
echo     @ https://mirrors.huaweicloud.com/python/%pyLatestVersion%/python-%pyLatestVersion%-embed-win32.zip
echo }
echo [/portable][/quickstart][/withpip]
echo.
echo.) >> %filePath%
goto :eof


:WriteYouget
:: %ygBLAKE2% is like: fd/a5/c896dccb53f44f54c5c8bcfbc7b8d953289064bcfbf17cccb68136fde3bf
( echo [youget][portable][quickstart]
echo ## Release log - YouGet
echo ## https://pypi.org/project/you-get/#history   or   https://pypi.org/project/you-get/#files
echo ## Last released: %ygLatestReleasedTime%
echo.
echo ## you-get.tar.gz , v%ygLatestVersion%
echo Mirrors{
echo     [origin]
echo     https://files.pythonhosted.org/packages/%ygBLAKE2%/you-get-%ygLatestVersion%.tar.gz
echo     $ https://github.com/soimort/you-get/releases/download/v%ygLatestVersion%/you-get-%ygLatestVersion%.tar.gz
echo     [cn]
echo     @ https://mirrors.tuna.tsinghua.edu.cn/pypi/web/packages/%ygBLAKE2%/you-get-%ygLatestVersion%.tar.gz
echo     $ https://mirrors.aliyun.com/pypi/packages/%ygBLAKE2%/you-get-%ygLatestVersion%.tar.gz
echo     [test]
echo     @ https://mirrors.huaweicloud.com/repository/pypi/packages/%ygBLAKE2%/you-get-%ygLatestVersion%.tar.gz
echo     $ http://mirrors.163.com/pypi/packages/%ygBLAKE2%/you-get-%ygLatestVersion%.tar.gz
echo }
echo [/youget][/portable][/quickstart]
echo.
echo.) >> %filePath%
goto :eof


:WriteYoutubedl
( echo [youtubedl][portable]
echo ## Release log - YoutubeDL
echo ## https://github.com/ytdl-org/youtube-dl/releases/latest   or   https://pypi.org/project/youtube_dl/#files
echo ## Last released: %ydLatestReleasedTime%
echo.
echo ## youtube_dl.tar.gz , %ydLatestVersion%
echo Mirrors{
echo     [origin]
echo     https://files.pythonhosted.org/packages/%ydBLAKE2%/youtube_dl-%ydLatestVersion_trimZero%.tar.gz
echo     $ https://github.com/ytdl-org/youtube-dl/releases/download/%ydLatestVersion%/youtube-dl-%ydLatestVersion%.tar.gz
echo     $ https://yt-dl.org/downloads/latest/youtube-dl-%ydLatestVersion%.tar.gz
echo     [cn]
echo     @ https://mirrors.tuna.tsinghua.edu.cn/pypi/web/packages/%ydBLAKE2%/youtube_dl-%ydLatestVersion_trimZero%.tar.gz
echo     $ https://mirrors.aliyun.com/pypi/packages/%ydBLAKE2%/youtube_dl-%ydLatestVersion_trimZero%.tar.gz
echo     [test]
echo     @ https://mirrors.huaweicloud.com/repository/pypi/packages/%ydBLAKE2%/youtube_dl-%ydLatestVersion_trimZero%.tar.gz
echo }
echo [/youtubedl][/portable]
echo.
echo.) >> %filePath%
goto :eof


:WriteLux
( echo [portable][withpip]
echo ## Release log - Lux
echo ## https://github.com/iawia002/lux/releases/latest
echo ## Last released: %lxLatestReleasedTime%
echo.
echo ## lux_Windows.zip , v%lxLatestVersion%
echo SystemType{
echo     [64]
echo     https://github.com/iawia002/lux/releases/download/%lxLatestVersion_Tag%/lux_%lxLatestVersion%_Windows_64-bit.zip
echo     [32]
echo     @ https://github.com/iawia002/lux/releases/download/%lxLatestVersion_Tag%/lux_%lxLatestVersion%_Windows_32-bit.zip
echo }
echo [/portable][/withpip]
echo.
echo.) >> %filePath%
goto :eof


:WritePip
( echo [withpip]
echo ## get-pip.py
echo     https://bootstrap.pypa.io/get-pip.py
echo [/withpip]
echo.
echo.) >> %filePath%
goto :eof


:WriteFfmpeg
( echo [ffmpeg]
echo ## Release log - FFmpeg
echo ## https://ffmpeg.org/download.html#releases   or   https://www.gyan.dev/ffmpeg/builds/
echo ## Last released: %ffLatestReleasedTime%
echo.
echo ## ffmpeg.7z , v%ffLatestVersion%
echo SystemType{
echo     [64]
echo     https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.7z
echo     $ https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-%ffLatestVersion%-essentials_build.7z
echo     [32]
echo     @ https://github.com/LussacZheng/video-downloader-deploy/releases/download/v1.6.0/ffmpeg-4.3.1-win32-shared.zip
echo }
echo [/ffmpeg]) >> %filePath%
goto :eof


rem ================= End of File =================
