# Installation de Voidlinux GLIC et via Menuconfig

_l'installation via chroot fera l'objet d'un post différent_

## X11 
### Specifique à Intel
``` Shell
xbps-install intel-video-accel
xbps-install mesa
xbps-install mesa-dri
xbps-install vulkan-loader
xbps-install mesa-vulkan-intel
```
- Copy xorg files and keyboard usfr
- Adjust font setting 
- Copy all stuff around X11

## Printer

```shell
xbps-install cups
xbps-install cups-filters
xbps-install surf
xbps-install dmenu
```

- After installation : http://localhost:631
- And load the PPD File
