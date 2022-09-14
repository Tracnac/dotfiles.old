# Installation OpenBSD

`qemu-img create -f qcow2 /opt/qemu/img/openbsd70.img 8G`

`qemu-system-x86_64 -hda /opt/qemu/img/openbsd70.img -smp 2 -m 2048 -device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::2222-:22 -device intel-hda`

`qemu-system-x86_64 -hda /opt/qemu/img/openbsd70.img -smp 2 -m 2048 -device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::2222-:22 -device intel-hda -boot d -cdrom ~/Downloads/miniroot70.img`


## Chiffrage du disque lors de l'installation

# TODO: A finir

Afficher les disques, j'assume que le disque est sd0
```shell
sysctl hw.disknames
fdisk -iy sd0
```

## Sous root
### Patching et config de base
```shell
syspatch
fw_update
# vim-*-gtk3
pkg_add vim colorls spleen mosh git
cat >> /etc/profile <<EOF
export TZ=Europe/Paris
export LANG=en_US.UTF-8

export ENV=\${HOME}/.kshrc
EOF
cat > ${HOME}/.kshrc <<EOF
set -o emacs
export PS1="{\A} \u@\l [\W] \\$ "
EOF
cat >> /etc/wsconsctl.conf << EOF
keyboard.bell.volume=0
EOF
```

### Services
```shell
rcctl disable slaacd
rcctl enable apmd
rcctl set apmd flags -A
pkg_add dbus
rcctl enable messagebus
```

### Configuration du mail en emission
```shell
cat > /etc/mail/secrets <<EOF
mailfence username:password
EOF
chown root:_smtpd /etc/mail/secrets
chmod 640 /etc/mail/secrets

cat > /etc/mail/smtpd.conf <<EOF
#       $OpenBSD: smtpd.conf,v 1.14 2019/11/26 20:14:38 gilles Exp $

# This is the smtpd server system-wide configuration file.
# See smtpd.conf(5) for more information.

table aliases file:/etc/mail/aliases
table secrets file:/etc/mail/secrets

listen on lo0

action "local_mail" mbox alias <aliases>
action "outbound" relay host smtps://mailfence@smtp.mailfence.com \
        auth <secrets>

match from local for local action "local_mail"
match from local for any action "outbound"
EOF
rcctl restart smtpd
```

### Les ports
```shell
cd /tmp
ftp https://ftp.openbsd.org/pub/OpenBSD/$(uname -r)/{ports.tar.gz,SHA256.sig}
signify -Cp /etc/signify/openbsd-$(uname -r | cut -c 1,3)-base.pub -x SHA256.sig ports.tar.gz
```
Attention bien vérifier le tar... "./ports" bug.
```shell
cd /usr
tar xzf /tmp/ports.tar.gz
```

### doas
```shell
cat > /etc/doas.conf << EOF
# Default
permit persist keepenv tracnac
EOF
```

TODO default


### login.conf
Attention à la syntaxe... OpenBSD est POSIX
```shell
cd ~/
mkdir backup
cp /etc/login.conf /root/backup/login.conf
sed -i -e '/staff:\\/,/#/{//!d;};' /etc/login.conf
sed -i -e '/staff:\\/a\
        :datasize-cur=2048M:\\\
        :datasize-max=infinity:\\\
        :maxproc-cur=256:\\\
        :maxproc-max=1024:\\\
        :openfiles-cur=4096:\\\
        :openfiles-max=8192:\\\
        :stacksize-cur=32M:\\\
        :ignorenologin:\\\
        :requirehome@:\\\
        :tc=default:

' /etc/login.conf
```

### sysctl.conf
```shell
cat > /etc/sysctl.conf << EOF
# shared memory limits
kern.shminfo.shmall=524288
kern.shminfo.shmmax=1073741823
kern.shminfo.shmmni=2048

# semaphores
kern.shminfo.shmseg=1024
kern.seminfo.semmns=4096
kern.seminfo.semmni=1024

kern.maxproc=32768
kern.maxfiles=65535
kern.bufcachepercent=90
kern.maxvnodes=262144
kern.somaxconn=2048
EOF
```

### fstab
```shell
cp /etc/fstab /root/backup/fstab
sed -i -e 's/rw,/rw,softdep,noatime,/' /etc/fstab
```

### MPD music
# mpc load radioparadise
# mpc play
```shell
pkg_add mpd mpc
sed -i 's/please-configure-your-music_directory/var\/spool\/mpd\/music/g' /etc/mpd.conf
mkdir /var/spool/mpd/music
cat > /var/spool/mpd/playlists/radioparadise.m3u <<EOF
#EXTM3U
#EXTINF:0,Radio Paradise
https://stream.radioparadise.com/aac-320
EOF
chown -R _mpd:_mpd /var/spool/mpd
chmod -R 0755 /var/spool/mpd
rcctl enable mpd
```

### X11
```shell
cp /etc/X11/xenodm/Xsetup_0 /root/Xsetup_0
sed -i 's/\(.*xconsole.*$\)/# \1/' /etc/X11/xenodm/Xsetup_0
sed -i 's/\(.*xsetroot.*$\)/# \1/' /etc/X11/xenodm/Xsetup_0
cat >> /etc/X11/xenodm/Xsetup_0 << EOF
xsetroot -solid black
xset b off
EOF
cp /etc/X11/xenodm/Xresources /root/backup/Xresources
cat > /etc/X11/xenodm/Xresources <<EOF
! $OpenBSD: Xresources.in,v 1.3 2020/06/28 15:38:34 matthieu Exp $
!
xlogin.Login.echoPasswd:       true
xlogin.Login.fail:             fail
xlogin.Login.greeting:
xlogin.Login.namePrompt:       \040login\040
xlogin.Login.passwdPrompt:     passwd\040

xlogin.Login.height:           180
xlogin.Login.width:            500
xlogin.Login.y:                320
xlogin.Login.frameWidth:       0
xlogin.Login.innerFramesWidth: 0

xlogin.Login.background:       black
xlogin.Login.foreground:       #eeeeee
xlogin.Login.failColor:        white
xlogin.Login.inpColor:         black
xlogin.Login.promptColor:      #eeeeec

xlogin.Login.face:             spleen-24
xlogin.Login.failFace:         spleen-24
xlogin.Login.promptFace:       spleen-24
EOF
```

