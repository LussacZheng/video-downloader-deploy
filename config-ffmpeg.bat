rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: FFmpeg Configure Batch
:: Author: Lussac
:: Version: embed-0.1.0
:: Last updated: 2019/06/02
:: https://blog.lussac.net
@echo off
set version=embed-0.1.0
set date=2019/06/02

cls
echo =============================================
echo =============================================
echo ==== FFmpeg Configure Batch  (By Lussac) ====
echo =============================================
echo ===== Version: %version% (%date%) =====
echo =============================================
echo =============================================
echo.
:: Check whether FFmpeg already installed
echo %PATH%|findstr /i "ffmpeg">NUL && goto configured|| goto check-ffmpeg-zip

:check-ffmpeg-zip
:: Check whether "ffmpeg-x.x.x.zip" exist
for /f "delims=" %%i in ('dir /b /a:a ffmpeg*.zip') do (set FFmpegZip=%%i&goto install-ffmpeg)
echo.&echo "ffmpeg-x.x.x-*.zip" NOT found.
goto EOF

:install-ffmpeg
echo Unzipping %FFmpegZip% ...
if NOT exist 7za.exe (
    echo.&echo "7za.exe" NOT found.
    goto EOF
)
7za x %FFmpegZip% -oC:\ -aoa > NUL
move C:\ffmpeg* C:\ffmpeg > NUL
setx "Path" "%Path%;C:\ffmpeg\bin"

:configured
echo FFmpeg already configured.

:: END OF FILE
:EOF
echo.&echo Press any key to exit.
pause>NUL
exit