@rem - Encoding:gb2312; Mode:Batch; Language:zh-CN; LineEndings:CRLF -
:: START OF TRANSLATION
set title=You-Get (绿色版) 配置脚本
set titleExpanded======  %title%  =====
:: Notification
set please-choose=请输入选项的序号并按回车: 
set please-newDir=请在一个新建的文件夹中运行此脚本。
set please-wait=请耐心等待下载完成
set please-init=请先执行 You-Get 初始配置。
set already-config=已配置。
set config-ok=配置已完成。
set bat-updated=脚本已是最新。
set bat-updating=脚本可更新。
set youget-upgraded=当前 You-Get 已是最新发行版
set already-updated=已更新。
:: :: use ^^) instead of ), since %open-webpage% will be used in "esle( )"
set open-webpage=按任意键获取更新 (打开浏览器访问 GitHub^^)
set return=按任意键以清空屏幕，并返回菜单。
:: Procedure
set unzipping=正在解压
set downloading=正在下载
set checkingUpdate=正在检查更新
set youget-upgrading=正在更新 You-Get
:: Guides of download batch
set dl-guide-embed1=对于此绿色版，应使用"yg"而不是"you-get"命令。
set dl-guide-embed2=如果你移动或重命名了整个文件夹，请重新运行 `config.bat` 并选择 `修复 "yg.cmd"` 。
set dl-guide1=下载视频的命令为：
set dl-guide2=yg+空格+视频网址
set dl-guide3=例如：
set dl-guide4=yg https://v.youku.com/v_show/id_aBCdefGh.html
set dl-guide5=默认下载最高清晰度。下载文件默认保存在 Download 目录。
set dl-guide6=如果你想选择清晰度、更改默认路径，或想了解You-Get其他的用法，请参考官方wiki：
set dl-guide7=https://github.com/soimort/you-get/wiki/中文说明
:: Contents of download batch
set dl-bat=You-Get下载视频
set dl-bat-created=已创建 You-Get 启动脚本"%dl-bat%"。
:: Menu Options
set opt1=[1] 初始配置 You-Get (无 FFmpeg)
set opt2=[2] 配置 FFmpeg
set opt3=[3] 更新 You-Get
set opt4=[4] 修复 "yg.cmd"
set opt5=[5] 重新创建启动脚本
set opt6=[6] 更新此脚本 (访问GitHub)
:: END OF TRANSLATION
:: Select mirror of source*.txt
set "_region=cn"