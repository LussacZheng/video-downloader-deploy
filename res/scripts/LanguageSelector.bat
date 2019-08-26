@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in ==Preparation==
:: No %cd% limit.
:: e.g. 
:: call res\scripts\LanguageSelector.bat
:: Get system language -> %_Language_%

chcp|find "936" >NUL && set "_Language_=zh" || set "_Language_=en"
goto :eof
::chcp 65001


:: For more languages selection, re-write this batch as follow:

:: :: By default, set language as "en".
:: set "_Language_=en"
:: :: Then enumerate all existing translations.
:: chcp|find "437" >NUL && set "_Language_=en"
:: chcp|find "936" >NUL && set "_Language_=zh"
:: chcp|find "932" >NUL && set "_Language_=ja"
:: :: ... etc.