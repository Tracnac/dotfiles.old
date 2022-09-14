### Disable Shortcuts

```shell
gsettings list-recursively | grep -E '<Super>|<Alt>|<Control>' | grep -v 'XF86' > keyboard.raw
gsettings list-recursively | grep -E '<Super>|<Alt>|<Control>' | grep 'XF86' > keyboardXF86.raw
gsettings list-recursively | grep -E '<Super>|<Alt>|<Control>|XF86' > keyboardXF86_1.raw
```


### USFR
```shell
cd /usr/share/X11/xkb/rules
base.extras.xml
evdev.extras.xml
sudo dpkg-reconfigure xkb-data # if debian
```
