@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in :setting_Wget & :setting_Wget2
:: Please make sure that: only call this batch when %cd% is "res\"; call "res\scripts\lang_*.bat" before calling this batch.
:: e.g. 
:: call scripts\GenerateWgetOptions.bat

@echo off
echo # ^>^>^> EDIT AT YOUR OWN RISK. ^<^<^<> wget.opt
echo #>> wget.opt
echo # This is a sample file used in "Deploy.bat" for the configuration of "wget.exe" options.>> wget.opt
echo #>> wget.opt
echo # 1*. Use a '#' symbol to comment.>> wget.opt
echo # 2. All options should be kept on an individual line.>> wget.opt
echo # 3. Only the first uncommented line takes effect.>> wget.opt
echo # 4. No additional 'space' at the beginning and end of the line.>> wget.opt
echo # 5*. Perform [ "Deploy.bat" -^> 6 -^> 5 ] to confirm the setting after editing this file.>> wget.opt
echo #>> wget.opt
echo # ---------->> wget.opt
echo #>> wget.opt
echo ## Default options ##>> wget.opt
echo #>> wget.opt
echo # ( Only show progress bar; Ignore HTTPS; Skip downloading if file already exists. )>> wget.opt
echo # ( https://stackoverflow.com/questions/4686464/how-to-show-wget-progress-bar-only )>> wget.opt
echo #>> wget.opt
echo -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc>> wget.opt
echo #>> wget.opt
echo # ---------->> wget.opt
echo #>> wget.opt
echo ## Proxy setting ##>> wget.opt
echo #>> wget.opt
echo # ( https://stackoverflow.com/questions/11211705/how-to-set-proxy-for-wget )>> wget.opt
echo #>> wget.opt
echo # -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc -e use_proxy=yes -e https_proxy=http://127.0.0.1:1080>> wget.opt
echo #>> wget.opt
echo # ---------->> wget.opt


rem ================= End of File =================