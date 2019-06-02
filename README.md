**[中文说明](#you-get-绿色版-配置脚本-windows)**

---

# You-Get (Portable) Configure Batch (Windows)

A guide batch for a portable version of [You-Get](https://github.com/soimort/you-get) configuration and quickstart, based on the embeddable version of Python.

## Getting Started

1. Save the You-Get configure batch "[config_en.bat](https://raw.githubusercontent.com/LussacZheng/you-get_install_win/embed/config_en.bat)" (Directly clicking the link cannot download it. Right-click and choose "**save as**").

2. Download [7za.exe](https://raw.githubusercontent.com/LussacZheng/you-get_install_win/embed/7za.exe) .

3. Visit the website of Python and PyPI. Download the right version of `python-3.x.x-embed-win32.zip` and `you-get-*.tar.gz` :
   - [Download Python](https://www.python.org/downloads/)
   - [Download You-Get](https://pypi.org/project/you-get/#files)

   Or download the latest version (Mar. 25th, 2019) in the following: 
   - [`python-3.7.3-embed-win32.zip`](https://www.python.org/ftp/python/3.7.3/python-3.7.3-embed-win32.zip)
   - [`you-get-0.4.1302.tar.gz`](https://files.pythonhosted.org/packages/f6/d1/654c81e572109d91760402edf851220ed5276fdb10d8a135631426771946/you-get-0.4.1302.tar.gz)

4. Create a new directory. Move `python-3.x.x-embed-win32.zip`, `you-get-*.tar.gz`, `7za.exe`, and `config_en.bat` into the same directory.

5. Run `config_en.bat`.

### Others

- Keep the new directory in step 4 as it is. You can only move or rename the whole folder integrally instead of changing each content in it easily. Once you move or rename the whole folder, run `config_en.bat` again.
- If you want the full version，see "[you-get_install_win](https://github.com/LussacZheng/you-get_install_win)".
- If the batch has a run-time error, please refer to [FAQ](https://github.com/LussacZheng/you-get_install_win/wiki/FAQ).

## Upgrade You-Get

1. Download the latest version of `you-get-*.tar.gz` from [here](https://pypi.org/project/you-get/#files). Decompress this file. 
2. Check the original files in the "you-get" folder, and exactly overwrite the original files with those decompressed correspondly. 

---

# You-Get (绿色版) 配置脚本 (Windows)

一个快速配置和使用 [You-Get](https://github.com/soimort/you-get) 的指导脚本。基于 Python 的 embeddable 版。

## 使用方法

1. 保存 You-Get 快速配置的脚本 “[config_zh.bat](https://raw.githubusercontent.com/LussacZheng/you-get_install_win/embed/config_zh.bat)” (直接点击不能下载，须右键点击并选择“**另存为**”)。

2. 下载 [7za.exe](https://raw.githubusercontent.com/LussacZheng/you-get_install_win/embed/7za.exe) .

3. 访问 Python 和 PyPI 官网，下载 `python-3.x.x-embed-win32.zip` 和 `you-get-*.tar.gz` 适合的版本：
   - [Download Python](https://www.python.org/downloads/)
   - [Download You-Get](https://pypi.org/project/you-get/#files) 

   或直接下载目前 (2019/3/25) 最新版本：
   - [`python-3.7.3-embed-win32.zip`](https://www.python.org/ftp/python/3.7.3/python-3.7.3-embed-win32.zip)
   - [`you-get-0.4.1302.tar.gz`](https://files.pythonhosted.org/packages/f6/d1/654c81e572109d91760402edf851220ed5276fdb10d8a135631426771946/you-get-0.4.1302.tar.gz)

4. 新建一个文件夹，将 `python-3.x.x-embed-win32.zip`, `you-get-*.tar.gz`, `7za.exe` 和 `config_zh.bat` 放在同一文件夹下。

5. 运行 `config_zh.bat`。

### 其他

- 对于步骤4中新建的文件夹，只能整体移动或重命名整个文件夹。请勿随意改变里面的文件。如果你移动或重命名了整个文件夹，请重新运行 `config.bat` 。
- 如果你需要完整版，另见 "[you-get_install_win](https://github.com/LussacZheng/you-get_install_win)"。
- 如果脚本运行时出现问题，请查阅 [FAQ](https://github.com/LussacZheng/you-get_install_win/wiki/FAQ)。

## 更新 You-Get

1. 从[这里](https://pypi.org/project/you-get/#files)下载最新的 `you-get-*.tar.gz`。解压该文件。
2. 查看 "you-get" 文件夹下的原有文件，用解压出来的文件对应覆盖原有文件。

---

## Source

- `7za.exe`
  ```
  Version:    v19.00
  MD5:        43141e85e7c36e31b52b22ab94d5e574
  Source:     https://sourceforge.net/projects/sevenzip/files/7-Zip/19.00/
  From:       "7z1900-extra.7z" \7za.exe
  ```

---

Part of codes had refered to the Repository: [you-get_install](https://github.com/twlz0ne/you-get_install).