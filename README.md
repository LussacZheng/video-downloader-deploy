**| [English](README_en.md) | Simplified Chinese | <a href="#" title="Corresponding documentation is temporarily unavailable.">Traditional Chinese</a> |**

# 视频下载器 一键配置脚本 (Windows)

![language](https://img.shields.io/badge/language-batchfile-c1f12e)
![platform](https://img.shields.io/badge/platform-Windows_7/8/10;_32/64--bit-brightgreen?logo=windows)
![GitHub repo size](https://img.shields.io/github/repo-size/LussacZheng/video-downloader-deploy?logo=github)
![version](https://img.shields.io/github/package-json/v/LussacZheng/video-downloader-deploy_info?color=important)

快速配置和使用 **[You-Get][you-get] , [Youtube-dl][youtube-dl] , [Annie][annie] , 和 [FFmpeg][ffmpeg]** 的一键配置脚本。

- 无需安装 Python ，一键配置绿色便携版的 you-get , youtube-dl 。
- 此绿色版基于 Python 的 embeddable 版。
- 除了一键部署，后续 you-get, youtube-dl, annie 的更新同样一键完成。

## 使用方法

下载 [一键配置脚本](https://github.com/LussacZheng/video-downloader-deploy/archive/master.zip) （国内用户可以从 [蓝奏网盘](https://www.lanzous.com/b926232/) 下载）。解压并运行 `Deploy.bat`。

演示动画 ( 2 min 52 s ) ：  
![demo.gif](https://s2.ax1x.com/2019/08/17/muTbIs.gif)

### 注意

- 对于 `Deploy.bat` 所在的文件夹，
  - 只能整体移动或重命名整个文件夹，且文件夹名称和路径不应包含 `!@$;%^&` 等特殊符号；
  - 配置完成后，你可以自行删除 `res\download\` 目录下所有下载的文件，以节省储存空间；
  - 除了 `Download\` 目录下所下载的视频文件，请勿随意改变里面的其他文件。
- 如果脚本运行时出现问题（如 **下载速度过慢 / 卡在 0%**），请查阅 [FAQ](https://github.com/LussacZheng/video-downloader-deploy/wiki/FAQ) 或 [提交 Issue](https://github.com/LussacZheng/video-downloader-deploy/issues) 。

### FFmpeg

> 没有 FFmpeg 不影响视频下载，只影响分段视频的合并。

此绿色版默认不配置 FFmpeg 。若需要配置 FFmpeg ，请重新运行 `Deploy.bat` 并选择 `配置 FFmpeg` 。

### 别名 / alias

运行 `Deploy.bat` 并选择 `别名管理` 即可配置自定义别名。

> 在新增自定义别名之前，不妨先尝试 `导入默认别名` ，然后打开启动脚本 `下载视频.bat` ，输入 `open` 并执行。

列举几个可能比较常用的别名作为参考：

| 别名                                                  | 作用                                                 |
| :---------------------------------------------------- | :--------------------------------------------------- |
| open = `explorer .\`                                  | 打开当前目录，即 `Download` 文件夹                   |
| proxy &asymp; `set HTTP(S)_PROXY=...`                 | 快速为当前 CMD 窗口启用/禁用代理 (`proxy help`)      |
| yb = `youtube-dl -f bestvideo+bestaudio`              | 使用 youtube-dl 下载最佳清晰度                       |
| yf = `youtube-dl --proxy socks5://127.0.0.1:10808 -F` | 使用 youtube-dl 查看所有可下载的清晰度，同时启用代理 |
| ac = `annie -c cookies.txt`                           | 使用 annie 下载并加载 cookies 文件                   |
| ygc = `you-get -c cookies.txt`                        | 使用 you-get 下载并加载 cookies 文件                 |
| ...                                                   | ...                                                  |

**注意**：自定义别名的命名，最好是英文字母、数字的组合。尽管可以包含横杠、下划线、或中文，但其至少应符合正则表达式 `^[\w\-\u4e00-\u9fa5]+$` ，尤其不应含有空格和上文提及的特殊符号。另外，别名切忌与命令相同，否则会导致无限循环调用。

---

## 其他

### Git

如果你已经安装了 [Git](https://git-scm.com/) ，建议你通过 `git clone` 获取脚本文件，因为后续可以通过 `git pull` 更新脚本文件。

```shell
git clone https://github.com/LussacZheng/video-downloader-deploy.git
```

国内用户可以从 [Gitee 镜像仓库](https://gitee.com/lussac/video-downloader-deploy) 克隆。

```shell
git clone https://gitee.com/lussac/video-downloader-deploy.git
```

只有当你此前是通过 `git clone` 获取的脚本文件时，才可以通过 `git pull` 更新。

```shell
git pull
```

### Source

- `7za.exe`

  ```
  Version:    v19.00
  MD5:        43141e85e7c36e31b52b22ab94d5e574
  Source:     https://sourceforge.net/projects/sevenzip/files/7-Zip/19.00/
  From:       "7z1900-extra.7z" \7za.exe
  ```

- `wget.exe`

  ```
  Version:    v1.20.3 , win32
  MD5:        f8247397ae65792524d949c825969391
  Source:     http://www.gnu.org/software/wget/faq.html#download
              https://eternallybored.org/misc/wget/
  From:       "wget-1.20.3-win32.zip" \wget.exe
  ```

- `get-pip.py`

  ```
  Version:    v19.2.2 (pip for bootstrap)
  MD5:        7f66b79bf181521f6851a75848aad8b2
  Source:     https://bootstrap.pypa.io/get-pip.py
  ```

### License

|            Project             |                 License                 |
| :----------------------------: | :-------------------------------------: |
|       [you-get][you-get]       |     [MIT License][you-get license]      |
|    [youtube-dl][youtube-dl]    |   [The Unlicense][youtube-dl license]   |
|         [annie][annie]         |      [MIT License][annie license]       |
| [FFmpeg Builds][ffmpeg builds] |    [GPL 3.0][ffmpeg builds license]     |
|        [Python][python]        | [PSF LICENSE AGREEMENT][python license] |

### 更多信息

查阅 [Wiki](https://github.com/LussacZheng/video-downloader-deploy/wiki) 以了解更多信息。

<!-- Reference Links -->

[you-get]: https://github.com/soimort/you-get
[you-get license]: https://github.com/soimort/you-get/blob/develop/LICENSE.txt
[youtube-dl]: https://github.com/ytdl-org/youtube-dl
[youtube-dl license]: https://github.com/ytdl-org/youtube-dl/blob/master/LICENSE
[annie]: https://github.com/iawia002/annie
[annie license]: https://github.com/iawia002/annie/blob/master/LICENSE
[ffmpeg]: https://ffmpeg.org
[ffmpeg builds]: https://ffmpeg.zeranoe.com/builds/
[ffmpeg builds license]: http://www.gnu.org/licenses/gpl-3.0.html
[python]: https://www.python.org
[python license]: https://docs.python.org/3.7/license.html#terms-and-conditions-for-accessing-or-otherwise-using-python
