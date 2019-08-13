@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in :Upgrade-portable & :Upgrade-withpip
:: Please make sure that: only call this batch when %cd% is "res\".

for /f "tokens=3 delims= " %%a in ('"%anBin%\annie.exe" -v') do ( set "anCurrentVersion=%%a" )
set "anCurrentVersion=%anCurrentVersion:,=%"
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -np https://github.com/iawia002/annie/releases/latest -O anLatestRelease.txt
:: The output of 'findstr /n /i "<title>" anLatestRelease.txt' should be like: 
::     31:  <title>Release 0.9.4 · iawia002/annie · GitHub</title>
for /f "tokens=3 delims= " %%i in ('findstr /n /i "<title>" anLatestRelease.txt') do ( set "anLatestVersion=%%i" )
del /Q anLatestRelease.txt >NUL 2>NUL
if "%anCurrentVersion%"=="%anLatestVersion%" ( set "_isAnLatestVersion=1" ) else ( set "_isAnLatestVersion=0" )