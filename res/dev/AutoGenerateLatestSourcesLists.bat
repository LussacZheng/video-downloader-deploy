@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Auto-Generate Sources Lists for "Video Downloaders One-Click Deployment Batch"
:: Author: Lussac (https://blog.lussac.net)
:: Last updated: 2020-03-30
:: >>> The extractor algorithm could be expired as the revision of websites. <<<
:: >>> Get updated from: https://github.com/LussacZheng/video-downloader-deploy/tree/master/res/dev <<<
:: >>> EDIT AT YOUR OWN RISK. <<<
@echo off
setlocal EnableDelayedExpansion
:: Read the comment at the 7th line of :WriteCommon (appr. Line#269) when EnableDelayedExpansion.


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
if NOT exist wget.exe (
    if exist ..\wget.exe (
        xcopy ..\wget.exe .\ > NUL
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
echo py=python, yg=you-get, yd=youtube-dl, an=annie, ff=ffmpeg, pip=pip
echo.
set "_WgetOptions_=-q --show-progress --progress=bar:force:noscroll --no-check-certificate -np"
wget %_WgetOptions_% https://www.python.org/downloads/windows/ -O pyLatestRelease.txt
wget %_WgetOptions_% https://pypi.org/project/you-get/ -O ygLatestRelease.txt
wget %_WgetOptions_% https://github.com/ytdl-org/youtube-dl/releases/latest -O ydLatestRelease.txt
wget %_WgetOptions_% https://github.com/iawia002/annie/releases/latest -O anLatestRelease.txt
wget %_WgetOptions_% https://ffmpeg.zeranoe.com/builds/win64/static/ -O ffLatestRelease.txt
wget %_WgetOptions_% https://pypi.org/project/pip/ -O pipLatestRelease.txt
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

:: The output of 'findstr /n /i "files.pythonhosted.org" ygLatestRelease.txt' should be like:
::     4865:   <a href="https://files.pythonhosted.org/packages/20/35/4979bb3315952a9cb20f2585455bec7ba113db5647c5739dffbc542e8761/you_get-0.4.1328-py3-none-any.whl">
::     4886:   <a href="https://files.pythonhosted.org/packages/fd/a5/c896dccb53f44f54c5c8bcfbc7b8d953289064bcfbf17cccb68136fde3bf/you-get-0.4.1328.tar.gz">
for /f "skip=1 tokens=2 delims=>=" %%a in ('findstr /n /i "files.pythonhosted.org" ygLatestRelease.txt') do ( set "ygUrl=%%a" )
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
REM @param  %ydLatestVersion%

:: The output of 'findstr /n /i "<title>" ydLatestRelease.txt' should be like:
::     31:  <title>Release youtube-dl 2019.08.02 · ytdl-org/youtube-dl · GitHub</title>
for /f "tokens=4 delims= " %%a in ('findstr /n /i "<title>" ydLatestRelease.txt') do ( set "ydLatestVersion=%%a" )
echo ydLatestVersion: %ydLatestVersion%
echo.


:GetAnnieLatestVersion
REM @param  %anLatestVersion%,  %anLatestReleasedTime%

:: The output of 'findstr /n /i "<title>" anLatestRelease.txt' should be like:
::     31:  <title>Release 0.9.4 · iawia002/annie · GitHub</title>
for /f "tokens=3 delims= " %%a in ('findstr /n /i "<title>" anLatestRelease.txt') do ( set "anLatestVersion=%%a" )
echo anLatestVersion: %anLatestVersion%

:: The output of 'findstr /n /i "relative-time" anLatestRelease.txt' should be like:
::     700:    <relative-time datetime="2019-08-13T14:18:48Z">Aug 13, 2019</relative-time>
for /f "tokens=3 delims==:" %%b in ('findstr /n /i "relative-time" anLatestRelease.txt') do ( set "anLatestReleasedTime=%%b" )
:: Now %anLatestReleasedTime% is like: "2019-08-13T14
set "anLatestReleasedTime=%anLatestReleasedTime:~1,10%"
echo anLatestReleasedTime: %anLatestReleasedTime%
echo.


:GetFfmpegLatestVersion
REM @param  %ffLatestVersion%,  %ffLatestReleasedTime%

for /f "delims=:" %%a in ('findstr /n /i "latest" ffLatestRelease.txt') do ( set "lineNum=%%a" )
set /a lineNum-=2
for /f "skip=%lineNum% delims=" %%b in (ffLatestRelease.txt) do ( set "ffInfo="%%b"" && goto :next )
:next
:: Use ` set "ffInfo="%%b"" ` instead of ` set "ffInfo=%%b" `, since %%b contains '<' and '>'
:: Now %ffInfo% is like: "<tr><td><a href="ffmpeg-4.1.4-win64-static.zip" title="ffmpeg-4.1.4-win64-static.zip">ffmpeg-4.1.4-win64-static.zip</a></td><td>61.9 MiB</td><td>2019-Jul-18 15:17</td></tr>"
:: %ffInfo% contains "" , so next command should not have additional "" as following:
:: for /f "tokens=2 delims=-" %%c in ("%ffInfo%") do ( set "ffLatestVersion=%%c" )
for /f "tokens=2 delims=-" %%c in (%ffInfo%) do ( set "ffLatestVersion=%%c" )
echo ffLatestVersion: %ffLatestVersion%
for /f "tokens=12 delims=> " %%d in (%ffInfo%) do ( set "ffLatestReleasedTime=%%d" )
echo ffLatestReleasedTime: %ffLatestReleasedTime%
echo.


:GetPipLatestVersion
REM @param  %pipUrl%,  %pipLatestVersion%,  %pipLatestReleasedTime%
REM Get %pipUrl% from https://pypi.org/project/pip/

:: The output of 'findstr /n /i "files.pythonhosted.org" pipLatestRelease.txt' should be like:
::     3048:   <a href="https://files.pythonhosted.org/packages/30/db/9e38760b32e3e7f40cce46dd5fb107b8c73840df38f0046d8e6514e675a1/pip-19.2.3-py2.py3-none-any.whl">
::     3080:   <a href="https://files.pythonhosted.org/packages/00/9e/4c83a0950d8bdec0b4ca72afd2f9cea92d08eb7c1a768363f2ea458d08b4/pip-19.2.3.tar.gz">
for /f "skip=1 tokens=2 delims=>=" %%a in ('findstr /n /i "files.pythonhosted.org" pipLatestRelease.txt') do ( set "pipUrl=%%a" )
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
del /Q pyLatestRelease.txt >NUL 2>NUL
del /Q ygLatestRelease.txt >NUL 2>NUL
del /Q ydLatestRelease.txt >NUL 2>NUL
del /Q anLatestRelease.txt >NUL 2>NUL
del /Q ffLatestRelease.txt >NUL 2>NUL
del /Q pipLatestRelease.txt >NUL 2>NUL
if exist .wget-hsts del .wget-hsts
echo. & echo.


rem ================= Generate Sources Lists =================


:AutoGenerateSourcesLists
set "filePath=sources.txt"
call :WriteCommon
call :WritePython
call :WriteYouget
call :WriteYoutubedl
call :WriteAnnie
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
pause > NUL
exit


rem ================= FUNCTIONS =================


:GetDateTime
for /f %%a in ('WMIC OS GET LocalDateTime ^| find "."') do ( set "LDT=%%a" )
set "formatedDateTime=%LDT:~0,4%-%LDT:~4,2%-%LDT:~6,2% %LDT:~8,2%:%LDT:~10,2%:%LDT:~12,2%"
goto :eof


:WriteCommon
call :GetDateTime
( echo ## Sources List of "video-downloader-deploy"
echo ## https://github.com/LussacZheng/video-downloader-deploy/blob/master/res/sources.txt
echo ## For Initial Deployment; Deployment of FFmpeg; Upgrade of You-Get.
echo ## ^( Auto-Generated by "%~nx0" at %formatedDateTime% ^)
echo.
REM :: Use ^^! if EnableDelayedExpansion; use single ! if not EnableDelayedExpansion.
echo ^<^^!-- DO NOT EDIT THIS FILE unless you understand the EXAMPLE. --^>
echo.
echo EXAMPLE
echo ## Title or Info
echo     # Content that already downloaded or existing.
echo     Content to be downlaoded.
echo     $ Another ^(optional^) source of the same content above. But the script will ignore this line. Exchange the URLs at your own risk.
echo Mirrors{
echo     [origin]
echo     URL of the content from original source. NO '@', called "switch on".
echo     [%%region1%%]
echo     @ URL of the content from mirror source in %%region1%%.
echo     $ "@ URL", that content will not to be downlaoded by this URL, called "switch off".
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
echo     $ https://npm.taobao.org/mirrors/python/%pyLatestVersion%/python-%pyLatestVersion%-embed-win32.zip
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
( echo [portable]
echo ## Release log - YoutubeDL
echo ## https://github.com/ytdl-org/youtube-dl/releases/latest
echo ## Last released: %ydLatestVersion%
echo.
echo ## youtube-dl.tar.gz , %ydLatestVersion%
echo     https://github.com/ytdl-org/youtube-dl/releases/download/%ydLatestVersion%/youtube-dl-%ydLatestVersion%.tar.gz
echo [/portable]
echo.
echo.) >> %filePath%
goto :eof


:WriteAnnie
( echo [portable][withpip]
echo ## Release log - Annie
echo ## https://github.com/iawia002/annie/releases/latest
echo ## Last released: %anLatestReleasedTime%
echo.
echo ## annie_Windows.zip , v%anLatestVersion%
echo SystemType{
echo     [64]
echo     https://github.com/iawia002/annie/releases/download/%anLatestVersion%/annie_%anLatestVersion%_Windows_64-bit.zip
echo     [32]
echo     @ https://github.com/iawia002/annie/releases/download/%anLatestVersion%/annie_%anLatestVersion%_Windows_32-bit.zip
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
echo ## https://ffmpeg.org/download.html#releases   or   https://ffmpeg.zeranoe.com/builds/win64/static/
echo ## Last released: %ffLatestReleasedTime%
echo.
echo ## ffmpeg-static.zip , v%ffLatestVersion% , win64
echo SystemType{
echo     [64]
echo     https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-%ffLatestVersion%-win64-static.zip
echo     [32]
echo     @ https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-%ffLatestVersion%-win32-static.zip
echo }
echo [/ffmpeg]) >> %filePath%
goto :eof


rem ================= End of File =================
