@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
@echo off
setlocal enabledelayedexpansion

set sourcesFile=%~1
set region=%~2

:: enum mirror_tag {
:: 0: Nothing to do with next line;
:: 1: Switch on (delete '@' from) the next line.
:: 2: Switch off (add '@' to) the next line.
:: 3: Logical negation. Switch on/off (delete/add '@' from/to) the next line.
::      echo !mirror_temp! | findstr "@">nul && ( set "mirror_temp=!mirror_temp:@ =!") || (set "mirror_temp=!mirror_temp:http=@ http!") 
:: }
set mirror_tag=0

:: Rewrite sources-%region%.txt
type nul > download\%sourcesFile%-%region%.txt
for /f "delims=:" %%i in ('findstr /n /i "<skip>" %sourcesFile%.txt') do ( set "mirror_skipLine=%%i" )
:: Find which line has the "<skip>" tag, skip these lines above.
for /f "eol=# skip=%mirror_skipLine% delims=" %%i in (%sourcesFile%.txt) do (
    if !mirror_tag!==0 (
        ::  use '\' to avoid wrong match, caused by a special match rule, like: findstr "[0-9]" is ture for number "6".
        echo %%i | findstr "\[">nul && ( set "mirror_tag=2" ) 
        echo %%i | findstr "\[%region%\]">nul && ( set "mirror_tag=1" )
        echo %%i>>download\%sourcesFile%-%region%.txt   
    ) else (
        set mirror_temp=%%i
        if !mirror_tag!==1 (
            echo !mirror_temp! | findstr "@">nul && ( set "mirror_temp=!mirror_temp:@ =!")
        ) else (
            echo !mirror_temp! | findstr "@">nul || (set "mirror_temp=!mirror_temp:http=@ http!")
        )
        echo !mirror_temp!>>download\%sourcesFile%-%region%.txt
        set mirror_tag=0
    ) 
)