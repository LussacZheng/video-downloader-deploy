# 功能实验室 (Lab features)
> [`you-get_install_win/res/dev/`](https://github.com/LussacZheng/you-get_install_win/tree/master/res/dev)

- 此目录下的脚本为 `develop` 状态，不保证功能稳定，请自行抉择是否使用；
- 下文中，称 `config.bat` 为 “主程序” ；
- 此目录下的脚本未被 主程序 引用。删除该文件夹不影响 `config.bat` 运行。

---

## AutoGenerateLatestSourcesLists

自动生成含有 `python-embed.zip` , `you-get.tar.gz` , `ffmpeg-static.zip` 的最新版本下载链接的 `sources*.txt` 。可供 主程序 使用。

### 原理
自动解析 [Python](https://www.python.org/downloads/windows/), [You-Get](https://pypi.org/project/you-get/#files), [FFmpeg](https://ffmpeg.zeranoe.com/builds/win64/static/) 项目发布页等相关网页，获得其最新版本的下载链接。

### 使用
确保 `AutoGenerateLatestSourcesLists.bat` 当前所在目录或上级目录存在 `wget.exe` ，直接运行脚本即可。  
若正常运行，则会在当前目录生成 `sources.txt` , `sources_youget.txt` 和 `sources_ffmpeg.txt`。移动并覆盖 `\res\` 目录下的同名文件即可。

### 注意
网页解析算法可能会因为网站改版而失效。

### References
1. [Another method to get Python latest version number. (GitHub - corpnewt/gibMacOS)](https://github.com/corpnewt/gibMacOS/blob/master/gibMacOS.bat#L87)
2. Another method to get YouGet latest version number.
   ```batch
   :GetYougetLatestVersion
   REM @param  %ygLatestVersion%

   wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -np https://github.com/soimort/you-get/releases/latest -O ygLatestRelease_Github.txt
   :: The output of 'findstr /n /i "<title>" ygLatestRelease_Github.txt' should be like: 
   ::     31:  <title>Release 0.4.1328 · soimort/you-get · GitHub</title>
   for /f "tokens=3 delims= " %%i in ('findstr /n /i "<title>" ygLatestRelease_Github.txt') do ( set "ygLatestVersion=%%i" )
   del /Q ygLatestRelease_Github.txt >NUL 2>NUL
   echo ygLatestVersion: %ygLatestVersion%
   ```

---

## To be developed

如果你有任何好的想法或建议，欢迎 [提交 Issue](https://github.com/LussacZheng/you-get_install_win/issues) 。  
If you have any ideas or suggestions, welcome to [Submit new issue](https://github.com/LussacZheng/you-get_install_win/issues) .