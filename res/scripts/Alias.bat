@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in :Create_Download-bat
:: Please make sure that: only call this batch when %cd% is %root%;
::     call "res\scripts\lang_*.bat" before calling this batch.
:: e.g.
:: call res\scripts\Alias.bat list
:: call res\scripts\Alias.bat add open="explorer .\"
:: call res\scripts\Alias.bat add yb="youtube-dl -f bestvideo+bestaudio"
:: call res\scripts\Alias.bat add yf="youtube-dl --proxy http://127.0.0.1:10809 -F"
:: call res\scripts\Alias.bat rm open
:: call res\scripts\Alias.bat file

@echo off
set "als_Alias=%~2"
set "als_Command=%~3"
if NOT exist usr\alias\ md usr\alias
pushd usr\alias
call :Alias_%~1
popd
echo.
goto :eof


rem ================= Action Types =================


:Alias_list
echo %str_alias-list%
setlocal EnableDelayedExpansion
for /f "delims=" %%i in ('dir /b /a-d /o:n ^| findstr "\.cmd$ \.bat$"') do (
    set "als_Alias=%%i"
    set "als_Alias=!als_Alias:~0,-4!"
    echo  * !als_Alias!
)
endlocal
goto :eof


:Alias_add
echo @%als_Command% %%*> "%als_Alias%.cmd" && call :als_added "%als_Alias%"
echo   alias %als_Alias%="%als_Command%"
goto :eof


:Alias_rm
set "a_Status=false"
if exist "%als_Alias%.cmd" ( set "a_Status=true" && del /Q "%als_Alias%.cmd" >NUL 2>NUL)
if exist "%als_Alias%.bat" ( set "a_Status=true" && del /Q "%als_Alias%.bat" >NUL 2>NUL)
if "%a_Status%"=="true" (
    call :als_removed "%als_Alias%"
) else ( call :als_notFound "%als_Alias%" )
goto :eof


:Alias_file
echo %str_alias-edit-manually%
explorer .\
goto :eof


rem ================= FUNCTIONS =================


:als_added
echo %str_alias-added%: "%~1"
goto :eof


:als_removed
echo %str_alias-removed%: "%~1"
goto :eof


:als_notFound
echo %str_alias-notFound%: "%~1"
goto :eof


rem ================= End of File =================
