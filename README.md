# makepkg-optimize

makepkg-optimize is a collection of supplemental [https://gitlab.archlinux.org/pacman/pacman/commit/295a3491adc4af5c8634ac82777212ed9c664457 tidy], [https://gitlab.archlinux.org/pacman/pacman/commit/508b4e3ec0cb3e365942f4dc0626edda4789932b buildenv], and [https://gitlab.archlinux.org/pacman/pacman/commit/0bb04fa16a82db133dd010478c1256bc8500c5e7 executable] scripts for [[pacman]] which provide macros for several kinds of optimization in the {{ic|build()}} and {{ic|package()}} stages.

{{Note|As with any package in the [[Arch User Repository]], {{AUR|makepkg-optimize}} has no official support. You should read, and you may post [[User:Quequotion/Arch User Repository#Commenting on packages|comments]] on its AUR page.}}

## Installation

Install makepkg-optimize-mold(https://aur.archlinux.org/packages/makepkg-optimize-mold/) and, to make optimizations available, install their backends: openmp, upx, optipng, svgo and mold

## Configuration

makepkg-optimize generates a redundant configuration file, /etc/makepkg-optimize.conf, from your current makepkg.conf configuration.

This file lists supplementary COMPILE FLAGS, BUILD ENVIRONMENT options, GLOBAL PACKAGE OPTIONS, PACKAGE OUTPUT options, and COMPRESSION DEFAULTS, all of which are disabled by default.

Some packages may fail to build with certain optimizations and over-optimization may cause problems for some programs--such as decreased performance and segmentation faults.

## Build an optimized package

After selecting your preferred optimizations, pass the configuration file when building:

\$ makepkg -c --config /etc/makepkg-optimize.conf

### Profile-guided optimization

Note: Profile-guided optimization requires that a package be built and installed twice. The first phase initiates profile generation in $PROFDEST/pkgbase.gen; the second moves them to $PROFDEST/pkgbase.used and applies them

## Build an optimized package in a clean chroot

Alternatively, makepkg-optimize can be used to build optimized packages within a chroot.

## Create a PGO cache ====

To use PGO, create a folder in the same place, inside and outside of the chroot, to store [https://gcc.gnu.org/onlinedocs/gcc/Gcov-Data-Files.html profiles]:

# mkdir -m 777 {"$CHROOT"/{root,"$USER"},}/mnt/pgo

Then edit \$CHROOT/root/etc/makepkg-optimize.conf and set PROFDEST=/mnt/pgo.

## Building with PGO

After the first building phase, bind the PGO cache:

# mount -o bind {,"\$CHROOT"/root}/mnt/pgo

# mount -o bind "$CHROOT"/{root,"$USER"}/mnt/pgo

Tip: Use fstab to bind these folders at boot.
