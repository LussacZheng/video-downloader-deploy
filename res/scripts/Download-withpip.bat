@echo off
:: >>> EDIT AT YOUR OWN RISK. <<<

color F0
call res\scripts\LanguageSelector.bat
:: Import translation text
call res\scripts\lang_%_lang_%.bat

set "root=%cd%"
set "pyBin=%root%\usr\python-embed"
set "ygBin=%root%\usr\you-get"
set "ydBin=%root%\usr\youtube-dl"
set "anBin=%root%\usr"
set "ffBin=%root%\usr\ffmpeg\bin"

set "PATH=%root%\res\command;%pyBin%;%pyBin%\Scripts;%anBin%;%ffBin%;%PATH%"
if NOT exist res\command md res\command
del /Q res\command\*.cmd >NUL 2>NUL
echo @"%pyBin%\python.exe" "%pyBin%\Scripts\pip3.exe" %%*> res\command\pip3.cmd
echo @"%pyBin%\python.exe" "%pyBin%\Scripts\pip.exe" %%*> res\command\pip.cmd
echo @"%pyBin%\python.exe" "%pyBin%\Scripts\wheel.exe" %%*> res\command\wheel.cmd
echo @"%pyBin%\python.exe" "%pyBin%\Scripts\easy_install.exe" %%*> res\command\easy_install.cmd
echo @"%pyBin%\python.exe" "%pyBin%\Scripts\you-get.exe" %%*> res\command\you-get.cmd
echo @"%pyBin%\python.exe" "%pyBin%\Scripts\youtube-dl.exe" %%*> res\command\youtube-dl.cmd

if NOT exist Download md Download
cd Download

title %str_dl-bat%
echo %str_dl-guide1%
echo %str_dl-guide2%
echo.
echo %str_dl-guide3%
echo you-get https://v.youku.com/v_show/id_aBCdefGh.html
echo youtube-dl https://www.youtube.com/watch?v=aBCdefGh
echo annie https://www.bilibili.com/video/av12345678
echo.
echo %str_dl-guide4%
echo.
echo.
echo %str_dl-guide5%
echo you-get:    https://github.com/soimort/you-get/wiki/%str_dl-guide_wiki%
echo youtube-dl: https://github.com/ytdl-org/youtube-dl/blob/master/README.md
echo annie:      https://github.com/iawia002/annie/blob/master/README.md
echo.
echo.
::PROMPT [$D $T$h$h$h$h$h$h]$_$P$_$G$G$G
PROMPT $P$_$G$G$G
cmd /Q /K