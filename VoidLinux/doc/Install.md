# Voidlinux ARM

## rc.local
```
TZ=Europe/Paris
LANG=en_US.UTF-8
export TZ LANG
```

#If static...  
#ip link set dev eth0 up  
#ip addr add 192.168.86.4/24 brd + dev eth0  
#ip route add default via 192.168.86.1  

## Services de base
```shell
xbps-install chrony dbus mpd cups cups-filters connman cronie
ln -s /etc/sv/ntpd /var/service
ln -s /etc/sv/dbus /var/service
ln -s /etc/sv/mpd /var/service
ln -s /etc/sv/cupsd /var/service
rm /var/service/dhcpcd
ln -s /etc/sv/connmand /var/service
ln -s /etc/sv/cronie /var/service
```

## Pour le Wifi
```shell
connmanctl  
enable wifi  
scan wifi
services
agent on
connect <wifi_id>
```

## Dev & Userland
```shell
xbps-install vim tmux git stow bash-completion unzip 
xbps-install wget curl
xbps-install alsa-utils
xbps-install make pkg-config hyperfine strace meson ctags
xbps-install clang clang-analyzer clang-tools-extra llvm
xbps-install janet nim nodejs go
xbps-install gdb rr lldb
xbps-install autoconf automake
```

## Emacs
```shell
xbps-install emacs-x11 isync mu mu4e
```

## X11 Minimum vital
```shell
xbps-install xorg-server xf86-input-evdev
xbps-install xinit xsel xclip xset xrandr xauth xdotool xev xprop xrdb setxkbmap xsetroot
xbps-install mesa mesa-dri
```

## X11 Video
### Specifique à Intel
``` Shell
xbps-install intel-video-accel
xbps-install vulkan-loader
xbps-install mesa-vulkan-intel
```
### Specifique a NVIDIA
```shell
xbps-install void-repo-nonfree
xbps-install -Sv
xbps-install nvidia
```

## Desktop
```shell
cd /etc/skel
mkdir -p Desktop Documents Downloads Music Pictures/Captures Public Templates Videos
cd
xbps-install bspwm picom dunst rofi sxhkd hsetroot scrot polybar mpc st xdg-utils xdg-user-dirs
```

## Compilation de st
```shell
xbps-install libXft-devel fontconfig-devel harfbuzz-devel
```

## Audio et MPD
```shell
# Only with NVIDIA
cat > /etc/asound.conf <<EOF
defaults.pcm.card 1
defaults.ctl.card 1
EOF

mkdir /var/lib/mpd/music
touch /var/lib/mpd/{mpd.db,log}
chown -R mpd:audio /var/lib/mpd
chmod -R 0775 /var/lib/mpd
cp /etc/mpd.conf /etc/mpd.save
cat > /etc/mpd.conf <<EOF
music_directory     "/var/lib/mpd/music"
playlist_directory  "/var/lib/mpd/playlists"
db_file             "/var/lib/mpd/mpd.db"
log_file            "/var/lib/mpd/log"
pid_file            "/run/mpd/mpd.pid"
state_file          "/var/lib/mpd/mpdstate"

user                "mpd"
group               "audio"
bind_to_address     "127.0.0.1"
port                "6600"
log_level			"notice"
auto_update         "yes"

input {
    plugin "curl"
}

audio_output {
	type		"alsa"
	name		"ALSA Device"
}
EOF
cat > /var/lib/mpd/playlists/radioparadise.m3u <<EOF
#EXTM3U
#EXTINF:0,Radio Paradise
https://stream.radioparadise.com/aac-320
EOF
pkill mpd
```

## Creation user
```shell
adduser -m -g users -G audio,video,wheel tracnac
passwd tracnac
```

# Userland
## Init

```shell
cd ~/
git clone https://github.com/tracnac/dotfiles
cd dotfiles
git submodule init
git submodule update
#git submodule update --init
cp dotfiles/dot-stowrc .stowrc
cd ~/
stow vim
stow tmux
stow bin
#vim :PlugUpgrade + :PlugInstall
#tmux ctrl-b + I
mkdir .config
cd ~/.config
ln -s ../dotfiles/rofi/dot-config/rofi
ln -s ../dotfiles/sxhkd/dot-config/sxhkd
ln -s ../dotfiles/dunst/dot-config/dunst
```

# Imprimante
- http://localhost:631
- And load the PPD File

## Divers
- Copy xorg files and keyboard usfr
- Adjust font setting 

## ISYNC
Crontab :
```
# mm  hh  DD  MM  W /path/program [--option]...  ( W = weekday: 0-6 [Sun=0] )
*/5 * * * * /usr/bin/mbsync mailfence 1>/dev/null 2>&1
```

```shell
mkdir ~/.mail/mailfence
cat > ~/.mbsyncrc <<EOF
IMAPAccount mailfence
Host imap.mailfence.com
User *******
Pass *******
SSLType IMAPS
CertificateFile /etc/ssl/certs/ca-certificates.crt

IMAPStore mailfence-remote
Account mailfence

MaildirStore mailfence-local
SubFolders Verbatim
Path ~/.mail/mailfence/
Inbox ~/.mail/mailfence/Inbox

Channel mailfence
Far :mailfence-remote:
Near :mailfence-local:
Patterns *
Create Near
Expunge Near
Remove Near
SyncState *
Sync All
EOF
```
```
mu init --maildir=~/.mail/mailfence --my-address=tracnac@devmobs.fr
mu index
```
