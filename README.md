# You-Get Install Batch (Windows)

A guide batch for [You-Get](https://github.com/soimort/you-get) installation and quickstart.

## Getting Started

1. Save the You-Get install batch "[install_en.bat](https://github.com/LussacZheng/you-get_install_win/raw/master/install_en.bat)" (Directly clicking the link cannot download it. Right click and choose "**save as**").

2. Download [unzip.exe](https://github.com/LussacZheng/you-get_install_win/raw/master/unzip.exe) .

3. Visit the website of Python and FFmpeg. Download the right version of `python-3.x.x.exe` and `ffmpeg-x.x.x-xxx.zip` :
   - [Download Python](https://www.python.org/downloads/)
   - [Download FFmpeg Builds](https://ffmpeg.zeranoe.com/builds/)  

   The latest version (Apr. 18th, 2019) are: `python-3.7.3.exe`, `ffmpeg-4.1.1-win64/32-static.zip` .

4. Move `python-3.x.x.exe`, `ffmpeg-x.x.x-xxx.zip`, `unzip.exe`, and `install_en.bat` into a same directory.

5. Run `install_en.bat` , and follow the instructions to finish installation.

6. The two batches created on the Desktop are used to start and upgrade You-Get.  
   You can move or rename the two batches optionally. If you know how to start CMD and the command to upgrade You-Get, you can even delete them.

If the script runs with error codes, try downloading `install_en.bat` from [here](https://github.com/LussacZheng/you-get_install_win/releases/latest) instead.

---

# You-Get 安装脚本 (Windows)

一个快速安装和使用 [You-Get](https://github.com/soimort/you-get) 的指导脚本。

## 使用方法

1. 保存 You-Get 快速安装的脚本 “[install_zh-GB18030.bat](https://github.com/LussacZheng/you-get_install_win/raw/master/install_zh-GB18030.bat)” (直接点击不能下载，须右键单击并选择“**另存为**”)。

2. 下载 [unzip.exe](https://github.com/LussacZheng/you-get_install_win/raw/master/unzip.exe) 。

3. 访问 Python 和 FFmpeg 官网，下载 `python-3.x.x.exe` 和 `ffmpeg-x.x.x-xxx.zip` 适合的版本：
   - [Download Python](https://www.python.org/downloads/)
   - [Download FFmpeg Builds](https://ffmpeg.zeranoe.com/builds/)  

   目前(2019/4/18)最新版为：`python-3.7.3.exe`, `ffmpeg-4.1.1-win64/32-static.zip` .

4. 将 `python-3.x.x.exe`, `ffmpeg-x.x.x-xxx.zip`, `unzip.exe`, 和 `install_zh-GB18030.bat` 放在同一文件夹下。

5. 运行 `install_zh-GB18030.bat`，并按照提示完成安装。

6. 创建在桌面的两个脚本分别用于打开和更新 You-Get 。  
   你可以任意移动或重命名这两个脚本。如果你知道如何打开 CMD 和更新 You-Get 的命令，你也可以删除它们。

如果脚本运行时出现乱码，尝试从[这里](https://github.com/LussacZheng/you-get_install_win/releases/latest)重新下载 `install_zh-GB18030.bat`。

---

## Source

- `unzip.exe`
  ```
  version:    v5.51-1
  md5:        fecf803f7d84d4cfa81277298574d6e6
  source:     https://sourceforge.net/projects/gnuwin32/files/unzip/5.51-1/
  from:       unzip-5.51-1-bin.zip \bin\unzip.exe
  ```