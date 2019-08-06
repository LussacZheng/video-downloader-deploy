@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Auto-Generate Sources Lists for "You-Get(Portable) Configure Batch"
:: Author: Lussac
:: Last updated: 2019-08-07
:: >>> The extractor algorithm could be expired as the revision of websites. <<<
:: https://blog.lussac.net
@echo off
REM setlocal enableDelayedExpansion


rem ================= Requiremnet Check =================


if NOT exist wget.exe (
    if exist ..\wget.exe ( 
        xcopy ..\wget.exe .\ > NUL
    ) else ( 
        echo "wget.exe" not founded. Please download it from
        echo https://raw.githubusercontent.com/LussacZheng/you-get_install_win/master/res/wget.exe
        pause>NUL
        exit
    ) 
)


:DownloadWebPages
echo Downloading web pages...
echo Please be patient while waiting for the download...
echo.
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -np https://www.python.org/downloads/windows/ -O pyLatestRelease.txt
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -np https://pypi.org/project/you-get/#files -O ygLatestRelease.txt
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -np https://ffmpeg.zeranoe.com/builds/win64/static/ -O ffLatestRelease.txt
echo.


rem ================= Get Variables =================


:GetPythonLatestVersion
REM @param  %pyLatestVersion%

:: The output of 'findstr /n /i /c:"Latest Python 3 Release" pyLatestRelease.txt' should be like: 
::     503:            <li><a href="/downloads/release/python-374/">Latest Python 3 Release - Python 3.7.4</a></li>
for /f "tokens=9 delims= " %%a in ('findstr /n /i /c:"Latest Python 3 Release" pyLatestRelease.txt') do ( set pyLatestVersion="%%a" )
:: %%b is like: 3.7.4</a></li>
:: Use ` set pyLatestVersion="%%b" ` instead of ` set "pyLatestVersion=%%b" `, since %%b contains '<' and '>'
:: And now %pyLatestVersion% is "3.7.4</a></li>" , containing "" , so next command should not be:
:: for /f "tokens=1 delims=<" %%b in ("%pyLatestVersion%"") do ( set "pyLatestVersion=%%b" )
for /f "tokens=1 delims=<" %%b in (%pyLatestVersion%) do ( set "pyLatestVersion=%%b" )
echo pyLatestVersion: %pyLatestVersion%


:GetYougetLatestVersion
REM @param  %ygLatestReleasedTime%,  %ygUrl%,  %ygLatestVersion%,  %ygUrl_BLAKE2_1%,  %ygUrl_BLAKE2_2%,  %ygUrl_BLAKE2_3%
REM Get %ygLatestDownloadUrl% (%ygUrl% for short) from https://pypi.org/project/you-get/#files

:: The output of 'findstr /n /i /c:"Last released" ygLatestRelease.txt' should be like: 
::     190:      <p class="package-header__date">Last released: <time class="-js-relative-time" datetime="2019-08-02T11:31:02+0000" data-controller="localized-time" data-localized-time-relative="true">
for /f "tokens=4 delims==" %%c in ('findstr /n /i /c:"Last released" ygLatestRelease.txt') do ( set "ygLatestReleasedTime=%%c" )
:: Now %ygLatestReleasedTime% is like: "2019-08-02T11:31:02+0000" data-controller
for /f "tokens=1-3 delims=-" %%m in ("%ygLatestReleasedTime%") do ( set "ygLatestReleasedTime_1=%%m" && set "ygLatestReleasedTime_2=%%n" && set "ygLatestReleasedTime_3=%%o" )
set "ygLatestReleasedTime=%ygLatestReleasedTime_1:"=%-%ygLatestReleasedTime_2%-%ygLatestReleasedTime_3:~0,2%"
echo ygLatestReleasedTime: %ygLatestReleasedTime%
:: The output of 'findstr /n /i "files.pythonhosted.org" ygLatestRelease.txt' should be like: 
::     4865:   <a href="https://files.pythonhosted.org/packages/20/35/4979bb3315952a9cb20f2585455bec7ba113db5647c5739dffbc542e8761/you_get-0.4.1328-py3-none-any.whl">
::     4886:   <a href="https://files.pythonhosted.org/packages/fd/a5/c896dccb53f44f54c5c8bcfbc7b8d953289064bcfbf17cccb68136fde3bf/you-get-0.4.1328.tar.gz">
for /f "skip=1 tokens=3 delims= " %%i in ('findstr /n /i "files.pythonhosted.org" ygLatestRelease.txt') do ( set ygUrl="%%i" )
REM for /f "tokens=* delims= " %%i in ('findstr /n /i "you-get-" ygLatestRelease.txt') do ( set ygUrl="%%i" )
:: Replace the " with ' since delims cannot be "
set ygUrl="%ygUrl:"='%"
:: Now %ygUrl% is like: "'href='https://files.pythonhosted.org/packages/fd/a5/c896dccb53f44f54c5c8bcfbc7b8d953289064bcfbf17cccb68136fde3bf/you-get-0.4.1328.tar.gz'>' "
:: Similarly, %ygUrl% contains "" , so next command should not be:
:: for /f "tokens=2 delims='" %%c in ("%ygUrl%") do ( set "ygUrl=%%c" )
for /f "tokens=2 delims='" %%d in (%ygUrl%) do ( set "ygUrl=%%d" )
:: Now %ygUrl% is like: https://files.pythonhosted.org/packages/fd/a5/c896dccb53f44f54c5c8bcfbc7b8d953289064bcfbf17cccb68136fde3bf/you-get-0.4.1328.tar.gz

:: Get the version number form %ygUrl%
for /f "tokens=7 delims=/" %%e in ("%ygUrl%") do ( set "ygLatestVersion=%%e")
set ygLatestVersion=%ygLatestVersion:you-get-=%
set ygLatestVersion=%ygLatestVersion:.tar.gz=%
echo ygLatestVersion: %ygLatestVersion%
:: Get the "Hash digest" in BLAKE2-256(Algorithm) for "you-get-v.er.sion.tar.gz" from %ygUrl%
for /f "tokens=4-6 delims=/" %%x in ("%ygUrl%") do ( set "ygUrl_BLAKE2_1=%%x" && set "ygUrl_BLAKE2_2=%%y" && set "ygUrl_BLAKE2_3=%%z" )
echo ygBLAKE2-256: %ygUrl_BLAKE2_1%/%ygUrl_BLAKE2_2%/%ygUrl_BLAKE2_3%


:GetFfmpegLatestVersion
REM REM @param  %ffLatestVersion%, %ffLatestReleasedTime%

for /f "delims=:" %%i in ('findstr /n /i "latest" ffLatestRelease.txt') do ( set "lineNum=%%i" )
set /a lineNum-=2
for /f "skip=%lineNum% delims=" %%f in (ffLatestRelease.txt) do ( set ffInfo="%%f" && goto next )
:: Now %ffInfo% is like: "<tr><td><a href="ffmpeg-4.1.4-win64-static.zip" title="ffmpeg-4.1.4-win64-static.zip">ffmpeg-4.1.4-win64-static.zip</a></td><td>61.9 MiB</td><td>2019-Jul-18 15:17</td></tr>"
:next
:: Similarly, %ffInfo% contains "" , no additional ""
for /f "tokens=2 delims=-" %%h in (%ffInfo%) do ( set "ffLatestVersion=%%h" )
echo ffLatestVersion: %ffLatestVersion%
for /f "tokens=4 delims= " %%i in (%ffInfo%) do ( set ffLatestReleasedTime="%%i" )
:: Now %ffLatestReleasedTime% is like: "MiB</td><td>2019-Jul-18"
:: Similarly, no additional ""
for /f "tokens=3 delims=>" %%j in (%ffLatestReleasedTime%) do ( set ffLatestReleasedTime=%%j )
echo ffLatestReleasedTime: %ffLatestReleasedTime%
echo.


:DeleteWebPages
del /Q pyLatestRelease.txt >NUL 2>NUL
del /Q ygLatestRelease.txt >NUL 2>NUL
del /Q ffLatestRelease.txt >NUL 2>NUL
if exist .wget-hsts del .wget-hsts

rem ================= Generate Sources Lists =================


:AutoGenerateSourcesLists_main
set "filePath_main=sources.txt"
echo ## Sources List of "you-get_install_win"> %filePath_main%
echo ## https://github.com/LussacZheng/you-get_install_win/blob/master/res/sources.txt>> %filePath_main%
echo ## For Initial Configuration.>> %filePath_main%
call :WriteCommon %filePath_main%
call :WritePython %filePath_main%
call :WriteYouget %filePath_main%
echo "%filePath_main%" has been generated.

:AutoGenerateSourcesLists_youget
set "filePath_youget=sources_youget.txt"
echo ## Sources List of "you-get_install_win"> %filePath_youget%
echo ## https://github.com/LussacZheng/you-get_install_win/blob/master/res/sources_youget.txt>> %filePath_youget%
echo ## For Upgrade of You-Get.>> %filePath_youget%
call :WriteCommon %filePath_youget%
echo ## Release log>> %filePath_youget%
echo ## https://pypi.org/project/you-get/#history>> %filePath_youget%
echo ## Last released: %ygLatestReleasedTime%>> %filePath_youget%
echo.>> %filePath_youget%
call :WriteYouget %filePath_youget%
echo "%filePath_youget%" has been generated.

:AutoGenerateSourcesLists_ffmpeg
set "filePath_ffmpeg=sources_ffmpeg.txt"
echo ## Sources List of "you-get_install_win"> %filePath_ffmpeg%
echo ## https://github.com/LussacZheng/you-get_install_win/blob/master/res/sources_ffmpeg.txt>> %filePath_ffmpeg%
echo ## For Configuration of FFmpeg.>> %filePath_ffmpeg%
call :WriteCommon %filePath_ffmpeg%
echo ## Release log>> %filePath_ffmpeg%
echo ## https://ffmpeg.org/download.html#releases   or   https://ffmpeg.zeranoe.com/builds/win64/static/>> %filePath_ffmpeg%
echo ## Last released: %ffLatestReleasedTime%>> %filePath_ffmpeg%
echo.>> %filePath_ffmpeg%
call :WriteFfmpeg %filePath_ffmpeg%
echo "%filePath_ffmpeg%" has been generated.


rem ================= Done =================


:Finish
echo.&echo Finished.
pause
exit


rem ================= FUNCTIONS =================


:GetDateTime
for /f %%a in ('WMIC OS GET LocalDateTime ^| find "."') do ( set "LDT=%%a" )
set "formatedDateTime=%LDT:~0,4%-%LDT:~4,2%-%LDT:~6,2% %LDT:~8,2%:%LDT:~10,2%:%LDT:~12,2%"
goto :eof

:WriteCommon
set "thisFilePath=%1"
call :GetDateTime
echo ## ( Auto-Generated by "%~nx0" at %formatedDateTime% )>> %thisFilePath%
echo.>> %thisFilePath%
:: use ^^! if enableDelayedExpansion
echo ^<!-- DO NOT EDIT THIS FILE unless you understand the EXAMPLE. --^>>> %thisFilePath%
echo.>> %thisFilePath%
echo EXAMPLE>> %thisFilePath%
echo ## Title or Info>> %thisFilePath%
echo # Content that already downloaded or existing.>> %thisFilePath%
echo Content to be downlaoded.>> %thisFilePath%
echo $ Another (optional) source of the same content above. But the script will ignore this line. Exchange the URLs at your own risk.>> %thisFilePath%
echo Mirrors{>> %thisFilePath%
echo     [origin]>> %thisFilePath%
echo     URL of the content from original source. NO '@', called "switch on".>> %thisFilePath%
echo     [%%region1%%]>> %thisFilePath%
echo     @ URL of the content from mirror source in %%region1%%.>> %thisFilePath%
echo     $ "@ URL", that content will not to be downlaoded by this URL, called "switch off".>> %thisFilePath%
echo     [%%region2%%]>> %thisFilePath%
echo     @ For a same content in { }, only one URL is switched on at one time.>> %thisFilePath%
echo }>> %thisFilePath%
echo.>> %thisFilePath%
echo ^<skip^>>> %thisFilePath%
echo.>> %thisFilePath%
echo ## wget.exe , v1.20.3 , win32>> %thisFilePath%
echo # https://eternallybored.org/misc/wget/1.20.3/32/wget.exe>> %thisFilePath%
echo #$ https://raw.githubusercontent.com/LussacZheng/you-get_install_win/master/res/wget.exe>> %thisFilePath%
echo.>> %thisFilePath%
echo ## 7za.exe , v19.00 , win32>> %thisFilePath%
echo https://raw.githubusercontent.com/LussacZheng/you-get_install_win/master/res/7za.exe>> %thisFilePath%
echo.>> %thisFilePath%
goto :eof


:WritePython
:: %thisFilePath% was setted at :WriteCommon
echo ## python-embed.zip , v%pyLatestVersion% , win32>> %thisFilePath%
echo Mirrors{>> %thisFilePath%
echo     [origin]>> %thisFilePath%
echo     https://www.python.org/ftp/python/%pyLatestVersion%/python-%pyLatestVersion%-embed-win32.zip>> %thisFilePath%
echo     [cn]>> %thisFilePath%
echo     @ https://npm.taobao.org/mirrors/python/%pyLatestVersion%/python-%pyLatestVersion%-embed-win32.zip>> %thisFilePath%
echo     [test]>> %thisFilePath%
echo     @ https://www.python.org/ftp/python/%pyLatestVersion%/python-%pyLatestVersion%-embed-win32.zip>> %thisFilePath%
echo }>> %thisFilePath%
echo.>> %thisFilePath%
goto :eof


:WriteYouget
echo ## you-get.tar.gz , v%ygLatestVersion%>> %thisFilePath%
echo Mirrors{>> %thisFilePath%
echo     [origin]>> %thisFilePath%
echo     https://files.pythonhosted.org/packages/%ygUrl_BLAKE2_1%/%ygUrl_BLAKE2_2%/%ygUrl_BLAKE2_3%/you-get-%ygLatestVersion%.tar.gz>> %thisFilePath%
echo     $ https://github.com/soimort/you-get/releases/download/v%ygLatestVersion%/you-get-%ygLatestVersion%.tar.gz>> %thisFilePath%
echo     [cn]>> %thisFilePath%
echo     @ https://mirrors.tuna.tsinghua.edu.cn/pypi/web/packages/%ygUrl_BLAKE2_1%/%ygUrl_BLAKE2_2%/%ygUrl_BLAKE2_3%/you-get-%ygLatestVersion%.tar.gz>> %thisFilePath%
echo     $ https://mirrors.aliyun.com/pypi/packages/%ygUrl_BLAKE2_1%/%ygUrl_BLAKE2_2%/%ygUrl_BLAKE2_3%/you-get-%ygLatestVersion%.tar.gz>> %thisFilePath%
echo     [test]>> %thisFilePath%
echo     @ http://mirrors.163.com/pypi/packages/%ygUrl_BLAKE2_1%/%ygUrl_BLAKE2_2%/%ygUrl_BLAKE2_3%/you-get-%ygLatestVersion%.tar.gz>> %thisFilePath%
echo }>> %thisFilePath%
goto :eof


:WriteFfmpeg
echo ## ffmpeg-static.zip , v%ffLatestVersion% , win64>> %filePath_ffmpeg%
echo https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-%ffLatestVersion%-win64-static.zip>> %filePath_ffmpeg%
echo $ https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-%ffLatestVersion%-win32-static.zip>> %filePath_ffmpeg%
goto :eof


rem ================= References =================

REM ## References
REM 1. [Another method to get Python latest version number](https://github.com/corpnewt/gibMacOS/blob/master/gibMacOS.bat#L87)