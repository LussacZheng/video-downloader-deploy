**| English | [简体中文](README.md) |**

# Video Downloaders One-Click Deployment Batch (Windows)

![language](https://img.shields.io/badge/language-batchfile-c1f12e)
![platform](https://img.shields.io/badge/platform-windows-brightgreen)
![GitHub repo size](https://img.shields.io/github/repo-size/LussacZheng/video-downloader-deploy)
![version](https://img.shields.io/github/package-json/v/LussacZheng/video-downloader-deploy_info?color=important)

A One-Click batch for the deployment and quickstart of **[You-Get](https://github.com/soimort/you-get) , [Youtube-dl](https://github.com/ytdl-org/youtube-dl) , [Annie](https://github.com/iawia002/annie) , and [FFmpeg](https://ffmpeg.org)** .
   - No need to install Python, one-click to deploy a portable version of you-get , youtube-dl .
   - This portable deployment is based on the embeddable version of Python.

## Getting Started

Download [One-Click Deployment Batch](https://github.com/LussacZheng/video-downloader-deploy/archive/master.zip) . Unzip and run `Deploy.bat` .

Demo.gif ( 2 min 52 s ) :  
![demo.gif](https://s2.ax1x.com/2019/08/17/muTbIs.gif)

### Note

- For the folder where `Deploy.bat` is located,
   - You can only move or rename the entire folder as a whole. The name of this folder or the file path should NOT contains special punctuation like: `!@$;%^&` ;
   - After the deployment, you can delete all the files downloaded in directory `res\download\` , to save storage;
   - Except the video files downloaded under the `Download\` directory, please do NOT change other files inside.
- If the batch has a run-time error (such as download speed is too slow), please refer to [FAQ](https://github.com/LussacZheng/video-downloader-deploy/wiki/FAQ) or [Submit new issue](https://github.com/LussacZheng/video-downloader-deploy/issues) .

### FFmpeg

> It has no effect on downloading video if without FFmpeg, which only affects the merging of multiple parts video.

This portable version does NOT deploy FFmpeg by default. To deploy FFmpeg, re-run `Deploy.bat` and select `Deploy FFmpeg`.

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
