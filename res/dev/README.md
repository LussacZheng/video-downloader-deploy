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
1. 另一种获得 Python 最新版本号的方法：   
   GitHub - corpnewt/gibMacOS : [gibMacOS.bat#L87-L124](https://github.com/corpnewt/gibMacOS/blob/ce6f62c388f2bd48ec57aeca057e29ff90406dbb/gibMacOS.bat#L87-L124)
2. 另一种获得 You-Get 最新版本号的方法：
   ```batch
   wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -np https://github.com/soimort/you-get/releases/latest -O yg.txt
   :: The output of 'findstr /n /i "<title>" yg.txt' should be like: 
   ::     31:  <title>Release 0.4.1328 · soimort/you-get · GitHub</title>
   for /f "tokens=3 delims= " %%i in ('findstr /n /i "<title>" yg.txt') do ( set "ygLatestVersion=%%i" )
   del /Q yg.txt >NUL 2>NUL
   echo ygLatestVersion: %ygLatestVersion%
   ```
   此方法已用于 `res\scripts\CheckUpdate.bat` 的 `:CheckUpdate_youget` 方法中。

---

## SourcesListsDiff

当通过 `AutoGenerateLatestSourcesLists.bat` 生成了新的 `sources.txt` 后，比较并输出其与 `..\sources.txt` 之间的差异，以直观体现是否有更新可用。

### 使用
确保 `SourcesListsDiff.bat` 当前所在目录和上级目录都存在 `sources.txt` ，使用文本编辑器将两个 `sources.txt` 的换行符都设置为 `CRLF` ，直接运行脚本即可。

### 注意
请勿将此脚本当作真正的 Diff 工具使用，它只适用于 `sources.txt` 的比较。Windows 系统下可以使用 `fc` 命令比较差异，CMD 下输入 `help fc` 以查看细节。
```batch
fc /N sources.txt ..\sources.txt
```

---

## GitHubActions.yml

GitHub Actions 是 GitHub 提供的非常强大的的持续集成服务，在 GitHub 仓库顶部的 `Actions` 选项卡中即可轻松构建一个 "workflow" 。

### 使用
将 `AutoGenerateLatestSourcesLists.bat` 的脚本流程简化并稍作改动，便可以写成 `GitHubActions.yml` 。复制其中的内容到 `.github/workflows/main.yml` 即可部署一个“定时检查各项目的最新版本”的 workflow ，相当于在服务器上部署了定时自动运行的 `AutoGenerateLatestSourcesLists.bat` 。

### 简要解析
1. 设置每天 05:00UTC (北京时间13:00) 运行
    ```yaml
    on:
      schedule:
      - cron: "0 12 * * *"
    ```
2. 使用指定的 Shell (如 Windows cmd)
    ```yaml
    steps:
    - name: Display the path
      run: echo %PATH%
      shell: cmd
    ```
3. 注意，各个 steps 中的变量并不互通，可以使用 `env` 来定义环境变量。但 step 中似乎无法修改 job 中定义的环境变量。
    ```yaml
    jobs:
      job1:
        env:
          FIRST_NAME: Mona
    ```

### 参考资料
（GitHub Help 右上角可以将切换语言为中文，配合英文便于理解）

1. [使用 GitHub Actions 自动化 workflow - GitHub Help](https://help.github.com/en/actions/automating-your-workflow-with-github-actions)
2. [GitHub Actions 的 workflow 语法 - GitHub Help](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/workflow-syntax-for-github-actions)
3. [GitHub Actions 的上下文和表达式语法 - GitHub Help](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/contexts-and-expression-syntax-for-github-actions)
4. [触发 workflows 的事件：定时运行 - GitHub Help](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/events-that-trigger-workflows#scheduled-events-schedule)
5. [GitHub - sdras/awesome-actions](https://github.com/sdras/awesome-actions): A curated list of awesome actions to use on GitHub
6. [GitHub Actions 入门教程 - 阮一峰的网络日志](http://www.ruanyifeng.com/blog/2019/09/getting-started-with-github-actions.html)
7. [创建 JavaScript action - GitHub Help](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-a-javascript-action)

---

## To be developed

如果你有任何好的想法或建议，欢迎 [提交 Issue](https://github.com/LussacZheng/video-downloader-deploy/issues) 。  
If you have any excellent ideas or suggestions, welcome to [Submit new issue](https://github.com/LussacZheng/video-downloader-deploy/issues) .