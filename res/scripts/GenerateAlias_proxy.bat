@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "res\scripts\Alias.bat" in :Alias_generate
:: Please make sure that: only call this batch when %cd% is %root%;
::     call "res\scripts\lang_*.bat" before calling this batch.
:: e.g.
:: call res\scripts\GenerateAlias_proxy.bat usr\alias

@echo off
set "ga_proxy_filename=%~1\proxy.cmd"


rem ================= Basic Command =================


REM :: Head
( echo @rem %str_fileMode%
echo @rem ^>^>^> EDIT AT YOUR OWN RISK. ^<^<^<
echo @echo off
echo.


REM :: Help message
echo :: %str_alsProxy_usage%: proxy [command]
echo ::
echo :: %str_alsProxy_usage2%:
echo ::                   %str_alsProxy_usage_null%
echo ::     toggle        %str_alsProxy_usage_toggle%
echo ::     on            %str_alsProxy_usage_on%
echo ::     off           %str_alsProxy_usage_off%
echo ::     use ^<[host:]port^>
echo ::     use ^<httpHost:port^> ^<httpsHost:port^>
echo ::                   %str_alsProxy_usage_use%
echo ::     status        %str_alsProxy_usage_status%
echo ::     help          %str_alsProxy_usage_help%
echo ::
echo :: end
echo.


REM :: Parse command
echo echo.
echo set "_proxy_command=%%~1"
echo if "%%_proxy_command%%"=="" goto Proxy_toggle
echo if "%%_proxy_command%%"=="toggle" goto Proxy_toggle
echo if "%%_proxy_command%%"=="on" goto Proxy_enable
echo if "%%_proxy_command%%"=="off" goto Proxy_disable
echo if "%%_proxy_command%%"=="use" goto Proxy_use
echo if "%%_proxy_command%%"=="status" goto Proxy_status
echo if "%%_proxy_command%%"=="help" goto Proxy_help
echo echo proxy %%_proxy_command%%: %str_alsProxy_usage3%
echo echo. ^&^& goto Proxy_help
echo goto :eof
echo.
echo.


rem ================= Action Types =================


REM :: Toggle the Proxy for current window
echo :Proxy_toggle
echo call :proxy_get
echo if "%%_proxy_state%%"=="true" goto Proxy_disable
echo goto Proxy_enable
echo.


REM :: Enable the Proxy for current window
echo :Proxy_enable
echo call :proxy_cache_read
REM :: If failed to access the `deploy.settings` after a cache miss,
REM ::   print out the error message directly.
echo if "%%_proxy_state%%"=="unknown" goto proxy_msg
echo goto Proxy_status
echo.


REM :: Disable the Proxy for current window
echo :Proxy_disable
echo set "http_proxy="
echo set "https_proxy="
echo set "_proxy_state=false"
echo call :proxy_msg
echo goto :eof
echo.


REM :: Apply the temporary Proxy defined by user-provided args
echo :Proxy_use
echo set "_proxy_server=%%~2"
echo if "%%_proxy_server%%"=="" ^(
echo     set "_proxy_state=noargs"
echo     goto proxy_msg
echo ^)
REM :: Usage examples:
REM ::   proxy use 1234
REM ::       ==> same as `proxy use http://127.0.0.1:1234`
REM ::   proxy use http://10.20.30.40:1234
REM ::       ==> same as `proxy use http://10.20.30.40:1234 http://10.20.30.40:1234`
REM ::   proxy use http://10.20.30.40:1234 https://50.60.70.80:5678
REM ::       ==> same as `set http_proxy=http://10.20.30.40:1234
REM ::                    set https_proxy=https://50.60.70.80:5678`
echo echo %%_proxy_server%% ^| findstr ":" ^>NUL ^&^& ^(
echo         call :proxy_cache_write "%%_proxy_server%%" "%%~3"
echo     ^) ^|^| ^(
echo         call :proxy_cache_write "http://127.0.0.1:%%_proxy_server%%"
echo     ^)
echo goto Proxy_status
echo goto :eof
echo.


REM :: Show the value of %HTTP_PROXY% and %HTTPS_PROXY%
echo :Proxy_status
echo call :proxy_get
echo call :proxy_msg
echo echo "HTTP_PROXY=%%http_proxy%%"
echo echo "HTTPS_PROXY=%%https_proxy%%"
echo echo.
echo goto :eof
echo.


REM :: Print the help message
echo :Proxy_help
echo setlocal EnableDelayedExpansion
echo for /f "usebackq eol=@ delims=" %%%%i in ^("%%~f0"^) do ^(
echo     set "_proxy_temp="%%%%i""
echo     echo ^^!_proxy_temp^^! ^| findstr "::" ^>NUL ^&^& ^(
echo             set "_proxy_temp=^!_proxy_temp:::=^!"
echo             set "_proxy_temp=^!_proxy_temp:"=^^!"
echo         ^)
echo     if "^!_proxy_temp^!"=="" ^(
echo         echo.
echo     ^) else if "^!_proxy_temp^!"==" end" ^(
echo         goto proxy_endOfHelp
echo     ^) else ^(
echo         echo ^^!_proxy_temp^^!
echo     ^)
echo ^)
echo :proxy_endOfHelp
echo endlocal
echo goto :eof
echo.


rem ================= FUNCTIONS =================


REM :: Get the state of proxy -> %_proxy_state%
echo :proxy_get
echo if NOT defined _proxy_state ^( set "_proxy_state=false" ^)
echo if NOT "%%http_proxy%%"=="" ^( set "_proxy_state=true" ^)
echo if NOT "%%https_proxy%%"=="" ^( set "_proxy_state=true" ^)
echo goto :eof
echo.


REM :: Print status message according to %_proxy_state%
echo :proxy_msg
echo if "%%_proxy_state%%"=="true" ^(
echo     echo %str_alsProxy_true%
echo ^)
echo if "%%_proxy_state%%"=="false" ^(
echo     echo %str_alsProxy_false%
echo ^)
echo if "%%_proxy_state%%"=="unknown" ^(
echo     echo %str_alsProxy_unknown%
echo ^)
echo if "%%_proxy_state%%"=="noargs" ^(
echo     echo proxy %%_proxy_command%%: %str_alsProxy_noargs%
echo ^)
echo echo.
echo goto :eof
echo.


REM :: Simulate caching mechanism to store the proxy settings -> %_proxy_storage%
echo :proxy_cache_read
REM :: cache hit [start]
echo if defined _proxy_storage ^( goto proxy_cache_apply ^)
REM :: cache hit [end]
REM :: cache miss [start]
echo if NOT defined _root ^( set "_root=%%~dp0..\.." ^)
echo if NOT exist "%%_root%%\res\deploy.settings" ^(
echo     set "_proxy_state=unknown"
echo     goto :eof
echo ^)
echo pushd "%%_root%%\res"
echo set "_proxyHost=" ^& set "_httpPort=" ^& set "_httpsPort="
echo for /f "tokens=2 delims= " %%%%i in ^('findstr /i "ProxyHost" deploy.settings'^) do ^( set "_proxyHost=%%%%i" ^)
echo for /f "tokens=2 delims= " %%%%i in ^('findstr /i "HttpPort" deploy.settings'^) do ^( set "_httpPort=%%%%i" ^)
echo for /f "tokens=2 delims= " %%%%i in ^('findstr /i "HttpsPort" deploy.settings'^) do ^( set "_httpsPort=%%%%i" ^)
echo popd
REM :: Only when none of these three variables is null, in other words,
REM ::   when they are all assigned, set %_proxy_state% to "true"
echo if NOT "%%_proxyHost%%"=="" if NOT "%%_httpPort%%"=="" if NOT "%%_httpsPort%%"=="" ^(
echo     call :proxy_cache_write "%%_proxyHost%%:%%_httpPort%%" "%%_proxyHost%%:%%_httpsPort%%"
echo ^) else ^(
echo     set "_proxy_state=unknown"
echo ^)
REM :: cache miss [end]
echo goto :eof
echo.


REM :: Write the proxy settings into %_proxy_storage% and %_proxy_storage_https%
echo :proxy_cache_write
REM :: write and apply
echo set "_proxy_storage=%%~1"
echo set "_proxy_storage_https=%%~1"
echo if NOT "%%~2"=="" ^( set "_proxy_storage_https=%%~2" ^)
echo call :proxy_cache_apply
echo goto :eof
echo.


REM :: Apply the proxy settings by using %_proxy_storage% and %_proxy_storage_https%
echo :proxy_cache_apply
echo set "http_proxy=%%_proxy_storage%%"
echo set "https_proxy=%%_proxy_storage%%"
echo if NOT "%%_proxy_storage_https%%"=="" ^( set "https_proxy=%%_proxy_storage_https%%" ^)
echo set "_proxy_state=true"
echo goto :eof


REM :: The end of the whole alias generating
echo.) > %ga_proxy_filename%


rem ================= End of File =================
