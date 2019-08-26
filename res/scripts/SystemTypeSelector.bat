@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in ==Preparation==
:: No %cd% limit.
:: e.g. 
:: call res\scripts\SystemTypeSelector.bat
:: Get system type -> %_SystemType_%

if /i "%PROCESSOR_IDENTIFIER:~0,3%"=="x86" (
	set "_SystemType_=32"
) else (
	set "_SystemType_=64"
)