| [English](README_EN.md) | 简体中文 |

# 视频下载器 一键配置脚本 (Windows)

快速配置和使用 [You-Get](https://github.com/soimort/you-get) , [Youtube-dl](https://github.com/ytdl-org/youtube-dl) , [Annie](https://github.com/iawia002/annie) , 和 [FFmpeg](https://ffmpeg.org) 的**一键配置脚本**。
- 无需安装 Python ，一键配置绿色便携版的 you-get , youtube-dl 。
- 此绿色版基于 Python 的 embeddable 版。

## 使用方法

下载 [一键配置脚本](https://github.com/LussacZheng/video-downloader-deploy/archive/master.zip) 。解压并运行 `Deploy.bat`。

演示动画：  
![demo.gif](https://blog.lussac.net/usr/uploads/2019/07/506175630.gif)

### 注意

- 对于 `Deploy.bat` 所在的文件夹，
   - 只能整体移动或重命名整个文件夹，且文件夹名称和路径不应包含 `!@$;%^&` 等特殊符号；
   - 配置完成后，你可以自行删除 `res\downlaod\` 目录下所有下载的文件，以节省储存空间；
   - 除了 "Download" 目录下所下载的视频文件，请勿随意改变里面的其他文件。
- 如果脚本运行时出现问题，请查阅 [FAQ](https://github.com/LussacZheng/video-downloader-deploy/wiki/FAQ) 或 [提交 Issue](https://github.com/LussacZheng/video-downloader-deploy/issues) 。

### FFmpeg

> 没有 FFmpeg 不影响视频下载，只影响分段视频的合并。

此绿色版默认不配置 FFmpeg 。若需要配置 FFmpeg ，请重新运行 `Deploy.bat` 并选择 `配置 FFmpeg` 。

---

## Source

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
  Version:    v19.2.2 (pip)
  MD5:        7f66b79bf181521f6851a75848aad8b2
  Source:     https://bootstrap.pypa.io/get-pip.py
  ```
