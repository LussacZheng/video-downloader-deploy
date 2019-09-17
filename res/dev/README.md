# 功能实验室 / Lab Features
> [`video-downloader-deploy/res/dev/`](https://github.com/LussacZheng/video-downloader-deploy/tree/master/res/dev)  
> *English translation is NOT provided for this instruction. Please translate it by yourself.*

- 此目录下的脚本为 `develop` 状态，不保证功能稳定，请自行抉择是否使用；
- 下文中，称 `Deploy.bat` 为 “主程序” ；
- 此目录下的脚本未被 主程序 引用。删除该文件夹不影响 主程序 运行。

---

## AutoGenerateLatestSourcesLists

自动生成含有 `python-embed.zip` , `you-get.tar.gz` , `youtube-dl.tar.gz` , `annie_Windows.zip` , `ffmpeg-static.zip` 的最新版本下载链接的 `sources.txt` 。可供 主程序 使用。

### 原理
自动解析 [Python](https://www.python.org/downloads/windows/), [You-Get](https://pypi.org/project/you-get/), [Youtube-dl](https://github.com/ytdl-org/youtube-dl/releases/latest) , [Annie](https://github.com/iawia002/annie/releases/latest) , [FFmpeg](https://ffmpeg.zeranoe.com/builds/win64/static/) , [Pip](https://pypi.org/project/pip/) 项目发布页等相关网页，获得其最新版本的下载链接。

### 使用
确保 `AutoGenerateLatestSourcesLists.bat` 当前所在目录或上级目录存在 `wget.exe` ，直接运行脚本即可。若正常运行，则会在当前目录生成 `sources.txt` ，移动并覆盖 `res\` 目录下的同名文件即可。

### 注意
网页解析算法可能会因为网站改版而失效。

### 参考资料
1. Another method to get Python latest version number.   
   [GitHub - corpnewt/gibMacOS : gibMacOS.bat#L87-L124](https://github.com/corpnewt/gibMacOS/blob/ce6f62c388f2bd48ec57aeca057e29ff90406dbb/gibMacOS.bat#L87-L124)
2. Another method to get YouGet latest version number.
   ```batch
   wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -np https://github.com/soimort/you-get/releases/latest -O ygLatestRelease_Github.txt
   :: The output of 'findstr /n /i "<title>" ygLatestRelease_Github.txt' should be like: 
   ::     31:  <title>Release 0.4.1328 · soimort/you-get · GitHub</title>
   for /f "tokens=3 delims= " %%i in ('findstr /n /i "<title>" ygLatestRelease_Github.txt') do ( set "ygLatestVersion=%%i" )
   del /Q ygLatestRelease_Github.txt >NUL 2>NUL
   echo ygLatestVersion: %ygLatestVersion%
   ```
   此方法已用于 `res\scripts\CheckUpdate.bat` 的 `:CheckUpdate_youget` 方法中。

---

## To be developed

如果你有任何好的想法或建议，欢迎 [提交 Issue](https://github.com/LussacZheng/video-downloader-deploy/issues) 。  
If you have any excellent ideas or suggestions, welcome to [Submit new issue](https://github.com/LussacZheng/video-downloader-deploy/issues) .