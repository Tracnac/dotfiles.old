#!/bin/env bash

# Before
# make partitions
# format partitions
# mount partitions
# basestrap /mnt base base-devel s6-base elogind-s6
# basestrap /mnt linux linux-firmware
# fstabgen -U /mnt >> /mnt/etc/fstab
# artix-chroot /mnt

# ENV
PKGS="vim tmux git"
HOSTNAME="artix"
TIMEZONE="Europe/Paris"
KEYMAP=us
FONT=ter-116n
ACCOUNT=tracnac


# Default package
pacman -S --noconfirm ${PKGS}

# Hostname:
cat > /etc/hostname << EOF
${HOSTNAME}
EOF

# Timezone & Date
ln -s "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime
hwclock --systohc

# LOCALE
sed -i 's/^#en_US.UTF-8.*UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen 
cat > /etc/locale.conf << EOF
export LANG="en_US.UTF-8"
export LC_COLLATE="C"
EOF

pacman -S --noconfirm terminus-font
mkdir /etc/conf.d
touch /etc/conf.d/consolefont
touch /etc/conf.d/keymaps
sed -i 's/^consolefont="default8x16"/consolefont="'${FONT}'"/' /etc/conf.d/consolefont
sed -i 's/keymap="us"/keymap="'${KEYMAP}'"/' /etc/conf.d/keymaps
cat > /etc/vconsole.conf << EOF
FONT=${FONT}
KEYMAP=${KEYMAP}
EOF
ln -s /usr/share/kbd/consolefonts /usr/share/consolefont

# GRUB
# sed -i 's/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev autodetect modconf block filesystems keyboard consolefont fsck)/' /etc/mkinitcpio.conf
pacman -S --noconfirm grub os-prober # efibootmgr
grub-install --recheck /dev/sda
# grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
pacman -S --noconfirm btrfs-progs # mkinitcpio -p linux
grub-mkconfig -o /boot/grub/grub.cfg

# Setup user [DON'T FORGET TO SET PASSWD for root and users if any]
if [ ! "x${ACCOUNT}" == "x" ]; then
    pacman -S --noconfirm sudo
    useradd -m ${ACCOUNT}
    usermod -aG wheel,users ${ACCOUNT}
    sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
    echo '' | EDITOR='tee -a' visudo -c
fi

# Services depend s6 or openrc
#pacman -S --noconfirm connman-openrc openssh-openrc
#rc-update add sshd
#rc-update add connmand
#rc-update add consolefont boot
#rc-update del agetty.tty6
#rc-update del agetty.tty5
#rc-update del agetty.tty4
#rc-update del agetty.tty3
pacman -S --noconfirm connman connman-s6 openssh openssh-s6
# s6-rc-bundle-update -c /etc/s6/rc/compiled add default [connmand sshd dbus]

# Xorg
pacman -S --noconfirm xorg-server xf86-input-evdev xorg-xinit xorg-xrdb xorg-xprop xorg-xrandr xorg-xset xorg-xauth xorg-setxkbmap xorg-xkbcomp xorg-xmodmap xorg-xsetroot xclip xsel

pacman -S --noconfirm xf86-video-intel # Intel driver free for non free look at libva and intel stuff
pacman -S --noconfirm vulkan-intel mesa-vdpau libva-mesa-driver

pacman -S --noconfirm xf86-video-vesa # Failback...
