# Voidlinux
## rc.local et profile
``` shell
cat >> /etc/rc.local <<EOF
# DBUS
install -d -m 0700 -o root -g root /run/user/0
install -d -m 0700 -o tracnac -g users /run/user/1000
EOF

sed -i 's/#fr_FR.UTF-8/fr_FR.UTF-8/g' /etc/default/libc-locales
cat >> /etc/locale.conf <<EOF
LC_MONETARY=fr_FR.UTF-8
LC_PAPER=fr_FR.UTF-8
LC_MEASUREMENT=fr_FR.UTF-8
LC_TIME=fr_FR.UTF-8
LC_NUMERIC=fr_FR.UTF-8
EOF
xbps-reconfigure --force glibc-locales

cat > /etc/profile.d/xdg_runtime_dir.sh <<EOF
#!/bin/sh

XDG_RUNTIME_DIR="/run/user/\$(id -u \${USER})"
export XDG_RUNTIME_DIR
EOF
```

#If static...  
#ip link set dev eth0 up  
#ip addr add 192.168.86.4/24 brd + dev eth0  
#ip route add default via 192.168.86.1  
## Packages de base
```shell
# keys.openpgp.org pgp.mit.edu keyring.debian.org keyserver.ubuntu.com
xbps-install -y gnupg2 pinentry pass pass-git-helper git-crypt git chezmoi age pam-u2f
```
## Services de base
```shell
xbps-install -y chrony dbus mpd cups cups-filters connman cronie acpid tlp socklog-void
ln -s /etc/sv/ntpd /var/service
ln -s /etc/sv/dbus /var/service
ln -s /etc/sv/mpd /var/service
ln -s /etc/sv/cupsd /var/service
ln -s /etc/sv/crond /var/service
ln -s /etc/sv/acpid /var/service
ln -s /etc/sv/tlp /var/service
ln -s /etc/sv/socklog-unix /var/service
ln -s /etc/sv/nanoklogd /var/service
rm /var/service/dhcpcd
ln -s /etc/sv/connmand /var/service
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
xbps-install -y tmux stow bash-completion unzip
xbps-install -y wget curl
xbps-install -y alsa-utils
xbps-install -y make autoconf automake pkg-config hyperfine strace meson ctags fzf ripgrep
# xbps-install clang clang-analyzer clang-tools-extra llvm lldb
xbps-install -y gcc gdb
xbps-install -y go
xbps-install -y rr
xbps-install -y qemu
```

## Editor
```shell
xbps-install -y emacs-x11 vim-x11
```
## X11 Minimum vital
```shell
xbps-install -y xorg-server xf86-input-evdev
xbps-install -y xinit xsel xclip xset xrandr xauth xdotool xev xprop xrdb setxkbmap xsetroot xbacklight xinput
```

## X11 Video
### Specifique à Intel
``` Shell
xbps-install -y intel-video-accel
xbps-install -y mesa-vulkan-intel
xbps-install -y vulkan-loader
xbps-install -y mesa mesa-dri
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
xbps-install -y bspwm cwm picom dunst rofi sxhkd hsetroot scrot mpc xdg-utils xdg-user-dirs i3lock xterm alacritty # polybar st
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
chown -R mpd:audio /var/lib/mpd
chmod -R 0775 /var/lib/mpd
pkill mpd
```

## Creation user
```shell
useradd -m -g users -G audio,video,wheel,kvm,plugdev tracnac
passwd tracnac
```
# Userland
## Init

```shell
# TODO: Make a shell script

cd ~/
chezmoi init tracnac
chezmoi apply
xdg-user-dirs-update
git clone ssh://git@github.com/tracnac/dotfiles.old .dotfiles
cd .dotfiles
git submodule init
git submodule update
# git submodule update --init
cd ~/
#vim :PlugUpgrade + :PlugInstall
#tmux ctrl-b + I
ln -s .dotfiles/bin/dot-bin .bin
ln -s .dotfiles/cwmrc/dot-cwmrc .cwmrc
ln -s .dotfiles/wallpaper/dot-wallpaper.png .wallpaper.png
cd ~/.config
ln -s ../.dotfiles/rofi/dot-config/rofi
ln -s ../.dotfiles/dunst/dot-config/dunst
# ln -s ../.dotfiles/polybar/dot-config/polybar
cd ~/
```
# Imprimante
- http://localhost:631
- And load the PPD File
## Divers
- Copy xorg files and keyboard usfr
- Adjust font setting 

# U2F
```shell
pamu2fcfg > ~/u2f_keys
sudo cp u2f_keys /etc/u2f_keys
sudo chmod 0400 /etc/u2f_keys
```
Add to /etc/pam.d/system-auth:
```
auth      sufficient pam_u2f.so     authfile=/etc/u2f_keys cue
```
# PGP (check with: echo "test" | gpg --clearsign)

``` shell
cat >> ~/.bashrc <<EOF
# GPGAgent
export GPG_TTY=$(tty)
if ! pgrep -x -u "${USER}" gpg-agent &> /dev/null; then
  gpg-connect-agent /bye &> /dev/null
fi
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
EOF
```
## Mail
```shell
# TODO: Aliases
xbps-install -y msmtp isync notmuch mu4e

cat > ~/.msmtprc << EOF
account default
auth on
host smtp.mailfence.com
from tracnac@devmobs.fr
user ********
password ********
tls on
tls_starttls off
tls_trust_file /etc/ssl/certs/ca-certificates.crt
from tracnac@devmobs.fr
syslog LOG_MAIL
EOF
chmod 0400 ~/.msmtprc
```
## ISYNC

Crontab :
```
# mm  hh  DD  MM  W /path/program [--option]...  ( W = weekday: 0-6 [Sun=0] )
*/5 * * * * /usr/bin/mbsync mailfence 1>/dev/null 2>&1
```

```shell
cat > ~/.mbsyncrc <<EOF
IMAPAccount mailfence
Host imap.mailfence.com
User *****
Pass *****
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
chmod 0400 ~/.mbsyncrc
```
```shell
# TODO: Notmuch for better integration with neomutt
mkdir -p ~/.mail/mailfence
chmod 0700 ~/.mail
chmod 0700 ~/.mail/mailfence
mu init --maildir=.mail/mailfence --my-address=tracnac@devmobs.fr
mu index
```
## MUTT
``` shell
cat > ~/.muttrc << EOF 
set mbox_type=Maildir
set header_cache=~/.cache/mutt
set folder='/home/tracnac/.mail/mailfence'

set editor = "\$EDITOR"
set implicit_autoview = yes
alternative_order text/enriched text/plain text

set ssl_force_tls = yes
set certificate_file=/etc/ssl/certs/ca-certificates.crt

# GPG section
set crypt_use_gpgme = yes
set crypt_autosign = no
set crypt_opportunistic_encrypt = no
set pgp_use_gpg_agent = yes
set sort = "threads"

# MTA section
set sendmail='msmtp --read-envelope-from --read-recipients'

# MRA section
set realname='Tracnac'
set from='tracnac@devmobs.fr'
mailboxes "/home/tracnac/.mail/mailfence/Inbox"
set postponed='+Drafts'
set record='+Sent Items'
set spoolfile='+Inbox'
set trash='+Trash'
EOF
