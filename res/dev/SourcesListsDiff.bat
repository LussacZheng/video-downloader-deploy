@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Tell the difference between two "sources.txt" of "Video Downloaders One-Click Deployment Batch"
:: Author: Lussac (https://blog.lussac.net)
:: Last updated: 2019-09-24
:: >>> Do NOT treat this batch as a true Diff tool. It can ONLY be used to diff "sources.txt". Run command `help fc` instead. <<<
:: >>> Get updated from: https://github.com/LussacZheng/video-downloader-deploy/tree/master/res/dev <<<
:: >>> EDIT AT YOUR OWN RISK. <<<
@echo off
setlocal EnableDelayedExpansion


rem ================= Preparation =================


:: Set the path of two files here
set "new=sources.txt"
set "old=..\sources.txt"


rem ================= Diff =================


:: https://stackoverflow.com/questions/20644249/find-list-of-differences-in-two-text-files-batch-script
echo. & echo  * Sources Lists Difference *

echo. & echo.
echo -------------------------------------------------------
echo ---------------------- Additions ----------------------
echo -------------------------------------------------------
echo  What from "%new%" is not in "%old%" :
echo -------------------------------------------------------
echo.
findstr /b /e /ivg:"%old%" "%new%" > diff1.txt
for /f "delims=" %%i in (diff1.txt) do ( 
    set "temp=%%i"
    REM :: Escape character \"
    set "temp=!temp:"=\"!"
    for /f "tokens=1,* delims=:" %%a in ('findstr /b /e /n /i /c:"!temp!" "%new%"') do (
        echo %%a:    %%b
    )  
)

echo. & echo.
echo -------------------------------------------------------
echo ---------------------- Deletions ----------------------
echo -------------------------------------------------------
echo  What from "%old%" is not in "%new%" :
echo -------------------------------------------------------
echo.
findstr /b /e /ivg:"%new%" "%old%" > diff2.txt
for /f "delims=" %%i in (diff2.txt) do ( 
    set "temp=%%i"
    REM :: Escape character \"
    set "temp=!temp:"=\"!"
    for /f "tokens=1,* delims=:" %%a in ('findstr /b /e /n /i /c:"!temp!" "%old%"') do (
        echo %%a:    %%b
    )  
)

del /Q diff1.txt >NUL 2>NUL
del /Q diff2.txt >NUL 2>NUL
echo. & echo. & echo.
echo  * EOF *
pause > NUL
exit