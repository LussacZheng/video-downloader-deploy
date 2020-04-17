@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in :InitDeploy-* & :Upgrade & :Update
:: Please make sure that: only call this batch when %cd% is "res\"; call "res\scripts\lang_*.bat" before calling this batch.
:: e.g.
:: call scripts\Download.bat main
:: call scripts\Download.bat dependency
:: call scripts\Download.bat wget

@echo off
call :Download_%~1
goto :eof


rem ================= FUNCTIONS =================


:Download_main
call :Download_wget
echo %str_downloading%...
call :Download_7za
:: %_Region_% was set in res\scripts\lang_%_Language_%.bat
call scripts\SourcesSelector.bat sources.txt %DeployMode% %_Region_% %_SystemType_% download\to-be-downloaded.txt
:: https://stackoverflow.com/questions/4686464/how-to-show-wget-progress-bar-only
wget %_WgetOptions_% -i download\to-be-downloaded.txt -P download
:: if exist .wget-hsts del .wget-hsts
goto :eof


:: Make sure the existence of "res\wget.exe" and import %_WgetOptions_%
:Download_wget
if NOT exist wget.exe (
    echo %str_downloading% "wget.exe", %str_please-wait%...
    REM :: use ^) instead of )
    REM powershell (New-Object Net.WebClient^).DownloadFile('%_RemoteRes_%/wget.exe', 'wget.exe'^)
    powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (new-object System.Net.WebClient).DownloadFile('%_RemoteRes_%/wget.exe','wget.exe')"
)
call scripts\Getter.bat WgetOptions
goto :eof


:: Make sure the existence of "res\7za.exe" and "res\download\7za.exe"
:: call :Download_wget before calling this function.
:Download_7za
if NOT exist 7za.exe (
    wget %_WgetOptions_% %_RemoteRes_%/7za.exe
)
if NOT exist download\7za.exe (
    xcopy 7za.exe download\ > NUL
)
goto :eof


:Download_dependency
call :Download_wget
call :Download_7za
goto :eof


rem ================= End of File =================
