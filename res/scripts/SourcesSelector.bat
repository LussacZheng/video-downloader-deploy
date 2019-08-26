@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in :Setup_FFmpeg & :Common & :Upgrade_YouGet & 
:: Please make sure that: only call this batch when %cd% is "res\".
:: e.g. 
:: call scripts\SourcesSelector.bat sources.txt portable cn 64 download\to-be-downloaded.txt
:: call scripts\SourcesSelector.bat sources.txt youget origin 32 download\to-be-downloaded.txt

@echo off
setlocal EnableDelayedExpansion


set ss_Input=%~1
set ss_Required=%~2
set ss_Region=%~3
set ss_SystemType=%~4
set "ss_Output=download\%ss_Input:.txt=%-%ss_Required%-%ss_Region%.txt"
set "ss_Final=%~5"


:: enum ss_Tag_required {
:: 0: Not required. Skip the following lines until ss_Tag_required changes.
:: 1: Required. Then goto switch on/off.
:: }

:: enum ss_Tag_switch {
:: 0: Nothing to do with next line;
:: 1: Switch on (delete '@' from) the next line.
:: 2: Switch off (add '@' to) the next line.
:: 3: Logical negation. Switch on/off (delete/add '@' from/to) the next line.
::      echo !ss_Temp! | findstr "@">nul && ( set "ss_Temp=!ss_Temp:@ =!") || (set "ss_Temp=!ss_Temp:http=@ http!") 
:: }

set ss_Tag_required=0
set ss_Tag_switch=0


:: Extract all required parts from sources.txt
type nul > %ss_Output%
for /f "delims=:" %%a in ('findstr /n /i "<skip>" %ss_Input%') do ( set "ss_SkipLine=%%a" )
:: Find which line has the "<skip>" tag, skip these lines above.
for /f "eol=# skip=%ss_SkipLine% delims=" %%i in (%ss_Input%) do (
    echo %%i | findstr "\[%ss_Required%\]">nul && ( set "ss_Tag_required=1" )
    if !ss_Tag_required!==1 (
        if !ss_Tag_switch!==0 (
            REM ::  use '\' to avoid wrong match, caused by a special match rule, like: findstr "[0-9]" is ture for number "6".
            REM ::  set ss_Tag_switch=2 by default if this line conains '['
            echo %%i | findstr "\[">nul && ( set "ss_Tag_switch=2" )      
            echo %%i | findstr "\[%ss_Region%\]">nul && ( set "ss_Tag_switch=1" )
            echo %%i | findstr "\[%ss_SystemType%\]">nul && ( set "ss_Tag_switch=1" )
            echo %%i>> %ss_Output%
        ) else (
            set "ss_Temp=%%i"
            if !ss_Tag_switch!==1 (
                echo !ss_Temp! | findstr "@">nul && ( set "ss_Temp=!ss_Temp:@ =!")
            ) else (
                echo !ss_Temp! | findstr "@">nul || (set "ss_Temp=!ss_Temp:http=@ http!" )
            )
            echo !ss_Temp!>> %ss_Output%
            set ss_Tag_switch=0
        )
    )     
    echo %%i | findstr "\[/%ss_Required%\]">nul && ( set "ss_Tag_required=0" )
)


:: Extract all URLs that are switched on. Actually this step can be skipped.
:: Because "wget.exe" can identify whether a line is pure URL(switched on).
:: This step is just for the convenience of the user.
type nul > %ss_Final%
for /f "delims=" %%i in (' findstr /i /c:"    http" %ss_Output%') do (
    set "ss_Temp=%%i"
    echo !ss_Temp:    =!>> %ss_Final%
)

REM del /Q %ss_Output% >NUL 2>NUL