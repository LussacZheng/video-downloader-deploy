@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Get system language -> %_lang_%
chcp|find "936" >NUL && set "_lang_=zh" || set "_lang_=en"
::chcp 65001


:: For more languages selection, re-write this batch as follow:

:: :: By default, set language as "en".
:: set "_lang=en"
:: :: Then enumerate all existing translations.
:: chcp|find "437" >NUL && set "_lang=en"
:: chcp|find "936" >NUL && set "_lang=zh"
:: chcp|find "932" >NUL && set "_lang=ja"
:: :: ... etc.