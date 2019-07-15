**[中文说明](#you-get-绿色版-配置脚本-windows)**

---

# You-Get (Portable) Configure Batch (Windows)

A **onekey batch** for the configuration and quickstart of [You-Get](https://github.com/soimort/you-get).
   - It is a portable version based on the embeddable version of Python.
   - If you want the full version, see [here](https://github.com/LussacZheng/you-get_install_win/tree/full).

## Getting Started

1. Download [You-Get onekey configure batch](https://github.com/LussacZheng/you-get_install_win/archive/master.zip).
2. Unzip and run `config.bat`.

### Note

- For the folder where `config.bat` is located,
   - You can only move or rename the entire folder as a whole;
   - Except the video files downloaded under the "Download" directory, please do NOT change other files inside;
   - Once you move or rename the whole folder, re-run `config.bat` and select `Fix "yg.cmd"`.
- If the batch has a run-time error, please refer to [FAQ](https://github.com/LussacZheng/you-get_install_win/wiki/FAQ).

## FFmpeg

> `FFmpeg` is a required dependency, for downloading and joining videos streamed in multiple parts (e.g. on some sites like Youku), and for YouTube videos of 1080p or high resolution.

This portable version does NOT configure FFmpeg by default. To configure FFmpeg, re-run `config.bat` and select `Configure FFmpeg`.

---

# You-Get (绿色版) 配置脚本 (Windows)

一个快速配置和使用 [You-Get](https://github.com/soimort/you-get) 的**一键配置脚本**。
   - 此绿色版基于 Python 的 embeddable 版。
   - 如果你需要完整版，详见 [此处](https://github.com/LussacZheng/you-get_install_win/tree/full)。

## 使用方法

1. 下载 [You-Get 一键配置脚本](https://github.com/LussacZheng/you-get_install_win/archive/master.zip)。
2. 解压并运行 `config.bat`。

### 注意

- 对于 `config.bat` 所在的文件夹，
   - 只能整体移动或重命名整个文件夹；
   - 除了 "Download" 目录下所下载的视频文件，请勿随意改变里面的其他文件；
   - 如果你移动或重命名了整个文件夹，请重新运行 `config.bat` 并选择 `修复 "yg.cmd"` 。
- 如果脚本运行时出现问题，请查阅 [FAQ](https://github.com/LussacZheng/you-get_install_win/wiki/FAQ)。

## FFmpeg

> `FFmpeg`为必要依赖，以下载流式视频以及合并分块视频(例如，类似Youku), 以及YouTube的1080p或更高分辨率.

此绿色版默认不配置 FFmpeg 。若需要配置 FFmpeg ，请重新运行 `config.bat` 并选择 `配置 FFmpeg` 。

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

---

Part of codes had refered to the Repository: [you-get_install](https://github.com/twlz0ne/you-get_install).