### les utilisateurs

```shell
cd /etc/skel
mkdir -p Desktop Documents Downloads Music Pictures/Captures Projects Public Templates Videos
cat > /etc/skel/.kshrc <<EOF
set -o emacs
export HISTFILE="\${HOME}/.sh_history"
export HISTSIZE=16384

export PS1="{\A} \u@\l [\W] \\$ "
EOF
useradd -m -g users -G staff,operator -c 'Tracnac Dev Team' tracnac
passwd tracnac
```

## Tracnac
```shell
su - tracnac
cd ~/
echo 'set from=tracnac@devmobs.fr' >> ${HOME}/.mailrc
echo 'set replyto=tracnac@devmobs.fr' >> ${HOME}/.mailrc

cat > ~/.gitconfig <<EOF
[user]
        email = tracnac@devmobs.fr
        name = Tracnac
        signingkey = 8E7873806AA124421519A62DA9BCFEFD2464C1B2
[commit]
        gpgsign = true
EOF
git clone https://github.com/tracnac/dotfiles .dotfiles
cd .dotfiles
git submodule init
git submodule update
# git submodule update --init
cd ~/
ln -s .dotfiles/bin/dot-bin .bin
ln -s .dotfiles/vim/dot-vim .vim
ln -s .dotfiles/vim/dot-vimrc  .vimrc
ln -s .dotfiles/tmux/dot-tmux .tmux
ln -s .dotfiles/tmux/dot-tmux.conf .tmux.conf
rm .kshrc .profile
ln -s .dotfiles/OpenBSD/dot-kshrc .kshrc
ln -s .dotfiles/OpenBSD/dot-profile .profile
# vim :PlugUpgrade + :PlugInstall
# tmux ctrl-b + I
doas pkg_add clang-tools-extra go janet fish fzf bat rust
fish
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install PatrickF1/fzf.fish
echo '/usr/local/bin/fish' | doas tee -a /etc/shells
chsh -s /usr/local/bin/fish tracnac
# cargo install fd-find Failed needed by fzf.fish
```

### Configure X
```shell
# TODO: Remplacer polybar (bloat)
doas pkg_add rofi dunst i3lock hsetroot scrot xclip xsel
ln -s .dotfiles/fonts/dot-fonts .fonts
rm .fonts/FantasqueSansMonoRegular.ttf
fc-cache --force
ln -s .dotfiles/OpenBSD/dot-cwmrc .cwmrc
ln -s .dotfiles/OpenBSD/dot-xinitrc .xsession
ln -s .dotfiles/wallpaper/dot-wallpaper.png .wallpaper.png
mkdir .config
cd ~/.config
ln -s ../.dotfiles/rofi/dot-config/rofi
ln -s ../.dotfiles/dunst/dot-config/dunst
cd ~
```

#### Emacs
```shell
doas pkg_add emacs ripgrep fzf shellcheck
# git clone --depth 1 https://github.com/hlissner/doom-emacs
# git clone https://github.com/rougier/nano-emacs.git
# ~/.emacs.d/bin/doom install
# Update init.el

```

#### ST
```shell
cd ~/.dotfiles/pkgsrc/st
tar xvzf st-0.8.2.tgz
cd st-0.8.2
cp ../config.* .
doas make install
```

#### Go
```shell
cd ~/
mkdir .go
go env -w GOPATH="/home/tracnac/.go"
go env -w GOMODCACHE="/home/tracnac/.go/pkg/mod"
go install github.com/Code-Hex/go-install-tools@latest
~/.go/bin/go-install-tools
fish_add_path ~/.go/bin
```

#### ISYNC
```shell
doas pkg_add isync neomutt notmuch w3m pandoc zathura feh
```
Crontab :
```
# mm  hh  DD  MM  W /path/program [--option]...  ( W = weekday: 0-6 [Sun=0] )
*/5 * * * * /usr/bin/mbsync mailfence 1>/dev/null 2>&1
```

```shell
mkdir -p ~/.mail/mailfence
cat > ~/.mbsyncrc <<EOF
IMAPAccount mailfence
Host imap.mailfence.com
User username
Pass password
SSLType IMAPS
CertificateFile /etc/ssl/cert.pem

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
chmod 0700 ~/.mail
chmod 0700 ~/.mail/mailfence
```
```shell
# TODO: Notmuch for better integration with neomutt
notmuch setup
mbsync mailfence
notmuch new
```

#### NEOMUTT
```shell
mkdir -p .cache/neomutt/headers .cache/neomutt/messages
cd ~/.config
ln -s ../.dotfiles/neomutt/dot-config/neomutt
find .mail/mailfence -not \( -path *cur* -o -path *new* -o -path *tmp* -o -path *.notmuch* -prune \) -type d | sed 's|.mail/mailfence/\(.*\)$|mailboxes "\+\1\"|g' > ~/.config/neomutt/mailboxes

### TODO
### wsconsctl display.brightness=100%
### wsconsctl keyboard.backlight=0%
