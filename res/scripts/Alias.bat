@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in :Aliases
:: Please make sure that: only call this batch when %cd% is %root%;
::     call "res\scripts\lang_*.bat" before calling this batch.
:: e.g.
:: call res\scripts\Alias.bat list
:: call res\scripts\Alias.bat add open="explorer .\"
:: call res\scripts\Alias.bat add yb="youtube-dl -f bestvideo+bestaudio"
:: call res\scripts\Alias.bat add yf="youtube-dl --proxy http://127.0.0.1:10809 -F"
:: call res\scripts\Alias.bat addf open="explorer .\"
:: call res\scripts\Alias.bat generate proxy
:: call res\scripts\Alias.bat rm open
:: call res\scripts\Alias.bat file

@echo off
set "als_Alias=%~2"
set "als_Command=%~3"
set "als_Flag=false"
if NOT exist usr\alias\ md usr\alias
if "%~1"=="generate" goto Alias_generate
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
    set "als_Item=%%i"
    set "als_Item=!als_Item:~0,-4!"
    echo  * !als_Item!
)
endlocal
goto :eof


:Alias_add
if "%als_Alias%"=="%als_Command%" (
    echo %str_alias-add_failed%
    echo %str_alias-add_loop%
    goto :eof
)
if exist "%als_Alias%.cmd" ( set "als_Flag=true" )
if exist "%als_Alias%.bat" ( set "als_Flag=true" )
if NOT "%als_Flag%"=="true" goto als_do_add
set als_Choice=0
echo %str_alias-exist%
set /p als_Choice= %str_enter-to-cancel%
echo.
if /i "%als_Choice%"=="Y" (
    goto als_do_add
) else ( echo %str_cancelled% && goto :eof )
goto :eof


:Alias_addf
:: alias add --force
call :als_do_add
goto :eof


:Alias_generate
:: add alias by "res\scripts\GenerateAlias_*.bat" (--force)
call res\scripts\GenerateAlias_%als_Alias%.bat usr\alias
call :als_added "%als_Alias%"
echo   %str_alias-help%: "%als_Alias% help"
echo.
goto :eof


:Alias_rm
if exist "%als_Alias%.cmd" ( set "als_Flag=true" && del /Q "%als_Alias%.cmd" >NUL 2>NUL )
if exist "%als_Alias%.bat" ( set "als_Flag=true" && del /Q "%als_Alias%.bat" >NUL 2>NUL )
if "%als_Flag%"=="true" (
    call :als_removed "%als_Alias%"
) else ( call :als_notFound "%als_Alias%" )
goto :eof


:Alias_file
echo %str_alias-edit-manually%
explorer .\
goto :eof


rem ================= FUNCTIONS =================


:als_do_add
echo @%als_Command% %%*> "%als_Alias%.cmd" && call :als_added "%als_Alias%"
echo   alias %als_Alias%="%als_Command%"
goto :eof


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
