# Voidlinux ARM

## rc.local
```
ip link set dev eth0 up
ip addr add 192.168.86.4/24 brd + dev eth0
ip route add default via 192.168.86.1

TZ=Europe/Paris
LANG=en_US.UTF-8
export TZ LANG
```

## Service de base
xbps-install dbus

## Dev 

xbps-install vim tmux git stow
xbps-install wget curl
xbps-install make pkg-config hyperfine
xbps-install clang clang-analyzer clang-tools-extra
xbps-install janet nim

# X11 Minimum vital
xbps-install xorg-server xf86-input-evdev
xbps-install xf86-video-fbturbo
xbps-install xinit xsel xclip xset xrandr xauth

# Desktop
xbps-install cwm st picom dunst rofi sxhkd hsetroot

# Compilation de st
xbps-install fontconfig-devel
xbps-install libXft-devel

