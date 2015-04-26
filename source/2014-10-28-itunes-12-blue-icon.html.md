---
title: iTunes 12 blue icon
date: 2014-10-28 00:00 WIB
tags: osx, apple, itunes, psycology
---

I'm not big fan of new icon for iTunes 12. Here is how to change it:

![Picture](https://coderwall-assets-0.s3.amazonaws.com/uploads/picture/file/3400/ituneses.png)

iTunes keep it's icon at 

```shell
/Applications/iTunes.app/Contents/Resources/iTunes.icns
```

For iTunes 11 you can download here: https://dl.dropboxusercontent.com/u/586048/iTunes.icns

I checked this [manual](http://www.visualpharm.com/articles/change_itunes_icon_on_macosx.html) and app [liteicon](http://www.freemacsoft.net/liteicon/) it worked for me. 

But it also works if you just replace icon.

```shell
# download file
wget https://dl.dropboxusercontent.com/u/586048/iTunes.icns -O /private/tmp/iTunes.icns
cd /Applications/iTunes.app/Contents/Resources
# replace icons
sudo mv iTunes.icns iTunes_red.icns
sudo cp /private/tmp/iTunes.icns .
# drop cache
sudo touch /Applications/iTunes.app
sudo touch /Applications/iTunes.app/Contents/Info.plist
sudo find /private/var/folders/ -name com.apple.dock.iconcache -exec rm {} \;
# restart dock (may take few seconds)
killall Dock
```

I tested on os x 10.9.5, blue iTunes icon is from macmini having not updated iTunes