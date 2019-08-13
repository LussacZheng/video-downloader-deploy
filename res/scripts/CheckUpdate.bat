@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in :Update
:: Please make sure that: only call this batch when %cd% is "res\".

set /p localVersion=<scripts\CurrentVersion
wget -q --no-check-certificate %res%/scripts/CurrentVersion -O scripts\RemoteVersion
set /p latestVersion=<scripts\RemoteVersion
if "%localVersion%"=="%latestVersion%" ( set "_isLatestVersion=1" ) else ( set "_isLatestVersion=0" )