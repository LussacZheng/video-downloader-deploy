@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in :Upgrade-portable
:: Please make sure that: only call this batch when %cd% is "res\".

for /f "tokens=2 delims='" %%a in ('type "%ydBin%\youtube_dl\version.py" ^| find "version"') do ( set "ydCurrentVersion=%%a" )
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -np https://github.com/ytdl-org/youtube-dl/releases/latest -O ydLatestRelease.txt
:: The output of 'findstr /n /i "<title>" ydLatestRelease.txt' should be like: 
::     31:  <title>Release youtube-dl 2019.08.02 · ytdl-org/youtube-dl · GitHub</title>
for /f "tokens=4 delims= " %%i in ('findstr /n /i "<title>" ydLatestRelease.txt') do ( set "ydLatestVersion=%%i" )
del /Q ydLatestRelease.txt >NUL 2>NUL
if "%ydCurrentVersion%"=="%ydLatestVersion%" ( set "_isYdLatestVersion=1" ) else ( set "_isYdLatestVersion=0" )