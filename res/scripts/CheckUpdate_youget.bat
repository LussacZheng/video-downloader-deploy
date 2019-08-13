@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in :Upgrade-portable & :Upgrade-quickstart
:: Please make sure that: only call this batch when %cd% is "res\".

for /f "tokens=2 delims='" %%a in ('type "%ygBin%\src\you_get\version.py" ^| find "version"') do ( set "ygCurrentVersion=%%a" )
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -np https://github.com/soimort/you-get/releases/latest -O ygLatestRelease.txt
:: The output of 'findstr /n /i "<title>" ygLatestRelease.txt' should be like: 
::     31:  <title>Release 0.4.1328 · soimort/you-get · GitHub</title>
for /f "tokens=3 delims= " %%i in ('findstr /n /i "<title>" ygLatestRelease.txt') do ( set "ygLatestVersion=%%i" )
del /Q ygLatestRelease.txt >NUL 2>NUL
if "%ygCurrentVersion%"=="%ygLatestVersion%" ( set "_isYgLatestVersion=1" ) else ( set "_isYgLatestVersion=0" )


:: (python -V) > test.txt              ---> OK
:: (you-get -V) > test.txt             ---> NO output
:: (youtube-dl --version) > test.txt   ---> OK
:: (annie -v) > test.txt               ---> OK

:: When there is even no ygBin, return 0. So that it will directly download the latest version.
:: if NOT exist "%ygBin%\src\you_get\version.py" set "_isYgLatestVersion=0"