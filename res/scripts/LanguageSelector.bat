@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in ==Preparation==
:: No %cd% limit.
:: e.g.
:: call res\scripts\LanguageSelector.bat
:: Get system language -> %_Language_%

:: By default, set language to "en".
set "_Language_=en"
:: Then enumerate all the existing translations.
:: chcp | find "437" >NUL && set "_Language_=en"
chcp | find "936" >NUL && set "_Language_=zh"
chcp | find "950" >NUL && set "_Language_=cht"
:: chcp | find "932" >NUL && set "_Language_=ja"
:: ... etc.
goto :eof

REM chcp 65001

:: chcp | find "936" >NUL && set "_Language_=zh" || set "_Language_=en"
