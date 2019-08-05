@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: START OF TRANSLATION
set title=You-Get(Portable) Configure Batch
set titleExpanded==  %title%  =
:: Notification
set please-choose=Please input the index number of option and press ENTER:
set please-newDir=Please run this batch in a newly created folder.
set please-wait=Please be patient while waiting for the download
set please-init=Please perform the initial configuration of You-Get first.
set already-config=already configured.
set config-ok=Configuration completed.
set bat-updated=This batch is the latest version.
set bat-updating=This batch can be updated.
set youget-upgraded=The current You-Get is the latest Release
set already-updated=already updated.
:: :: use ^^) instead of ), since %open-webpage% will be used in "esle( )"
set open-webpage=Press any key to get updated (Open browser to visit GitHub^^)
set return=Press any key to clear the screen and return to Menu.
:: Procedure
set unzipping=Unzipping
set downloading=Downloading
set checkingUpdate=Checking for update
set youget-upgrading=Upgrading You-Get
:: Guides of download batch
set dl-guide-embed1=For this portable version, use "yg" command instead of "you-get".
set dl-guide-embed2=If you move or rename the whole folder, please re-run `config.bat` and select `Fix "yg.cmd"`.
set dl-guide1=The command to download a video is:
set dl-guide2=yg+'Space'+'video url'
set dl-guide3=For example:
set dl-guide4=yg https://www.youtube.com/watch?v=aBCdefGh
set dl-guide5=By default, you will get the video of highest quality. And the files downloaded will be saved in "Download".
set dl-guide6=If you want to choose the quality of video, change the directory saved in, or learn more usage of You-Get, please refer the Official wiki:
set dl-guide7=https://github.com/soimort/you-get#download-a-video
:: Contents of download batch
set dl-bat=You-Get_Download_video
set dl-bat-created=The You-Get starting batch "%dl-bat%" has been created.
:: Menu Options
set opt1=[1] Initial Configuration of You-Get (Without FFmpeg)
set opt2=[2] Configure FFmpeg
set opt3=[3] Upgrade You-Get
set opt4=[4] Fix "yg.cmd"
set opt5=[5] Re-create the quickstart batch
set opt6=[6] Update this batch (Visit GitHub)
:: END OF TRANSLATION
:: Select mirror of source*.txt
set "_region=origin"