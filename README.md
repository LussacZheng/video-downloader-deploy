**[中文说明](#you-get-绿色版-配置脚本-windows)**

---

# You-Get (Portable) Configure Batch (Windows)

A **onekey batch** for the configuration and quickstart of [You-Get](https://github.com/soimort/you-get). It is a portable version based on the embeddable version of Python.

## Getting Started

1. Save the You-Get onekey configure batch "[config_en.bat](https://raw.githubusercontent.com/LussacZheng/you-get_install_win/embed/config_en.bat)" (Directly clicking the link cannot download it. Right-click and select "**save as**").
2. Create a new folder. Move `config_en.bat` into that folder.
3. Run `config_en.bat`.

### Others

- For the newly created folder in step 2,
   - You can only move or rename the entire folder as a whole;
   - Except the video files downloaded under the "Download" directory, please do not change other files inside;
   - Once you move or rename the whole folder, re-run `config.bat` and select `Fix "yg.cmd"`.
- If you want the full version，see "[you-get_install_win](https://github.com/LussacZheng/you-get_install_win)".
- If the batch has a run-time error, please refer to [FAQ](https://github.com/LussacZheng/you-get_install_win/wiki/FAQ).

## Upgrade You-Get

To upgrade You-Get, re-run `config.bat` and select `Upgrade You-Get`.

## FFmpeg

> `FFmpeg` is a required dependency, for downloading and joining videos streamed in multiple parts (e.g. on some sites like Youku), and for YouTube videos of 1080p or high resolution.

This portable version does NOT configure FFmpeg by default. To configure FFmpeg, re-run `config.bat` and select `Configure FFmpeg`.

---

# You-Get (绿色版) 配置脚本 (Windows)

一个快速配置和使用 [You-Get](https://github.com/soimort/you-get) 的**一键配置脚本**。此绿色版基于 Python 的 embeddable 版。

## 使用方法

1. 保存 You-Get 一键配置脚本 “[config_zh.bat](https://raw.githubusercontent.com/LussacZheng/you-get_install_win/embed/config_zh.bat)” (直接点击不能下载，须右键点击并选择“**另存为**”)。
2. 新建一个文件夹，将 `config_zh.bat` 放在此文件夹下。
3. 运行 `config_zh.bat`。

### 其他

- 对于步骤2中新建的文件夹，
   - 只能整体移动或重命名整个文件夹；
   - 除了 "Download" 目录下所下载的视频文件，请勿随意改变里面的其他文件；
   - 如果你移动或重命名了整个文件夹，请重新运行 `config.bat` 并选择 `修复 "yg.cmd"` 。
- 如果你需要完整版，另见 "[you-get_install_win](https://github.com/LussacZheng/you-get_install_win)"。
- 如果脚本运行时出现问题，请查阅 [FAQ](https://github.com/LussacZheng/you-get_install_win/wiki/FAQ)。

## 更新 You-Get

若需要更新 You-Get ，请重新运行 `config.bat` 并选择 `更新 You-Get` 。

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