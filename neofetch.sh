#!/usr/bin/env bash
# vim: noai:ts=4:sw=4:expandtab
# shellcheck source=/dev/null
# shellcheck disable=2009
#
# Neofetch: A command-line system information tool written in bash 3.2+.
# https://github.com/dylanaraps/neofetch
#
# The MIT License (MIT)
#
# Copyright (c) 2015-2020 Dylan Araps
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

version=7.1.0

# Fallback to a value of '5' for shells which support bash
# but do not set the 'BASH_' shell variables (osh).
bash_version=${BASH_VERSINFO[0]:-5}
shopt -s eval_unsafe_arith &>/dev/null

sys_locale=${LANG:-C}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-${HOME}/.config}
PATH=$PATH:/usr/xpg4/bin:/usr/sbin:/sbin:/usr/etc:/usr/libexec
reset='\e[0m'
shopt -s nocasematch

# Speed up script by not using unicode.
LC_ALL=C
LANG=C

# Fix issues with gsettings.
export GIO_EXTRA_MODULES=/usr/lib/x86_64-linux-gnu/gio/modules/

# Neofetch default config.
read -rd '' config <<'EOF'
# See this wiki page for more info:
# https://github.com/dylanaraps/neofetch/wiki/Customizing-Info
print_info() {
    info title
    info underline

    info "OS" distro
    info "Host" model
    info "Kernel" kernel
    info "Uptime" uptime
    info "Packages" packages
    info "Shell" shell
    info "Resolution" resolution
    info "DE" de
    info "WM" wm
    info "WM Theme" wm_theme
    info "Theme" theme
    info "Icons" icons
    info "Terminal" term
    info "Terminal Font" term_font
    info "CPU" cpu
    info "GPU" gpu
    info "Memory" memory

    # info "GPU Driver" gpu_driver  # Linux/macOS only
    # info "Disk" disk
    # info "Battery" battery
    # info "Font" font
    # info "Song" song
    # [[ "$player" ]] && prin "Music Player" "$player"
    # info "Local IP" local_ip
    # info "Public IP" public_ip
    # info "Users" users
    # info "Locale" locale  # This only works on glibc systems.

    info cols
}

# Title


# Hide/Show Fully qualified domain name.
#
# Default:  'off'
# Values:   'on', 'off'
# Flag:     --title_fqdn
title_fqdn="off"


# Kernel


# Shorten the output of the kernel function.
#
# Default:  'on'
# Values:   'on', 'off'
# Flag:     --kernel_shorthand
# Supports: Everything except *BSDs (except PacBSD and PC-BSD)
#
# Example:
# on:  '4.8.9-1-ARCH'
# off: 'Linux 4.8.9-1-ARCH'
kernel_shorthand="on"


# Distro


# Shorten the output of the distro function
#
# Default:  'off'
# Values:   'on', 'tiny', 'off'
# Flag:     --distro_shorthand
# Supports: Everything except Windows and Haiku
distro_shorthand="off"

# Show/Hide OS Architecture.
# Show 'x86_64', 'x86' and etc in 'Distro:' output.
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --os_arch
#
# Example:
# on:  'Arch Linux x86_64'
# off: 'Arch Linux'
os_arch="on"


# Uptime


# Shorten the output of the uptime function
#
# Default: 'on'
# Values:  'on', 'tiny', 'off'
# Flag:    --uptime_shorthand
#
# Example:
# on:   '2 days, 10 hours, 3 mins'
# tiny: '2d 10h 3m'
# off:  '2 days, 10 hours, 3 minutes'
uptime_shorthand="on"


# Memory


# Show memory percentage in output.
#
# Default: 'off'
# Values:  'on', 'off'
# Flag:    --memory_percent
#
# Example:
# on:   '1801MiB / 7881MiB (22%)'
# off:  '1801MiB / 7881MiB'
memory_percent="off"

# Change memory output unit.
#
# Default: 'mib'
# Values:  'kib', 'mib', 'gib'
# Flag:    --memory_unit
#
# Example:
# kib  '1020928KiB / 7117824KiB'
# mib  '1042MiB / 6951MiB'
# gib: ' 0.98GiB / 6.79GiB'
memory_unit="mib"


# Packages


# Show/Hide Package Manager names.
#
# Default: 'tiny'
# Values:  'on', 'tiny' 'off'
# Flag:    --package_managers
#
# Example:
# on:   '998 (pacman), 8 (flatpak), 4 (snap)'
# tiny: '908 (pacman, flatpak, snap)'
# off:  '908'
package_managers="on"


# Shell


# Show the path to $SHELL
#
# Default: 'off'
# Values:  'on', 'off'
# Flag:    --shell_path
#
# Example:
# on:  '/bin/bash'
# off: 'bash'
shell_path="off"

# Show $SHELL version
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --shell_version
#
# Example:
# on:  'bash 4.4.5'
# off: 'bash'
shell_version="on"


# CPU


# CPU speed type
#
# Default: 'bios_limit'
# Values: 'scaling_cur_freq', 'scaling_min_freq', 'scaling_max_freq', 'bios_limit'.
# Flag:    --speed_type
# Supports: Linux with 'cpufreq'
# NOTE: Any file in '/sys/devices/system/cpu/cpu0/cpufreq' can be used as a value.
speed_type="bios_limit"

# CPU speed shorthand
#
# Default: 'off'
# Values: 'on', 'off'.
# Flag:    --speed_shorthand
# NOTE: This flag is not supported in systems with CPU speed less than 1 GHz
#
# Example:
# on:    'i7-6500U (4) @ 3.1GHz'
# off:   'i7-6500U (4) @ 3.100GHz'
speed_shorthand="off"

# Enable/Disable CPU brand in output.
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --cpu_brand
#
# Example:
# on:   'Intel i7-6500U'
# off:  'i7-6500U (4)'
cpu_brand="on"

# CPU Speed
# Hide/Show CPU speed.
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --cpu_speed
#
# Example:
# on:  'Intel i7-6500U (4) @ 3.1GHz'
# off: 'Intel i7-6500U (4)'
cpu_speed="on"

# CPU Cores
# Display CPU cores in output
#
# Default: 'logical'
# Values:  'logical', 'physical', 'off'
# Flag:    --cpu_cores
# Support: 'physical' doesn't work on BSD.
#
# Example:
# logical:  'Intel i7-6500U (4) @ 3.1GHz' (All virtual cores)
# physical: 'Intel i7-6500U (2) @ 3.1GHz' (All physical cores)
# off:      'Intel i7-6500U @ 3.1GHz'
cpu_cores="logical"

# CPU Temperature
# Hide/Show CPU temperature.
# Note the temperature is added to the regular CPU function.
#
# Default: 'off'
# Values:  'C', 'F', 'off'
# Flag:    --cpu_temp
# Supports: Linux, BSD
# NOTE: For FreeBSD and NetBSD-based systems, you'll need to enable
#       coretemp kernel module. This only supports newer Intel processors.
#
# Example:
# C:   'Intel i7-6500U (4) @ 3.1GHz [27.2°C]'
# F:   'Intel i7-6500U (4) @ 3.1GHz [82.0°F]'
# off: 'Intel i7-6500U (4) @ 3.1GHz'
cpu_temp="off"


# GPU


# Enable/Disable GPU Brand
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --gpu_brand
#
# Example:
# on:  'AMD HD 7950'
# off: 'HD 7950'
gpu_brand="on"

# Which GPU to display
#
# Default: 'all'
# Values:  'all', 'dedicated', 'integrated'
# Flag:    --gpu_type
# Supports: Linux
#
# Example:
# all:
#   GPU1: AMD HD 7950
#   GPU2: Intel Integrated Graphics
#
# dedicated:
#   GPU1: AMD HD 7950
#
# integrated:
#   GPU1: Intel Integrated Graphics
gpu_type="all"


# Resolution


# Display refresh rate next to each monitor
# Default: 'off'
# Values:  'on', 'off'
# Flag:    --refresh_rate
# Supports: Doesn't work on Windows.
#
# Example:
# on:  '1920x1080 @ 60Hz'
# off: '1920x1080'
refresh_rate="off"


# Gtk Theme / Icons / Font


# Shorten output of GTK Theme / Icons / Font
#
# Default: 'off'
# Values:  'on', 'off'
# Flag:    --gtk_shorthand
#
# Example:
# on:  'Numix, Adwaita'
# off: 'Numix [GTK2], Adwaita [GTK3]'
gtk_shorthand="off"


# Enable/Disable gtk2 Theme / Icons / Font
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --gtk2
#
# Example:
# on:  'Numix [GTK2], Adwaita [GTK3]'
# off: 'Adwaita [GTK3]'
gtk2="on"

# Enable/Disable gtk3 Theme / Icons / Font
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --gtk3
#
# Example:
# on:  'Numix [GTK2], Adwaita [GTK3]'
# off: 'Numix [GTK2]'
gtk3="on"


# IP Address


# Website to ping for the public IP
#
# Default: 'http://ident.me'
# Values:  'url'
# Flag:    --ip_host
public_ip_host="http://ident.me"

# Public IP timeout.
#
# Default: '2'
# Values:  'int'
# Flag:    --ip_timeout
public_ip_timeout=2

# Local IP interface
#
# Default: 'auto' (interface of default route)
# Values:  'auto', 'en0', 'en1'
# Flag:    --ip_interface
local_ip_interface=('auto')


# Desktop Environment


# Show Desktop Environment version
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --de_version
de_version="on"


# Disk


# Which disks to display.
# The values can be any /dev/sdXX, mount point or directory.
# NOTE: By default we only show the disk info for '/'.
#
# Default: '/'
# Values:  '/', '/dev/sdXX', '/path/to/drive'.
# Flag:    --disk_show
#
# Example:
# disk_show=('/' '/dev/sdb1'):
#      'Disk (/): 74G / 118G (66%)'
#      'Disk (/mnt/Videos): 823G / 893G (93%)'
#
# disk_show=('/'):
#      'Disk (/): 74G / 118G (66%)'
#
disk_show=('/')

# Disk subtitle.
# What to append to the Disk subtitle.
#
# Default: 'mount'
# Values:  'mount', 'name', 'dir', 'none'
# Flag:    --disk_subtitle
#
# Example:
# name:   'Disk (/dev/sda1): 74G / 118G (66%)'
#         'Disk (/dev/sdb2): 74G / 118G (66%)'
#
# mount:  'Disk (/): 74G / 118G (66%)'
#         'Disk (/mnt/Local Disk): 74G / 118G (66%)'
#         'Disk (/mnt/Videos): 74G / 118G (66%)'
#
# dir:    'Disk (/): 74G / 118G (66%)'
#         'Disk (Local Disk): 74G / 118G (66%)'
#         'Disk (Videos): 74G / 118G (66%)'
#
# none:   'Disk: 74G / 118G (66%)'
#         'Disk: 74G / 118G (66%)'
#         'Disk: 74G / 118G (66%)'
disk_subtitle="mount"

# Disk percent.
# Show/Hide disk percent.
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --disk_percent
#
# Example:
# on:  'Disk (/): 74G / 118G (66%)'
# off: 'Disk (/): 74G / 118G'
disk_percent="on"


# Song


# Manually specify a music player.
#
# Default: 'auto'
# Values:  'auto', 'player-name'
# Flag:    --music_player
#
# Available values for 'player-name':
#
# amarok
# audacious
# banshee
# bluemindo
# clementine
# cmus
# deadbeef
# deepin-music
# dragon
# elisa
# exaile
# gnome-music
# gmusicbrowser
# gogglesmm
# guayadeque
# io.elementary.music
# iTunes
# Music
# juk
# lollypop
# MellowPlayer
# mocp
# mopidy
# mpd
# muine
# netease-cloud-music
# olivia
# playerctl
# pogo
# pragha
# qmmp
# quodlibet
# rhythmbox
# sayonara
# smplayer
# spotify
# strawberry
# tauonmb
# tomahawk
# vlc
# xmms2d
# xnoise
# yarock
music_player="auto"

# Format to display song information.
#
# Default: '%artist% - %album% - %title%'
# Values:  '%artist%', '%album%', '%title%'
# Flag:    --song_format
#
# Example:
# default: 'Song: Jet - Get Born - Sgt Major'
song_format="%artist% - %album% - %title%"

# Print the Artist, Album and Title on separate lines
#
# Default: 'off'
# Values:  'on', 'off'
# Flag:    --song_shorthand
#
# Example:
# on:  'Artist: The Fratellis'
#      'Album: Costello Music'
#      'Song: Chelsea Dagger'
#
# off: 'Song: The Fratellis - Costello Music - Chelsea Dagger'
song_shorthand="off"

# 'mpc' arguments (specify a host, password etc).
#
# Default:  ''
# Example: mpc_args=(-h HOST -P PASSWORD)
mpc_args=()


# Text Colors


# Text Colors
#
# Default:  'distro'
# Values:   'distro', 'num' 'num' 'num' 'num' 'num' 'num'
# Flag:     --colors
#
# Each number represents a different part of the text in
# this order: 'title', '@', 'underline', 'subtitle', 'colon', 'info'
#
# Example:
# colors=(distro)      - Text is colored based on Distro colors.
# colors=(4 6 1 8 8 6) - Text is colored in the order above.
colors=(distro)


# Text Options


# Toggle bold text
#
# Default:  'on'
# Values:   'on', 'off'
# Flag:     --bold
bold="on"

# Enable/Disable Underline
#
# Default:  'on'
# Values:   'on', 'off'
# Flag:     --underline
underline_enabled="on"

# Underline character
#
# Default:  '-'
# Values:   'string'
# Flag:     --underline_char
underline_char="-"


# Info Separator
# Replace the default separator with the specified string.
#
# Default:  ':'
# Flag:     --separator
#
# Example:
# separator="->":   'Shell-> bash'
# separator=" =":   'WM = dwm'
separator=":"


# Color Blocks


# Color block range
# The range of colors to print.
#
# Default:  '0', '15'
# Values:   'num'
# Flag:     --block_range
#
# Example:
#
# Display colors 0-7 in the blocks.  (8 colors)
# neofetch --block_range 0 7
#
# Display colors 0-15 in the blocks. (16 colors)
# neofetch --block_range 0 15
block_range=(0 15)

# Toggle color blocks
#
# Default:  'on'
# Values:   'on', 'off'
# Flag:     --color_blocks
color_blocks="on"

# Color block width in spaces
#
# Default:  '3'
# Values:   'num'
# Flag:     --block_width
block_width=3

# Color block height in lines
#
# Default:  '1'
# Values:   'num'
# Flag:     --block_height
block_height=1

# Color Alignment
#
# Default: 'auto'
# Values: 'auto', 'num'
# Flag: --col_offset
#
# Number specifies how far from the left side of the terminal (in spaces) to
# begin printing the columns, in case you want to e.g. center them under your
# text.
# Example:
# col_offset="auto" - Default behavior of neofetch
# col_offset=7      - Leave 7 spaces then print the colors
col_offset="auto"

# Progress Bars


# Bar characters
#
# Default:  '-', '='
# Values:   'string', 'string'
# Flag:     --bar_char
#
# Example:
# neofetch --bar_char 'elapsed' 'total'
# neofetch --bar_char '-' '='
bar_char_elapsed="-"
bar_char_total="="

# Toggle Bar border
#
# Default:  'on'
# Values:   'on', 'off'
# Flag:     --bar_border
bar_border="on"

# Progress bar length in spaces
# Number of chars long to make the progress bars.
#
# Default:  '15'
# Values:   'num'
# Flag:     --bar_length
bar_length=15

# Progress bar colors
# When set to distro, uses your distro's logo colors.
#
# Default:  'distro', 'distro'
# Values:   'distro', 'num'
# Flag:     --bar_colors
#
# Example:
# neofetch --bar_colors 3 4
# neofetch --bar_colors distro 5
bar_color_elapsed="distro"
bar_color_total="distro"


# Info display
# Display a bar with the info.
#
# Default: 'off'
# Values:  'bar', 'infobar', 'barinfo', 'off'
# Flags:   --memory_display
#          --battery_display
#          --disk_display
#
# Example:
# bar:     '[---=======]'
# infobar: 'info [---=======]'
# barinfo: '[---=======] info'
# off:     'info'
memory_display="off"
battery_display="off"
disk_display="off"


# Backend Settings


# Image backend.
#
# Default:  'ascii'
# Values:   'ascii', 'caca', 'catimg', 'chafa', 'jp2a', 'iterm2', 'off',
#           'pot', 'termpix', 'pixterm', 'tycat', 'w3m', 'kitty', 'ueberzug',
#           'viu'

# Flag:     --backend
image_backend="ascii"

# Image Source
#
# Which image or ascii file to display.
#
# Default:  'auto'
# Values:   'auto', 'ascii', 'wallpaper', '/path/to/img', '/path/to/ascii', '/path/to/dir/'
#           'command output (neofetch --ascii "$(fortune | cowsay -W 30)")'
# Flag:     --source
#
# NOTE: 'auto' will pick the best image source for whatever image backend is used.
#       In ascii mode, distro ascii art will be used and in an image mode, your
#       wallpaper will be used.
image_source="auto"


# Ascii Options


# Ascii distro
# Which distro's ascii art to display.
#
# Default: 'auto'
# Values:  'auto', 'distro_name'
# Flag:    --ascii_distro
# NOTE: AIX, Hash, Alpine, AlterLinux, Amazon, AmogOS, Anarchy, Android, instantOS,
#       Antergos, antiX, "AOSC OS", "AOSC OS/Retro", Apricity, ArchCraft,
#       ArcoLinux, ArchBox, ARCHlabs, ArchStrike, XFerience, ArchMerge, Arch,
#       Artix, Arya, Bedrock, Bitrig, BlackArch, BLAG, BlankOn, BlueLight,
#       Bodhi, bonsai, BSD, BunsenLabs, Calculate, Carbs, CentOS, Chakra, ChaletOS,
#       Chapeau, Chrom*, Cleanjaro, ClearOS, Clear_Linux, Clover, Condres,
#       Container_Linux, CrystalUX, CRUX, Cucumber, dahlia, Debian, Deepin,
#       DesaOS, Devuan, DracOS, DarkOs, Itc, DragonFly, Drauger, Elementary,
#       EndeavourOS, Endless, EuroLinux, Exherbo, Fedora, Feren, FreeBSD,
#       FreeMiNT, Frugalware, Funtoo, GalliumOS, Garuda, Gentoo, Pentoo,
#       gNewSense, GNOME, GNU, GoboLinux, Grombyang, Guix, Haiku, Huayra, HydroOS
#       Hyperbola, iglunix, janus, Kali, KaOS, KDE_neon, Kibojoe, Kogaion, Korora,
#       KSLinux, Kubuntu, LEDE, LaxerOS, LibreELEC, LFS, Linux_Lite, LMDE,
#       Lubuntu, Lunar, macos, Mageia, MagpieOS, Mandriva, Manjaro, TeArch, Maui,
#       Mer, Minix, LinuxMint, Live_Raizo, MX_Linux, Namib, Neptune, NetBSD,
#       Netrunner, Nitrux, NixOS, Nurunner, NuTyX, OBRevenge, OpenBSD,
#       openEuler, OpenIndiana, openmamba, OpenMandriva, OpenStage, OpenWrt,
#       osmc, Oracle, OS Elbrus, PacBSD, Parabola, Pardus, Parrot, Parsix,
#       TrueOS, PCLinuxOS, Pengwin, Peppermint, Pisi, popos, Porteus, PostMarketOS,
#       Proxmox, PuffOS, Puppy, PureOS, Qubes, Quibian, Radix, Raspbian,
#       Reborn_OS, Redstar, Redcore, Redhat, Refracted_Devuan, Regata, Regolith,
#       Rocky, Rosa, sabotage, Sabayon, Sailfish, SalentOS, Scientific, Septor,
#       SereneLinux, SharkLinux, Siduction, SkiffOS, Slackware, SliTaz, SmartOS,
#       Solus, Source_Mage, Sparky, Star, SteamOS, SunOS, openSUSE_Leap, t2,
#       openSUSE_Tumbleweed, openSUSE, SwagArch, Tails, Trisquel,
#       Ubuntu-Cinnamon, Ubuntu-Budgie, Ubuntu-GNOME, Ubuntu-MATE,
#       Ubuntu-Studio, Ubuntu, Univention, Venom, Void, LangitKetujuh, semc,
#       Obarun, windows10, Windows7, Xubuntu, Zorin, and IRIX have ascii logos.
# NOTE: Arch, Ubuntu, Redhat, Fedora and Dragonfly have 'old' logo variants.
#       Use '{distro name}_old' to use the old logos.
# NOTE: Ubuntu has flavor variants.
#       Change this to Lubuntu, Kubuntu, Xubuntu, Ubuntu-GNOME,
#       Ubuntu-Studio, Ubuntu-Mate  or Ubuntu-Budgie to use the flavors.
# NOTE: Arcolinux, Dragonfly, Fedora, Alpine, Arch, Ubuntu,
#       CRUX, Debian, Gentoo, FreeBSD, Mac, NixOS, OpenBSD, android,
#       Artix, CentOS, Cleanjaro, ElementaryOS, GUIX, Hyperbola,
#       Manjaro, MXLinux, NetBSD, Parabola, POP_OS, PureOS,
#       Slackware, SunOS, LinuxLite, OpenSUSE, Raspbian,
#       postmarketOS, and Void have a smaller logo variant.
#       Use '{distro name}_small' to use the small variants.
ascii_distro="auto"

# Ascii Colors
#
# Default:  'distro'
# Values:   'distro', 'num' 'num' 'num' 'num' 'num' 'num'
# Flag:     --ascii_colors
#
# Example:
# ascii_colors=(distro)      - Ascii is colored based on Distro colors.
# ascii_colors=(4 6 1 8 8 6) - Ascii is colored using these colors.
ascii_colors=(distro)

# Bold ascii logo
# Whether or not to bold the ascii logo.
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --ascii_bold
ascii_bold="on"


# Image Options


# Image loop
# Setting this to on will make neofetch redraw the image constantly until
# Ctrl+C is pressed. This fixes display issues in some terminal emulators.
#
# Default:  'off'
# Values:   'on', 'off'
# Flag:     --loop
image_loop="off"

# Thumbnail directory
#
# Default: '~/.cache/thumbnails/neofetch'
# Values:  'dir'
thumbnail_dir="${XDG_CACHE_HOME:-${HOME}/.cache}/thumbnails/neofetch"

# Crop mode
#
# Default:  'normal'
# Values:   'normal', 'fit', 'fill'
# Flag:     --crop_mode
#
# See this wiki page to learn about the fit and fill options.
# https://github.com/dylanaraps/neofetch/wiki/What-is-Waifu-Crop%3F
crop_mode="normal"

# Crop offset
# Note: Only affects 'normal' crop mode.
#
# Default:  'center'
# Values:   'northwest', 'north', 'northeast', 'west', 'center'
#           'east', 'southwest', 'south', 'southeast'
# Flag:     --crop_offset
crop_offset="center"

# Image size
# The image is half the terminal width by default.
#
# Default: 'auto'
# Values:  'auto', '00px', '00%', 'none'
# Flags:   --image_size
#          --size
image_size="auto"

# Catimg block size.
# Control the resolution of catimg.
#
# Default: '2'
# Values:  '1', '2'
# Flags:   --catimg_size
catimg_size="2"

# Gap between image and text
#
# Default: '3'
# Values:  'num', '-num'
# Flag:    --gap
gap=3

# Image offsets
# Only works with the w3m backend.
#
# Default: '0'
# Values:  'px'
# Flags:   --xoffset
#          --yoffset
yoffset=0
xoffset=0

# Image background color
# Only works with the w3m backend.
#
# Default: ''
# Values:  'color', 'blue'
# Flag:    --bg_color
background_color=


# Misc Options

# Stdout mode
# Turn off all colors and disables image backend (ASCII/Image).
# Useful for piping into another command.
# Default: 'off'
# Values: 'on', 'off'
stdout="off"
EOF

# DETECT INFORMATION

get_os() {
    # $kernel_name is set in a function called cache_uname and is
    # just the output of "uname -s".
    case $kernel_name in
        Darwin)   os=$darwin_name ;;
        SunOS)    os=Solaris ;;
        Haiku)    os=Haiku ;;
        MINIX)    os=MINIX ;;
        AIX)      os=AIX ;;
        IRIX*)    os=IRIX ;;
        FreeMiNT) os=FreeMiNT ;;

        Linux|GNU*)
            os=Linux
        ;;

        *BSD|DragonFly|Bitrig)
            os=BSD
        ;;

        CYGWIN*|MSYS*|MINGW*)
            os=Windows
        ;;

        *)
            printf '%s\n' "Unknown OS detected: '$kernel_name', aborting..." >&2
            printf '%s\n' "Open an issue on GitHub to add support for your OS." >&2
            exit 1
        ;;
    esac
}

get_distro() {
    [[ $distro ]] && return

    case $os in
        Linux|BSD|MINIX)
            if [[ -f /bedrock/etc/bedrock-release && -z $BEDROCK_RESTRICT ]]; then
                case $distro_shorthand in
                    on|tiny) distro="Bedrock Linux" ;;
                    *) distro=$(< /bedrock/etc/bedrock-release)
                esac

            elif [[ -f /etc/redstar-release ]]; then
                case $distro_shorthand in
                    on|tiny) distro="Red Star OS" ;;
                    *) distro="Red Star OS $(awk -F'[^0-9*]' '$0=$2' /etc/redstar-release)"
                esac

            elif [[ -f /etc/armbian-release ]]; then
                . /etc/armbian-release
                distro="Armbian $DISTRIBUTION_CODENAME (${VERSION:-})"

            elif [[ -f /etc/siduction-version ]]; then
                case $distro_shorthand in
                    on|tiny) distro=Siduction ;;
                    *) distro="Siduction ($(lsb_release -sic))"
                esac

            elif [[ -f /etc/mcst_version ]]; then
                case $distro_shorthand in
                    on|tiny) distro="OS Elbrus" ;;
                    *) distro="OS Elbrus $(< /etc/mcst_version)"
                esac

            elif type -p pveversion >/dev/null; then
                case $distro_shorthand in
                    on|tiny) distro="Proxmox VE" ;;
                    *)
                        distro=$(pveversion)
                        distro=${distro#pve-manager/}
                        distro="Proxmox VE ${distro%/*}"
                esac

            elif type -p lsb_release >/dev/null; then
                case $distro_shorthand in
                    on)   lsb_flags=-si ;;
                    tiny) lsb_flags=-si ;;
                    *)    lsb_flags=-sd ;;
                esac
                distro=$(lsb_release "$lsb_flags")

            elif [[ -f /etc/os-release || \
                    -f /usr/lib/os-release || \
                    -f /etc/openwrt_release || \
                    -f /etc/lsb-release ]]; then

                # Source the os-release file
                for file in /etc/lsb-release /usr/lib/os-release \
                            /etc/os-release  /etc/openwrt_release; do
                    source "$file" && break
                done

                # Format the distro name.
                case $distro_shorthand in
                    on)   distro="${NAME:-${DISTRIB_ID}} ${VERSION_ID:-${DISTRIB_RELEASE}}" ;;
                    tiny) distro="${NAME:-${DISTRIB_ID:-${TAILS_PRODUCT_NAME}}}" ;;
                    off)  distro="${PRETTY_NAME:-${DISTRIB_DESCRIPTION}} ${UBUNTU_CODENAME}" ;;
                esac

            elif [[ -f /etc/GoboLinuxVersion ]]; then
                case $distro_shorthand in
                    on|tiny) distro=GoboLinux ;;
                    *) distro="GoboLinux $(< /etc/GoboLinuxVersion)"
                esac

            elif [[ -f /etc/SDE-VERSION ]]; then
                distro="$(< /etc/SDE-VERSION)"
                case $distro_shorthand in
                    on|tiny) distro="${distro% *}" ;;
                esac

            elif type -p crux >/dev/null; then
                distro=$(crux)
                case $distro_shorthand in
                    on)   distro=${distro//version} ;;
                    tiny) distro=${distro//version*}
                esac

            elif type -p tazpkg >/dev/null; then
                distro="SliTaz $(< /etc/slitaz-release)"

            elif type -p kpt >/dev/null && \
                 type -p kpm >/dev/null; then
                distro=KSLinux

            elif [[ -d /system/app/ && -d /system/priv-app ]]; then
                distro="Android $(getprop ro.build.version.release)"

            # Chrome OS doesn't conform to the /etc/*-release standard.
            # While the file is a series of variables they can't be sourced
            # by the shell since the values aren't quoted.
            elif [[ -f /etc/lsb-release && $(< /etc/lsb-release) == *CHROMEOS* ]]; then
                distro='Chrome OS'

            elif type -p guix >/dev/null; then
                case $distro_shorthand in
                    on|tiny) distro="Guix System" ;;
                    *) distro="Guix System $(guix -V | awk 'NR==1{printf $4}')"
                esac

            # Display whether using '-current' or '-release' on OpenBSD.
            elif [[ $kernel_name = OpenBSD ]] ; then
                read -ra kernel_info <<< "$(sysctl -n kern.version)"
                distro=${kernel_info[*]:0:2}

            else
                for release_file in /etc/*-release; do
                    distro+=$(< "$release_file")
                done

                if [[ -z $distro ]]; then
                    case $distro_shorthand in
                        on|tiny) distro=$kernel_name ;;
                        *) distro="$kernel_name $kernel_version" ;;
                    esac

                    distro=${distro/DragonFly/DragonFlyBSD}

                    # Workarounds for some BSD based distros.
                    [[ -f /etc/pcbsd-lang ]]       && distro=PCBSD
                    [[ -f /etc/trueos-lang ]]      && distro=TrueOS
                    [[ -f /etc/pacbsd-release ]]   && distro=PacBSD
                    [[ -f /etc/hbsd-update.conf ]] && distro=HardenedBSD
                fi
            fi

            if [[ $(< /proc/version) == *Microsoft* || $kernel_version == *Microsoft* ]]; then
                case $distro_shorthand in
                    on)   distro+=" [Windows 10]" ;;
                    tiny) distro="Windows 10" ;;
                    *)    distro+=" on Windows 10" ;;
                esac

            elif [[ $(< /proc/version) == *chrome-bot* || -f /dev/cros_ec ]]; then
                [[ $distro != *Chrome* ]] &&
                    case $distro_shorthand in
                        on)   distro+=" [Chrome OS]" ;;
                        tiny) distro="Chrome OS" ;;
                        *)    distro+=" on Chrome OS" ;;
                    esac
                    distro=${distro## on }
            fi

            distro=$(trim_quotes "$distro")
            distro=${distro/NAME=}

            # Get Ubuntu flavor.
            if [[ $distro == "Ubuntu"* ]]; then
                case $XDG_CONFIG_DIRS in
                    *"studio"*)   distro=${distro/Ubuntu/Ubuntu Studio} ;;
                    *"plasma"*)   distro=${distro/Ubuntu/Kubuntu} ;;
                    *"mate"*)     distro=${distro/Ubuntu/Ubuntu MATE} ;;
                    *"xubuntu"*)  distro=${distro/Ubuntu/Xubuntu} ;;
                    *"Lubuntu"*)  distro=${distro/Ubuntu/Lubuntu} ;;
                    *"budgie"*)   distro=${distro/Ubuntu/Ubuntu Budgie} ;;
                    *"cinnamon"*) distro=${distro/Ubuntu/Ubuntu Cinnamon} ;;
                esac
            fi
        ;;

        "Mac OS X"|"macOS")
            case $osx_version in
                10.4*)  codename="Mac OS X Tiger" ;;
                10.5*)  codename="Mac OS X Leopard" ;;
                10.6*)  codename="Mac OS X Snow Leopard" ;;
                10.7*)  codename="Mac OS X Lion" ;;
                10.8*)  codename="OS X Mountain Lion" ;;
                10.9*)  codename="OS X Mavericks" ;;
                10.10*) codename="OS X Yosemite" ;;
                10.11*) codename="OS X El Capitan" ;;
                10.12*) codename="macOS Sierra" ;;
                10.13*) codename="macOS High Sierra" ;;
                10.14*) codename="macOS Mojave" ;;
                10.15*) codename="macOS Catalina" ;;
                10.16*) codename="macOS Big Sur" ;;
                11.*)  codename="macOS Big Sur" ;;
                12.*)  codename="macOS Monterey" ;;
                *)      codename=macOS ;;
            esac

            distro="$codename $osx_version $osx_build"

            case $distro_shorthand in
                on) distro=${distro/ ${osx_build}} ;;

                tiny)
                    case $osx_version in
                        10.[4-7]*)            distro=${distro/${codename}/Mac OS X} ;;
                        10.[8-9]*|10.1[0-1]*) distro=${distro/${codename}/OS X} ;;
                        10.1[2-6]*|11.0*)     distro=${distro/${codename}/macOS} ;;
                    esac
                    distro=${distro/ ${osx_build}}
                ;;
            esac
        ;;

        "iPhone OS")
            distro="iOS $osx_version"

            # "uname -m" doesn't print architecture on iOS.
            os_arch=off
        ;;

        Windows)
            distro=$(wmic os get Caption)
            distro=${distro/Caption}
            distro=${distro/Microsoft }
        ;;

        Solaris)
            case $distro_shorthand in
                on|tiny) distro=$(awk 'NR==1 {print $1,$3}' /etc/release) ;;
                *)       distro=$(awk 'NR==1 {print $1,$2,$3}' /etc/release) ;;
            esac
            distro=${distro/\(*}
        ;;

        Haiku)
            distro=Haiku
        ;;

        AIX)
            distro="AIX $(oslevel)"
        ;;

        IRIX)
            distro="IRIX ${kernel_version}"
        ;;

        FreeMiNT)
            distro=FreeMiNT
        ;;
    esac

    distro=${distro//Enterprise Server}

    [[ $distro ]] || distro="$os (Unknown)"

    # Get OS architecture.
    case $os in
        Solaris|AIX|Haiku|IRIX|FreeMiNT)
            machine_arch=$(uname -p)
        ;;

        *)  machine_arch=$kernel_machine ;;
    esac

    [[ $os_arch == on ]] && \
        distro+=" $machine_arch"

    [[ ${ascii_distro:-auto} == auto ]] && \
        ascii_distro=$(trim "$distro")
}

get_model() {
    case $os in
        Linux)
            if [[ -d /system/app/ && -d /system/priv-app ]]; then
                model="$(getprop ro.product.brand) $(getprop ro.product.model)"

            elif [[ -f /sys/devices/virtual/dmi/id/product_name ||
                    -f /sys/devices/virtual/dmi/id/product_version ]]; then
                model=$(< /sys/devices/virtual/dmi/id/product_name)
                model+=" $(< /sys/devices/virtual/dmi/id/product_version)"

            elif [[ -f /sys/firmware/devicetree/base/model ]]; then
                model=$(< /sys/firmware/devicetree/base/model)

            elif [[ -f /tmp/sysinfo/model ]]; then
                model=$(< /tmp/sysinfo/model)
            fi
        ;;

        "Mac OS X"|"macOS")
            if [[ $(kextstat | grep -F -e "FakeSMC" -e "VirtualSMC") != "" ]]; then
                model="Hackintosh (SMBIOS: $(sysctl -n hw.model))"
            else
                model=$(sysctl -n hw.model)
            fi
        ;;

        "iPhone OS")
            case $kernel_machine in
                iPad1,1):            "iPad" ;;
                iPad2,[1-4]):        "iPad 2" ;;
                iPad3,[1-3]):        "iPad 3" ;;
                iPad3,[4-6]):        "iPad 4" ;;
                iPad6,1[12]):        "iPad 5" ;;
                iPad7,[5-6]):        "iPad 6" ;;
                iPad7,1[12]):        "iPad 7" ;;
                iPad11,[67]):        "iPad 8" ;;
                iPad4,[1-3]):        "iPad Air" ;;
                iPad5,[3-4]):        "iPad Air 2" ;;
                iPad11,[3-4]):       "iPad Air 3" ;;
                iPad13,[1-2]):       "iPad Air 4";;
                iPad6,[7-8]):        "iPad Pro (12.9 Inch)" ;;
                iPad6,[3-4]):        "iPad Pro (9.7 Inch)" ;;
                iPad7,[1-2]):        "iPad Pro 2 (12.9 Inch)" ;;
                iPad7,[3-4]):        "iPad Pro (10.5 Inch)" ;;
                iPad8,[1-4]):        "iPad Pro (11 Inch)" ;;
                iPad8,[5-8]):        "iPad Pro 3 (12.9 Inch)" ;;
                iPad8,9 | iPad8,10): "iPad Pro 4 (11 Inch)" ;;
                iPad8,1[1-2]):       "iPad Pro 4 (12.9 Inch)" ;;
                iPad2,[5-7]):        "iPad mini" ;;
                iPad4,[4-6]):        "iPad mini 2" ;;
                iPad4,[7-9]):        "iPad mini 3" ;;
                iPad5,[1-2]):        "iPad mini 4" ;;
                iPad11,[1-2]):       "iPad mini 5" ;;

                iPhone1,1):     "iPhone" ;;
                iPhone1,2):     "iPhone 3G" ;;
                iPhone2,1):     "iPhone 3GS" ;;
                iPhone3,[1-3]): "iPhone 4" ;;
                iPhone4,1):     "iPhone 4S" ;;
                iPhone5,[1-2]): "iPhone 5" ;;
                iPhone5,[3-4]): "iPhone 5c" ;;
                iPhone6,[1-2]): "iPhone 5s" ;;
                iPhone7,2):     "iPhone 6" ;;
                iPhone7,1):     "iPhone 6 Plus" ;;
                iPhone8,1):     "iPhone 6s" ;;
                iPhone8,2):     "iPhone 6s Plus" ;;
                iPhone8,4):     "iPhone SE" ;;
                iPhone9,[13]):  "iPhone 7" ;;
                iPhone9,[24]):  "iPhone 7 Plus" ;;
                iPhone10,[14]): "iPhone 8" ;;
                iPhone10,[25]): "iPhone 8 Plus" ;;
                iPhone10,[36]): "iPhone X" ;;
                iPhone11,2):    "iPhone XS" ;;
                iPhone11,[46]): "iPhone XS Max" ;;
                iPhone11,8):    "iPhone XR" ;;
                iPhone12,1):    "iPhone 11" ;;
                iPhone12,3):    "iPhone 11 Pro" ;;
                iPhone12,5):    "iPhone 11 Pro Max" ;;
                iPhone12,8):    "iPhone SE 2020" ;;
                iPhone13,1):    "iPhone 12 Mini" ;;
                iPhone13,2):    "iPhone 12" ;;
                iPhone13,3):    "iPhone 12 Pro" ;;
                iPhone13,4):    "iPhone 12 Pro Max" ;;

                iPod1,1): "iPod touch" ;;
                ipod2,1): "iPod touch 2G" ;;
                ipod3,1): "iPod touch 3G" ;;
                ipod4,1): "iPod touch 4G" ;;
                ipod5,1): "iPod touch 5G" ;;
                ipod7,1): "iPod touch 6G" ;;
                iPod9,1): "iPod touch 7G" ;;
            esac

            model=$_
        ;;

        BSD|MINIX)
            model=$(sysctl -n hw.vendor hw.product)
        ;;

        Windows)
            model=$(wmic computersystem get manufacturer,model)
            model=${model/Manufacturer}
            model=${model/Model}
        ;;

        Solaris)
            model=$(prtconf -b | awk -F':' '/banner-name/ {printf $2}')
        ;;

        AIX)
            model=$(/usr/bin/uname -M)
        ;;

        FreeMiNT)
            model=$(sysctl -n hw.model)
            model=${model/ (_MCH *)}
        ;;
    esac

    # Remove dummy OEM info.
    model=${model//To be filled by O.E.M.}
    model=${model//To Be Filled*}
    model=${model//OEM*}
    model=${model//Not Applicable}
    model=${model//System Product Name}
    model=${model//System Version}
    model=${model//Undefined}
    model=${model//Default string}
    model=${model//Not Specified}
    model=${model//Type1ProductConfigId}
    model=${model//INVALID}
    model=${model//All Series}
    model=${model//�}

    case $model in
        "Standard PC"*) model="KVM/QEMU (${model})" ;;
        OpenBSD*)       model="vmm ($model)" ;;
    esac
}

get_title() {
    user=${USER:-$(id -un || printf %s "${HOME/*\/}")}

    case $title_fqdn in
        on) hostname=$(hostname -f) ;;
        *)  hostname=${HOSTNAME:-$(hostname)} ;;
    esac

    title=${title_color}${bold}${user}${at_color}@${title_color}${bold}${hostname}
    length=$((${#user} + ${#hostname} + 1))
}

get_kernel() {
    # Since these OS are integrated systems, it's better to skip this function altogether
    [[ $os =~ (AIX|IRIX) ]] && return

    # Haiku uses 'uname -v' and not - 'uname -r'.
    [[ $os == Haiku ]] && {
        kernel=$(uname -v)
        return
    }

    # In Windows 'uname' may return the info of GNUenv thus use wmic for OS kernel.
    [[ $os == Windows ]] && {
        kernel=$(wmic os get Version)
        kernel=${kernel/Version}
        return
    }

    case $kernel_shorthand in
        on)  kernel=$kernel_version ;;
        off) kernel="$kernel_name $kernel_version" ;;
    esac

    # Hide kernel info if it's identical to the distro info.
    [[ $os =~ (BSD|MINIX) && $distro == *"$kernel_name"* ]] &&
        case $distro_shorthand in
            on|tiny) kernel=$kernel_version ;;
            *)       unset kernel ;;
        esac
}

get_uptime() {
    # Get uptime in seconds.
    case $os in
        Linux|Windows|MINIX)
            if [[ -r /proc/uptime ]]; then
                s=$(< /proc/uptime)
                s=${s/.*}
            else
                boot=$(date -d"$(uptime -s)" +%s)
                now=$(date +%s)
                s=$((now - boot))
            fi
        ;;

        "Mac OS X"|"macOS"|"iPhone OS"|BSD|FreeMiNT)
            boot=$(sysctl -n kern.boottime)
            boot=${boot/\{ sec = }
            boot=${boot/,*}

            # Get current date in seconds.
            now=$(date +%s)
            s=$((now - boot))
        ;;

        Solaris)
            s=$(kstat -p unix:0:system_misc:snaptime | awk '{print $2}')
            s=${s/.*}
        ;;

        AIX|IRIX)
            t=$(LC_ALL=POSIX ps -o etime= -p 1)

            [[ $t == *-*   ]] && { d=${t%%-*}; t=${t#*-}; }
            [[ $t == *:*:* ]] && { h=${t%%:*}; t=${t#*:}; }

            h=${h#0}
            t=${t#0}

            s=$((${d:-0}*86400 + ${h:-0}*3600 + ${t%%:*}*60 + ${t#*:}))
        ;;

        Haiku)
            s=$(($(system_time) / 1000000))
        ;;
    esac

    d="$((s / 60 / 60 / 24)) days"
    h="$((s / 60 / 60 % 24)) hours"
    m="$((s / 60 % 60)) minutes"

    # Remove plural if < 2.
    ((${d/ *} == 1)) && d=${d/s}
    ((${h/ *} == 1)) && h=${h/s}
    ((${m/ *} == 1)) && m=${m/s}

    # Hide empty fields.
    ((${d/ *} == 0)) && unset d
    ((${h/ *} == 0)) && unset h
    ((${m/ *} == 0)) && unset m

    uptime=${d:+$d, }${h:+$h, }$m
    uptime=${uptime%', '}
    uptime=${uptime:-$s seconds}

    # Make the output of uptime smaller.
    case $uptime_shorthand in
        on)
            uptime=${uptime/ minutes/ mins}
            uptime=${uptime/ minute/ min}
            uptime=${uptime/ seconds/ secs}
        ;;

        tiny)
            uptime=${uptime/ days/d}
            uptime=${uptime/ day/d}
            uptime=${uptime/ hours/h}
            uptime=${uptime/ hour/h}
            uptime=${uptime/ minutes/m}
            uptime=${uptime/ minute/m}
            uptime=${uptime/ seconds/s}
            uptime=${uptime//,}
        ;;
    esac
}

get_packages() {
    # to adjust the number of pkgs per pkg manager
    pkgs_h=0

    # has: Check if package manager installed.
    # dir: Count files or dirs in a glob.
    # pac: If packages > 0, log package manager name.
    # tot: Count lines in command output.
    has() { type -p "$1" >/dev/null && manager=$1; }
    # globbing is intentional here
    # shellcheck disable=SC2206
    dir() { pkgs=($@); ((packages+=${#pkgs[@]})); pac "$((${#pkgs[@]}-pkgs_h))"; }
    pac() { (($1 > 0)) && { managers+=("$1 (${manager})"); manager_string+="${manager}, "; }; }
    tot() {
        IFS=$'\n' read -d "" -ra pkgs <<< "$("$@")";
        ((packages+=${#pkgs[@]}));
        pac "$((${#pkgs[@]}-pkgs_h))";
    }

    # Redefine tot() and dir() for Bedrock Linux.
    [[ -f /bedrock/etc/bedrock-release && $PATH == */bedrock/cross/* ]] && {
        br_strata=$(brl list)
        tot() {
            IFS=$'\n' read -d "" -ra pkgs <<< "$(for s in ${br_strata}; do strat -r "$s" "$@"; done)"
            ((packages+="${#pkgs[@]}"))
            pac "$((${#pkgs[@]}-pkgs_h))";
        }
        dir() {
            local pkgs=()
            # globbing is intentional here
            # shellcheck disable=SC2206
            for s in ${br_strata}; do pkgs+=(/bedrock/strata/$s/$@); done
            ((packages+=${#pkgs[@]}))
            pac "$((${#pkgs[@]}-pkgs_h))"
        }
    }

    case $os in
        Linux|BSD|"iPhone OS"|Solaris)
            # Package Manager Programs.
            has kiss       && tot kiss l
            has cpt-list   && tot cpt-list
            has pacman-key && tot pacman -Qq --color never
            has dpkg       && tot dpkg-query -f '.\n' -W
            has xbps-query && tot xbps-query -l
            has apk        && tot apk info
            has opkg       && tot opkg list-installed
            has pacman-g2  && tot pacman-g2 -Q
            has lvu        && tot lvu installed
            has tce-status && tot tce-status -i
            has pkg_info   && tot pkg_info
            has tazpkg     && pkgs_h=6 tot tazpkg list && ((packages-=6))
            has sorcery    && tot gaze installed
            has alps       && tot alps showinstalled
            has butch      && tot butch list
            has swupd      && tot swupd bundle-list --quiet
            has pisi       && tot pisi li

            # Using the dnf package cache is much faster than rpm.
            if has dnf && type -p sqlite3 >/dev/null && [[ -f /var/cache/dnf/packages.db ]]; then
                pac "$(sqlite3 /var/cache/dnf/packages.db "SELECT count(pkg) FROM installed")"
            else
                has rpm && tot rpm -qa
            fi

            # 'mine' conflicts with minesweeper games.
            [[ -f /etc/SDE-VERSION ]] &&
                has mine && tot mine -q

            # Counting files/dirs.
            # Variables need to be unquoted here. Only Bedrock Linux is affected.
            # $br_prefix is fixed and won't change based on user input so this is safe either way.
            # shellcheck disable=SC2086
            {
            shopt -s nullglob
            has brew    && dir "$(brew --cellar)/* $(brew --caskroom)/*"
            has emerge  && dir "/var/db/pkg/*/*"
            has Compile && dir "/Programs/*/"
            has eopkg   && dir "/var/lib/eopkg/package/*"
            has crew    && dir "${CREW_PREFIX:-/usr/local}/etc/crew/meta/*.filelist"
            has pkgtool && dir "/var/log/packages/*"
            has scratch && dir "/var/lib/scratchpkg/index/*/.pkginfo"
            has kagami  && dir "/var/lib/kagami/pkgs/*"
            has cave    && dir "/var/db/paludis/repositories/cross-installed/*/data/*/ \
                               /var/db/paludis/repositories/installed/data/*/"
            shopt -u nullglob
            }

            # Other (Needs complex command)
            has kpm-pkg && ((packages+=$(kpm  --get-selections | grep -cv deinstall$)))

            has guix && {
                manager=guix-system && tot guix package -p "/run/current-system/profile" -I
                manager=guix-user   && tot guix package -I
            }

            has nix-store && {
                nix-user-pkgs() {
                    nix-store -qR ~/.nix-profile
                    nix-store -qR /etc/profiles/per-user/"$USER"
                }
                manager=nix-system  && tot nix-store -qR /run/current-system/sw
                manager=nix-user    && tot nix-user-pkgs
                manager=nix-default && tot nix-store -qR /nix/var/nix/profiles/default
            }

            # pkginfo is also the name of a python package manager which is painfully slow.
            # TODO: Fix this somehow.
            has pkginfo && tot pkginfo -i

            case $os-$kernel_name in
                BSD-FreeBSD|BSD-DragonFly)
                    has pkg && tot pkg info
                ;;

                BSD-*)
                    has pkg && dir /var/db/pkg/*

                    ((packages == 0)) &&
                        has pkg && tot pkg list
                ;;
            esac

            # List these last as they accompany regular package managers.
            has flatpak && tot flatpak list
            has spm     && tot spm list -i
            has puyo    && dir ~/.puyo/installed

            # Snap hangs if the command is run without the daemon running.
            # Only run snap if the daemon is also running.
            has snap && ps -e | grep -qFm 1 snapd >/dev/null && \
            pkgs_h=1 tot snap list && ((packages-=1))

            # This is the only standard location for appimages.
            # See: https://github.com/AppImage/AppImageKit/wiki
            manager=appimage && has appimaged && dir ~/.local/bin/*.appimage
        ;;

        "Mac OS X"|"macOS"|MINIX)
            has port  && pkgs_h=1 tot port installed && ((packages-=1))
            has brew  && dir "$(brew --cellar)/* $(brew --caskroom)/*"
            has pkgin && tot pkgin list
            has dpkg  && tot dpkg-query -f '.\n' -W

            has nix-store && {
                nix-user-pkgs() {
                    nix-store -qR ~/.nix-profile
                    nix-store -qR /etc/profiles/per-user/"$USER"
                }
                manager=nix-system && tot nix-store -qR /run/current-system/sw
                manager=nix-user   && tot nix-user-pkgs
            }
        ;;

        AIX|FreeMiNT)
            has lslpp && ((packages+=$(lslpp -J -l -q | grep -cv '^#')))
            has rpm   && tot rpm -qa
        ;;

        Windows)
            case $kernel_name in
                CYGWIN*) has cygcheck && tot cygcheck -cd ;;
                MSYS*)   has pacman   && tot pacman -Qq --color never ;;
            esac

            # Scoop environment throws errors if `tot scoop list` is used
            has scoop && pkgs_h=1 dir ~/scoop/apps/* && ((packages-=1))

            # Count chocolatey packages.
            [[ -d /cygdrive/c/ProgramData/chocolatey/lib ]] && \
                dir /cygdrive/c/ProgramData/chocolatey/lib/*
        ;;

        Haiku)
            has pkgman && dir /boot/system/package-links/*
            packages=${packages/pkgman/depot}
        ;;

        IRIX)
            manager=swpkg
            pkgs_h=3 tot versions -b && ((packages-=3))
        ;;
    esac

    if ((packages == 0)); then
        unset packages

    elif [[ $package_managers == on ]]; then
        printf -v packages '%s, ' "${managers[@]}"
        packages=${packages%,*}

    elif [[ $package_managers == tiny ]]; then
        packages+=" (${manager_string%,*})"
    fi

    packages=${packages/pacman-key/pacman}
}

get_shell() {
    case $shell_path in
        on)  shell="$SHELL " ;;
        off) shell="${SHELL##*/} " ;;
    esac

    [[ $shell_version != on ]] && return

    case ${shell_name:=${SHELL##*/}} in
        bash)
            [[ $BASH_VERSION ]] ||
                BASH_VERSION=$("$SHELL" -c "printf %s \"\$BASH_VERSION\"")

            shell+=${BASH_VERSION/-*}
        ;;

        sh|ash|dash|es) ;;

        *ksh)
            shell+=$("$SHELL" -c "printf %s \"\$KSH_VERSION\"")
            shell=${shell/ * KSH}
            shell=${shell/version}
        ;;

        osh)
            if [[ $OIL_VERSION ]]; then
                shell+=$OIL_VERSION
            else
                shell+=$("$SHELL" -c "printf %s \"\$OIL_VERSION\"")
            fi
        ;;

        tcsh)
            shell+=$("$SHELL" -c "printf %s \$tcsh")
        ;;

        yash)
            shell+=$("$SHELL" --version 2>&1)
            shell=${shell/ $shell_name}
            shell=${shell/ Yet another shell}
            shell=${shell/Copyright*}
        ;;

        *)
            shell+=$("$SHELL" --version 2>&1)
            shell=${shell/ $shell_name}
        ;;
    esac

    # Remove unwanted info.
    shell=${shell/, version}
    shell=${shell/xonsh\//xonsh }
    shell=${shell/options*}
    shell=${shell/\(*\)}
}

get_de() {
    # If function was run, stop here.
    ((de_run == 1)) && return

    case $os in
        "Mac OS X"|"macOS") de=Aqua ;;

        Windows)
            case $distro in
                *"Windows 10"*)
                    de=Fluent
                ;;

                *"Windows 8"*)
                    de=Metro
                ;;

                *)
                    de=Aero
                ;;
            esac
        ;;

        FreeMiNT)
            freemint_wm=(/proc/*)

            case ${freemint_wm[*]} in
                *thing*)  de=Thing ;;
                *jinnee*) de=Jinnee ;;
                *tera*)   de=Teradesk ;;
                *neod*)   de=NeoDesk ;;
                *zdesk*)  de=zDesk ;;
                *mdesk*)  de=mDesk ;;
            esac
        ;;

        *)
            ((wm_run != 1)) && get_wm

            # Temporary support for Regolith Linux
            if [[ $DESKTOP_SESSION == *regolith ]]; then
                de=Regolith

            elif [[ $XDG_CURRENT_DESKTOP ]]; then
                de=${XDG_CURRENT_DESKTOP/X\-}
                de=${de/Budgie:GNOME/Budgie}
                de=${de/:Unity7:ubuntu}

            elif [[ $DESKTOP_SESSION ]]; then
                de=${DESKTOP_SESSION##*/}

            elif [[ $GNOME_DESKTOP_SESSION_ID ]]; then
                de=GNOME

            elif [[ $MATE_DESKTOP_SESSION_ID ]]; then
                de=MATE

            elif [[ $TDE_FULL_SESSION ]]; then
                de=Trinity
            fi

            # When a window manager is started from a display manager
            # the desktop variables are sometimes also set to the
            # window manager name. This checks to see if WM == DE
            # and discards the DE value.
            [[ $de == "$wm" ]] && { unset -v de; return; }
        ;;
    esac

    # Fallback to using xprop.
    [[ $DISPLAY && -z $de ]] && type -p xprop &>/dev/null && \
        de=$(xprop -root | awk '/KDE_SESSION_VERSION|^_MUFFIN|xfce4|xfce5/')

    # Format strings.
    case $de in
        KDE_SESSION_VERSION*) de=KDE${de/* = } ;;
        *xfce4*)  de=Xfce4 ;;
        *xfce5*)  de=Xfce5 ;;
        *xfce*)   de=Xfce ;;
        *mate*)   de=MATE ;;
        *GNOME*)  de=GNOME ;;
        *MUFFIN*) de=Cinnamon ;;
    esac

    ((${KDE_SESSION_VERSION:-0} >= 4)) && de=${de/KDE/Plasma}

    if [[ $de_version == on && $de ]]; then
        case $de in
            Plasma*)   de_ver=$(plasmashell --version) ;;
            MATE*)     de_ver=$(mate-session --version) ;;
            Xfce*)     de_ver=$(xfce4-session --version) ;;
            GNOME*)    de_ver=$(gnome-shell --version) ;;
            Cinnamon*) de_ver=$(cinnamon --version) ;;
            Deepin*)   de_ver=$(awk -F'=' '/MajorVersion/ {print $2}' /etc/os-version) ;;
            Budgie*)   de_ver=$(budgie-desktop --version) ;;
            LXQt*)     de_ver=$(lxqt-session --version) ;;
            Lumina*)   de_ver=$(lumina-desktop --version 2>&1) ;;
            Trinity*)  de_ver=$(tde-config --version) ;;
            Unity*)    de_ver=$(unity --version) ;;
        esac

        de_ver=${de_ver/*TDE:}
        de_ver=${de_ver/tde-config*}
        de_ver=${de_ver/liblxqt*}
        de_ver=${de_ver/Copyright*}
        de_ver=${de_ver/)*}
        de_ver=${de_ver/* }
        de_ver=${de_ver//\"}

        de+=" $de_ver"
    fi

    # TODO:
    #  - New config option + flag: --de_display_server on/off ?
    #  - Add display of X11, Arcan and anything else relevant.
    [[ $de && $WAYLAND_DISPLAY ]] &&
        de+=" (Wayland)"

    de_run=1
}

get_wm() {
    # If function was run, stop here.
    ((wm_run == 1)) && return

    case $kernel_name in
        *OpenBSD*) ps_flags=(x -c) ;;
        *)         ps_flags=(-e) ;;
    esac

    if [[ -O "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY:-wayland-0}" ]]; then
        if tmp_pid="$(lsof -t "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY:-wayland-0}" 2>&1)" ||
           tmp_pid="$(fuser   "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY:-wayland-0}" 2>&1)"; then
            wm="$(ps -p "${tmp_pid}" -ho comm=)"
        else
            # lsof may not exist, or may need root on some systems. Similarly fuser.
            # On those systems we search for a list of known window managers, this can mistakenly
            # match processes for another user or session and will miss unlisted window managers.
            wm=$(ps "${ps_flags[@]}" | grep -m 1 -o -F \
                               -e arcan \
                               -e asc \
                               -e clayland \
                               -e dwc \
                               -e fireplace \
                               -e gnome-shell \
                               -e greenfield \
                               -e grefsen \
                               -e hikari \
                               -e kwin \
                               -e lipstick \
                               -e maynard \
                               -e mazecompositor \
                               -e motorcar \
                               -e orbital \
                               -e orbment \
                               -e perceptia \
                               -e river \
                               -e rustland \
                               -e sway \
                               -e ulubis \
                               -e velox \
                               -e wavy \
                               -e way-cooler \
                               -e wayfire \
                               -e wayhouse \
                               -e westeros \
                               -e westford \
                               -e weston)
        fi

    elif [[ $DISPLAY && $os != "Mac OS X" && $os != "macOS" && $os != FreeMiNT ]]; then
        # non-EWMH WMs.
        wm=$(ps "${ps_flags[@]}" | grep -m 1 -o \
                           -e "[s]owm" \
                           -e "[c]atwm" \
                           -e "[f]vwm" \
                           -e "[d]wm" \
                           -e "[2]bwm" \
                           -e "[m]onsterwm" \
                           -e "[t]inywm" \
                           -e "[x]11fs" \
                           -e "[x]monad")

        [[ -z $wm ]] && type -p xprop &>/dev/null && {
            id=$(xprop -root -notype _NET_SUPPORTING_WM_CHECK)
            id=${id##* }
            wm=$(xprop -id "$id" -notype -len 100 -f _NET_WM_NAME 8t)
            wm=${wm/*WM_NAME = }
            wm=${wm/\"}
            wm=${wm/\"*}
        }

    else
        case $os in
            "Mac OS X"|"macOS")
                ps_line=$(ps -e | grep -o \
                    -e "[S]pectacle" \
                    -e "[A]methyst" \
                    -e "[k]wm" \
                    -e "[c]hun[k]wm" \
                    -e "[y]abai" \
                    -e "[R]ectangle")

                case $ps_line in
                    *chunkwm*)   wm=chunkwm ;;
                    *kwm*)       wm=Kwm ;;
                    *yabai*)     wm=yabai ;;
                    *Amethyst*)  wm=Amethyst ;;
                    *Spectacle*) wm=Spectacle ;;
                    *Rectangle*) wm=Rectangle ;;
                    *)           wm="Quartz Compositor" ;;
                esac
            ;;

            Windows)
                wm=$(
                    tasklist |

                    grep -Fom 1 \
                         -e bugn \
                         -e Windawesome \
                         -e blackbox \
                         -e emerge \
                         -e litestep
                )

                [[ $wm == blackbox ]] &&
                    wm="bbLean (Blackbox)"

                wm=${wm:+$wm, }DWM.exe
            ;;

            FreeMiNT)
                freemint_wm=(/proc/*)

                case ${freemint_wm[*]} in
                    *xaaes* | *xaloader*) wm=XaAES ;;
                    *myaes*)              wm=MyAES ;;
                    *naes*)               wm=N.AES ;;
                    geneva)               wm=Geneva ;;
                    *)                    wm="Atari AES" ;;
                esac
            ;;
        esac
    fi

    # Rename window managers to their proper values.
    [[ $wm == *WINDOWMAKER* ]] && wm=wmaker
    [[ $wm == *GNOME*Shell* ]] && wm=Mutter

    wm_run=1
}

get_wm_theme() {
    ((wm_run != 1)) && get_wm
    ((de_run != 1)) && get_de

    case $wm  in
        E16)
            wm_theme=$(awk -F "= " '/theme.name/ {print $2}' "${HOME}/.e16/e_config--0.0.cfg")
        ;;

        Sawfish)
            wm_theme=$(awk -F '\\(quote|\\)' '/default-frame-style/ {print $(NF-4)}' \
                       "$HOME/.sawfish/custom")
        ;;

        Cinnamon|Muffin|"Mutter (Muffin)")
            detheme=$(gsettings get org.cinnamon.theme name)
            wm_theme=$(gsettings get org.cinnamon.desktop.wm.preferences theme)
            wm_theme="$detheme ($wm_theme)"
        ;;

        Compiz|Mutter|Gala)
            if type -p gsettings >/dev/null; then
                wm_theme=$(gsettings get org.gnome.shell.extensions.user-theme name)

                [[ ${wm_theme//\'} ]] || \
                    wm_theme=$(gsettings get org.gnome.desktop.wm.preferences theme)

            elif type -p gconftool-2 >/dev/null; then
                wm_theme=$(gconftool-2 -g /apps/metacity/general/theme)
            fi
        ;;

        Metacity*)
            if [[ $de == Deepin ]]; then
                wm_theme=$(gsettings get com.deepin.wrap.gnome.desktop.wm.preferences theme)

            elif [[ $de == MATE ]]; then
                wm_theme=$(gsettings get org.mate.Marco.general theme)

            else
                wm_theme=$(gconftool-2 -g /apps/metacity/general/theme)
            fi
        ;;

        E17|Enlightenment)
            if type -p eet >/dev/null; then
                wm_theme=$(eet -d "$HOME/.e/e/config/standard/e.cfg" config |\
                            awk '/value \"file\" string.*.edj/ {print $4}')
                wm_theme=${wm_theme##*/}
                wm_theme=${wm_theme%.*}
            fi
        ;;

        Fluxbox)
            [[ -f $HOME/.fluxbox/init ]] &&
                wm_theme=$(awk -F "/" '/styleFile/ {print $NF}' "$HOME/.fluxbox/init")
        ;;

        IceWM*)
            [[ -f $HOME/.icewm/theme ]] &&
                wm_theme=$(awk -F "[\",/]" '!/#/ {print $2}' "$HOME/.icewm/theme")
        ;;

        Openbox)
            case $de in
                LXDE*) ob_file=lxde-rc ;;
                LXQt*) ob_file=lxqt-rc ;;
                    *) ob_file=rc ;;
            esac

            ob_file=$XDG_CONFIG_HOME/openbox/$ob_file.xml

            [[ -f $ob_file ]] &&
                wm_theme=$(awk '/<theme>/ {while (getline n) {if (match(n, /<name>/))
                            {l=n; exit}}} END {split(l, a, "[<>]"); print a[3]}' "$ob_file")
        ;;

        PekWM)
            [[ -f $HOME/.pekwm/config ]] &&
                wm_theme=$(awk -F "/" '/Theme/{gsub(/\"/,""); print $NF}' "$HOME/.pekwm/config")
        ;;

        Xfwm4)
            [[ -f $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml ]] &&
                wm_theme=$(xfconf-query -c xfwm4 -p /general/theme)
        ;;

        KWin*)
            kde_config_dir
            kwinrc=$kde_config_dir/kwinrc
            kdebugrc=$kde_config_dir/kdebugrc

            if [[ -f $kwinrc ]]; then
                wm_theme=$(awk '/theme=/ {
                                    gsub(/theme=.*qml_|theme=.*svg__/,"",$0);
                                    print $0;
                                    exit
                                 }' "$kwinrc")

                [[ "$wm_theme" ]] ||
                    wm_theme=$(awk '/library=org.kde/ {
                                        gsub(/library=org.kde./,"",$0);
                                        print $0;
                                        exit
                                     }' "$kwinrc")

                [[ $wm_theme ]] ||
                    wm_theme=$(awk '/PluginLib=kwin3_/ {
                                        gsub(/PluginLib=kwin3_/,"",$0);
                                        print $0;
                                        exit
                                     }' "$kwinrc")

            elif [[ -f $kdebugrc ]]; then
                wm_theme=$(awk '/(decoration)/ {gsub(/\[/,"",$1); print $1; exit}' "$kdebugrc")
            fi

            wm_theme=${wm_theme/theme=}
        ;;

        "Quartz Compositor")
            global_preferences=$HOME/Library/Preferences/.GlobalPreferences.plist
            wm_theme=$(PlistBuddy -c "Print AppleInterfaceStyle" "$global_preferences")
            wm_theme_color=$(PlistBuddy -c "Print AppleAccentColor" "$global_preferences")

            [[ "$wm_theme" ]] ||
                wm_theme=Light

            case $wm_theme_color in
                -1) wm_theme_color=Graphite ;;
                0)  wm_theme_color=Red ;;
                1)  wm_theme_color=Orange ;;
                2)  wm_theme_color=Yellow ;;
                3)  wm_theme_color=Green ;;
                5)  wm_theme_color=Purple ;;
                6)  wm_theme_color=Pink ;;
                *)  wm_theme_color=Blue ;;
            esac

            wm_theme="$wm_theme_color ($wm_theme)"
        ;;

        *Explorer)
            path=/proc/registry/HKEY_CURRENT_USER/Software/Microsoft
            path+=/Windows/CurrentVersion/Themes/CurrentTheme

            wm_theme=$(head -n1 "$path")
            wm_theme=${wm_theme##*\\}
            wm_theme=${wm_theme%.*}
        ;;

        Blackbox|bbLean*)
            path=$(wmic process get ExecutablePath | grep -F "blackbox")
            path=${path//\\/\/}

            wm_theme=$(grep '^session\.styleFile:' "${path/\.exe/.rc}")
            wm_theme=${wm_theme/session\.styleFile: }
            wm_theme=${wm_theme##*\\}
            wm_theme=${wm_theme%.*}
        ;;
    esac

    wm_theme=$(trim_quotes "$wm_theme")
}

get_cpu() {
    case $os in
        "Linux" | "MINIX" | "Windows")
            # Get CPU name.
            cpu_file="/proc/cpuinfo"

            case $kernel_machine in
                "frv" | "hppa" | "m68k" | "openrisc" | "or"* | "powerpc" | "ppc"* | "sparc"*)
                    cpu="$(awk -F':' '/^cpu\t|^CPU/ {printf $2; exit}' "$cpu_file")"
                ;;

                "s390"*)
                    cpu="$(awk -F'=' '/machine/ {print $4; exit}' "$cpu_file")"
                ;;

                "ia64" | "m32r")
                    cpu="$(awk -F':' '/model/ {print $2; exit}' "$cpu_file")"
                    [[ -z "$cpu" ]] && cpu="$(awk -F':' '/family/ {printf $2; exit}' "$cpu_file")"
                ;;

                *)
                    cpu="$(awk -F '\\s*: | @' \
                            '/model name|Hardware|Processor|^cpu model|chip type|^cpu type/ {
                            cpu=$2; if ($1 == "Hardware") exit } END { print cpu }' "$cpu_file")"
                ;;
            esac

            speed_dir="/sys/devices/system/cpu/cpu0/cpufreq"

            # Select the right temperature file.
            for temp_dir in /sys/class/hwmon/*; do
                [[ "$(< "${temp_dir}/name")" =~ (cpu_thermal|coretemp|fam15h_power|k10temp) ]] && {
                    temp_dirs=("$temp_dir"/temp*_input)
                    temp_dir=${temp_dirs[0]}
                    break
                }
            done

            # Get CPU speed.
            if [[ -d "$speed_dir" ]]; then
                # Fallback to bios_limit if $speed_type fails.
                speed="$(< "${speed_dir}/${speed_type}")" ||\
                speed="$(< "${speed_dir}/bios_limit")" ||\
                speed="$(< "${speed_dir}/scaling_max_freq")" ||\
                speed="$(< "${speed_dir}/cpuinfo_max_freq")"
                speed="$((speed / 1000))"

            else
                case $kernel_machine in
                    "sparc"*)
                        # SPARC systems use a different file to expose clock speed information.
                        speed_file="/sys/devices/system/cpu/cpu0/clock_tick"
                        speed="$(($(< "$speed_file") / 1000000))"
                    ;;

                    *)
                        speed="$(awk -F ': |\\.' '/cpu MHz|^clock/ {printf $2; exit}' "$cpu_file")"
                        speed="${speed/MHz}"
                    ;;
                esac
            fi

            # Get CPU temp.
            [[ -f "$temp_dir" ]] && deg="$(($(< "$temp_dir") * 100 / 10000))"

            # Get CPU cores.
            case $kernel_machine in
                "sparc"*)
                    case $cpu_cores in
                        # SPARC systems doesn't expose detailed topology information in
                        # /proc/cpuinfo so I have to use lscpu here.
                        "logical" | "on")
                            cores="$(lscpu | awk -F ': *' '/^CPU\(s\)/ {print $2}')"
                        ;;
                        "physical")
                            cores="$(lscpu | awk -F ': *' '/^Core\(s\) per socket/ {print $2}')"
                            sockets="$(lscpu | awk -F ': *' '/^Socket\(s\)/ {print $2}')"
                            cores="$((sockets * cores))"
                        ;;
                    esac
                ;;

                *)
                    case $cpu_cores in
                        "logical" | "on")
                            cores="$(grep -c "^processor" "$cpu_file")"
                        ;;
                        "physical")
                            cores="$(awk '/^core id/&&!a[$0]++{++i} END {print i}' "$cpu_file")"
                        ;;
                    esac
                ;;
            esac
        ;;

        "Mac OS X"|"macOS")
            cpu="$(sysctl -n machdep.cpu.brand_string)"

            # Get CPU cores.
            case $cpu_cores in
                "logical" | "on") cores="$(sysctl -n hw.logicalcpu_max)" ;;
                "physical")       cores="$(sysctl -n hw.physicalcpu_max)" ;;
            esac
        ;;

        "iPhone OS")
            case $kernel_machine in
                "iPhone1,"[1-2] | "iPod1,1"): "Samsung S5L8900 (1) @ 412MHz" ;;
                "iPhone2,1"):                 "Samsung S5PC100 (1) @ 600MHz" ;;
                "iPhone3,"[1-3] | "iPod4,1"): "Apple A4 (1) @ 800MHz" ;;
                "iPhone4,1" | "iPod5,1"):     "Apple A5 (2) @ 800MHz" ;;
                "iPhone5,"[1-4]): "Apple A6 (2) @ 1.3GHz" ;;
                "iPhone6,"[1-2]): "Apple A7 (2) @ 1.3GHz" ;;
                "iPhone7,"[1-2]): "Apple A8 (2) @ 1.4GHz" ;;
                "iPhone8,"[1-4] | "iPad6,1"[12]): "Apple A9 (2) @ 1.85GHz" ;;
                "iPhone9,"[1-4] | "iPad7,"[5-6] | "iPad7,1"[1-2]):
                    "Apple A10 Fusion (4) @ 2.34GHz"
                ;;
                "iPhone10,"[1-6]): "Apple A11 Bionic (6) @ 2.39GHz" ;;
                "iPhone11,"[2468] | "iPad11,"[1-4] | "iPad11,"[6-7]): "Apple A12 Bionic (6) @ 2.49GHz" ;;
                "iPhone12,"[1358]): "Apple A13 Bionic (6) @ 2.65GHz" ;;
                "iPhone13,"[1-4] | "iPad13,"[1-2]): "Apple A14 Bionic (6) @ 3.00Ghz" ;;

                "iPod2,1"): "Samsung S5L8720 (1) @ 533MHz" ;;
                "iPod3,1"): "Samsung S5L8922 (1) @ 600MHz" ;;
                "iPod7,1"): "Apple A8 (2) @ 1.1GHz" ;;
                "iPad1,1"): "Apple A4 (1) @ 1GHz" ;;
                "iPad2,"[1-7]): "Apple A5 (2) @ 1GHz" ;;
                "iPad3,"[1-3]): "Apple A5X (2) @ 1GHz" ;;
                "iPad3,"[4-6]): "Apple A6X (2) @ 1.4GHz" ;;
                "iPad4,"[1-3]): "Apple A7 (2) @ 1.4GHz" ;;
                "iPad4,"[4-9]): "Apple A7 (2) @ 1.4GHz" ;;
                "iPad5,"[1-2]): "Apple A8 (2) @ 1.5GHz" ;;
                "iPad5,"[3-4]): "Apple A8X (3) @ 1.5GHz" ;;
                "iPad6,"[3-4]): "Apple A9X (2) @ 2.16GHz" ;;
                "iPad6,"[7-8]): "Apple A9X (2) @ 2.26GHz" ;;
                "iPad7,"[1-4]): "Apple A10X Fusion (6) @ 2.39GHz" ;;
                "iPad8,"[1-8]): "Apple A12X Bionic (8) @ 2.49GHz" ;;
                "iPad8,9" | "iPad8,1"[0-2]): "Apple A12Z Bionic (8) @ 2.49GHz" ;;
            esac
            cpu="$_"
        ;;

        "BSD")
            # Get CPU name.
            cpu="$(sysctl -n hw.model)"
            cpu="${cpu/[0-9]\.*}"
            cpu="${cpu/ @*}"

            # Get CPU speed.
            speed="$(sysctl -n hw.cpuspeed)"
            [[ -z "$speed" ]] && speed="$(sysctl -n  hw.clockrate)"

            # Get CPU cores.
            case $kernel_name in
                "OpenBSD"*)
                    [[ "$(sysctl -n hw.smt)" == "1" ]] && smt="on" || smt="off"
                    ncpufound="$(sysctl -n hw.ncpufound)"
                    ncpuonline="$(sysctl -n hw.ncpuonline)"
                    cores="${ncpuonline}/${ncpufound},\\xc2\\xa0SMT\\xc2\\xa0${smt}"
                ;;
                *)
                    cores="$(sysctl -n hw.ncpu)"
                ;;
            esac

            # Get CPU temp.
            case $kernel_name in
                "FreeBSD"* | "DragonFly"* | "NetBSD"*)
                    deg="$(sysctl -n dev.cpu.0.temperature)"
                    deg="${deg/C}"
                ;;
                "OpenBSD"* | "Bitrig"*)
                    deg="$(sysctl hw.sensors | \
                        awk -F'=|degC' '/(ksmn|adt|lm|cpu)0.temp0/ {printf("%2.1f", $2); exit}')"
                ;;
            esac
        ;;

        "Solaris")
            # Get CPU name.
            cpu="$(psrinfo -pv)"
            cpu="${cpu//*$'\n'}"
            cpu="${cpu/[0-9]\.*}"
            cpu="${cpu/ @*}"
            cpu="${cpu/\(portid*}"

            # Get CPU speed.
            speed="$(psrinfo -v | awk '/operates at/ {print $6; exit}')"

            # Get CPU cores.
            case $cpu_cores in
                "logical" | "on") cores="$(kstat -m cpu_info | grep -c -F "chip_id")" ;;
                "physical") cores="$(psrinfo -p)" ;;
            esac
        ;;

        "Haiku")
            # Get CPU name.
            cpu="$(sysinfo -cpu | awk -F '\\"' '/CPU #0/ {print $2}')"
            cpu="${cpu/@*}"

            # Get CPU speed.
            speed="$(sysinfo -cpu | awk '/running at/ {print $NF; exit}')"
            speed="${speed/MHz}"

            # Get CPU cores.
            cores="$(sysinfo -cpu | grep -c -F 'CPU #')"
        ;;

        "AIX")
            # Get CPU name.
            cpu="$(lsattr -El proc0 -a type | awk '{printf $2}')"

            # Get CPU speed.
            speed="$(prtconf -s | awk -F':' '{printf $2}')"
            speed="${speed/MHz}"

            # Get CPU cores.
            case $cpu_cores in
                "logical" | "on")
                    cores="$(lparstat -i | awk -F':' '/Online Virtual CPUs/ {printf $2}')"
                ;;

                "physical")
                    cores="$(lparstat -i | awk -F':' '/Active Physical CPUs/ {printf $2}')"
                ;;
            esac
        ;;

        "IRIX")
            # Get CPU name.
            cpu="$(hinv -c processor | awk -F':' '/CPU:/ {printf $2}')"

            # Get CPU speed.
            speed="$(hinv -c processor | awk '/MHZ/ {printf $2}')"

            # Get CPU cores.
            cores="$(sysconf NPROC_ONLN)"
        ;;

        "FreeMiNT")
            cpu="$(awk -F':' '/CPU:/ {printf $2}' /kern/cpuinfo)"
            speed="$(awk -F '[:.M]' '/Clocking:/ {printf $2}' /kern/cpuinfo)"
        ;;
    esac

    # Remove un-needed patterns from cpu output.
    cpu="${cpu//(TM)}"
    cpu="${cpu//(tm)}"
    cpu="${cpu//(R)}"
    cpu="${cpu//(r)}"
    cpu="${cpu//CPU}"
    cpu="${cpu//Processor}"
    cpu="${cpu//Dual-Core}"
    cpu="${cpu//Quad-Core}"
    cpu="${cpu//Six-Core}"
    cpu="${cpu//Eight-Core}"
    cpu="${cpu//[1-9][0-9]-Core}"
    cpu="${cpu//[0-9]-Core}"
    cpu="${cpu//, * Compute Cores}"
    cpu="${cpu//Core / }"
    cpu="${cpu//(\"AuthenticAMD\"*)}"
    cpu="${cpu//with Radeon * Graphics}"
    cpu="${cpu//, altivec supported}"
    cpu="${cpu//FPU*}"
    cpu="${cpu//Chip Revision*}"
    cpu="${cpu//Technologies, Inc}"
    cpu="${cpu//Core2/Core 2}"

    # Trim spaces from core and speed output
    cores="${cores//[[:space:]]}"
    speed="${speed//[[:space:]]}"

    # Remove CPU brand from the output.
    if [[ "$cpu_brand" == "off" ]]; then
        cpu="${cpu/AMD }"
        cpu="${cpu/Intel }"
        cpu="${cpu/Core? Duo }"
        cpu="${cpu/Qualcomm }"
    fi

    # Add CPU cores to the output.
    [[ "$cpu_cores" != "off" && "$cores" ]] && \
        case $os in
            "Mac OS X"|"macOS") cpu="${cpu/@/(${cores}) @}" ;;
            *)                  cpu="$cpu ($cores)" ;;
        esac

    # Add CPU speed to the output.
    if [[ "$cpu_speed" != "off" && "$speed" ]]; then
        if (( speed < 1000 )); then
            cpu="$cpu @ ${speed}MHz"
        else
            [[ "$speed_shorthand" == "on" ]] && speed="$((speed / 100))"
            speed="${speed:0:1}.${speed:1}"
            cpu="$cpu @ ${speed}GHz"
        fi
    fi

    # Add CPU temp to the output.
    if [[ "$cpu_temp" != "off" && "$deg" ]]; then
        deg="${deg//.}"

        # Convert to Fahrenheit if enabled
        [[ "$cpu_temp" == "F" ]] && deg="$((deg * 90 / 50 + 320))"

        # Format the output
        deg="[${deg/${deg: -1}}.${deg: -1}°${cpu_temp:-C}]"
        cpu="$cpu $deg"
    fi
}

get_gpu() {
    case $os in
        "Linux")
            # Read GPUs into array.
            gpu_cmd="$(lspci -mm |
                       awk -F '\"|\" \"|\\(' \
                              '/"Display|"3D|"VGA/ {
                                  a[$0] = $1 " " $3 " " ($7 ~ /^$|^Device [[:xdigit:]]+$/ ? $4 : $7)
                              }
                              END { for (i in a) {
                                  if (!seen[a[i]]++) {
                                      sub("^[^ ]+ ", "", a[i]);
                                      print a[i]
                                  }
                              }}')"
            IFS=$'\n' read -d "" -ra gpus <<< "$gpu_cmd"

            # Remove duplicate Intel Graphics outputs.
            # This fixes cases where the outputs are both
            # Intel but not entirely identical.
            #
            # Checking the first two array elements should
            # be safe since there won't be 2 intel outputs if
            # there's a dedicated GPU in play.
            [[ "${gpus[0]}" == *Intel* && "${gpus[1]}" == *Intel* ]] && unset -v "gpus[0]"

            for gpu in "${gpus[@]}"; do
                # GPU shorthand tests.
                [[ "$gpu_type" == "dedicated" && "$gpu" == *Intel* ]] || \
                [[ "$gpu_type" == "integrated" && ! "$gpu" == *Intel* ]] && \
                    { unset -v gpu; continue; }

                case $gpu in
                    *"Advanced"*)
                        brand="${gpu/*AMD*ATI*/AMD ATI}"
                        brand="${brand:-${gpu/*AMD*/AMD}}"
                        brand="${brand:-${gpu/*ATI*/ATi}}"

                        gpu="${gpu/\[AMD\/ATI\] }"
                        gpu="${gpu/\[AMD\] }"
                        gpu="${gpu/OEM }"
                        gpu="${gpu/Advanced Micro Devices, Inc.}"
                        gpu="${gpu/*\[}"
                        gpu="${gpu/\]*}"
                        gpu="$brand $gpu"
                    ;;

                    *"NVIDIA"*)
                        gpu="${gpu/*\[}"
                        gpu="${gpu/\]*}"
                        gpu="NVIDIA $gpu"
                    ;;

                    *"Intel"*)
                        gpu="${gpu/*Intel/Intel}"
                        gpu="${gpu/\(R\)}"
                        gpu="${gpu/Corporation}"
                        gpu="${gpu/ \(*}"
                        gpu="${gpu/Integrated Graphics Controller}"
                        gpu="${gpu/*Xeon*/Intel HD Graphics}"

                        [[ -z "$(trim "$gpu")" ]] && gpu="Intel Integrated Graphics"
                    ;;

                    *"MCST"*)
                        gpu="${gpu/*MCST*MGA2*/MCST MGA2}"
                    ;;

                    *"VirtualBox"*)
                        gpu="VirtualBox Graphics Adapter"
                    ;;

                    *) continue ;;
                esac

                if [[ "$gpu_brand" == "off" ]]; then
                    gpu="${gpu/AMD }"
                    gpu="${gpu/NVIDIA }"
                    gpu="${gpu/Intel }"
                fi

                prin "${subtitle:+${subtitle}${gpu_name}}" "$gpu"
            done

            return
        ;;

        "Mac OS X"|"macOS")
            if [[ -f "${cache_dir}/neofetch/gpu" ]]; then
                source "${cache_dir}/neofetch/gpu"

            else
                gpu="$(system_profiler SPDisplaysDataType |\
                       awk -F': ' '/^\ *Chipset Model:/ {printf $2 ", "}')"
                gpu="${gpu//\/ \$}"
                gpu="${gpu%,*}"

                cache "gpu" "$gpu"
            fi
        ;;

        "iPhone OS")
            case $kernel_machine in
                "iPhone1,"[1-2]):                             "PowerVR MBX Lite 3D" ;;
                "iPhone2,1" | "iPhone3,"[1-3] | "iPod3,1" | "iPod4,1" | "iPad1,1"):
                    "PowerVR SGX535"
                ;;
                "iPhone4,1" | "iPad2,"[1-7] | "iPod5,1"):     "PowerVR SGX543MP2" ;;
                "iPhone5,"[1-4]):                             "PowerVR SGX543MP3" ;;
                "iPhone6,"[1-2] | "iPad4,"[1-9]):             "PowerVR G6430" ;;
                "iPhone7,"[1-2] | "iPod7,1" | "iPad5,"[1-2]): "PowerVR GX6450" ;;
                "iPhone8,"[1-4] | "iPad6,1"[12]):             "PowerVR GT7600" ;;
                "iPhone9,"[1-4] | "iPad7,"[5-6]):             "PowerVR GT7600 Plus" ;;
                "iPhone10,"[1-6]):                            "Apple Designed GPU (A11)" ;;
                "iPhone11,"[2468] | "iPad11,"[67]):           "Apple Designed GPU (A12)" ;;
                "iPhone12,"[1358]):                           "Apple Designed GPU (A13)" ;;
                "iPhone13,"[1234] | "iPad13,"[12]):           "Apple Designed GPU (A14)" ;;

                "iPad3,"[1-3]):     "PowerVR SGX534MP4" ;;
                "iPad3,"[4-6]):     "PowerVR SGX554MP4" ;;
                "iPad5,"[3-4]):     "PowerVR GXA6850" ;;
                "iPad6,"[3-8]):     "PowerVR 7XT" ;;

                "iPod1,1" | "iPod2,1")
                    : "PowerVR MBX Lite"
                ;;
            esac
            gpu="$_"
        ;;

        "Windows")
            wmic path Win32_VideoController get caption | while read -r line; do
                line=$(trim "$line")

                case $line in
                    *Caption*|'')
                        continue
                    ;;

                    *)
                        prin "${subtitle:+${subtitle}${gpu_name}}" "$line"
                    ;;
                esac
            done
        ;;

        "Haiku")
            gpu="$(listdev | grep -A2 -F 'device Display controller' |\
                   awk -F':' '/device beef/ {print $2}')"
        ;;

        *)
            case $kernel_name in
                "FreeBSD"* | "DragonFly"*)
                    gpu="$(pciconf -lv | grep -B 4 -F "VGA" | grep -F "device")"
                    gpu="${gpu/*device*= }"
                    gpu="$(trim_quotes "$gpu")"
                ;;

                *)
                    gpu="$(glxinfo -B | grep -F 'OpenGL renderer string')"
                    gpu="${gpu/OpenGL renderer string: }"
                ;;
            esac
        ;;
    esac

    if [[ "$gpu_brand" == "off" ]]; then
        gpu="${gpu/AMD}"
        gpu="${gpu/NVIDIA}"
        gpu="${gpu/Intel}"
    fi
}

get_memory() {
    case $os in
        "Linux" | "Windows")
            # MemUsed = Memtotal + Shmem - MemFree - Buffers - Cached - SReclaimable
            # Source: https://github.com/KittyKatt/screenFetch/issues/386#issuecomment-249312716
            while IFS=":" read -r a b; do
                case $a in
                    "MemTotal") ((mem_used+=${b/kB})); mem_total="${b/kB}" ;;
                    "Shmem") ((mem_used+=${b/kB}))  ;;
                    "MemFree" | "Buffers" | "Cached" | "SReclaimable")
                        mem_used="$((mem_used-=${b/kB}))"
                    ;;

                    # Available since Linux 3.14rc (34e431b0ae398fc54ea69ff85ec700722c9da773).
                    # If detected this will be used over the above calculation for mem_used.
                    "MemAvailable")
                        mem_avail=${b/kB}
                    ;;
                esac
            done < /proc/meminfo

            if [[ $mem_avail ]]; then
                mem_used=$(((mem_total - mem_avail) / 1024))
            else
                mem_used="$((mem_used / 1024))"
            fi

            mem_total="$((mem_total / 1024))"
        ;;

        "Mac OS X" | "macOS" | "iPhone OS")
            hw_pagesize="$(sysctl -n hw.pagesize)"
            mem_total="$(($(sysctl -n hw.memsize) / 1024 / 1024))"
            pages_app="$(($(sysctl -n vm.page_pageable_internal_count) - $(sysctl -n vm.page_purgeable_count)))"
            pages_wired="$(vm_stat | awk '/ wired/ { print $4 }')"
            pages_compressed="$(vm_stat | awk '/ occupied/ { printf $5 }')"
            pages_compressed="${pages_compressed:-0}"
            mem_used="$(((${pages_app} + ${pages_wired//.} + ${pages_compressed//.}) * hw_pagesize / 1024 / 1024))"
        ;;

        "BSD" | "MINIX")
            # Mem total.
            case $kernel_name in
                "NetBSD"*) mem_total="$(($(sysctl -n hw.physmem64) / 1024 / 1024))" ;;
                *) mem_total="$(($(sysctl -n hw.physmem) / 1024 / 1024))" ;;
            esac

            # Mem free.
            case $kernel_name in
                "NetBSD"*)
                    mem_free="$(($(awk -F ':|kB' '/MemFree:/ {printf $2}' /proc/meminfo) / 1024))"
                ;;

                "FreeBSD"* | "DragonFly"*)
                    hw_pagesize="$(sysctl -n hw.pagesize)"
                    mem_inactive="$(($(sysctl -n vm.stats.vm.v_inactive_count) * hw_pagesize))"
                    mem_unused="$(($(sysctl -n vm.stats.vm.v_free_count) * hw_pagesize))"
                    mem_cache="$(($(sysctl -n vm.stats.vm.v_cache_count) * hw_pagesize))"
                    mem_free="$(((mem_inactive + mem_unused + mem_cache) / 1024 / 1024))"
                ;;

                "MINIX")
                    mem_free="$(top -d 1 | awk -F ',' '/^Memory:/ {print $2}')"
                    mem_free="${mem_free/M Free}"
                ;;

                "OpenBSD"*) ;;
                *) mem_free="$(($(vmstat | awk 'END {printf $5}') / 1024))" ;;
            esac

            # Mem used.
            case $kernel_name in
                "OpenBSD"*)
                    mem_used="$(vmstat | awk 'END {printf $3}')"
                    mem_used="${mem_used/M}"
                ;;

                *) mem_used="$((mem_total - mem_free))" ;;
            esac
        ;;

        "Solaris" | "AIX")
            hw_pagesize="$(pagesize)"
            case $os in
                "Solaris")
                    pages_total="$(kstat -p unix:0:system_pages:pagestotal | awk '{print $2}')"
                    pages_free="$(kstat -p unix:0:system_pages:pagesfree | awk '{print $2}')"
                ;;

                "AIX")
                    IFS=$'\n'"| " read -d "" -ra mem_stat <<< "$(svmon -G -O unit=page)"
                    pages_total="${mem_stat[11]}"
                    pages_free="${mem_stat[16]}"
                ;;
            esac
            mem_total="$((pages_total * hw_pagesize / 1024 / 1024))"
            mem_free="$((pages_free * hw_pagesize / 1024 / 1024))"
            mem_used="$((mem_total - mem_free))"
        ;;

        "Haiku")
            mem_total="$(($(sysinfo -mem | awk -F '\\/ |)' '{print $2; exit}') / 1024 / 1024))"
            mem_used="$(sysinfo -mem | awk -F '\\/|)' '{print $2; exit}')"
            mem_used="$((${mem_used/max} / 1024 / 1024))"
        ;;

        "IRIX")
            IFS=$'\n' read -d "" -ra mem_cmd <<< "$(pmem)"
            IFS=" " read -ra mem_stat <<< "${mem_cmd[0]}"

            mem_total="$((mem_stat[3] / 1024))"
            mem_free="$((mem_stat[5] / 1024))"
            mem_used="$((mem_total - mem_free))"
        ;;

        "FreeMiNT")
            mem="$(awk -F ':|kB' '/MemTotal:|MemFree:/ {printf $2, " "}' /kern/meminfo)"
            mem_free="${mem/*  }"
            mem_total="${mem/$mem_free}"
            mem_used="$((mem_total - mem_free))"
            mem_total="$((mem_total / 1024))"
            mem_used="$((mem_used / 1024))"
        ;;

    esac

    [[ "$memory_percent" == "on" ]] && ((mem_perc=mem_used * 100 / mem_total))

    case $memory_unit in
        gib)
            mem_used=$(awk '{printf "%.2f", $1 / $2}' <<< "$mem_used 1024")
            mem_total=$(awk '{printf "%.2f", $1 / $2}' <<< "$mem_total 1024")
            mem_label=GiB
        ;;

        kib)
            mem_used=$((mem_used * 1024))
            mem_total=$((mem_total * 1024))
            mem_label=KiB
        ;;
    esac

    memory="${mem_used}${mem_label:-MiB} / ${mem_total}${mem_label:-MiB} ${mem_perc:+(${mem_perc}%)}"

    # Bars.
    case $memory_display in
        "bar")     memory="$(bar "${mem_used}" "${mem_total}")" ;;
        "infobar") memory="${memory} $(bar "${mem_used}" "${mem_total}")" ;;
        "barinfo") memory="$(bar "${mem_used}" "${mem_total}")${info_color} ${memory}" ;;
    esac
}

get_song() {
    players=(
        "amarok"
        "audacious"
        "banshee"
        "bluemindo"
        "clementine"
        "cmus"
        "deadbeef"
        "deepin-music"
        "dragon"
        "elisa"
        "exaile"
        "gnome-music"
        "gmusicbrowser"
        "gogglesmm"
        "guayadeque"
        "io.elementary.music"
        "iTunes"
        "Music"
        "juk"
        "lollypop"
        "MellowPlayer"
        "mocp"
        "mopidy"
        "mpd"
        "muine"
        "netease-cloud-music"
        "olivia"
        "plasma-browser-integration"
        "playerctl"
        "pogo"
        "pragha"
        "qmmp"
        "quodlibet"
        "rhythmbox"
        "sayonara"
        "smplayer"
        "spotify"
        "Spotify"
        "strawberry"
        "tauonmb"
        "tomahawk"
        "vlc"
        "xmms2d"
        "xnoise"
        "yarock"
    )

    printf -v players "|%s" "${players[@]}"
    player="$(ps aux | awk -v pattern="(${players:1})" \
        '!/ awk / && !/iTunesHelper/ && match($0,pattern){print substr($0,RSTART,RLENGTH); exit}')"

    [[ "$music_player" && "$music_player" != "auto" ]] && player="$music_player"

    get_song_dbus() {
        # Multiple players use an almost identical dbus command to get the information.
        # This function saves us using the same command throughout the function.
        song="$(\
            dbus-send --print-reply --dest=org.mpris.MediaPlayer2."${1}" /org/mpris/MediaPlayer2 \
            org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' \
            string:'Metadata' |\
            awk -F '"' 'BEGIN {RS=" entry"}; /"xesam:artist"/ {a = $4} /"xesam:album"/ {b = $4}
                        /"xesam:title"/ {t = $4} END {print a " \n" b " \n" t}'
        )"
    }

    case ${player/*\/} in
        "mocp"*)          song="$(mocp -Q '%artist \n%album \n%song')" ;;
        "deadbeef"*)      song="$(deadbeef --nowplaying-tf '%artist% \\n%album% \\n%title%')" ;;
        "qmmp"*)          song="$(qmmp --nowplaying '%p \n%a \n%t')" ;;
        "gnome-music"*)   get_song_dbus "GnomeMusic" ;;
        "lollypop"*)      get_song_dbus "Lollypop" ;;
        "clementine"*)    get_song_dbus "clementine" ;;
        "cmus"*)          get_song_dbus "cmus" ;;
        "juk"*)           get_song_dbus "juk" ;;
        "bluemindo"*)     get_song_dbus "Bluemindo" ;;
        "guayadeque"*)    get_song_dbus "guayadeque" ;;
        "yarock"*)        get_song_dbus "yarock" ;;
        "deepin-music"*)  get_song_dbus "DeepinMusic" ;;
        "tomahawk"*)      get_song_dbus "tomahawk" ;;
        "elisa"*)         get_song_dbus "elisa" ;;
        "sayonara"*)      get_song_dbus "sayonara" ;;
        "audacious"*)     get_song_dbus "audacious" ;;
        "vlc"*)           get_song_dbus "vlc" ;;
        "gmusicbrowser"*) get_song_dbus "gmusicbrowser" ;;
        "pragha"*)        get_song_dbus "pragha" ;;
        "amarok"*)        get_song_dbus "amarok" ;;
        "dragon"*)        get_song_dbus "dragonplayer" ;;
        "smplayer"*)      get_song_dbus "smplayer" ;;
        "rhythmbox"*)     get_song_dbus "rhythmbox" ;;
        "strawberry"*)    get_song_dbus "strawberry" ;;
        "gogglesmm"*)     get_song_dbus "gogglesmm" ;;
        "xnoise"*)        get_song_dbus "xnoise" ;;
        "tauonmb"*)       get_song_dbus "tauon" ;;
        "olivia"*)        get_song_dbus "olivia" ;;
        "exaile"*)        get_song_dbus "exaile" ;;
        "netease-cloud-music"*)        get_song_dbus "netease-cloud-music" ;;
        "plasma-browser-integration"*) get_song_dbus "plasma-browser-integration" ;;
        "io.elementary.music"*)        get_song_dbus "Music" ;;
        "MellowPlayer"*)  get_song_dbus "MellowPlayer3" ;;

        "mpd"* | "mopidy"*)
            song="$(mpc -f '%artist% \n%album% \n%title%' current "${mpc_args[@]}")"
        ;;

        "xmms2d"*)
            song="$(xmms2 current -f "\${artist}"$' \n'"\${album}"$' \n'"\${title}")"
        ;;

        "spotify"*)
            case $os in
                "Linux") get_song_dbus "spotify" ;;

                "Mac OS X"|"macOS")
                    song="$(osascript -e 'tell application "Spotify" to artist of current track as¬
                                          string & "\n" & album of current track as¬
                                          string & "\n" & name of current track as string')"
                ;;
            esac
        ;;

        "itunes"*)
            song="$(osascript -e 'tell application "iTunes" to artist of current track as¬
                                  string & "\n" & album of current track as¬
                                  string & "\n" & name of current track as string')"
        ;;

        "music"*)
            song="$(osascript -e 'tell application "Music" to artist of current track as¬
                                  string & "\n" & album of current track as¬
                                  string & "\n" & name of current track as string')"
        ;;

        "banshee"*)
            song="$(banshee --query-artist --query-album --query-title |\
                    awk -F':' '/^artist/ {a=$2} /^album/ {b=$2} /^title/ {t=$2}
                               END {print a " \n" b " \n"t}')"
        ;;

        "muine"*)
            song="$(dbus-send --print-reply --dest=org.gnome.Muine /org/gnome/Muine/Player \
                    org.gnome.Muine.Player.GetCurrentSong |
                    awk -F':' '/^artist/ {a=$2} /^album/ {b=$2} /^title/ {t=$2}
                               END {print a " \n" b " \n" t}')"
        ;;

        "quodlibet"*)
            song="$(dbus-send --print-reply --dest=net.sacredchao.QuodLibet \
                    /net/sacredchao/QuodLibet net.sacredchao.QuodLibet.CurrentSong |\
                    awk -F'"' 'BEGIN {RS=" entry"}; /"artist"/ {a=$4} /"album"/ {b=$4}
                    /"title"/ {t=$4} END {print a " \n" b " \n" t}')"
        ;;

        "pogo"*)
            song="$(dbus-send --print-reply --dest=org.mpris.pogo /Player \
                    org.freedesktop.MediaPlayer.GetMetadata |
                    awk -F'"' 'BEGIN {RS=" entry"}; /"artist"/ {a=$4} /"album"/ {b=$4}
                    /"title"/ {t=$4} END {print a " \n" b " \n" t}')"
        ;;

        "playerctl"*)
            song="$(playerctl metadata --format '{{ artist }} \n{{ album }} \n{{ title }}')"
         ;;

        *) mpc &>/dev/null && song="$(mpc -f '%artist% \n%album% \n%title%' current)" || return ;;
    esac

    IFS=$'\n' read -d "" -r artist album title <<< "${song//'\n'/$'\n'}"

    # Make sure empty tags are truly empty.
    artist="$(trim "$artist")"
    album="$(trim "$album")"
    title="$(trim "$title")"

    # Set default values if no tags were found.
    : "${artist:=Unknown Artist}" "${album:=Unknown Album}" "${title:=Unknown Song}"

    # Display Artist, Album and Title on separate lines.
    if [[ "$song_shorthand" == "on" ]]; then
        prin "Artist" "$artist"
        prin "Album"  "$album"
        prin "Song"   "$title"
    else
        song="${song_format/\%artist\%/$artist}"
        song="${song/\%album\%/$album}"
        song="${song/\%title\%/$title}"
    fi
}

get_resolution() {
    case $os in
        "Mac OS X"|"macOS")
            if type -p screenresolution >/dev/null; then
                resolution="$(screenresolution get 2>&1 | awk '/Display/ {printf $6 "Hz, "}')"
                resolution="${resolution//x??@/ @ }"

            else
                resolution="$(system_profiler SPDisplaysDataType |\
                              awk '/Resolution:/ {printf $2"x"$4" @ "$6"Hz, "}')"
            fi

            if [[ -e "/Library/Preferences/com.apple.windowserver.plist" ]]; then
                scale_factor="$(PlistBuddy -c "Print DisplayAnyUserSets:0:0:Resolution" \
                                /Library/Preferences/com.apple.windowserver.plist)"
            else
                scale_factor=""
            fi

            # If no refresh rate is empty.
            [[ "$resolution" == *"@ Hz"* ]] && \
                resolution="${resolution//@ Hz}"

            [[ "${scale_factor%.*}" == 2 ]] && \
                resolution="${resolution// @/@2x @}"

            if [[ "$refresh_rate" == "off" ]]; then
                resolution="${resolution// @ [0-9][0-9]Hz}"
                resolution="${resolution// @ [0-9][0-9][0-9]Hz}"
            fi

            [[ "$resolution" == *"0Hz"* ]] && \
                resolution="${resolution// @ 0Hz}"
        ;;

        "Windows")
            IFS=$'\n' read -d "" -ra sw \
                <<< "$(wmic path Win32_VideoController get CurrentHorizontalResolution)"

            IFS=$'\n' read -d "" -ra sh \
                <<< "$(wmic path Win32_VideoController get CurrentVerticalResolution)"

            sw=("${sw[@]//CurrentHorizontalResolution}")
            sh=("${sh[@]//CurrentVerticalResolution}")

            for ((mn = 0; mn < ${#sw[@]}; mn++)) {
                [[ ${sw[mn]//[[:space:]]} && ${sh[mn]//[[:space:]]} ]] &&
                    resolution+="${sw[mn]//[[:space:]]}x${sh[mn]//[[:space:]]}, "
            }

            resolution=${resolution%,}
        ;;

        "Haiku")
            resolution="$(screenmode | awk -F ' |, ' 'END{printf $2 "x" $3 " @ " $6 $7}')"

            [[ "$refresh_rate" == "off" ]] && resolution="${resolution/ @*}"
        ;;

        "FreeMiNT")
            # Need to block X11 queries
        ;;

        *)
            if type -p xrandr >/dev/null && [[ $DISPLAY && -z $WAYLAND_DISPLAY ]]; then
                case $refresh_rate in
                    "on")
                        resolution="$(xrandr --nograb --current |\
                                      awk 'match($0,/[0-9]*\.[0-9]*\*/) {
                                           printf $1 " @ " substr($0,RSTART,RLENGTH) "Hz, "}')"
                    ;;

                    "off")
                        resolution="$(xrandr --nograb --current |\
                                      awk -F 'connected |\\+|\\(' \
                                             '/ connected.*[0-9]+x[0-9]+\+/ && $2 {printf $2 ", "}')"

                        resolution="${resolution/primary, }"
                        resolution="${resolution/primary }"
                    ;;
                esac
                resolution="${resolution//\*}"

            elif type -p xwininfo >/dev/null && [[ $DISPLAY && -z $WAYLAND_DISPLAY ]]; then
                read -r w h \
                    <<< "$(xwininfo -root | awk -F':' '/Width|Height/ {printf $2}')"
                resolution="${w}x${h}"

            elif type -p xdpyinfo >/dev/null && [[ $DISPLAY && -z $WAYLAND_DISPLAY ]]; then
                resolution="$(xdpyinfo | awk '/dimensions:/ {printf $2}')"

            elif [[ -d /sys/class/drm ]]; then
                for dev in /sys/class/drm/*/modes; do
                    read -r single_resolution _ < "$dev"

                    [[ $single_resolution ]] && resolution="${single_resolution}, ${resolution}"
                done
            fi
        ;;
    esac

    resolution="${resolution%%,}"
    resolution="${resolution%%, }"
    [[ -z "${resolution/x}" ]] && resolution=
}

get_style() {
    # Fix weird output when the function is run multiple times.
    unset gtk2_theme gtk3_theme theme path

    if [[ "$DISPLAY" && $os != "Mac OS X" && $os != "macOS" ]]; then
        # Get DE if user has disabled the function.
        ((de_run != 1)) && get_de

        # Remove version from '$de'.
        [[ $de_version == on ]] && de=${de/ *}

        # Check for DE Theme.
        case $de in
            "KDE"* | "Plasma"*)
                kde_config_dir

                if [[ -f "${kde_config_dir}/kdeglobals" ]]; then
                    kde_config_file="${kde_config_dir}/kdeglobals"

                    kde_theme="$(grep "^${kde}" "$kde_config_file")"
                    kde_theme="${kde_theme/*=}"
                    if [[ "$kde" == "font" ]]; then
                        kde_font_size="${kde_theme#*,}"
                        kde_font_size="${kde_font_size/,*}"
                        kde_theme="${kde_theme/,*} ${kde_theme/*,} ${kde_font_size}"
                    fi
                    kde_theme="$kde_theme [$de], "
                else
                    err "Theme: KDE config files not found, skipping."
                fi
            ;;

            *"Cinnamon"*)
                if type -p gsettings >/dev/null; then
                    gtk3_theme="$(gsettings get org.cinnamon.desktop.interface "$gsettings")"
                    gtk2_theme="$gtk3_theme"
                fi
            ;;

            "Gnome"* | "Unity"* | "Budgie"*)
                if type -p gsettings >/dev/null; then
                    gtk3_theme="$(gsettings get org.gnome.desktop.interface "$gsettings")"
                    gtk2_theme="$gtk3_theme"

                elif type -p gconftool-2 >/dev/null; then
                    gtk2_theme="$(gconftool-2 -g /desktop/gnome/interface/"$gconf")"
                fi
            ;;

            "Mate"*)
                gtk3_theme="$(gsettings get org.mate.interface "$gsettings")"
                gtk2_theme="$gtk3_theme"
            ;;

            "Xfce"*)
                type -p xfconf-query >/dev/null && \
                    gtk2_theme="$(xfconf-query -c xsettings -p "$xfconf")"
            ;;
        esac

        # Check for general GTK2 Theme.
        if [[ -z "$gtk2_theme" ]]; then
            if [[ -n "$GTK2_RC_FILES" ]]; then
                IFS=: read -ra rc_files <<< "$GTK2_RC_FILES"
                gtk2_theme="$(grep "^[^#]*${name}" "${rc_files[@]}")"
            elif [[ -f "${HOME}/.gtkrc-2.0"  ]]; then
                gtk2_theme="$(grep "^[^#]*${name}" "${HOME}/.gtkrc-2.0")"

            elif [[ -f "/etc/gtk-2.0/gtkrc" ]]; then
                gtk2_theme="$(grep "^[^#]*${name}" /etc/gtk-2.0/gtkrc)"

            elif [[ -f "/usr/share/gtk-2.0/gtkrc" ]]; then
                gtk2_theme="$(grep "^[^#]*${name}" /usr/share/gtk-2.0/gtkrc)"

            fi

            gtk2_theme="${gtk2_theme/*${name}*=}"
        fi

        # Check for general GTK3 Theme.
        if [[ -z "$gtk3_theme" ]]; then
            if [[ -f "${XDG_CONFIG_HOME}/gtk-3.0/settings.ini" ]]; then
                gtk3_theme="$(grep "^[^#]*$name" "${XDG_CONFIG_HOME}/gtk-3.0/settings.ini")"

            elif type -p gsettings >/dev/null; then
                gtk3_theme="$(gsettings get org.gnome.desktop.interface "$gsettings")"

            elif [[ -f "/etc/gtk-3.0/settings.ini" ]]; then
                gtk3_theme="$(grep "^[^#]*$name" /etc/gtk-3.0/settings.ini)"

            elif [[ -f "/usr/share/gtk-3.0/settings.ini" ]]; then
                gtk3_theme="$(grep "^[^#]*$name" /usr/share/gtk-3.0/settings.ini)"
            fi

            gtk3_theme="${gtk3_theme/${name}*=}"
        fi

        # Trim whitespace.
        gtk2_theme="$(trim "$gtk2_theme")"
        gtk3_theme="$(trim "$gtk3_theme")"

        # Remove quotes.
        gtk2_theme="$(trim_quotes "$gtk2_theme")"
        gtk3_theme="$(trim_quotes "$gtk3_theme")"

        # Toggle visibility of GTK themes.
        [[ "$gtk2" == "off" ]] && unset gtk2_theme
        [[ "$gtk3" == "off" ]] && unset gtk3_theme

        # Format the string based on which themes exist.
        if [[ "$gtk2_theme" && "$gtk2_theme" == "$gtk3_theme" ]]; then
            gtk3_theme+=" [GTK2/3]"
            unset gtk2_theme

        elif [[ "$gtk2_theme" && "$gtk3_theme" ]]; then
            gtk2_theme+=" [GTK2], "
            gtk3_theme+=" [GTK3] "

        else
            [[ "$gtk2_theme" ]] && gtk2_theme+=" [GTK2] "
            [[ "$gtk3_theme" ]] && gtk3_theme+=" [GTK3] "
        fi

        # Final string.
        theme="${kde_theme}${gtk2_theme}${gtk3_theme}"
        theme="${theme%, }"

        # Make the output shorter by removing "[GTKX]" from the string.
        if [[ "$gtk_shorthand" == "on" ]]; then
            theme="${theme// '[GTK'[0-9]']'}"
            theme="${theme/ '[GTK2/3]'}"
            theme="${theme/ '[KDE]'}"
            theme="${theme/ '[Plasma]'}"
        fi
    fi
}

get_theme() {
    name="gtk-theme-name"
    gsettings="gtk-theme"
    gconf="gtk_theme"
    xfconf="/Net/ThemeName"
    kde="Name"

    get_style
}

get_icons() {
    name="gtk-icon-theme-name"
    gsettings="icon-theme"
    gconf="icon_theme"
    xfconf="/Net/IconThemeName"
    kde="Theme"

    get_style
    icons="$theme"
}

get_font() {
    name="gtk-font-name"
    gsettings="font-name"
    gconf="font_theme"
    xfconf="/Gtk/FontName"
    kde="font"

    get_style
    font="$theme"
}

get_term() {
    # If function was run, stop here.
    ((term_run == 1)) && return

    # Workaround for macOS systems that
    # don't support the block below.
    case $TERM_PROGRAM in
        "iTerm.app")    term="iTerm2" ;;
        "Terminal.app") term="Apple Terminal" ;;
        "Hyper")        term="HyperTerm" ;;
        *)              term="${TERM_PROGRAM/\.app}" ;;
    esac

    # Most likely TosWin2 on FreeMiNT - quick check
    [[ "$TERM" == "tw52" || "$TERM" == "tw100" ]] && term="TosWin2"
    [[ "$SSH_CONNECTION" ]] && term="$SSH_TTY"
    [[ "$WT_SESSION" ]]     && term="Windows Terminal"

    # Check $PPID for terminal emulator.
    while [[ -z "$term" ]]; do
        parent="$(get_ppid "$parent")"
        [[ -z "$parent" ]] && break
        name="$(get_process_name "$parent")"

        case ${name// } in
            "${SHELL/*\/}"|*"sh"|"screen"|"su"*|"newgrp") ;;

            "login"*|*"Login"*|"init"|"(init)")
                term="$(tty)"
            ;;

            "ruby"|"1"|"tmux"*|"systemd"|"sshd"*|"python"*|\
            "USER"*"PID"*|"kdeinit"*|"launchd"*|"bwrap")
                break
            ;;

            "gnome-terminal-") term="gnome-terminal" ;;
            "urxvtd")          term="urxvt" ;;
            *"nvim")           term="Neovim Terminal" ;;
            *"NeoVimServer"*)  term="VimR Terminal" ;;

            *)
                # Fix issues with long process names on Linux.
                [[ $os == Linux ]] && term=$(realpath "/proc/$parent/exe")

                term="${name##*/}"

                # Fix wrapper names in Nix.
                [[ $term == .*-wrapped ]] && {
                   term="${term#.}"
                   term="${term%-wrapped}"
                }
            ;;
        esac
    done

    # Log that the function was run.
    term_run=1
}

get_term_font() {
    ((term_run != 1)) && get_term

    case $term in
        "alacritty"*)
            shopt -s nullglob
            confs=({$XDG_CONFIG_HOME,$HOME}/{alacritty,}/{.,}alacritty.ym?)
            shopt -u nullglob

            [[ -f "${confs[0]}" ]] || return

            term_font="$(awk '/normal:/ {while (!/family:/ || /#/)
                         {if (!getline) {exit}} print; exit}' "${confs[0]}")"
            term_font="${term_font/*family:}"
            term_font="${term_font/$'\n'*}"
            term_font="${term_font/\#*}"
            term_font="${term_font//\"}"
        ;;

        "Apple_Terminal")
            term_font="$(osascript <<END
                         tell application "Terminal" to font name of window frontmost
END
)"
        ;;

        "iTerm2")
            # Unfortunately the profile name is not unique, but it seems to be the only thing
            # that identifies an active profile. There is the "id of current session of current win-
            # dow" though, but that does not match to a guid in the plist.
            # So, be warned, collisions may occur!
            # See: https://groups.google.com/forum/#!topic/iterm2-discuss/0tO3xZ4Zlwg
            local current_profile_name profiles_count profile_name diff_font

            current_profile_name="$(osascript <<END
                                    tell application "iTerm2" to profile name \
                                    of current session of current window
END
)"

            # Warning: Dynamic profiles are not taken into account here!
            # https://www.iterm2.com/documentation-dynamic-profiles.html
            font_file="${HOME}/Library/Preferences/com.googlecode.iterm2.plist"

            # Count Guids in "New Bookmarks"; they should be unique
            profiles_count="$(PlistBuddy -c "Print ':New Bookmarks:'" "$font_file" | \
                              grep -w -c "Guid")"

            for ((i=0; i<profiles_count; i++)); do
                profile_name="$(PlistBuddy -c "Print ':New Bookmarks:${i}:Name:'" "$font_file")"

                if [[ "$profile_name" == "$current_profile_name" ]]; then
                    # "Normal Font"
                    term_font="$(PlistBuddy -c "Print ':New Bookmarks:${i}:Normal Font:'" \
                                 "$font_file")"

                    # Font for non-ascii characters
                    # Only check for a different non-ascii font, if the user checked
                    # the "use a different font for non-ascii text" switch.
                    diff_font="$(PlistBuddy -c "Print ':New Bookmarks:${i}:Use Non-ASCII Font:'" \
                                 "$font_file")"

                    if [[ "$diff_font" == "true" ]]; then
                        non_ascii="$(PlistBuddy -c "Print ':New Bookmarks:${i}:Non Ascii Font:'" \
                                     "$font_file")"

                        [[ "$term_font" != "$non_ascii" ]] && \
                            term_font="$term_font (normal) / $non_ascii (non-ascii)"
                    fi
                fi
            done
        ;;

        "deepin-terminal"*)
            term_font="$(awk -F '=' '/font=/ {a=$2} /font_size/ {b=$2} END {print a,b}' \
                         "${XDG_CONFIG_HOME}/deepin/deepin-terminal/config.conf")"
        ;;

        "GNUstep_Terminal")
             term_font="$(awk -F '>|<' '/>TerminalFont</ {getline; f=$3}
                          />TerminalFontSize</ {getline; s=$3} END {print f,s}' \
                          "${HOME}/GNUstep/Defaults/Terminal.plist")"
        ;;

        "Hyper"*)
            term_font="$(awk -F':|,' '/fontFamily/ {print $2; exit}' "${HOME}/.hyper.js")"
            term_font="$(trim_quotes "$term_font")"
        ;;

        "kitty"*)
            term_font="from kitty.cli import *; o = create_default_opts(); \
                       print(f'{o.font_family} {o.font_size}')"
            term_font="$(kitty +runpy ''"$term_font"'')"
        ;;

        "konsole" | "yakuake")
            # Get Process ID of current konsole window / tab
            child="$(get_ppid "$$")"

            QT_BINDIR="$(qtpaths --binaries-dir)" && PATH+=":$QT_BINDIR"

            IFS=$'\n' read -d "" -ra konsole_instances \
                <<< "$(qdbus | awk '/org.kde.'"$term"'/ {print $1}')"

            for i in "${konsole_instances[@]}"; do
                IFS=$'\n' read -d "" -ra konsole_sessions <<< "$(qdbus "$i" | grep -F '/Sessions/')"

                for session in "${konsole_sessions[@]}"; do
                    if ((child == "$(qdbus "$i" "$session" processId)")); then
                        profile="$(qdbus "$i" "$session" environment |\
                                   awk -F '=' '/KONSOLE_PROFILE_NAME/ {print $2}')"
                        [[ $profile ]] || profile="$(qdbus "$i" "$session" profile)"
                        break
                    fi
                done
                [[ $profile ]] && break
            done

            [[ $profile ]] || return

            # We could have two profile files for the same profile name, take first match
            profile_filename="$(grep -l "Name=${profile}" "$HOME"/.local/share/konsole/*.profile)"
            profile_filename="${profile_filename/$'\n'*}"

            [[ $profile_filename ]] && \
                term_font="$(awk -F '=|,' '/Font=/ {print $2,$3}' "$profile_filename")"
        ;;

        "lxterminal"*)
            term_font="$(awk -F '=' '/fontname=/ {print $2; exit}' \
                         "${XDG_CONFIG_HOME}/lxterminal/lxterminal.conf")"
        ;;

        "mate-terminal")
            # To get the actual config we have to create a temporarily file with the
            # --save-config option.
            mateterm_config="/tmp/mateterm.cfg"

            # Ensure /tmp exists and we do not overwrite anything.
            if [[ -d "/tmp" && ! -f "$mateterm_config" ]]; then
                mate-terminal --save-config="$mateterm_config"

                role="$(xprop -id "${WINDOWID}" WM_WINDOW_ROLE)"
                role="${role##* }"
                role="${role//\"}"

                profile="$(awk -F '=' -v r="$role" \
                                  '$0~r {
                                            getline;
                                            if(/Maximized/) getline;
                                            if(/Fullscreen/) getline;
                                            id=$2"]"
                                         } $0~id {if(id) {getline; print $2; exit}}' \
                           "$mateterm_config")"

                rm -f "$mateterm_config"

                mate_get() {
                   gsettings get org.mate.terminal.profile:/org/mate/terminal/profiles/"$1"/ "$2"
                }

                if [[ "$(mate_get "$profile" "use-system-font")" == "true" ]]; then
                    term_font="$(gsettings get org.mate.interface monospace-font-name)"
                else
                    term_font="$(mate_get "$profile" "font")"
                fi
                term_font="$(trim_quotes "$term_font")"
            fi
        ;;

        "mintty")
            term_font="$(awk -F '=' '!/^($|#)/ && /^\\s*Font\\s*=/ {printf $2; exit}' "${HOME}/.minttyrc")"
        ;;

        "pantheon"*)
            term_font="$(gsettings get org.pantheon.terminal.settings font)"

            [[ -z "${term_font//\'}" ]] && \
                term_font="$(gsettings get org.gnome.desktop.interface monospace-font-name)"

            term_font="$(trim_quotes "$term_font")"
        ;;

        "qterminal")
            term_font="$(awk -F '=' '/fontFamily=/ {a=$2} /fontSize=/ {b=$2} END {print a,b}' \
                         "${XDG_CONFIG_HOME}/qterminal.org/qterminal.ini")"
        ;;

        "sakura"*)
            term_font="$(awk -F '=' '/^font=/ {print $2; exit}' \
                         "${XDG_CONFIG_HOME}/sakura/sakura.conf")"
        ;;

        "st")
            term_font="$(ps -o command= -p "$parent" | grep -F -- "-f")"

            if [[ "$term_font" ]]; then
                term_font="${term_font/*-f/}"
                term_font="${term_font/ -*/}"

            else
                # On Linux we can get the exact path to the running binary through the procfs
                # (in case `st` is launched from outside of $PATH) on other systems we just
                # have to guess and assume `st` is invoked from somewhere in the users $PATH
                [[ -L "/proc/$parent/exe" ]] && binary="/proc/$parent/exe" || binary="$(type -p st)"

                # Grep the output of strings on the `st` binary for anything that looks vaguely
                # like a font definition. NOTE: There is a slight limitation in this approach.
                # Technically "Font Name" is a valid font. As it doesn't specify any font options
                # though it is hard to match it correctly amongst the rest of the noise.
                [[ -n "$binary" ]] &&
                    term_font=$(
                        strings "$binary" |

                        grep -m 1 "*font[^2]"
                    )
            fi

            term_font="${term_font/xft:}"
            term_font="${term_font#*=}"
            term_font="${term_font/:*}"
        ;;

        "terminology")
            term_font="$(strings "${XDG_CONFIG_HOME}/terminology/config/standard/base.cfg" |\
                         awk '/^font\.name$/{print a}{a=$0}')"
            term_font="${term_font/.pcf}"
            term_font="${term_font/:*}"
        ;;

        "termite")
            [[ -f "${XDG_CONFIG_HOME}/termite/config" ]] && \
                termite_config="${XDG_CONFIG_HOME}/termite/config"

            term_font="$(awk -F '= ' '/\[options\]/ {
                                          opt=1
                                      }
                                      /^\s*font/ {
                                          if(opt==1) a=$2;
                                          opt=0
                                      } END {print a}' "/etc/xdg/termite/config" \
                         "$termite_config")"
        ;;

        urxvt|urxvtd|rxvt-unicode|xterm)
            xrdb=$(xrdb -query)
            term_font=$(grep -im 1 -e "^${term/d}"'\**\.*font:' -e '^\*font:' <<< "$xrdb")
            term_font=${term_font/*"*font:"}
            term_font=${term_font/*".font:"}
            term_font=${term_font/*"*.font:"}
            term_font=$(trim "$term_font")

            [[ -z $term_font && $term == xterm ]] && \
                term_font=$(grep '^XTerm.vt100.faceName' <<< "$xrdb")

            term_font=$(trim "${term_font/*"faceName:"}")

            # xft: isn't required at the beginning so we prepend it if it's missing
            [[ ${term_font:0:1} != '-' && ${term_font:0:4} != xft: ]] && \
                term_font=xft:$term_font

            # Xresources has two different font formats, this checks which
            # one is in use and formats it accordingly.
            case $term_font in
                *xft:*)
                    term_font=${term_font/xft:}
                    term_font=${term_font/:*}
                ;;

                -*)
                    IFS=- read -r _ _ term_font _ <<< "$term_font"
                ;;
            esac
        ;;

        "xfce4-terminal")
            term_font="$(awk -F '=' '/^FontName/{a=$2}/^FontUseSystem=TRUE/{a=$0} END {print a}' \
                         "${XDG_CONFIG_HOME}/xfce4/terminal/terminalrc")"

            [[ "$term_font" == "FontUseSystem=TRUE" ]] && \
                term_font="$(gsettings get org.gnome.desktop.interface monospace-font-name)"

            term_font="$(trim_quotes "$term_font")"

            # Default fallback font hardcoded in terminal-preferences.c
            [[ -z "$term_font" ]] && term_font="Monospace 12"
        ;;

        conemu-*)
            # Could have used `eval set -- "$ConEmuArgs"` instead for arg parsing.
            readarray -t ce_arg_list < <(xargs -n1 printf "%s\n" <<< "${ConEmuArgs-}")

            for ce_arg_idx in "${!ce_arg_list[@]}"; do
                # Search for "-LoadCfgFile" arg
                [[ "${ce_arg_list[$ce_arg_idx]}" == -LoadCfgFile ]] && {
                    # Conf path is the next arg
                    ce_conf=${ce_arg_list[++ce_arg_idx]}
                    break
                }
            done

            # https://conemu.github.io/en/ConEmuXml.html#search-sequence
            for ce_conf in "$ce_conf" "${ConEmuDir-}\ConEmu.xml" "${ConEmuDir-}\.ConEmu.xml" \
                           "${ConEmuBaseDir-}\ConEmu.xml" "${ConEmuBaseDir-}\.ConEmu.xml" \
                           "$APPDATA\ConEmu.xml" "$APPDATA\.ConEmu.xml"; do
                # Search for first conf file available
                [[ -f "$ce_conf" ]] && {
                    # Very basic XML parsing
                    term_font="$(awk '/name="FontName"/ && match($0, /data="([^"]*)"/) {
                        print substr($0, RSTART+6, RLENGTH-7)}' "$ce_conf")"
                    break
                }
            done

            # Null-terminated contents in /proc/registry files triggers a Bash warning.
            [[ "$term_font" ]] || read -r term_font < \
                /proc/registry/HKEY_CURRENT_USER/Software/ConEmu/.Vanilla/FontName
        ;;
    esac
}

get_disk() {
    type -p df &>/dev/null ||
        { err "Disk requires 'df' to function. Install 'df' to get disk info."; return; }

    df_version=$(df --version 2>&1)

    case $df_version in
        *IMitv*)   df_flags=(-P -g) ;; # AIX
        *befhikm*) df_flags=(-P -k) ;; # IRIX
        *hiklnP*)  df_flags=(-h)    ;; # OpenBSD

        *Tracker*) # Haiku
            err "Your version of df cannot be used due to the non-standard flags"
            return
        ;;

        *) df_flags=(-P -h) ;;
    esac

    # Create an array called 'disks' where each element is a separate line from
    # df's output. We then unset the first element which removes the column titles.
    IFS=$'\n' read -d "" -ra disks <<< "$(df "${df_flags[@]}" "${disk_show[@]:-/}")"
    unset "disks[0]"

    # Stop here if 'df' fails to print disk info.
    [[ ${disks[*]} ]] || {
        err "Disk: df failed to print the disks, make sure the disk_show array is set properly."
        return
    }

    for disk in "${disks[@]}"; do
        # Create a second array and make each element split at whitespace this time.
        IFS=" " read -ra disk_info <<< "$disk"
        disk_perc=${disk_info[${#disk_info[@]} - 2]/\%}

        case $disk_percent in
            off) disk_perc=
        esac

        case $df_version in
            *befhikm*)
                disk=$((disk_info[${#disk_info[@]} - 4] / 1024 / 1024))G
                disk+=" / "
                disk+=$((disk_info[${#disk_info[@]} - 5] / 1024/ 1024))G
                disk+=${disk_perc:+ ($disk_perc%)}
            ;;

            *)
                disk=${disk_info[${#disk_info[@]} - 4]/i}
                disk+=" / "
                disk+=${disk_info[${#disk_info[@]} - 5]/i}
                disk+=${disk_perc:+ ($disk_perc%)}
            ;;
        esac

        case $disk_subtitle in
            name)
                disk_sub=${disk_info[*]::${#disk_info[@]} - 5}
            ;;

            dir)
                disk_sub=${disk_info[${#disk_info[@]} - 1]/*\/}
                disk_sub=${disk_sub:-${disk_info[${#disk_info[@]} - 1]}}
            ;;

            none) ;;

            *)
                disk_sub=${disk_info[${#disk_info[@]} - 1]}
            ;;
        esac

        case $disk_display in
            bar)     disk="$(bar "$disk_perc" "100")" ;;
            infobar) disk+=" $(bar "$disk_perc" "100")" ;;
            barinfo) disk="$(bar "$disk_perc" "100")${info_color} $disk" ;;
            perc)    disk="${disk_perc}% $(bar "$disk_perc" "100")" ;;
        esac

        # Append '(disk mount point)' to the subtitle.
        if [[ "$subtitle" ]]; then
            prin "$subtitle${disk_sub:+ ($disk_sub)}" "$disk"
        else
            prin "$disk_sub" "$disk"
        fi
    done
}

get_battery() {
    case $os in
        "Linux")
            # We use 'prin' here so that we can do multi battery support
            # with a single battery per line.
            for bat in "/sys/class/power_supply/"{BAT,axp288_fuel_gauge,CMB}*; do
                capacity="$(< "${bat}/capacity")"
                status="$(< "${bat}/status")"

                if [[ "$capacity" ]]; then
                    battery="${capacity}% [${status}]"

                    case $battery_display in
                        "bar")     battery="$(bar "$capacity" 100)" ;;
                        "infobar") battery+=" $(bar "$capacity" 100)" ;;
                        "barinfo") battery="$(bar "$capacity" 100)${info_color} ${battery}" ;;
                    esac

                    bat="${bat/*axp288_fuel_gauge}"
                    prin "${subtitle:+${subtitle}${bat: -1}}" "$battery"
                fi
            done
            return
        ;;

        "BSD")
            case $kernel_name in
                "FreeBSD"* | "DragonFly"*)
                    battery="$(acpiconf -i 0 | awk -F ':\t' '/Remaining capacity/ {print $2}')"
                    battery_state="$(acpiconf -i 0 | awk -F ':\t\t\t' '/State/ {print $2}')"
                ;;

                "NetBSD"*)
                    battery="$(envstat | awk '\\(|\\)' '/charge:/ {print $2}')"
                    battery="${battery/\.*/%}"
                ;;

                "OpenBSD"* | "Bitrig"*)
                    battery0full="$(sysctl -n   hw.sensors.acpibat0.watthour0\
                                                hw.sensors.acpibat0.amphour0)"
                    battery0full="${battery0full%% *}"

                    battery0now="$(sysctl -n    hw.sensors.acpibat0.watthour3\
                                                hw.sensors.acpibat0.amphour3)"
                    battery0now="${battery0now%% *}"

                    state="$(sysctl -n hw.sensors.acpibat0.raw0)"
                    state="${state##? (battery }"
                    state="${state%)*}"

                    [[ "${state}" == "charging" ]] && battery_state="charging"
                    [[ "$battery0full" ]] && \
                    battery="$((100 * ${battery0now/\.} / ${battery0full/\.}))%"
                ;;
            esac
        ;;

        "Mac OS X"|"macOS")
            battery="$(pmset -g batt | grep -o '[0-9]*%')"
            state="$(pmset -g batt | awk '/;/ {print $4}')"
            [[ "$state" == "charging;" ]] && battery_state="charging"
        ;;

        "Windows")
            battery="$(wmic Path Win32_Battery get EstimatedChargeRemaining)"
            battery="${battery/EstimatedChargeRemaining}"
            battery="$(trim "$battery")%"
            state="$(wmic /NameSpace:'\\root\WMI' Path BatteryStatus get Charging)"
            state="${state/Charging}"
            [[ "$state" == *TRUE* ]] && battery_state="charging"
        ;;

        "Haiku")
            battery0full="$(awk -F '[^0-9]*' 'NR==2 {print $4}' /dev/power/acpi_battery/0)"
            battery0now="$(awk -F '[^0-9]*' 'NR==5 {print $4}' /dev/power/acpi_battery/0)"
            battery="$((battery0full * 100 / battery0now))%"
        ;;
    esac

    [[ "$battery_state" ]] && battery+=" Charging"

    case $battery_display in
        "bar")     battery="$(bar "${battery/\%*}" 100)" ;;
        "infobar") battery="${battery} $(bar "${battery/\%*}" 100)" ;;
        "barinfo") battery="$(bar "${battery/\%*}" 100)${info_color} ${battery}" ;;
    esac
}

get_local_ip() {
    case $os in
        "Linux" | "BSD" | "Solaris" | "AIX" | "IRIX")
            if [[ "${local_ip_interface[0]}" == "auto" ]]; then
                local_ip="$(ip route get 1 | awk -F'src' '{print $2; exit}')"
                local_ip="${local_ip/uid*}"
                [[ "$local_ip" ]] || local_ip="$(ifconfig -a | awk '/broadcast/ {print $2; exit}')"
            else
                for interface in "${local_ip_interface[@]}"; do
                    local_ip="$(ip addr show "$interface" 2> /dev/null |
                        awk '/inet / {print $2; exit}')"
                    local_ip="${local_ip/\/*}"
                    [[ "$local_ip" ]] ||
                        local_ip="$(ifconfig "$interface" 2> /dev/null |
                        awk '/broadcast/ {print $2; exit}')"
                    if [[ -n "$local_ip" ]]; then
                        prin "$interface" "$local_ip"
                    else
                        err "Local IP: Could not detect local ip for $interface"
                    fi
                done
            fi
        ;;

        "MINIX")
            local_ip="$(ifconfig | awk '{printf $3; exit}')"
        ;;

        "Mac OS X" | "macOS" | "iPhone OS")
            if [[ "${local_ip_interface[0]}" == "auto" ]]; then
                interface="$(route get 1 | awk -F': ' '/interface/ {printf $2; exit}')"
                local_ip="$(ipconfig getifaddr "$interface")"
            else
                for interface in "${local_ip_interface[@]}"; do
                    local_ip="$(ipconfig getifaddr "$interface")"
                    if [[ -n "$local_ip" ]]; then
                        prin "$interface" "$local_ip"
                    else
                        err "Local IP: Could not detect local ip for $interface"
                    fi
                done
            fi
        ;;

        "Windows")
            local_ip="$(ipconfig | awk -F ': ' '/IPv4 Address/ {printf $2 ", "}')"
            local_ip="${local_ip%\,*}"
        ;;

        "Haiku")
            local_ip="$(ifconfig | awk -F ': ' '/Bcast/ {print $2}')"
            local_ip="${local_ip/, Bcast}"
        ;;
    esac
}

get_public_ip() {
    if [[ ! -n "$public_ip_host" ]] && type -p dig >/dev/null; then
        public_ip="$(dig +time=1 +tries=1 +short myip.opendns.com @resolver1.opendns.com)"
       [[ "$public_ip" =~ ^\; ]] && unset public_ip
    fi

    if [[ ! -n "$public_ip_host" ]] && [[ -z "$public_ip" ]] && type -p drill >/dev/null; then
        public_ip="$(drill myip.opendns.com @resolver1.opendns.com | \
                     awk '/^myip\./ && $3 == "IN" {print $5}')"
    fi

    if [[ -z "$public_ip" ]] && type -p curl >/dev/null; then
        public_ip="$(curl -L --max-time "$public_ip_timeout" -w '\n' "$public_ip_host")"
    fi

    if [[ -z "$public_ip" ]] && type -p wget >/dev/null; then
        public_ip="$(wget -T "$public_ip_timeout" -qO- "$public_ip_host")"
    fi
}

get_users() {
    users="$(who | awk '!seen[$1]++ {printf $1 ", "}')"
    users="${users%\,*}"
}

get_locale() {
    locale="$sys_locale"
}

get_gpu_driver() {
    case $os in
        "Linux")
            gpu_driver="$(lspci -nnk | awk -F ': ' \
                          '/Display|3D|VGA/{nr[NR+2]}; NR in nr {printf $2 ", "; exit}')"
            gpu_driver="${gpu_driver%, }"

            if [[ "$gpu_driver" == *"nvidia"* ]]; then
                gpu_driver="$(< /proc/driver/nvidia/version)"
                gpu_driver="${gpu_driver/*Module  }"
                gpu_driver="NVIDIA ${gpu_driver/  *}"
            fi
        ;;

        "Mac OS X"|"macOS")
            if [[ "$(kextstat | grep "GeForceWeb")" != "" ]]; then
                gpu_driver="NVIDIA Web Driver"
            else
                gpu_driver="macOS Default Graphics Driver"
            fi
        ;;
    esac
}

get_cols() {
    local blocks blocks2 cols

    if [[ "$color_blocks" == "on" ]]; then
        # Convert the width to space chars.
        printf -v block_width "%${block_width}s"

        # Generate the string.
        for ((block_range[0]; block_range[0]<=block_range[1]; block_range[0]++)); do
            case ${block_range[0]} in
                [0-7])
                    printf -v blocks  '%b\e[3%bm\e[4%bm%b' \
                        "$blocks" "${block_range[0]}" "${block_range[0]}" "$block_width"
                ;;

                *)
                    printf -v blocks2 '%b\e[38;5;%bm\e[48;5;%bm%b' \
                        "$blocks2" "${block_range[0]}" "${block_range[0]}" "$block_width"
                ;;
            esac
        done

        # Convert height into spaces.
        printf -v block_spaces "%${block_height}s"

        # Convert the spaces into rows of blocks.
        [[ "$blocks"  ]] && cols+="${block_spaces// /${blocks}[mnl}"
        [[ "$blocks2" ]] && cols+="${block_spaces// /${blocks2}[mnl}"

        # Add newlines to the string.
        cols=${cols%%nl}
        cols=${cols//nl/
[${text_padding}C${zws}}

        # Add block height to info height.
        ((info_height+=block_range[1]>7?block_height+2:block_height+1))

        case $col_offset in
            "auto") printf '\n\e[%bC%b\n' "$text_padding" "${zws}${cols}" ;;
            *) printf '\n\e[%bC%b\n' "$col_offset" "${zws}${cols}" ;;
        esac
    fi

    unset -v blocks blocks2 cols

    # Tell info() that we printed manually.
    prin=1
}

# IMAGES

image_backend() {
    [[ "$image_backend" != "off" ]] && ! type -p convert &>/dev/null && \
        { image_backend="ascii"; err "Image: Imagemagick not found, falling back to ascii mode."; }

    case ${image_backend:-off} in
        "ascii") print_ascii ;;
        "off") image_backend="off" ;;

        "caca" | "catimg" | "chafa" | "jp2a" | "iterm2" | "termpix" |\
        "tycat" | "w3m" | "sixel" | "pixterm" | "kitty" | "pot", | "ueberzug" |\
         "viu")
            get_image_source

            [[ ! -f "$image" ]] && {
                to_ascii "Image: '$image_source' doesn't exist, falling back to ascii mode."
                return
            }
            [[ "$image_backend" == "ueberzug" ]] && wait=true;

            get_window_size

            ((term_width < 1)) && {
                to_ascii "Image: Failed to find terminal window size."
                err "Image: Check the 'Images in the terminal' wiki page for more info,"
                return
            }

            printf '\e[2J\e[H'
            get_image_size
            make_thumbnail
            display_image || to_off "Image: $image_backend failed to display the image."
        ;;

        *)
            err "Image: Unknown image backend specified '$image_backend'."
            err "Image: Valid backends are: 'ascii', 'caca', 'catimg', 'chafa', 'jp2a', 'iterm2',
                                            'kitty', 'off', 'sixel', 'pot', 'pixterm', 'termpix',
                                            'tycat', 'w3m', 'viu')"
            err "Image: Falling back to ascii mode."
            print_ascii
        ;;
    esac

    # Set cursor position next image/ascii.
    [[ "$image_backend" != "off" ]] && printf '\e[%sA\e[9999999D' "${lines:-0}"
}

print_ascii() {
    if [[ -f "$image_source" && ! "$image_source" =~ (png|jpg|jpeg|jpe|svg|gif) ]]; then
        ascii_data="$(< "$image_source")"
    elif [[ "$image_source" == "ascii" || $image_source == auto ]]; then
        :
    else
        ascii_data="$image_source"
    fi

    # Set locale to get correct padding.
    LC_ALL="$sys_locale"

    # Calculate size of ascii file in line length / line count.
    while IFS=$'\n' read -r line; do
        line=${line//\\\\/\\}
        line=${line//█/ }
        ((++lines,${#line}>ascii_len)) && ascii_len="${#line}"
    done <<< "${ascii_data//\$\{??\}}"

    # Fallback if file not found.
    ((lines==1)) && {
        lines=
        ascii_len=
        image_source=auto
        get_distro_ascii
        print_ascii
        return
    }

    # Colors.
    ascii_data="${ascii_data//\$\{c1\}/$c1}"
    ascii_data="${ascii_data//\$\{c2\}/$c2}"
    ascii_data="${ascii_data//\$\{c3\}/$c3}"
    ascii_data="${ascii_data//\$\{c4\}/$c4}"
    ascii_data="${ascii_data//\$\{c5\}/$c5}"
    ascii_data="${ascii_data//\$\{c6\}/$c6}"

    ((text_padding=ascii_len+gap))
    printf '%b\n' "$ascii_data${reset}"
    LC_ALL=C
}

get_image_source() {
    case $image_source in
        "auto" | "wall" | "wallpaper")
            get_wallpaper
        ;;

        *)
            # Get the absolute path.
            image_source="$(get_full_path "$image_source")"

            if [[ -d "$image_source" ]]; then
                shopt -s nullglob
                files=("${image_source%/}"/*.{png,jpg,jpeg,jpe,gif,svg})
                shopt -u nullglob
                image="${files[RANDOM % ${#files[@]}]}"

            else
                image="$image_source"
            fi
        ;;
    esac

    err "Image: Using image '$image'"
}

get_wallpaper() {
    case $os in
        "Mac OS X"|"macOS")
            image="$(osascript <<END
                     tell application "System Events" to picture of current desktop
END
)"
        ;;

        "Windows")
            case $distro in
                "Windows XP")
                    image="/c/Documents and Settings/${USER}"
                    image+="/Local Settings/Application Data/Microsoft/Wallpaper1.bmp"

                    [[ "$kernel_name" == *CYGWIN* ]] && image="/cygdrive${image}"
                ;;

                "Windows"*)
                    image="${APPDATA}/Microsoft/Windows/Themes/TranscodedWallpaper.jpg"
                ;;
            esac
        ;;

        *)
            # Get DE if user has disabled the function.
            ((de_run != 1)) && get_de

            type -p wal >/dev/null && [[ -f "${HOME}/.cache/wal/wal" ]] && \
                { image="$(< "${HOME}/.cache/wal/wal")"; return; }

            case $de in
                "MATE"*)
                    image="$(gsettings get org.mate.background picture-filename)"
                ;;

                "Xfce"*)
                    image="$(xfconf-query -c xfce4-desktop -p \
                             "/backdrop/screen0/monitor0/workspace0/last-image")"
                ;;

                "Cinnamon"*)
                    image="$(gsettings get org.cinnamon.desktop.background picture-uri)"
                    image="$(decode_url "$image")"
                ;;

                "GNOME"*)
                    image="$(gsettings get org.gnome.desktop.background picture-uri)"
                    image="$(decode_url "$image")"
                ;;

                "Plasma"*)
                    image=$XDG_CONFIG_HOME/plasma-org.kde.plasma.desktop-appletsrc
                    image=$(awk -F '=' '$1 == "Image" { print $2 }' "$image")
                ;;

                "LXQt"*)
                    image="$XDG_CONFIG_HOME/pcmanfm-qt/lxqt/settings.conf"
                    image="$(awk -F '=' '$1 == "Wallpaper" {print $2}' "$image")"
                ;;

                *)
                    if type -p feh >/dev/null && [[ -f "${HOME}/.fehbg" ]]; then
                        image="$(awk -F\' '/feh/ {printf $(NF-1)}' "${HOME}/.fehbg")"

                    elif type -p setroot >/dev/null && \
                         [[ -f "${XDG_CONFIG_HOME}/setroot/.setroot-restore" ]]; then
                        image="$(awk -F\' '/setroot/ {printf $(NF-1)}' \
                                 "${XDG_CONFIG_HOME}/setroot/.setroot-restore")"

                    elif type -p nitrogen >/dev/null; then
                        image="$(awk -F'=' '/file/ {printf $2;exit;}' \
                                 "${XDG_CONFIG_HOME}/nitrogen/bg-saved.cfg")"

                    else
                        image="$(gsettings get org.gnome.desktop.background picture-uri)"
                        image="$(decode_url "$image")"
                    fi
                ;;
            esac

            # Strip un-needed info from the path.
            image="${image/file:\/\/}"
            image="$(trim_quotes "$image")"
        ;;
    esac

    # If image is an xml file, don't use it.
    [[ "${image/*\./}" == "xml" ]] && image=""
}

get_w3m_img_path() {
    # Find w3m-img path.
    shopt -s nullglob
    w3m_paths=({/usr/{local/,},~/.nix-profile/}{lib,libexec,lib64,libexec64}/w3m/w3mi*)
    shopt -u nullglob

    [[ -x "${w3m_paths[0]}" ]] && \
        { w3m_img_path="${w3m_paths[0]}"; return; }

    err "Image: w3m-img wasn't found on your system"
}

get_window_size() {
    # This functions gets the current window size in
    # pixels.
    #
    # We first try to use the escape sequence "\033[14t"
    # to get the terminal window size in pixels. If this
    # fails we then fallback to using "xdotool" or other
    # programs.

    # Tmux has a special way of reading escape sequences
    # so we have to use a slightly different sequence to
    # get the terminal size.
    if [[ "$image_backend" == "tycat" ]]; then
        printf '%b' '\e}qs\000'

    elif [[ -z $VTE_VERSION ]]; then
        case ${TMUX:-null} in
            "null") printf '%b' '\e[14t' ;;
            *)      printf '%b' '\ePtmux;\e\e[14t\e\\ ' ;;
        esac
    fi

    # The escape codes above print the desired output as
    # user input so we have to use read to store the out
    # -put as a variable.
    # The 1 second timeout is required for older bash
    #
    # False positive.
    # shellcheck disable=2141
    case $bash_version in
        4|5) IFS=';t' read -d t -t 0.05 -sra term_size ;;
        *)   IFS=';t' read -d t -t 1 -sra term_size ;;
    esac
    unset IFS

    # Split the string into height/width.
    if [[ "$image_backend" == "tycat" ]]; then
        term_width="$((term_size[2] * term_size[0]))"
        term_height="$((term_size[3] * term_size[1]))"

    else
        term_height="${term_size[1]}"
        term_width="${term_size[2]}"
    fi

    # Get terminal width/height.
    if (( "${term_width:-0}" < 50 )) && [[ "$DISPLAY" && $os != "Mac OS X" && $os != "macOS" ]]; then
        if type -p xdotool &>/dev/null; then
            IFS=$'\n' read -d "" -ra win \
                <<< "$(xdotool getactivewindow getwindowgeometry --shell %1)"
            term_width="${win[3]/WIDTH=}"
            term_height="${win[4]/HEIGHT=}"

        elif type -p xwininfo &>/dev/null; then
            # Get the focused window's ID.
            if type -p xdo &>/dev/null; then
                current_window="$(xdo id)"

            elif type -p xprop &>/dev/null; then
                current_window="$(xprop -root _NET_ACTIVE_WINDOW)"
                current_window="${current_window##* }"

            elif type -p xdpyinfo &>/dev/null; then
                current_window="$(xdpyinfo | grep -F "focus:")"
                current_window="${current_window/*window }"
                current_window="${current_window/,*}"
            fi

            # If the ID was found get the window size.
            if [[ "$current_window" ]]; then
                term_size=("$(xwininfo -id "$current_window")")
                term_width="${term_size[0]#*Width: }"
                term_width="${term_width/$'\n'*}"
                term_height="${term_size[0]/*Height: }"
                term_height="${term_height/$'\n'*}"
            fi
        fi
    fi

    term_width="${term_width:-0}"
}


get_term_size() {
    # Get the terminal size in cells.
    read -r lines columns <<< "$(stty size)"

    # Calculate font size.
    font_width="$((term_width / columns))"
    font_height="$((term_height / lines))"
}

get_image_size() {
    # This functions determines the size to make the thumbnail image.
    get_term_size

    case $image_size in
        "auto")
            image_size="$((columns * font_width / 2))"
            term_height="$((term_height - term_height / 4))"

            ((term_height < image_size)) && \
                image_size="$term_height"
        ;;

        *"%")
            percent="${image_size/\%}"
            image_size="$((percent * term_width / 100))"

            (((percent * term_height / 50) < image_size)) && \
                image_size="$((percent * term_height / 100))"
        ;;

        "none")
            # Get image size so that we can do a better crop.
            read -r width height <<< "$(identify -format "%w %h" "$image")"

            while ((width >= (term_width / 2) || height >= term_height)); do
                ((width=width/2,height=height/2))
            done

            crop_mode="none"
        ;;

        *)  image_size="${image_size/px}" ;;
    esac

    # Check for terminal padding.
    [[ "$image_backend" == "w3m" ]] && term_padding

    width="${width:-$image_size}"
    height="${height:-$image_size}"
    text_padding="$(((width + padding + xoffset) / font_width + gap))"
}

make_thumbnail() {
    # Name the thumbnail using variables so we can
    # use it later.
    image_name="${crop_mode}-${crop_offset}-${width}-${height}-${image//\/}"

    # Handle file extensions.
    case ${image##*.} in
        "eps"|"pdf"|"svg"|"gif"|"png")
            image_name+=".png" ;;
        *)  image_name+=".jpg" ;;
    esac

    # Create the thumbnail dir if it doesn't exist.
    mkdir -p "${thumbnail_dir:=${XDG_CACHE_HOME:-${HOME}/.cache}/thumbnails/neofetch}"

    if [[ ! -f "${thumbnail_dir}/${image_name}" ]]; then
        # Get image size so that we can do a better crop.
        [[ -z "$size" ]] && {
            read -r og_width og_height <<< "$(identify -format "%w %h" "$image")"
            ((og_height > og_width)) && size="$og_width" || size="$og_height"
        }

        case $crop_mode in
            "fit")
                c="$(convert "$image" \
                    -colorspace srgb \
                    -format "%[pixel:p{0,0}]" info:)"

                convert \
                    -background none \
                    "$image" \
                    -trim +repage \
                    -gravity south \
                    -background "$c" \
                    -extent "${size}x${size}" \
                    -scale "${width}x${height}" \
                    "${thumbnail_dir}/${image_name}"
            ;;

            "fill")
                convert \
                    -background none \
                    "$image" \
                    -trim +repage \
                    -scale "${width}x${height}^" \
                    -extent "${width}x${height}" \
                    "${thumbnail_dir}/${image_name}"
            ;;

            "none")
                cp "$image" "${thumbnail_dir}/${image_name}"
            ;;

            *)
                convert \
                    -background none \
                    "$image" \
                    -strip \
                    -gravity "$crop_offset" \
                    -crop "${size}x${size}+0+0" \
                    -scale "${width}x${height}" \
                    "${thumbnail_dir}/${image_name}"
            ;;
        esac
    fi

    # The final image.
    image="${thumbnail_dir}/${image_name}"
}

display_image() {
    case $image_backend in
        "caca")
            img2txt \
                -W "$((width / font_width))" \
                -H "$((height / font_height))" \
                --gamma=0.6 \
            "$image"
        ;;


        "ueberzug")
            if [ "$wait" = true ];then
                wait=false;
            else
                ueberzug layer --parser bash 0< <(
                    declare -Ap ADD=(\
                        [action]="add"\
                        [identifier]="neofetch"\
                        [x]=$xoffset [y]=$yoffset\
                        [path]=$image\
                    )
                    read -rs
                )
            fi
        ;;

        "catimg")
            catimg -w "$((width*catimg_size / font_width))" -r "$catimg_size" "$image"
        ;;

        "chafa")
            chafa --stretch --size="$((width / font_width))x$((height / font_height))" "$image"
        ;;

        "jp2a")
            jp2a \
                --colors \
                --width="$((width / font_width))" \
                --height="$((height / font_height))" \
            "$image"
        ;;

        "kitty")
            kitty +kitten icat \
                --align left \
                --place "$((width/font_width))x$((height/font_height))@${xoffset}x${yoffset}" \
            "$image"
        ;;

        "pot")
            pot \
                "$image" \
                --size="$((width / font_width))x$((height / font_height))"
        ;;

        "pixterm")
            pixterm \
                -tc "$((width / font_width))" \
                -tr "$((height / font_height))" \
            "$image"
        ;;

        "sixel")
            img2sixel \
                -w "$width" \
                -h "$height" \
            "$image"
        ;;

        "termpix")
            termpix \
                --width "$((width / font_width))" \
                --height "$((height / font_height))" \
            "$image"
        ;;

        "iterm2")
            printf -v iterm_cmd '\e]1337;File=width=%spx;height=%spx;inline=1:%s' \
                "$width" "$height" "$(base64 < "$image")"

            # Tmux requires an additional escape sequence for this to work.
            [[ -n "$TMUX" ]] && printf -v iterm_cmd '\ePtmux;\e%b\e'\\ "$iterm_cmd"

            printf '%b\a\n' "$iterm_cmd"
        ;;

        "tycat")
            tycat \
                -g "${width}x${height}" \
            "$image"
        ;;

        "viu")
            viu \
                -t -w "$((width / font_width))" -h "$((height / font_height))" \
            "$image"
        ;;

        "w3m")
            get_w3m_img_path
            zws='\xE2\x80\x8B\x20'

            # Add a tiny delay to fix issues with images not
            # appearing in specific terminal emulators.
            ((bash_version>3)) && sleep 0.05
            printf '%b\n%s;\n%s\n' "0;1;$xoffset;$yoffset;$width;$height;;;;;$image" 3 4 |\
            "${w3m_img_path:-false}" -bg "$background_color" &>/dev/null
        ;;
    esac
}

to_ascii() {
    err "$1"
    image_backend="ascii"
    print_ascii

    # Set cursor position next image/ascii.
    printf '\e[%sA\e[9999999D' "${lines:-0}"
}

to_off() {
    err "$1"
    image_backend="off"
    text_padding=
}


# TEXT FORMATTING

info() {
    # Save subtitle value.
    [[ "$2" ]] && subtitle="$1"

    # Make sure that $prin is unset.
    unset -v prin

    # Call the function.
    "get_${2:-$1}"

    # If the get_func function called 'prin' directly, stop here.
    [[ "$prin" ]] && return

    # Update the variable.
    if [[ "$2" ]]; then
        output="$(trim "${!2}")"
    else
        output="$(trim "${!1}")"
    fi

    if [[ "$2" && "${output// }" ]]; then
        prin "$1" "$output"

    elif [[ "${output// }" ]]; then
        prin "$output"

    else
        err "Info: Couldn't detect ${1}."
    fi

    unset -v subtitle
}

prin() {
    # If $2 doesn't exist we format $1 as info.
    if [[ "$(trim "$1")" && "$2" ]]; then
        [[ "$json" ]] && { printf '    %s\n' "\"${1}\": \"${2}\","; return; }

        string="${1}${2:+: $2}"
    else
        string="${2:-$1}"
        local subtitle_color="$info_color"
    fi

    string="$(trim "${string//$'\e[0m'}")"
    length="$(strip_sequences "$string")"
    length="${#length}"

    # Format the output.
    string="${string/:/${reset}${colon_color}${separator:=:}${info_color}}"
    string="${subtitle_color}${bold}${string}"

    # Print the info.
    printf '%b\n' "${text_padding:+\e[${text_padding}C}${zws}${string//\\n}${reset} "

    # Calculate info height.
    ((++info_height))

    # Log that prin was used.
    prin=1
}

get_underline() {
    [[ "$underline_enabled" == "on" ]] && {
        printf -v underline "%${length}s"
        printf '%b%b\n' "${text_padding:+\e[${text_padding}C}${zws}${underline_color}" \
                        "${underline// /$underline_char}${reset} "
    }

    ((++info_height))
    length=
    prin=1
}

get_bold() {
    case $ascii_bold in
        "on")  ascii_bold='\e[1m' ;;
        "off") ascii_bold="" ;;
    esac

    case $bold in
        "on")  bold='\e[1m' ;;
        "off") bold="" ;;
    esac
}

trim() {
    set -f
    # shellcheck disable=2048,2086
    set -- $*
    printf '%s\n' "${*//[[:space:]]/}"
    set +f
}

trim_quotes() {
    trim_output="${1//\'}"
    trim_output="${trim_output//\"}"
    printf "%s" "$trim_output"
}

strip_sequences() {
    strip="${1//$'\e['3[0-9]m}"
    strip="${strip//$'\e['[0-9]m}"
    strip="${strip//\\e\[[0-9]m}"
    strip="${strip//$'\e['38\;5\;[0-9]m}"
    strip="${strip//$'\e['38\;5\;[0-9][0-9]m}"
    strip="${strip//$'\e['38\;5\;[0-9][0-9][0-9]m}"

    printf '%s\n' "$strip"
}

# COLORS

set_colors() {
    c1="$(color "$1")${ascii_bold}"
    c2="$(color "$2")${ascii_bold}"
    c3="$(color "$3")${ascii_bold}"
    c4="$(color "$4")${ascii_bold}"
    c5="$(color "$5")${ascii_bold}"
    c6="$(color "$6")${ascii_bold}"

    [[ "$color_text" != "off" ]] && set_text_colors "$@"
}

set_text_colors() {
    if [[ "${colors[0]}" == "distro" ]]; then
        title_color="$(color "$1")"
        at_color="$reset"
        underline_color="$reset"
        subtitle_color="$(color "$2")"
        colon_color="$reset"
        info_color="$reset"

        # If the ascii art uses 8 as a color, make the text the fg.
        ((${1:-1} == 8)) && title_color="$reset"
        ((${2:-7} == 8)) && subtitle_color="$reset"

        # If the second color is white use the first for the subtitle.
        ((${2:-7} == 7)) && subtitle_color="$(color "$1")"
        ((${1:-1} == 7)) && title_color="$reset"
    else
        title_color="$(color "${colors[0]}")"
        at_color="$(color "${colors[1]}")"
        underline_color="$(color "${colors[2]}")"
        subtitle_color="$(color "${colors[3]}")"
        colon_color="$(color "${colors[4]}")"
        info_color="$(color "${colors[5]}")"
    fi

    # Bar colors.
    if [[ "$bar_color_elapsed" == "distro" ]]; then
        bar_color_elapsed="$(color fg)"
    else
        bar_color_elapsed="$(color "$bar_color_elapsed")"
    fi

    case ${bar_color_total}${1} in
        distro[736]) bar_color_total=$(color "$1") ;;
        distro[0-9]) bar_color_total=$(color "$2") ;;
        *)           bar_color_total=$(color "$bar_color_total") ;;
    esac
}

color() {
    case $1 in
        [0-6])    printf '%b\e[3%sm'   "$reset" "$1" ;;
        7 | "fg") printf '\e[37m%b'    "$reset" ;;
        *)        printf '\e[38;5;%bm' "$1" ;;
    esac
}

# OTHER

stdout() {
    image_backend="off"
    unset subtitle_color colon_color info_color underline_color bold title_color at_color \
          text_padding zws reset color_blocks bar_color_elapsed bar_color_total \
          c1 c2 c3 c4 c5 c6 c7 c8
}

err() {
    err+="$(color 1)[!]${reset} $1
"
}

get_full_path() {
    # This function finds the absolute path from a relative one.
    # For example "Pictures/Wallpapers" --> "/home/dylan/Pictures/Wallpapers"

    # If the file exists in the current directory, stop here.
    [[ -f "${PWD}/${1}" ]] && { printf '%s\n' "${PWD}/${1}"; return; }

    ! cd "${1%/*}" && {
        err "Error: Directory '${1%/*}' doesn't exist or is inaccessible"
        err "       Check that the directory exists or try another directory."
        exit 1
    }

    local full_dir="${1##*/}"

    # Iterate down a (possible) chain of symlinks.
    while [[ -L "$full_dir" ]]; do
        full_dir="$(readlink "$full_dir")"
        cd "${full_dir%/*}" || exit
        full_dir="${full_dir##*/}"
    done

    # Final directory.
    full_dir="$(pwd -P)/${1/*\/}"

    [[ -e "$full_dir" ]] && printf '%s\n' "$full_dir"
}

get_user_config() {
    # --config /path/to/config.conf
    if [[ -f "$config_file" ]]; then
        source "$config_file"
        err "Config: Sourced user config. (${config_file})"
        return

    elif [[ -f "${XDG_CONFIG_HOME}/neofetch/config.conf" ]]; then
        source "${XDG_CONFIG_HOME}/neofetch/config.conf"
        err "Config: Sourced user config.    (${XDG_CONFIG_HOME}/neofetch/config.conf)"

    elif [[ -f "${XDG_CONFIG_HOME}/neofetch/config" ]]; then
        source "${XDG_CONFIG_HOME}/neofetch/config"
        err "Config: Sourced user config.    (${XDG_CONFIG_HOME}/neofetch/config)"

    elif [[ -z "$no_config" ]]; then
        config_file="${XDG_CONFIG_HOME}/neofetch/config.conf"

        # The config file doesn't exist, create it.
        mkdir -p "${XDG_CONFIG_HOME}/neofetch/"
        printf '%s\n' "$config" > "$config_file"
    fi
}

bar() {
    # Get the values.
    elapsed="$(($1 * bar_length / $2))"

    # Create the bar with spaces.
    printf -v prog  "%${elapsed}s"
    printf -v total "%$((bar_length - elapsed))s"

    # Set the colors and swap the spaces for $bar_char_.
    bar+="${bar_color_elapsed}${prog// /${bar_char_elapsed}}"
    bar+="${bar_color_total}${total// /${bar_char_total}}"

    # Borders.
    [[ "$bar_border" == "on" ]] && \
        bar="$(color fg)[${bar}$(color fg)]"

    printf "%b" "${bar}${info_color}"
}

cache() {
    if [[ "$2" ]]; then
        mkdir -p "${cache_dir}/neofetch"
        printf "%s" "${1/*-}=\"$2\"" > "${cache_dir}/neofetch/${1/*-}"
    fi
}

get_cache_dir() {
    case $os in
        "Mac OS X"|"macOS") cache_dir="/Library/Caches" ;;
        *)          cache_dir="/tmp" ;;
    esac
}

kde_config_dir() {
    # If the user is using KDE get the KDE
    # configuration directory.
    if [[ "$kde_config_dir" ]]; then
        return

    elif type -p kf5-config &>/dev/null; then
        kde_config_dir="$(kf5-config --path config)"

    elif type -p kde4-config &>/dev/null; then
        kde_config_dir="$(kde4-config --path config)"

    elif type -p kde-config &>/dev/null; then
        kde_config_dir="$(kde-config --path config)"

    elif [[ -d "${HOME}/.kde4" ]]; then
        kde_config_dir="${HOME}/.kde4/share/config"

    elif [[ -d "${HOME}/.kde3" ]]; then
        kde_config_dir="${HOME}/.kde3/share/config"
    fi

    kde_config_dir="${kde_config_dir/$'/:'*}"
}

term_padding() {
    # Get terminal padding to properly align cursor.
    [[ -z "$term" ]] && get_term

    case $term in
        urxvt*|rxvt-unicode)
            [[ $xrdb ]] || xrdb=$(xrdb -query)

            [[ $xrdb != *internalBorder:* ]] &&
                return

            padding=${xrdb/*internalBorder:}
            padding=${padding/$'\n'*}

            [[ $padding =~ ^[0-9]+$ ]] ||
                padding=
        ;;
    esac
}

dynamic_prompt() {
    [[ "$image_backend" == "off" ]]   && { printf '\n'; return; }
    [[ "$image_backend" != "ascii" ]] && ((lines=(height + yoffset) / font_height + 1))
    [[ "$image_backend" == "w3m" ]]   && ((lines=lines + padding / font_height + 1))

    # If the ascii art is taller than the info.
    ((lines=lines>info_height?lines-info_height+1:1))

    printf -v nlines "%${lines}s"
    printf "%b" "${nlines// /\\n}"
}

cache_uname() {
    # Cache the output of uname so we don't
    # have to spawn it multiple times.
    IFS=" " read -ra uname <<< "$(uname -srm)"

    kernel_name="${uname[0]}"
    kernel_version="${uname[1]}"
    kernel_machine="${uname[2]}"

    if [[ "$kernel_name" == "Darwin" ]]; then
        # macOS can report incorrect versions unless this is 0.
        # https://github.com/dylanaraps/neofetch/issues/1607
        export SYSTEM_VERSION_COMPAT=0

        IFS=$'\n' read -d "" -ra sw_vers <<< "$(awk -F'<|>' '/key|string/ {print $3}' \
                            "/System/Library/CoreServices/SystemVersion.plist")"
        for ((i=0;i<${#sw_vers[@]};i+=2)) {
            case ${sw_vers[i]} in
                ProductName)          darwin_name=${sw_vers[i+1]} ;;
                ProductVersion)       osx_version=${sw_vers[i+1]} ;;
                ProductBuildVersion)  osx_build=${sw_vers[i+1]}   ;;
            esac
        }
    fi
}

get_ppid() {
    # Get parent process ID of PID.
    case $os in
        "Windows")
            ppid="$(ps -p "${1:-$PPID}" | awk '{printf $2}')"
            ppid="${ppid/PPID}"
        ;;

        "Linux")
            ppid="$(grep -i -F "PPid:" "/proc/${1:-$PPID}/status")"
            ppid="$(trim "${ppid/PPid:}")"
        ;;

        *)
            ppid="$(ps -p "${1:-$PPID}" -o ppid=)"
        ;;
    esac

    printf "%s" "$ppid"
}

get_process_name() {
    # Get PID name.
    case $os in
        "Windows")
            name="$(ps -p "${1:-$PPID}" | awk '{printf $8}')"
            name="${name/COMMAND}"
            name="${name/*\/}"
        ;;

        "Linux")
            name="$(< "/proc/${1:-$PPID}/comm")"
        ;;

        *)
            name="$(ps -p "${1:-$PPID}" -o comm=)"
        ;;
    esac

    printf "%s" "$name"
}

decode_url() {
    decode="${1//+/ }"
    printf "%b" "${decode//%/\\x}"
}

# FINISH UP

usage() { printf "%s" "\
Usage: neofetch func_name --option \"value\" --option \"value\"

Neofetch is a CLI system information tool written in BASH. Neofetch
displays information about your system next to an image, your OS logo,
or any ASCII file of your choice.

NOTE: Every launch flag has a config option.

Options:

INFO:
    func_name                   Specify a function name (second part of info() from config) to
                                quickly display only that function's information.

                                Example: neofetch uptime --uptime_shorthand tiny

                                Example: neofetch uptime disk wm memory

                                This can be used in bars and scripts like so:

                                memory=\"\$(neofetch memory)\"; memory=\"\${memory##*: }\"

                                For multiple outputs at once (each line of info in an array):

                                IFS=\$'\\n' read -d \"\" -ra info < <(neofetch memory uptime wm)

                                info=(\"\${info[@]##*: }\")

    --disable infoname          Allows you to disable an info line from appearing
                                in the output. 'infoname' is the function name from the
                                'print_info()' function inside the config file.
                                For example: 'info \"Memory\" memory' would be '--disable memory'

                                NOTE: You can supply multiple args. eg. 'neofetch --disable cpu gpu'

    --title_fqdn on/off         Hide/Show Fully Qualified Domain Name in title.
    --package_managers on/off   Hide/Show Package Manager names . (on, tiny, off)
    --os_arch on/off            Hide/Show OS architecture.
    --speed_type type           Change the type of cpu speed to display.
                                Possible values: current, min, max, bios,
                                scaling_current, scaling_min, scaling_max

                                NOTE: This only supports Linux with cpufreq.

    --speed_shorthand on/off    Whether or not to show decimals in CPU speed.

                                NOTE: This flag is not supported in systems with CPU speed less than
                                1 GHz.

    --cpu_brand on/off          Enable/Disable CPU brand in output.
    --cpu_cores type            Whether or not to display the number of CPU cores
                                Possible values: logical, physical, off

                                NOTE: 'physical' doesn't work on BSD.

    --cpu_speed on/off          Hide/Show cpu speed.
    --cpu_temp C/F/off          Hide/Show cpu temperature.

                                NOTE: This only works on Linux and BSD.

                                NOTE: For FreeBSD and NetBSD-based systems, you need to enable
                                coretemp kernel module. This only supports newer Intel processors.

    --distro_shorthand on/off   Shorten the output of distro (on, tiny, off)

                                NOTE: This option won't work in Windows (Cygwin)

    --kernel_shorthand on/off   Shorten the output of kernel

                                NOTE: This option won't work in BSDs (except PacBSD and PC-BSD)

    --uptime_shorthand on/off   Shorten the output of uptime (on, tiny, off)
    --refresh_rate on/off       Whether to display the refresh rate of each monitor
                                Unsupported on Windows
    --gpu_brand on/off          Enable/Disable GPU brand in output. (AMD/NVIDIA/Intel)
    --gpu_type type             Which GPU to display. (all, dedicated, integrated)

                                NOTE: This only supports Linux.

    --de_version on/off         Show/Hide Desktop Environment version
    --gtk_shorthand on/off      Shorten output of gtk theme/icons
    --gtk2 on/off               Enable/Disable gtk2 theme/font/icons output
    --gtk3 on/off               Enable/Disable gtk3 theme/font/icons output
    --shell_path on/off         Enable/Disable showing \$SHELL path
    --shell_version on/off      Enable/Disable showing \$SHELL version
    --disk_show value           Which disks to display.
                                Possible values: '/', '/dev/sdXX', '/path/to/mount point'

                                NOTE: Multiple values can be given. (--disk_show '/' '/dev/sdc1')

    --disk_subtitle type        What information to append to the Disk subtitle.
                                Takes: name, mount, dir, none

                                'name' shows the disk's name (sda1, sda2, etc)

                                'mount' shows the disk's mount point (/, /mnt/Local Disk, etc)

                                'dir' shows the basename of the disks's path. (/, Local Disk, etc)

                                'none' shows only 'Disk' or the configured title.

    --disk_percent on/off       Hide/Show disk percent.

    --ip_host url               URL to query for public IP
    --ip_timeout int            Public IP timeout (in seconds).
    --ip_interface value        Interface(s) to use for local IP
    --song_format format        Print the song data in a specific format (see config file).
    --song_shorthand on/off     Print the Artist/Album/Title on separate lines.
    --memory_percent on/off     Display memory percentage.
    --memory_unit kib/mib/gib   Memory output unit.
    --music_player player-name  Manually specify a player to use.
                                Available values are listed in the config file

TEXT FORMATTING:
    --colors x x x x x x        Changes the text colors in this order:
                                title, @, underline, subtitle, colon, info
    --underline on/off          Enable/Disable the underline.
    --underline_char char       Character to use when underlining title
    --bold on/off               Enable/Disable bold text
    --separator string          Changes the default ':' separator to the specified string.

COLOR BLOCKS:
    --color_blocks on/off       Enable/Disable the color blocks
    --col_offset auto/num       Left-padding of color blocks
    --block_width num           Width of color blocks in spaces
    --block_height num          Height of color blocks in lines
    --block_range num num       Range of colors to print as blocks

BARS:
    --bar_char 'elapsed char' 'total char'
                                Characters to use when drawing bars.
    --bar_border on/off         Whether or not to surround the bar with '[]'
    --bar_length num            Length in spaces to make the bars.
    --bar_colors num num        Colors to make the bar.
                                Set in this order: elapsed, total
    --memory_display mode       Bar mode.
                                Possible values: bar, infobar, barinfo, off
    --battery_display mode      Bar mode.
                                Possible values: bar, infobar, barinfo, off
    --disk_display mode         Bar mode.
                                Possible values: bar, infobar, barinfo, off

IMAGE BACKEND:
    --backend backend           Which image backend to use.
                                Possible values: 'ascii', 'caca', 'catimg', 'chafa', 'jp2a',
                                'iterm2', 'off', 'sixel', 'tycat', 'w3m', 'kitty', 'viu'
    --source source             Which image or ascii file to use.
                                Possible values: 'auto', 'ascii', 'wallpaper', '/path/to/img',
                                '/path/to/ascii', '/path/to/dir/', 'command output' [ascii]

    --ascii source              Shortcut to use 'ascii' backend.

                                NEW: neofetch --ascii \"\$(fortune | cowsay -W 30)\"

    --caca source               Shortcut to use 'caca' backend.
    --catimg source             Shortcut to use 'catimg' backend.
    --chafa source              Shortcut to use 'chafa' backend.
    --iterm2 source             Shortcut to use 'iterm2' backend.
    --jp2a source               Shortcut to use 'jp2a' backend.
    --kitty source              Shortcut to use 'kitty' backend.
    --pot source                Shortcut to use 'pot' backend.
    --pixterm source            Shortcut to use 'pixterm' backend.
    --sixel source              Shortcut to use 'sixel' backend.
    --termpix source            Shortcut to use 'termpix' backend.
    --tycat source              Shortcut to use 'tycat' backend.
    --w3m source                Shortcut to use 'w3m' backend.
    --ueberzug source           Shortcut to use 'ueberzug' backend
    --viu source                Shortcut to use 'viu' backend
    --off                       Shortcut to use 'off' backend (Disable ascii art).

    NOTE: 'source; can be any of the following: 'auto', 'ascii', 'wallpaper', '/path/to/img',
    '/path/to/ascii', '/path/to/dir/'

ASCII:
    --ascii_colors x x x x x x  Colors to print the ascii art
    --ascii_distro distro       Which Distro's ascii art to print

                                NOTE: AIX, Hash, Alpine, AlterLinux, Amazon, Anarchy, Android,
                                instantOS, Antergos, antiX, \"AOSC OS\", \"AOSC OS/Retro\",
                                Apricity, ArchCraft, ArcoLinux, ArchBox, ARCHlabs, ArchStrike,
                                XFerience, ArchMerge, Arch, Artix, Arya, Bedrock, Bitrig,
                                BlackArch, BLAG, BlankOn, BlueLight, Bodhi, bonsai, BSD, BunsenLabs,
                                Calculate, Carbs, CentOS, Chakra, ChaletOS, Chapeau, Chrom,
                                Cleanjaro, ClearOS, Clear_Linux, Clover, Condres, Container_Linux,
                                CrystalUX, CRUX, Cucumber, dahlia, Debian, Deepin, DesaOS, Devuan,
                                DracOS, DarkOs, Itc, DragonFly, Drauger, Elementary, EndeavourOS, Endless,
                                EuroLinux, Exherbo, Fedora, Feren, FreeBSD, FreeMiNT, Frugalware,
                                Funtoo, GalliumOS, Garuda, Gentoo, Pentoo, gNewSense, GNOME, GNU,
                                GoboLinux, Grombyang, Guix, Haiku, Huayra, Hyperbola, iglunix, janus, Kali,
                                KaOS, KDE_neon, Kibojoe, Kogaion, Korora, KSLinux, Kubuntu, LEDE,
                                LaxerOS, LibreELEC, LFS, Linux_Lite, LMDE, Lubuntu, Lunar, macos,
                                Mageia, MagpieOS, Mandriva, Manjaro, TeArch, Maui, Mer, Minix, LinuxMint,
                                Live_Raizo, MX_Linux, Namib, Neptune, NetBSD, Netrunner, Nitrux,
                                NixOS, Nurunner, NuTyX, OBRevenge, OpenBSD, openEuler, OpenIndiana,
                                openmamba, OpenMandriva, OpenStage, OpenWrt, osmc, Oracle,
                                OS Elbrus, PacBSD, Parabola, Pardus, Parrot, Parsix, TrueOS,
                                PCLinuxOS, Pengwin, Peppermint, Pisi, popos, Porteus, PostMarketOS,
                                Proxmox, PuffOS, Puppy, PureOS, Qubes, Quibian, Radix, Raspbian, Reborn_OS,
                                Redstar, Redcore, Redhat, Refracted_Devuan, Regata, Regolith, Rosa,
                                sabotage, Sabayon, Sailfish, SalentOS, Scientific, Septor,
                                SereneLinux, SharkLinux, Siduction, Slackware, SliTaz, SmartOS,
                                Solus, Source_Mage, Sparky, Star, SteamOS, SunOS, openSUSE_Leap,
                                t2, openSUSE_Tumbleweed, openSUSE, SwagArch, Tails, Trisquel,
                                Ubuntu-Cinnamon, Ubuntu-Budgie, Ubuntu-GNOME, Ubuntu-MATE,
                                Ubuntu-Studio, Ubuntu, Univention, Venom, Void, LangitKetujuh, semc,
                                Obarun, windows10, Windows7, Xubuntu, Zorin, and IRIX have ascii logos.

                                NOTE: Arch, Ubuntu, Redhat, Fedora and Dragonfly have 'old' logo variants.

                                NOTE: Use '{distro name}_old' to use the old logos.

                                NOTE: Ubuntu has flavor variants.

                                NOTE: Change this to Lubuntu, Kubuntu, Xubuntu, Ubuntu-GNOME,
                                Ubuntu-Studio, Ubuntu-Mate  or Ubuntu-Budgie to use the flavors.

                                NOTE: Arcolinux, Dragonfly, Fedora, Alpine, Arch, Ubuntu,
                                CRUX, Debian, Gentoo, FreeBSD, Mac, NixOS, OpenBSD, android,
                                Artix, CentOS, Cleanjaro, ElementaryOS, GUIX, Hyperbola,
                                Manjaro, MXLinux, NetBSD, Parabola, POP_OS, PureOS,
                                Slackware, SunOS, LinuxLite, OpenSUSE, Raspbian,
                                postmarketOS, and Void have a smaller logo variant.

                                NOTE: Use '{distro name}_small' to use the small variants.

    --ascii_bold on/off         Whether or not to bold the ascii logo.
    -L, --logo                  Hide the info text and only show the ascii logo.

IMAGE:
    --loop                      Redraw the image constantly until Ctrl+C is used. This fixes issues
                                in some terminals emulators when using image mode.
    --size 00px | --size 00%    How to size the image.
                                Possible values: auto, 00px, 00%, none
    --catimg_size 1/2           Change the resolution of catimg.
    --crop_mode mode            Which crop mode to use
                                Takes the values: normal, fit, fill
    --crop_offset value         Change the crop offset for normal mode.
                                Possible values: northwest, north, northeast,
                                west, center, east, southwest, south, southeast

    --xoffset px                How close the image will be to the left edge of the
                                window. This only works with w3m.
    --yoffset px                How close the image will be to the top edge of the
                                window. This only works with w3m.
    --bg_color color            Background color to display behind transparent image.
                                This only works with w3m.
    --gap num                   Gap between image and text.

                                NOTE: --gap can take a negative value which will move the text
                                closer to the left side.

    --clean                     Delete cached files and thumbnails.

OTHER:
    --config /path/to/config    Specify a path to a custom config file
    --config none               Launch the script without a config file
    --no_config                 Don't create the user config file.
    --print_config              Print the default config file to stdout.
    --stdout                    Turn off all colors and disables any ASCII/image backend.
    --help                      Print this text and exit
    --version                   Show neofetch version
    -v                          Display error messages.
    -vv                         Display a verbose log for error reporting.

DEVELOPER:
    --gen-man                   Generate a manpage for Neofetch in your PWD. (Requires GNU help2man)


Report bugs to https://github.com/dylanaraps/neofetch/issues

"
exit 1
}

get_args() {
    # Check the commandline flags early for '--config'.
    [[ "$*" != *--config* && "$*" != *--no_config* ]] && get_user_config

    while [[ "$1" ]]; do
        case $1 in
            # Info
            "--title_fqdn") title_fqdn="$2" ;;
            "--package_managers") package_managers="$2" ;;
            "--os_arch") os_arch="$2" ;;
            "--cpu_cores") cpu_cores="$2" ;;
            "--cpu_speed") cpu_speed="$2" ;;
            "--speed_type") speed_type="$2" ;;
            "--speed_shorthand") speed_shorthand="$2" ;;
            "--distro_shorthand") distro_shorthand="$2" ;;
            "--kernel_shorthand") kernel_shorthand="$2" ;;
            "--uptime_shorthand") uptime_shorthand="$2" ;;
            "--cpu_brand") cpu_brand="$2" ;;
            "--gpu_brand") gpu_brand="$2" ;;
            "--gpu_type") gpu_type="$2" ;;
            "--refresh_rate") refresh_rate="$2" ;;
            "--de_version") de_version="$2" ;;
            "--gtk_shorthand") gtk_shorthand="$2" ;;
            "--gtk2") gtk2="$2" ;;
            "--gtk3") gtk3="$2" ;;
            "--shell_path") shell_path="$2" ;;
            "--shell_version") shell_version="$2" ;;
            "--ip_host") public_ip_host="$2" ;;
            "--ip_timeout") public_ip_timeout="$2" ;;
            "--ip_interface")
                unset local_ip_interface
                for arg in "$@"; do
                    case "$arg" in
                        "--ip_interface") ;;
                        "-"*) break ;;
                        *) local_ip_interface+=("$arg") ;;
                    esac
                done
            ;;

            "--song_format") song_format="$2" ;;
            "--song_shorthand") song_shorthand="$2" ;;
            "--music_player") music_player="$2" ;;
            "--memory_percent") memory_percent="$2" ;;
            "--memory_unit") memory_unit="$2" ;;
            "--cpu_temp")
                cpu_temp="$2"
                [[ "$cpu_temp" == "on" ]] && cpu_temp="C"
            ;;

            "--disk_subtitle") disk_subtitle="$2" ;;
            "--disk_percent")  disk_percent="$2" ;;
            "--disk_show")
                unset disk_show
                for arg in "$@"; do
                    case $arg in
                        "--disk_show") ;;
                        "-"*) break ;;
                        *) disk_show+=("$arg") ;;
                    esac
                done
            ;;

            "--disable")
                for func in "$@"; do
                    case $func in
                        "--disable") continue ;;
                        "-"*) break ;;
                        *)
                            ((bash_version >= 4)) && func="${func,,}"
                            unset -f "get_$func"
                        ;;
                    esac
                done
            ;;

            # Text Colors
            "--colors")
                unset colors
                for arg in "$2" "$3" "$4" "$5" "$6" "$7"; do
                    case $arg in
                        "-"*) break ;;
                        *) colors+=("$arg") ;;
                    esac
                done
                colors+=(7 7 7 7 7 7)
            ;;

            # Text Formatting
            "--underline") underline_enabled="$2" ;;
            "--underline_char") underline_char="$2" ;;
            "--bold") bold="$2" ;;
            "--separator") separator="$2" ;;

            # Color Blocks
            "--color_blocks") color_blocks="$2" ;;
            "--block_range") block_range=("$2" "$3") ;;
            "--block_width") block_width="$2" ;;
            "--block_height") block_height="$2" ;;
            "--col_offset") col_offset="$2" ;;

            # Bars
            "--bar_char")
                bar_char_elapsed="$2"
                bar_char_total="$3"
            ;;

            "--bar_border") bar_border="$2" ;;
            "--bar_length") bar_length="$2" ;;
            "--bar_colors")
                bar_color_elapsed="$2"
                bar_color_total="$3"
            ;;

            "--memory_display") memory_display="$2" ;;
            "--battery_display") battery_display="$2" ;;
            "--disk_display") disk_display="$2" ;;

            # Image backend
            "--backend") image_backend="$2" ;;
            "--source") image_source="$2" ;;
            "--ascii" | "--caca" | "--catimg" | "--chafa" | "--jp2a" | "--iterm2" | "--off" |\
            "--pot" | "--pixterm" | "--sixel" | "--termpix" | "--tycat" | "--w3m" | "--kitty" |\
            "--ueberzug" | "--viu")
                image_backend="${1/--}"
                case $2 in
                    "-"* | "") ;;
                    *) image_source="$2" ;;
                esac
            ;;

            # Image options
            "--loop") image_loop="on" ;;
            "--image_size" | "--size") image_size="$2" ;;
            "--catimg_size") catimg_size="$2" ;;
            "--crop_mode") crop_mode="$2" ;;
            "--crop_offset") crop_offset="$2" ;;
            "--xoffset") xoffset="$2" ;;
            "--yoffset") yoffset="$2" ;;
            "--background_color" | "--bg_color") background_color="$2" ;;
            "--gap") gap="$2" ;;
            "--clean")
                [[ -d "$thumbnail_dir" ]] && rm -rf "$thumbnail_dir"
                rm -rf "/Library/Caches/neofetch/"
                rm -rf "/tmp/neofetch/"
                exit
            ;;

            "--ascii_colors")
                unset ascii_colors
                for arg in "$2" "$3" "$4" "$5" "$6" "$7"; do
                    case $arg in
                        "-"*) break ;;
                        *) ascii_colors+=("$arg")
                    esac
                done
                ascii_colors+=(7 7 7 7 7 7)
            ;;

            "--ascii_distro")
                image_backend="ascii"
                ascii_distro="$2"
            ;;

            "--ascii_bold") ascii_bold="$2" ;;
            "--logo" | "-L")
                image_backend="ascii"
                print_info() { printf '\n'; }
            ;;

            # Other
            "--config")
                case $2 in
                    "none" | "off" | "") ;;
                    *)
                        config_file="$(get_full_path "$2")"
                        get_user_config
                    ;;
                esac
            ;;
            "--no_config") no_config="on" ;;
            "--stdout") stdout="on" ;;
            "-v") verbose="on" ;;
            "--print_config") printf '%s\n' "$config"; exit ;;
            "-vv") set -x; verbose="on" ;;
            "--help") usage ;;
            "--version")
                printf '%s\n' "Neofetch $version"
                exit 1
            ;;
            "--gen-man")
                help2man -n "A fast, highly customizable system info script" \
                          -N ./neofetch -o neofetch.1
                exit 1
            ;;

            "--json")
                json="on"
                unset -f get_title get_cols get_underline

                printf '{\n'
                print_info 2>/dev/null
                printf '    %s\n' "\"Version\": \"${version}\""
                printf '}\n'
                exit
            ;;

            "--travis")
                print_info() {
                    info title
                    info underline

                    info "OS" distro
                    info "Host" model
                    info "Kernel" kernel
                    info "Uptime" uptime
                    info "Packages" packages
                    info "Shell" shell
                    info "Resolution" resolution
                    info "DE" de
                    info "WM" wm
                    info "WM Theme" wm_theme
                    info "Theme" theme
                    info "Icons" icons
                    info "Terminal" term
                    info "Terminal Font" term_font
                    info "CPU" cpu
                    info "GPU" gpu
                    info "GPU Driver" gpu_driver
                    info "Memory" memory

                    info "Disk" disk
                    info "Battery" battery
                    info "Font" font
                    info "Song" song
                    info "Local IP" local_ip
                    info "Public IP" public_ip
                    info "Users" users

                    info cols

                    # Testing.
                    prin "prin"
                    prin "prin" "prin"

                    # Testing no subtitles.
                    info uptime
                    info disk
                }

                refresh_rate="on"
                shell_version="on"
                memory_display="infobar"
                disk_display="infobar"
                cpu_temp="C"

                # Known implicit unused variables.
                mpc_args=()
                printf '%s\n' "$kernel $icons $font $battery $locale ${mpc_args[*]}"
            ;;
        esac

        shift
    done
}

get_simple() {
    while [[ "$1" ]]; do
        [[ "$(type -t "get_$1")" == "function" ]] && {
            get_distro
            stdout
            simple=1
            info "$1" "$1"
        }
        shift
    done
    ((simple)) && exit
}

old_functions() {
    # Removed functions for backwards compatibility.
    get_line_break() { :; }
    get_cpu_usage() { :; }
}

get_distro_ascii() {
    # This function gets the distro ascii art and colors.
    #
    # $ascii_distro is the same as $distro.
    case $(trim "$ascii_distro") in
        "AIX"*)
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c1}           `:+ssssossossss+-`
        .oys///oyhddddhyo///sy+.
      /yo:+hNNNNNNNNNNNNNNNNh+:oy/
    :h/:yNNNNNNNNNNNNNNNNNNNNNNy-+h:
  `ys.yNNNNNNNNNNNNNNNNNNNNNNNNNNy.ys
 `h+-mNNNNNNNNNNNNNNNNNNNNNNNNNNNNm-oh
 h+-NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN.oy
/d`mNNNNNNN/::mNNNd::m+:/dNNNo::dNNNd`m:
h//NNNNNNN: . .NNNh  mNo  od. -dNNNNN:+y
N.sNNNNNN+ -N/ -NNh  mNNd.   sNNNNNNNo-m
N.sNNNNNs  +oo  /Nh  mNNs` ` /mNNNNNNo-m
h//NNNNh  ossss` +h  md- .hm/ `sNNNNN:+y
:d`mNNN+/yNNNNNd//y//h//oNNNNy//sNNNd`m-
 yo-NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNm.ss
 `h+-mNNNNNNNNNNNNNNNNNNNNNNNNNNNNm-oy
   sy.yNNNNNNNNNNNNNNNNNNNNNNNNNNs.yo
    :h+-yNNNNNNNNNNNNNNNNNNNNNNs-oh-
      :ys:/yNNNNNNNNNNNNNNNmy/:sy:
        .+ys///osyhhhhys+///sy+.
            -/osssossossso/-
EOF
        ;;

	"Aperio GNU/Linux"*)
	    set_colors 255
	    read -rd '' ascii_data <<'EOF'
${c2}
 _.._  _ ._.. _
(_][_)(/,[  |(_)
   |   GNU/Linux
EOF
	;;

        "Hash"*)
            set_colors 123
            read -rd '' ascii_data <<'EOF'
${c1}

      +   ######   +
    ###   ######   ###
  #####   ######   #####
 ######   ######   ######

####### '"###### '"########
#######   ######   ########
#######   ######   ########

 ###### '"###### '"######
  #####   ######   #####
    ###   ######   ###
      ~   ######   ~

EOF
        ;;

        "AlmaLinux"*)
            set_colors 1 3 4 2 6
            read -rd '' ascii_data <<'EOF'
${c1}         'c:.
${c1}        lkkkx, ..       ${c2}..   ,cc,
${c1}        okkkk:ckkx'  ${c2}.lxkkx.okkkkd
${c1}        .:llcokkx'  ${c2}:kkkxkko:xkkd,
${c1}      .xkkkkdood:  ${c2};kx,  .lkxlll;
${c1}       xkkx.       ${c2}xk'     xkkkkk:
${c1}       'xkx.       ${c2}xd      .....,.
${c3}      .. ${c1}:xkl'     ${c2}:c      ..''..
${c3}    .dkx'  ${c1}.:ldl:'. ${c2}'  ${c4}':lollldkkxo;
${c3}  .''lkkko'                     ${c4}ckkkx.
${c3}'xkkkd:kkd.       ..  ${c5};'        ${c4}:kkxo.
${c3},xkkkd;kk'      ,d;    ${c5}ld.   ${c4}':dkd::cc,
${c3} .,,.;xkko'.';lxo.      ${c5}dx,  ${c4}:kkk'xkkkkc
${c3}     'dkkkkkxo:.        ${c5};kx  ${c4}.kkk:;xkkd.
${c3}       .....   ${c5}.;dk:.   ${c5}lkk.  ${c4}:;,
             ${c5}:kkkkkkkdoxkkx
              ,c,,;;;:xkkd.
                ;kkkkl...
                ;kkkkl
                 ,od;
EOF
        ;;

        "alpine_small")
            set_colors 4 7
            read -rd '' ascii_data <<'EOF'
${c1}   /\\ /\\
  /${c2}/ ${c1}\\  \\
 /${c2}/   ${c1}\\  \\
/${c2}//    ${c1}\\  \\
${c2}//      ${c1}\\  \\
         \\
EOF
        ;;

        "Alpine"*)
            set_colors 4 5 7 6
            read -rd '' ascii_data <<'EOF'
${c1}       .hddddddddddddddddddddddh.
      :dddddddddddddddddddddddddd:
     /dddddddddddddddddddddddddddd/
    +dddddddddddddddddddddddddddddd+
  `sdddddddddddddddddddddddddddddddds`
 `ydddddddddddd++hdddddddddddddddddddy`
.hddddddddddd+`  `+ddddh:-sdddddddddddh.
hdddddddddd+`      `+y:    .sddddddddddh
ddddddddh+`   `//`   `.`     -sddddddddd
ddddddh+`   `/hddh/`   `:s-    -sddddddd
ddddh+`   `/+/dddddh/`   `+s-    -sddddd
ddd+`   `/o` :dddddddh/`   `oy-    .yddd
hdddyo+ohddyosdddddddddho+oydddy++ohdddh
.hddddddddddddddddddddddddddddddddddddh.
 `yddddddddddddddddddddddddddddddddddy`
  `sdddddddddddddddddddddddddddddddds`
    +dddddddddddddddddddddddddddddd+
     /dddddddddddddddddddddddddddd/
      :dddddddddddddddddddddddddd:
       .hddddddddddddddddddddddh.
EOF
        ;;

        "Alter"*)
            set_colors 6 6
            read -rd '' ascii_data <<'EOF'
${c1}                      %,
                    ^WWWw
                   'wwwwww
                  !wwwwwwww
                 #`wwwwwwwww
                @wwwwwwwwwwww
               wwwwwwwwwwwwwww
              wwwwwwwwwwwwwwwww
             wwwwwwwwwwwwwwwwwww
            wwwwwwwwwwwwwwwwwwww,
           w~1i.wwwwwwwwwwwwwwwww,
         3~:~1lli.wwwwwwwwwwwwwwww.
        :~~:~?ttttzwwwwwwwwwwwwwwww
       #<~:~~~~?llllltO-.wwwwwwwwwww
      #~:~~:~:~~?ltlltlttO-.wwwwwwwww
     @~:~~:~:~:~~(zttlltltlOda.wwwwwww
    @~:~~: ~:~~:~:(zltlltlO    a,wwwwww
   8~~:~~:~~~~:~~~~_1ltltu          ,www
  5~~:~~:~~:~~:~~:~~~_1ltq             N,,
 g~:~~:~~~:~~:~~:~:~~~~1q                N,
EOF
        ;;

        "Amazon"*)
            set_colors 3 7
            read -rd '' ascii_data <<'EOF'
${c1}             `-/oydNNdyo:.`
      `.:+shmMMMMMMMMMMMMMMmhs+:.`
    -+hNNMMMMMMMMMMMMMMMMMMMMMMNNho-
.``      -/+shmNNMMMMMMNNmhs+/-      ``.
dNmhs+:.       `.:/oo/:.`       .:+shmNd
dMMMMMMMNdhs+:..        ..:+shdNMMMMMMMd
dMMMMMMMMMMMMMMNds    odNMMMMMMMMMMMMMMd
dMMMMMMMMMMMMMMMMh    yMMMMMMMMMMMMMMMMd
dMMMMMMMMMMMMMMMMh    yMMMMMMMMMMMMMMMMd
dMMMMMMMMMMMMMMMMh    yMMMMMMMMMMMMMMMMd
dMMMMMMMMMMMMMMMMh    yMMMMMMMMMMMMMMMMd
dMMMMMMMMMMMMMMMMh    yMMMMMMMMMMMMMMMMd
dMMMMMMMMMMMMMMMMh    yMMMMMMMMMMMMMMMMd
dMMMMMMMMMMMMMMMMh    yMMMMMMMMMMMMMMMMd
dMMMMMMMMMMMMMMMMh    yMMMMMMMMMMMMMMMMd
dMMMMMMMMMMMMMMMMh    yMMMMMMMMMMMMMMMMd
.:+ydNMMMMMMMMMMMh    yMMMMMMMMMMMNdy+:.
     `.:+shNMMMMMh    yMMMMMNhs+:``
            `-+shy    shs+:`
EOF
        ;;
        "AmogOS"*)
            set_colors 6 6 7 1
            read -rd '' ascii_data <<'EOF'
${c1}                   '
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣤⣤⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⠟⠉⠉⠉⠉⠉⠉⠉⠙⠻⢶⣄⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣷⡀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡟⠀⣠⣶⠛⠛⠛⠛⠛⠛⠳⣦⡀⠀⠘⣿⡄⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⠁⠀⢹⣿⣦⣀⣀⣀⣀⣀⣠⣼⡇⠀⠀⠸⣷⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡏⠀⠀⠀⠉⠛⠿⠿⠿⠿⠛⠋⠁⠀⠀⠀⠀⣿⡄
⠀⠀    ⠀⠀⢠⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡇⠀
      ⠀⠀⣸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣧⠀
⠀⠀⠀⠀⠀⠀⠀⢸⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⠀
⠀⠀⠀⠀⠀⠀⠀⣾⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀
⠀⠀⠀⠀⠀⠀⠀⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀
⠀⠀⠀⠀⠀⠀⢰⣿⠀⠀⠀⠀⣠⡶⠶⠿⠿⠿⠿⢷⣦⠀⠀⠀⠀⠀⠀⠀⣿⠀
⠀⠀⣀⣀⣀⠀⣸⡇⠀⠀⠀⠀⣿⡀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⣿⠀
⣠⡿⠛⠛⠛⠛⠻⠀⠀⠀⠀⠀⢸⣇⠀⠀⠀⠀⠀⠀⣿⠇⠀⠀⠀⠀⠀⠀⣿⠀
⢻⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⡟⠀⠀⢀⣤⣤⣴⣿⠀⠀⠀⠀⠀⠀⠀⣿⠀
⠈⠙⢷⣶⣦⣤⣤⣤⣴⣶⣾⠿⠛⠁⢀⣶⡟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡟⠀
          ⠀⠀⠀⠀⠈⣿⣆⡀⠀⠀⠀⠀⠀⠀⢀⣠⣴⡾⠃⠀
⠀        ⠀⠀⠀⠀⠀⠀⠈⠛⠻⢿⣿⣾⣿⡿⠿⠟⠋⠁⠀⠀⠀
EOF
        ;;
        "Anarchy"*)
            set_colors 7 4
            read -rd '' ascii_data <<'EOF'
                         ${c2}..${c1}
                        ${c2}..${c1}
                      ${c2}:..${c1}
                    ${c2}:+++.${c1}
              .:::++${c2}++++${c1}+::.
          .:+######${c2}++++${c1}######+:.
       .+#########${c2}+++++${c1}##########:.
     .+##########${c2}+++++++${c1}##${c2}+${c1}#########+.
    +###########${c2}+++++++++${c1}############:
   +##########${c2}++++++${c1}#${c2}++++${c1}#${c2}+${c1}###########+
  +###########${c2}+++++${c1}###${c2}++++${c1}#${c2}+${c1}###########+
 :##########${c2}+${c1}#${c2}++++${c1}####${c2}++++${c1}#${c2}+${c1}############:
 ###########${c2}+++++${c1}#####${c2}+++++${c1}#${c2}+${c1}###${c2}++${c1}######+
.##########${c2}++++++${c1}#####${c2}++++++++++++${c1}#######.
.##########${c2}+++++++++++++++++++${c1}###########.
 #####${c2}++++++++++++++${c1}###${c2}++++++++${c1}#########+
 :###${c2}++++++++++${c1}#########${c2}+++++++${c1}#########:
  +######${c2}+++++${c1}##########${c2}++++++++${c1}#######+
   +####${c2}+++++${c1}###########${c2}+++++++++${c1}#####+
    :##${c2}++++++${c1}############${c2}++++++++++${c1}##:
     .${c2}++++++${c1}#############${c2}++++++++++${c1}+.
      :${c2}++++${c1}###############${c2}+++++++${c1}::
     .${c2}++. .:+${c1}##############${c2}+++++++${c1}..
     ${c2}.:.${c1}      ..::++++++::..:${c2}++++${c1}+.
     ${c2}.${c1}                       ${c2}.:+++${c1}.
                                ${c2}.:${c1}:
                                   ${c2}..${c1}
                                    ${c2}..${c1}
EOF
        ;;

        "android_small"*)
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c1}  ;,           ,;
   ';,.-----.,;'
  ,'           ',
 /    O     O    \\
|                 |
'-----------------'
EOF
        ;;

        "Android"*)
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c1}         -o          o-
          +hydNNNNdyh+
        +mMMMMMMMMMMMMm+
      `dMM${c2}m:${c1}NMMMMMMN${c2}:m${c1}MMd`
      hMMMMMMMMMMMMMMMMMMh
  ..  yyyyyyyyyyyyyyyyyyyy  ..
.mMMm`MMMMMMMMMMMMMMMMMMMM`mMMm.
:MMMM-MMMMMMMMMMMMMMMMMMMM-MMMM:
:MMMM-MMMMMMMMMMMMMMMMMMMM-MMMM:
:MMMM-MMMMMMMMMMMMMMMMMMMM-MMMM:
:MMMM-MMMMMMMMMMMMMMMMMMMM-MMMM:
-MMMM-MMMMMMMMMMMMMMMMMMMM-MMMM-
 +yy+ MMMMMMMMMMMMMMMMMMMM +yy+
      mMMMMMMMMMMMMMMMMMMm
      `/++MMMMh++hMMMM++/`
          MMMMo  oMMMM
          MMMMo  oMMMM
          oNMm-  -mMNs
EOF
        ;;

    "instantOS"*)
        set_colors 4 6
        read -rd '' ascii_data <<'EOF'

${c1}
     'cx0XWWMMWNKOd:'.
  .;kNMMMMMMMMMMMMMWNKd'
 'kNMMMMMMWNNNWMMMMMMMMXo.
,0MMMMMW0o;'..,:dKWMMMMMWx.
OMMMMMXl.        .xNMMMMMNo
WMMMMNl           .kWWMMMMO'
MMMMMX;            oNWMMMMK,
NMMMMWo           .OWMMMMMK,
kWMMMMNd.        ,kWMMMMMMK,
'kWMMMMWXxl:;;:okNMMMMMMMMK,
 .oXMMMMMMMWWWMMMMMMMMMMMMK,
   'oKWMMMMMMMMMMMMMMMMMMMK,
     .;lxOKXXXXXXXXXXXXXXXO;......
          ................,d0000000kd:.
                          .kMMMMMMMMMW0;
                          .kMMMMMMMMMMMX
                          .xMMMMMMMMMMMW
                           cXMMMMMMMMMM0
                            :0WMMMMMMNx,
                             .o0NMWNOc.
EOF
        ;;

        "Antergos"*)
            set_colors 4 6
            read -rd '' ascii_data <<'EOF'
${c2}              `.-/::/-``
            .-/osssssssso/.
           :osyysssssssyyys+-
        `.+yyyysssssssssyyyyy+.
       `/syyyyyssssssssssyyyyys-`
      `/yhyyyyysss${c1}++${c2}ssosyyyyhhy/`
     .ohhhyyyys${c1}o++/+o${c2}so${c1}+${c2}syy${c1}+${c2}shhhho.
    .shhhhys${c1}oo++//+${c2}sss${c1}+++${c2}yyy${c1}+s${c2}hhhhs.
   -yhhhhs${c1}+++++++o${c2}ssso${c1}+++${c2}yyy${c1}s+o${c2}hhddy:
  -yddhhy${c1}o+++++o${c2}syyss${c1}++++${c2}yyy${c1}yooy${c2}hdddy-
 .yddddhs${c1}o++o${c2}syyyyys${c1}+++++${c2}yyhh${c1}sos${c2}hddddy`
`odddddhyosyhyyyyyy${c1}++++++${c2}yhhhyosddddddo
.dmdddddhhhhhhhyyyo${c1}+++++${c2}shhhhhohddddmmh.
ddmmdddddhhhhhhhso${c1}++++++${c2}yhhhhhhdddddmmdy
dmmmdddddddhhhyso${c1}++++++${c2}shhhhhddddddmmmmh
-dmmmdddddddhhys${c1}o++++o${c2}shhhhdddddddmmmmd-
.smmmmddddddddhhhhhhhhhdddddddddmmmms.
   `+ydmmmdddddddddddddddddddmmmmdy/.
      `.:+ooyyddddddddddddyyso+:.`
EOF
        ;;

        "antiX"*)
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
${c1}
                    \
         , - ~ ^ ~ - \        /
     , '              \ ' ,  /
   ,                   \   '/
  ,                     \  / ,
 ,___,                   \/   ,
 /   |   _  _  _|_ o     /\   ,
|,   |  / |/ |  |  |    /  \  ,
 \,_/\_/  |  |_/|_/|_/_/    \,
   ,                  /     ,\
     ,               /  , '   \
      ' - , _ _ _ ,  '
EOF
        ;;

        "AOSC OS/Retro"*)
            set_colors 4 7 1 3
            read -rd '' ascii_data <<'EOF'
${c2}          .........
     ...................
   .....................${c1}################${c2}
 ..............     ....${c1}################${c2}
..............       ...${c1}################${c2}
.............         ..${c1}****************${c2}
............     .     .${c1}****************${c2}
...........     ...     ${c1}................${c2}
..........     .....     ${c1}...............${c2}
.........     .......     ...
 .${c3}......                   ${c2}.
  ${c3}.....      .....${c2}....    ${c4}...........
  ${c3}....      ......${c2}.       ${c4}...........
  ${c3}...      .......        ${c4}...........
  ${c3}................        ${c4}***********
  ${c3}................        ${c4}###########
  ${c3}****************
  ${c3}################
EOF
        ;;

        "AOSC OS"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c2}             .:+syhhhhys+:.
         .ohNMMMMMMMMMMMMMMNho.
      `+mMMMMMMMMMMmdmNMMMMMMMMm+`
     +NMMMMMMMMMMMM/   `./smMMMMMN+
   .mMMMMMMMMMMMMMMo        -yMMMMMm.
  :NMMMMMMMMMMMMMMMs          .hMMMMN:
 .NMMMMhmMMMMMMMMMMm+/-         oMMMMN.
 dMMMMs  ./ymMMMMMMMMMMNy.       sMMMMd
-MMMMN`      oMMMMMMMMMMMN:      `NMMMM-
/MMMMh       NMMMMMMMMMMMMm       hMMMM/
/MMMMh       NMMMMMMMMMMMMm       hMMMM/
-MMMMN`      :MMMMMMMMMMMMy.     `NMMMM-
 dMMMMs       .yNMMMMMMMMMMMNy/. sMMMMd
 .NMMMMo         -/+sMMMMMMMMMMMmMMMMN.
  :NMMMMh.          .MMMMMMMMMMMMMMMN:
   .mMMMMMy-         NMMMMMMMMMMMMMm.
     +NMMMMMms/.`    mMMMMMMMMMMMN+
      `+mMMMMMMMMNmddMMMMMMMMMMm+`
         .ohNMMMMMMMMMMMMMMNho.
             .:+syhhhhys+:.
EOF
        ;;

        "Apricity"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c2}                                    ./o-
          ``...``              `:. -/:
     `-+ymNMMMMMNmho-`      :sdNNm/
   `+dMMMMMMMMMMMMMMMmo` sh:.:::-
  /mMMMMMMMMMMMMMMMMMMMm/`sNd/
 oMMMMMMMMMMMMMMMMMMMMMMMs -`
:MMMMMMMMMMMMMMMMMMMMMMMMM/
NMMMMMMMMMMMMMMMMMMMMMMMMMd
MMMMMMMmdmMMMMMMMMMMMMMMMMd
MMMMMMy` .mMMMMMMMMMMMmho:`
MMMMMMNo/sMMMMMMMNdy+-.`-/
MMMMMMMMMMMMNdy+:.`.:ohmm:
MMMMMMMmhs+-.`.:+ymNMMMy.
MMMMMM/`.-/ohmNMMMMMMy-
MMMMMMNmNNMMMMMMMMmo.
MMMMMMMMMMMMMMMms:`
MMMMMMMMMMNds/.
dhhyys+/-`
EOF
        ;;

        "Archcraft"*)
            set_colors 6 6 7 1
            read -rd '' ascii_data <<'EOF'
${c1}                   -m:
                  :NMM+      .+
                 +MMMMMo    -NMy
                sMMMMMMMy  -MMMMh`
               yMMMMMMMMMd` oMMMMd`
             `dMMMMMMMMMMMm. /MMMMm-
            .mMMMMMm-dMMMMMN- :NMMMN:
           -NMMMMMd`  yMMMMMN: .mMMMM/
          :NMMMMMy     sMMMMMM+ `dMMMMo
         +MMMMMMs       +MMMMMMs `hMMMMy
        oMMMMMMMds-      :NMMMMMy  sMMMMh`
       yMMMMMNoydMMmo`    -NMMMMMd` +MMMMd.
     `dMMMMMN-   `:yNNs`   .mMMMMMm. /MMMMm-
    .mMMMMMm.        :hN/   `dMMMMMN- -NMMMN:
   -NMMMMMd`           -hh`  `yMMMMMN: .mMMMM/
  :NMMMMMy         `s`   :h.   oMMMMMM+ `-----
 +MMMMMMo         .dMm.   `o.   +MMMMMMo
sMMMMMM+         .mMMMN:    :`   :NMMMMMy
EOF
        ;;

        "arcolinux_small"*)
            set_colors 7 4
            read -rd '' ascii_data <<'EOF'
${c2}          A
         ooo
        ooooo
       ooooooo
      ooooooooo
     ooooo ooooo
    ooooo   ooooo
   ooooo     ooooo
  ooooo  ${c1}<oooooooo>${c2}
 ooooo      ${c1}<oooooo>${c2}
ooooo          ${c1}<oooo>${c2}
EOF
        ;;

        "ArcoLinux"*)
            set_colors 7 4
            read -rd '' ascii_data <<'EOF'
${c2}                    /-
                   ooo:
                  yoooo/
                 yooooooo
                yooooooooo
               yooooooooooo
             .yooooooooooooo
            .oooooooooooooooo
           .oooooooarcoooooooo
          .ooooooooo-oooooooooo
         .ooooooooo-  oooooooooo
        :ooooooooo.    :ooooooooo
       :ooooooooo.      :ooooooooo
      :oooarcooo         .oooarcooo
     :ooooooooy           .ooooooooo
    :ooooooooo   ${c1}/ooooooooooooooooooo${c2}
   :ooooooooo      ${c1}.-ooooooooooooooooo.${c2}
  ooooooooo-             ${c1}-ooooooooooooo.${c2}
 ooooooooo-                 ${c1}.-oooooooooo.${c2}
ooooooooo.                     ${c1}-ooooooooo${c2}
EOF
        ;;

        "arch_small")
            set_colors 6 7 1
            read -rd '' ascii_data <<'EOF'
${c1}      /\\
     /  \\
    /\\   \\
${c2}   /      \\
  /   ,,   \\
 /   |  |  -\\
/_-''    ''-_\\
EOF
        ;;

        "arch_old")
            set_colors 6 7 1
            read -rd '' ascii_data <<'EOF'
${c1}             __
         _=(SDGJT=_
       _GTDJHGGFCVS)
      ,GTDJGGDTDFBGX0
${c1}     JDJDIJHRORVFSBSVL${c2}-=+=,_
${c1}    IJFDUFHJNXIXCDXDSV,${c2}  "DEBL
${c1}   [LKDSDJTDU=OUSCSBFLD.${c2}   '?ZWX,
${c1}  ,LMDSDSWH'     `DCBOSI${c2}     DRDS],
${c1}  SDDFDFH'         !YEWD,${c2}   )HDROD
${c1} !KMDOCG            &GSU|${c2}\_GFHRGO\'
${c1} HKLSGP'${c2}           __${c1}\TKM0${c2}\GHRBV)'
${c1}JSNRVW'${c2}       __+MNAEC${c1}\IOI,${c2}\BN'
${c1}HELK['${c2}    __,=OFFXCBGHC${c1}\FD)
${c1}?KGHE ${c2}\_-#DASDFLSV='${c1}    'EF
'EHTI                    !H
 `0F'                    '!
EOF
        ;;

        "ArchBox"*)
            set_colors 2 7 1
            read -rd '' ascii_data <<'EOF'
${c1}              ...:+oh/:::..
         ..-/oshhhhhh`   `::::-.
     .:/ohhhhhhhhhhhh`        `-::::.
 .+shhhhhhhhhhhhhhhhh`             `.::-.
 /`-:+shhhhhhhhhhhhhh`            .-/+shh
 /      .:/ohhhhhhhhh`       .:/ohhhhhhhh
 /           `-:+shhh`  ..:+shhhhhhhhhhhh
 /                 .:ohhhhhhhhhhhhhhhhhhh
 /                  `hhhhhhhhhhhhhhhhhhhh
 /                  `hhhhhhhhhhhhhhhhhhhh
 /                  `hhhhhhhhhhhhhhhhhhhh
 /                  `hhhhhhhhhhhhhhhhhhhh
 /      .+o+        `hhhhhhhhhhhhhhhhhhhh
 /     -hhhhh       `hhhhhhhhhhhhhhhhhhhh
 /     ohhhhho      `hhhhhhhhhhhhhhhhhhhh
 /:::+`hhhhoos`     `hhhhhhhhhhhhhhhhhs+`
    `--/:`   /:     `hhhhhhhhhhhho/-
             -/:.   `hhhhhhs+:-`
                ::::/ho/-`
EOF
        ;;

        "ARCHlabs"*)
            set_colors 6 6 7 1
            read -rd '' ascii_data <<'EOF'
${c1}                     'c'
                    'kKk,
                   .dKKKx.
                  .oKXKXKd.
                 .l0XXXXKKo.
                 c0KXXXXKX0l.
                :0XKKOxxOKX0l.
               :OXKOc. .c0XX0l.
              :OK0o. ${c4}...${c1}'dKKX0l.
             :OX0c  ${c4};xOx'${c1}'dKXX0l.
            :0KKo.${c4}.o0XXKd'.${c1}lKXX0l.
           c0XKd.${c4}.oKXXXXKd..${c1}oKKX0l.
         .c0XKk;${c4}.l0K0OO0XKd..${c1}oKXXKo.
        .l0XXXk:${c4},dKx,.'l0XKo.${c1}.kXXXKo.
       .o0XXXX0d,${c4}:x;   .oKKx'${c1}.dXKXXKd.
      .oKXXXXKK0c.${c4};.    :00c'${c1}cOXXXXXKd.
     .dKXXXXXXXXk,${c4}.     cKx'${c1}'xKXXXXXXKx'
    'xKXXXXK0kdl:.     ${c4}.ok; ${c1}.cdk0KKXXXKx'
   'xKK0koc,..         ${c4}'c, ${c1}    ..,cok0KKk,
  ,xko:'.             ${c4}.. ${c1}           .':okx;
 .,'.                                   .',.
EOF
        ;;

        "ArchStrike"*)
            set_colors 8 6
            read -rd '' ascii_data <<'EOF'
${c1}                   *   
                  **.
                 ****
                ******
                *******
              ** *******
             **** *******
            ${c1}****${c2}_____${c1}***${c2}/${c1}*
           ***${c2}/${c1}*******${c2}//${c1}***
          **${c2}/${c1}********${c2}///${c1}*${c2}/${c1}**
         **${c2}/${c1}*******${c2}////${c1}***${c2}/${c1}**
        **${c2}/${c1}****${c2}//////.,${c1}****${c2}/${c1}**
       ***${c2}/${c1}*****${c2}/////////${c1}**${c2}/${c1}***
      ****${c2}/${c1}****    ${c2}/////${c1}***${c2}/${c1}****
     ******${c2}/${c1}***  ${c2}////   ${c1}**${c2}/${c1}******
    ********${c2}/${c1}* ${c2}///      ${c1}*${c2}/${c1}********
  ,******     ${c2}// ______ /    ${c1}******,
EOF
        ;;

        *"XFerience"*)
            set_colors 6 6 7 1
            read -rd '' ascii_data <<'EOF'
${c1}           ``--:::::::-.`
        .-/+++ooooooooo+++:-`
     `-/+oooooooooooooooooo++:.
    -/+oooooo/+ooooooooo+/ooo++:`
  `/+oo++oo.   .+oooooo+.-: +:-o+-
 `/+o/.  -o.    :oooooo+ ```:.+oo+-
`:+oo-    -/`   :oooooo+ .`-`+oooo/.
.+ooo+.    .`   `://///+-+..oooooo+:`
-+ooo:`                ``.-+oooooo+/`
-+oo/`                       :+oooo/.
.+oo:            ..-/. .      -+oo+/`
`/++-         -:::++::/.      -+oo+-
 ./o:          `:///+-     `./ooo+:`
  .++-         `` /-`   -:/+oooo+:`
   .:+/:``          `-:ooooooo++-
     ./+o+//:...../+oooooooo++:`
       `:/++ooooooooooooo++/-`
          `.-//++++++//:-.`
               ``````
EOF
        ;;

        "ArchMerge"*)
            set_colors 6 6 7 1
            read -rd '' ascii_data <<'EOF'
${c1}                    y:
                  sMN-
                 +MMMm`
                /MMMMMd`
               :NMMMMMMy
              -NMMMMMMMMs
             .NMMMMMMMMMM+
            .mMMMMMMMMMMMM+
            oNMMMMMMMMMMMMM+
          `+:-+NMMMMMMMMMMMM+
          .sNMNhNMMMMMMMMMMMM/
        `hho/sNMMMMMMMMMMMMMMM/
       `.`omMMmMMMMMMMMMMMMMMMM+
      .mMNdshMMMMd+::oNMMMMMMMMMo
     .mMMMMMMMMM+     `yMMMMMMMMMs
    .NMMMMMMMMM/        yMMMMMMMMMy
   -NMMMMMMMMMh         `mNMMMMMMMMd`
  /NMMMNds+:.`             `-/oymMMMm.
 +Mmy/.                          `:smN:
/+.                                  -o.
EOF
        ;;

        "Arch"*)
            set_colors 6 6 7 1
            read -rd '' ascii_data <<'EOF'
${c1}                   -`
                  .o+`
                 `ooo/
                `+oooo:
               `+oooooo:
               -+oooooo+:
             `/:-:++oooo+:
            `/++++/+++++++:
           `/++++++++++++++:
          `/+++o${c2}oooooooo${c1}oooo/`
${c2}         ${c1}./${c2}ooosssso++osssssso${c1}+`
${c2}        .oossssso-````/ossssss+`
       -osssssso.      :ssssssso.
      :osssssss/        osssso+++.
     /ossssssss/        +ssssooo/-
   `/ossssso+/:-        -:/+osssso+-
  `+sso+:-`                 `.-/+oso:
 `++:.                           `-/+/
 .`                                 `/
EOF
        ;;

        "artix_small"*)
            set_colors 6 6 7 1
            read -rd '' ascii_data <<'EOF'
${c1}      /\\
     /  \\
    /`'.,\\
   /     ',
  /      ,`\\
 /   ,.'`.  \\
/.,'`     `'.\\
EOF
        ;;

        "Artix"*)
            set_colors 6 6 7 1
            read -rd '' ascii_data <<'EOF'
${c1}                   '
                  'o'
                 'ooo'
                'ooxoo'
               'ooxxxoo'
              'oookkxxoo'
             'oiioxkkxxoo'
            ':;:iiiioxxxoo'
               `'.;::ioxxoo'
          '-.      `':;jiooo'
         'oooio-..     `'i:io'
        'ooooxxxxoio:,.   `'-;'
       'ooooxxxxxkkxoooIi:-.  `'
      'ooooxxxxxkkkkxoiiiiiji'
     'ooooxxxxxkxxoiiii:'`     .i'
    'ooooxxxxxoi:::'`       .;ioxo'
   'ooooxooi::'`         .:iiixkxxo'
  'ooooi:'`                `'';ioxxo'
 'i:'`                          '':io'
'`                                   `'
EOF
        ;;

        "Arya"*)
            set_colors 2 1
            read -rd '' ascii_data <<'EOF'
${c1}                `oyyy/${c2}-yyyyyy+
${c1}               -syyyy/${c2}-yyyyyy+
${c1}              .syyyyy/${c2}-yyyyyy+
${c1}              :yyyyyy/${c2}-yyyyyy+
${c1}           `/ :yyyyyy/${c2}-yyyyyy+
${c1}          .+s :yyyyyy/${c2}-yyyyyy+
${c1}         .oys :yyyyyy/${c2}-yyyyyy+
${c1}        -oyys :yyyyyy/${c2}-yyyyyy+
${c1}       :syyys :yyyyyy/${c2}-yyyyyy+
${c1}      /syyyys :yyyyyy/${c2}-yyyyyy+
${c1}     +yyyyyys :yyyyyy/${c2}-yyyyyy+
${c1}   .oyyyyyyo. :yyyyyy/${c2}-yyyyyy+ ---------
${c1}  .syyyyyy+`  :yyyyyy/${c2}-yyyyy+-+syyyyyyyy
${c1} -syyyyyy/    :yyyyyy/${c2}-yyys:.syyyyyyyyyy
${c1}:syyyyyy/     :yyyyyy/${c2}-yyo.:syyyyyyyyyyy
EOF
        ;;

        "AsteroidOS"*)
            set_colors 160 208 202 214
            read -rd '' ascii_data <<'EOF'
${c1}                    ***
${c1}                   *****
${c1}                **********
${c1}              ***************
${c1}           *///****////****////.
${c2}         (/////// /////// ///////(
${c2}      /(((((//*     //,     //((((((.
${c2}    (((((((((((     (((        ((((((((
${c2} *(((((((((((((((((((((((        ((((((((
${c3}    (((((#(((((((#(((((        ((#(((((
${c3}     (#(#(#####(#(#,       ####(#(#
${c3}         #########        ########
${c3}           /########   ########
${c4}              #######%#######
${c4}                (#%%%%%%%#
${c4}                   %%%%%
${c4}                    %%%
EOF
        ;;

        "Bedrock"*)
            set_colors 8 7
            read -rd '' ascii_data <<'EOF'
${c1}--------------------------------------
--------------------------------------
--------------------------------------
---${c2}\\\\\\\\\\\\\\\\\\\\\\\\${c1}-----------------------
----${c2}\\\\\\      \\\\\\${c1}----------------------
-----${c2}\\\\\\      \\\\\\${c1}---------------------
------${c2}\\\\\\      \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\${c1}------
-------${c2}\\\\\\                    \\\\\\${c1}-----
--------${c2}\\\\\\                    \\\\\\${c1}----
---------${c2}\\\\\\        ______      \\\\\\${c1}---
----------${c2}\\\\\\                   ///${c1}---
-----------${c2}\\\\\\                 ///${c1}----
------------${c2}\\\\\\               ///${c1}-----
-------------${c2}\\\\\\////////////////${c1}------
--------------------------------------
--------------------------------------
--------------------------------------
EOF
        ;;

        "Bitrig"*)
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c1}   `hMMMMN+
   -MMo-dMd`
   oMN- oMN`
   yMd  /NM:
  .mMmyyhMMs
  :NMMMhsmMh
  +MNhNNoyMm-
  hMd.-hMNMN:
  mMmsssmMMMo
 .MMdyyhNMMMd
 oMN.`/dMddMN`
 yMm/hNm+./MM/
.dMMMmo.``.NMo
:NMMMNmmmmmMMh
/MN/-------oNN:
hMd.       .dMh
sm/         /ms
EOF
        ;;

        "BlackArch"*)
            set_colors 1 1 0 1
            read -rd '' ascii_data <<'EOF'
${c3}                   00
                   11
                  ====${c1}
                  .${c3}//${c1}
                 `o${c3}//${c1}:
                `+o${c3}//${c1}o:
               `+oo${c3}//${c1}oo:
               -+oo${c3}//${c1}oo+:
             `/:-:+${c3}//${c1}ooo+:
            `/+++++${c3}//${c1}+++++:
           `/++++++${c3}//${c1}++++++:
          `/+++o${c2}ooo${c3}//${c2}ooo${c1}oooo/`
${c2}         ${c1}./${c2}ooosssso${c3}//${c2}osssssso${c1}+`
${c2}        .oossssso-`${c3}//${c1}`/ossssss+`
       -osssssso.  ${c3}//${c1}  :ssssssso.
      :osssssss/   ${c3}//${c1}   osssso+++.
     /ossssssss/   ${c3}//${c1}   +ssssooo/-
   `/ossssso+/:-   ${c3}//${c1}   -:/+osssso+-
  `+sso+:-`        ${c3}//${c1}       `.-/+oso:
 `++:.             ${c3}//${c1}            `-/+/
 .`                ${c3}/${c1}                `/
EOF
        ;;

        "BLAG"*)
            set_colors 5 7
            read -rd '' ascii_data <<'EOF'
${c1}             d
            ,MK:
            xMMMX:
           .NMMMMMX;
           lMMMMMMMM0clodkO0KXWW:
           KMMMMMMMMMMMMMMMMMMX'
      .;d0NMMMMMMMMMMMMMMMMMMK.
 .;dONMMMMMMMMMMMMMMMMMMMMMMx
'dKMMMMMMMMMMMMMMMMMMMMMMMMl
   .:xKWMMMMMMMMMMMMMMMMMMM0.
       .:xNMMMMMMMMMMMMMMMMMK.
          lMMMMMMMMMMMMMMMMMMK.
          ,MMMMMMMMWkOXWMMMMMM0
          .NMMMMMNd.     `':ldko
           OMMMK:
           oWk,
           ;:
EOF
        ;;

        "BlankOn"*)
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
${c2}        `./ohdNMMMMNmho+.` ${c1}       .+oo:`
${c2}      -smMMMMMMMMMMMMMMMMmy-`    ${c1}`yyyyy+
${c2}   `:dMMMMMMMMMMMMMMMMMMMMMMd/`  ${c1}`yyyyys
${c2}  .hMMMMMMMNmhso/++symNMMMMMMMh- ${c1}`yyyyys
${c2} -mMMMMMMms-`         -omMMMMMMN-${c1}.yyyyys
${c2}.mMMMMMMy.              .yMMMMMMm:${c1}yyyyys
${c2}sMMMMMMy                 `sMMMMMMh${c1}yyyyys
${c2}NMMMMMN:                  .NMMMMMN${c1}yyyyys
${c2}MMMMMMm.                   NMMMMMN${c1}yyyyys
${c2}hMMMMMM+                  /MMMMMMN${c1}yyyyys
${c2}:NMMMMMN:                :mMMMMMM+${c1}yyyyys
${c2} oMMMMMMNs-            .sNMMMMMMs.${c1}yyyyys
${c2}  +MMMMMMMNho:.`  `.:ohNMMMMMMNo ${c1}`yyyyys
${c2}   -hMMMMMMMMNNNmmNNNMMMMMMMMh-  ${c1}`yyyyys
${c2}     :yNMMMMMMMMMMMMMMMMMMNy:`   ${c1}`yyyyys
${c2}       .:sdNMMMMMMMMMMNds/.      ${c1}`yyyyyo
${c2}           `.:/++++/:.`           ${c1}:oys+.
EOF
        ;;

        "BlueLight"*)
            set_colors 7 4
            read -rd '' ascii_data <<'EOF'
${c1}              oMMNMMMMMMMMMMMMMMMMMMMMMM
              oMMMMMMMMMMMMMMMMMMMMMMMMM
              oMMMMMMMMMMMMMMMMMMMMMMMMM
              oMMMMMMMMMMMMMMMMMMMMMMMMM
              -+++++++++++++++++++++++mM${c2}
             ```````````````````````..${c1}dM${c2}
           ```````````````````````....${c1}dM${c2}
         ```````````````````````......${c1}dM${c2}
       ```````````````````````........${c1}dM${c2}
     ```````````````````````..........${c1}dM${c2}
   ```````````````````````............${c1}dM${c2}
.::::::::::::::::::::::-..............${c1}dM${c2}
 `-+yyyyyyyyyyyyyyyyyyyo............${c1}+mMM${c2}
     -+yyyyyyyyyyyyyyyyo..........${c1}+mMMMM${c2}
        ./syyyyyyyyyyyyo........${c1}+mMMMMMM${c2}
           ./oyyyyyyyyyo......${c1}+mMMMMMMMM${c2}
              omdyyyyyyo....${c1}+mMMMMMMMMMM${c2}
              ${c1}oMMM${c2}mdhyyo..${c1}+mMMMMMMMMMMMM
              oNNNNNNm${c2}dso${c1}mMMMMMMMMMMMMMM
EOF
        ;;

       "Bodhi"*)
           set_colors 7 11 2
           read -rd '' ascii_data <<'EOF'
${c1}|           ${c2},,mmKKKKKKKKWm,,
 ${c1}'      ${c2},aKKP${c1}LL**********|L*${c2}TKp,
   ${c1}t  ${c2}aKP${c1}L**```          ```**L${c2}*Kp
    IX${c1}EL${c3}L,wwww,              ${c1}``*||${c2}Kp
  ,#P${c1}L|${c3}KKKpPP@IPPTKmw,          ${c1}`*||${c2}K
 ,K${c1}LL*${c3}{KKKKKKPPb$KPhpKKPKp        ${c1}`||${c2}K
 #${c1}PL  ${c3}!KKKKKKPhKPPP$KKEhKKKKp      ${c1}`||${c2}K
!H${c1}L*   ${c3}1KKKKKKKphKbPKKKKKK$KKp      ${c1}`|I${c2}W
$${c1}bL     ${c3}KKKKKKKKBQKhKbKKKKKKKK       ${c1}|I${c2}N
$${c1}bL     ${c3}!KKKKKKKKKKNKKKKKKKPP`       ${c1}|I${c2}b
TH${c1}L*     ${c3}TKKKKKK##KKKN@KKKK^         ${c1}|I${c2}M
 K@${c1}L      ${c3}*KKKKKKKKKKKEKE5          ${c1}||${c2}K
 `NL${c1}L      ${c3}`KKKKKKKKKK"```|L       ${c1}||${c2}#P
  `K@${c1}LL       ${c3}`"**"`        ${c1}'.   :||${c2}#P
    Yp${c1}LL                      ${c1}' |L${c2}$M`
     `Tp${c1}pLL,                ,|||${c2}p'L
        "Kpp${c1}LL++,.,    ,,|||$${c2}#K*   ${c1}'.
           ${c2}`"MKWpppppppp#KM"`        ${c1}`h,
EOF
       ;;

       "bonsai"*)
           set_colors 6 2 3
           read -rd '' ascii_data <<'EOF'
${c2}   ,####,
   ${c2}#######,  ${c2},#####,
   ${c2}#####',#  ${c2}'######
    ${c2}''###'${c3}';,,,'${c2}###'
   ${c3}       ,;  ''''
   ${c3}      ;;;   ${c2},#####,
   ${c3}     ;;;'  ,,;${c2};;###
   ${c3}     ';;;;''${c2}'####'
   ${c3}      ;;;
   ${c3}   ,.;;';'',,,
   ${c3}  '     '
${c1} #
 #                        O
 ##, ,##,',##, ,##  ,#,   ,
 # # #  # #''# #,,  # #   #
 '#' '##' #  #  ,,# '##;, #
EOF
       ;;

       "BSD")
            set_colors 1 7 4 3 6
            read -rd '' ascii_data <<'EOF'
${c1}             ,        ,
            /(        )`
            \ \___   / |
            /- _  `-/  '
           (${c2}/\/ \ ${c1}\   /\
           ${c2}/ /   | `    ${c1}\
           ${c3}O O   ${c2}) ${c1}/    |
           ${c2}`-^--'${c1}`<     '
          (_.)  _  )   /
           `.___/`    /
             `-----' /
${c4}<----.     __ / __   \
${c4}<----|====${c1}O)))${c4}==${c1}) \) /${c4}====|
<----'    ${c1}`--' `.__,' \
             |        |
              \       /       /\
         ${c5}______${c1}( (_  / \______/
       ${c5},'  ,-----'   |
       `--{__________)
EOF
        ;;

        "BunsenLabs"*)
            set_colors fg 7
            read -rd '' ascii_data <<'EOF'
${c1}        `++
      -yMMs
    `yMMMMN`
   -NMMMMMMm.
  :MMMMMMMMMN-
 .NMMMMMMMMMMM/
 yMMMMMMMMMMMMM/
`MMMMMMNMMMMMMMN.
-MMMMN+ /mMMMMMMy
-MMMm`   `dMMMMMM
`MMN.     .NMMMMM.
 hMy       yMMMMM`
 -Mo       +MMMMN
  /o       +MMMMs
           +MMMN`
           hMMM:
          `NMM/
          +MN:
          mh.
         -/
EOF
        ;;

        "Calculate"*)
            set_colors 7 3
            read -rd '' ascii_data <<'EOF'
${c1}                              ......
                           ,,+++++++,.
                         .,,,....,,,${c2}+**+,,.${c1}
                       ............,${c2}++++,,,${c1}
                      ...............
                    ......,,,........
                  .....+*#####+,,,*+.
              .....,*###############,..,,,,,,..
           ......,*#################*..,,,,,..,,,..
         .,,....*####################+***+,,,,...,++,
       .,,..,..*#####################*,
     ,+,.+*..*#######################.
   ,+,,+*+..,########################*
.,++++++.  ..+##**###################+
.....      ..+##***#################*.
           .,.*#*****##############*.
           ..,,*********#####****+.
     ${c2}.,++*****+++${c1}*****************${c2}+++++,.${c1}
      ${c2},++++++**+++++${c1}***********${c2}+++++++++,${c1}
     ${c2}.,,,,++++,..  .,,,,,.....,+++,.,,${c1}
EOF
        ;;
    "Carbs"*)
        set_colors 4 5 4 4 4 4
        read -rd '' ascii_data <<'EOF'
${c2}             ..........
          ..,;:ccccccc:;'..
       ..,clllc:;;;;;:cllc,.
      .,cllc,...     ..';;'.
     .;lol;..           ..
    .,lol;.
    .coo:.
   .'lol,.
   .,lol,.
   .,lol,.
    'col;.
    .:ooc'.
    .'col:.
     .'cllc'..          .''.
      ..:lolc,'.......',cll,.
        ..;cllllccccclllc;'.
          ...',;;;;;;,,...
                .....
EOF
        ;;


        "CelOS"*)
            set_colors 4 6 0 5
            read -rd '' ascii_data <<'EOF'

${c4}                     .,cmmmmmmmmmmmc,.
                .,cmMMMMMMMMMMMMMMMMMMMMmc.
             .cMMMMMMMMMMMMMMMMMMMMMMMMMMMmc.
           .cMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMc.
         ,:MMM ${c3}####################################${c4}
        cMMMMMMmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmc.
       .MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.
      .MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMc
      "******************************MMMMMMMMMMMMMc:
${c3}#################################### ${c4}MMMMMMMMMMMMMc
      "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:
       "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
       'MMMMMMMMM*******************************:
        \"MMMMMM ${c3}#####################################
         ${c4}`:MMMMMMmmmmmmmmmmmmmmmmmmmmmmmmmmmmm;
           `"MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
             `":MMMMMMMMMMMMMMMMMMMMMMMMM;'
                `":MMMMMMMMMMMMMMMMMMM:"
                     "************"




EOF
        ;;

        "centos_small"*)
            set_colors 3 2 4 5 7
            read -rd '' ascii_data <<'EOF'
${c2} ____${c1}^${c4}____
${c2} |\\  ${c1}|${c4}  /|
${c2} | \\ ${c1}|${c4} / |
${c4}<---- ${c3}---->
${c3} | / ${c2}|${c1} \\ |
${c3} |/__${c2}|${c1}__\\|
${c2}     v
EOF
        ;;

        "CentOS"*)
            set_colors 3 2 4 5 7
            read -rd '' ascii_data <<'EOF'
${c1}                 ..
               .PLTJ.
              <><><><>
     ${c2}KKSSV' 4KKK ${c1}LJ${c4} KKKL.'VSSKK
     ${c2}KKV' 4KKKKK ${c1}LJ${c4} KKKKAL 'VKK
     ${c2}V' ' 'VKKKK ${c1}LJ${c4} KKKKV' ' 'V
     ${c2}.4MA.' 'VKK ${c1}LJ${c4} KKV' '.4Mb.
${c4}   . ${c2}KKKKKA.' 'V ${c1}LJ${c4} V' '.4KKKKK ${c3}.
${c4} .4D ${c2}KKKKKKKA.'' ${c1}LJ${c4} ''.4KKKKKKK ${c3}FA.
${c4}<QDD ++++++++++++  ${c3}++++++++++++ GFD>
${c4} 'VD ${c3}KKKKKKKK'.. ${c2}LJ ${c1}..'KKKKKKKK ${c3}FV
${c4}   ' ${c3}VKKKKK'. .4 ${c2}LJ ${c1}K. .'KKKKKV ${c3}'
     ${c3} 'VK'. .4KK ${c2}LJ ${c1}KKA. .'KV'
     ${c3}A. . .4KKKK ${c2}LJ ${c1}KKKKA. . .4
     ${c3}KKA. 'KKKKK ${c2}LJ ${c1}KKKKK' .4KK
     ${c3}KKSSA. VKKK ${c2}LJ ${c1}KKKV .4SSKK
${c2}              <><><><>
               'MKKM'
                 ''
EOF
        ;;

        "Chakra"*)
            set_colors 4 5 7 6
            read -rd '' ascii_data <<'EOF'
${c1}     _ _ _        "kkkkkkkk.
   ,kkkkkkkk.,    'kkkkkkkkk,
   ,kkkkkkkkkkkk., 'kkkkkkkkk.
  ,kkkkkkkkkkkkkkkk,'kkkkkkkk,
 ,kkkkkkkkkkkkkkkkkkk'kkkkkkk.
  "''"''',;::,,"''kkk''kkkkk;   __
      ,kkkkkkkkkk, "k''kkkkk' ,kkkk
    ,kkkkkkk' ., ' .: 'kkkk',kkkkkk
  ,kkkkkkkk'.k'   ,  ,kkkk;kkkkkkkkk
 ,kkkkkkkk';kk 'k  "'k',kkkkkkkkkkkk
.kkkkkkkkk.kkkk.'kkkkkkkkkkkkkkkkkk'
;kkkkkkkk''kkkkkk;'kkkkkkkkkkkkk''
'kkkkkkk; 'kkkkkkkk.,""''"''""
  ''kkkk;  'kkkkkkkkkk.,
     ';'    'kkkkkkkkkkkk.,
             ';kkkkkkkkkk'
               ';kkkkkk'
                  "''"
EOF
        ;;

        "ChaletOS"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}             `.//+osso+/:``
         `/sdNNmhyssssydmNNdo:`
       :hNmy+-`          .-+hNNs-
     /mMh/`       `+:`       `+dMd:
   .hMd-        -sNNMNo.  /yyy  /mMs`
  -NM+       `/dMd/--omNh::dMM   `yMd`
 .NN+      .sNNs:/dMNy:/hNmo/s     yMd`
 hMs    `/hNd+-smMMMMMMd+:omNy-    `dMo
:NM.  .omMy:/hNMMMMMMMMMMNy:/hMd+`  :Md`
/Md` `sm+.omMMMMMMMMMMMMMMMMd/-sm+  .MN:
/Md`      MMMMMMMMMMMMMMMMMMMN      .MN:
:NN.      MMMMMMm....--NMMMMMN      -Mm.
`dMo      MMMMMMd      mMMMMMN      hMs
 -MN:     MMMMMMd      mMMMMMN     oMm`
  :NM:    MMMMMMd      mMMMMMN    +Mm-
   -mMy.  mmmmmmh      dmmmmmh  -hMh.
     oNNs-                    :yMm/
      .+mMdo:`            `:smMd/`
         -ohNNmhsoo++osshmNNh+.
            `./+syyhhyys+:``
EOF
        ;;

        "Chapeau"*)
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c1}               .-/-.
            ////////.
          ////////${c2}y+${c1}//.
        ////////${c2}mMN${c1}/////.
      ////////${c2}mMN+${c1}////////.
    ////////////////////////.
  /////////+${c2}shhddhyo${c1}+////////.
 ////////${c2}ymMNmdhhdmNNdo${c1}///////.
///////+${c2}mMms${c1}////////${c2}hNMh${c1}///////.
///////${c2}NMm+${c1}//////////${c2}sMMh${c1}///////
//////${c2}oMMNmmmmmmmmmmmmMMm${c1}///////
//////${c2}+MMmssssssssssssss+${c1}///////
`//////${c2}yMMy${c1}////////////////////
 `//////${c2}smMNhso++oydNm${c1}////////
  `///////${c2}ohmNMMMNNdy+${c1}///////
    `//////////${c2}++${c1}//////////
       `////////////////.
           -////////-
EOF
        ;;

        "Chrom"*)
            set_colors 2 1 3 4 7
            read -rd '' ascii_data <<'EOF'
${c2}            .,:loool:,.
        .,coooooooooooooc,.
     .,lllllllllllllllllllll,.
    ;ccccccccccccccccccccccccc;
${c1}  '${c2}ccccccccccccccccccccccccccccc.
${c1} ,oo${c2}c::::::::okO${c5}000${c3}0OOkkkkkkkkkkk:
${c1}.ooool${c2};;;;:x${c5}K0${c4}kxxxxxk${c5}0X${c3}K0000000000.
${c1}:oooool${c2};,;O${c5}K${c4}ddddddddddd${c5}KX${c3}000000000d
${c1}lllllool${c2};l${c5}N${c4}dllllllllllld${c5}N${c3}K000000000
${c1}lllllllll${c2}o${c5}M${c4}dccccccccccco${c5}W${c3}K000000000
${c1};cllllllllX${c5}X${c4}c:::::::::c${c5}0X${c3}000000000d
${c1}.ccccllllllO${c5}Nk${c4}c;,,,;cx${c5}KK${c3}0000000000.
${c1} .cccccclllllxOO${c5}OOO${c1}Okx${c3}O0000000000;
${c1}  .:ccccccccllllllllo${c3}O0000000OOO,
${c1}    ,:ccccccccclllcd${c3}0000OOOOOOl.
${c1}      '::ccccccccc${c3}dOOOOOOOkx:.
${c1}        ..,::cccc${c3}xOOOkkko;.
${c1}            ..,:${c3}dOkxl:.
EOF
        ;;

        "cleanjaro_small"*)
            set_colors 7 7
            read -rd '' ascii_data <<'EOF'
${c1}█████ ██████████
█████ ██████████
█████
█████
█████
████████████████
████████████████
EOF
        ;;

        "Cleanjaro"*)
            set_colors 7 7
            read -rd '' ascii_data <<'EOF'
${c1}███████▌ ████████████████
███████▌ ████████████████
███████▌ ████████████████
███████▌
███████▌
███████▌
███████▌
███████▌
█████████████████████████
█████████████████████████
█████████████████████████
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
EOF
        ;;

        "ClearOS"*)
            set_colors 2
            read -rd '' ascii_data <<'EOF'
${c1}             `.--::::::--.`
         .-:////////////////:-.
      `-////////////////////////-`
     -////////////////////////////-
   `//////////////-..-//////////////`
  ./////////////:      ://///////////.
 `//////:..-////:      :////-..-//////`
 ://////`    -///:.``.:///-`    ://///:
`///////:.     -////////-`    `:///////`
.//:--////:.     -////-`    `:////--://.
./:    .////:.     --`    `:////-    :/.
`//-`    .////:.        `:////-    `-//`
 :///-`    .////:.    `:////-    `-///:
 `/////-`    -///:    :///-    `-/////`
  `//////-   `///:    :///`   .//////`
   `:////:   `///:    :///`   -////:`
     .://:   `///:    :///`   -//:.
       .::   `///:    :///`   -:.
             `///:    :///`
              `...    ...`
EOF
        ;;

        "Clear Linux OS"* | "Clear_Linux"*)
            set_colors 4 3 7 6
            read -rd '' ascii_data <<'EOF'
${c1}          BBB
       BBBBBBBBB
     BBBBBBBBBBBBBBB
   BBBBBBBBBBBBBBBBBBBB
   BBBBBBBBBBB         BBB
  BBBBBBBB${c2}YYYYY
${c1}  BBBBBBBB${c2}YYYYYY
${c1}  BBBBBBBB${c2}YYYYYYY
${c1}  BBBBBBBBB${c2}YYYYY${c3}W
${c4} GG${c1}BBBBBBBY${c2}YYYY${c3}WWW
${c4} GGG${c1}BBBBBBB${c2}YY${c3}WWWWWWWW
${c4} GGGGGG${c1}BBBBBB${c3}WWWWWWWW
${c4} GGGGGGGG${c1}BBBB${c3}WWWWWWWW
${c4}GGGGGGGGGGG${c1}BBB${c3}WWWWWWW
${c4}GGGGGGGGGGGGG${c1}B${c3}WWWWWW
${c4}GGGGGGGG${c3}WWWWWWWWWWW
${c4}GG${c3}WWWWWWWWWWWWWWWW
 WWWWWWWWWWWWWWWW
      WWWWWWWWWW
          WWW
EOF
        ;;

        "Clover"*)
            set_colors 2 6
            read -rd '' ascii_data <<'EOF'
${c1}               `omo``omo`
             `oNMMMNNMMMNo`
           `oNMMMMMMMMMMMMNo`
          oNMMMMMMMMMMMMMMMMNo
          `sNMMMMMMMMMMMMMMNs`
     `omo`  `sNMMMMMMMMMMNs`  `omo`
   `oNMMMNo`  `sNMMMMMMNs`  `oNMMMNo`
 `oNMMMMMMMNo`  `oNMMNs`  `oNMMMMMMMNo`
oNMMMMMMMMMMMNo`  `sy`  `oNMMMMMMMMMMMNo
`sNMMMMMMMMMMMMNo.${c2}oNNs${c1}.oNMMMMMMMMMMMMNs`
`oNMMMMMMMMMMMMNs.${c2}oNNs${c1}.oNMMMMMMMMMMMMNo`
oNMMMMMMMMMMMNs`  `sy`  `oNMMMMMMMMMMMNo
 `oNMMMMMMMNs`  `oNMMNo`  `oNMMMMMMMNs`
   `oNMMMNs`  `sNMMMMMMNs`  `oNMMMNs`
     `oNs`  `sNMMMMMMMMMMNs`  `oNs`
          `sNMMMMMMMMMMMMMMNs`
          +NMMMMMMMMMMMMMMMMNo
           `oNMMMMMMMMMMMMNo`
             `oNMMMNNMMMNs`
               `omo``oNs`
EOF
        ;;

        "Condres"*)
            set_colors 2 3 6
            read -rd '' ascii_data <<'EOF'
${c1}syyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy+${c3}.+.
${c1}`oyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy+${c3}:++.
${c2}/o${c1}+oyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy/${c3}oo++.
${c2}/y+${c1}syyyyyyyyyyyyyyyyyyyyyyyyyyyyy${c3}+ooo++.
${c2}/hy+${c1}oyyyhhhhhhhhhhhhhhyyyyyyyyy${c3}+oo+++++.
${c2}/hhh+${c1}shhhhhdddddhhhhhhhyyyyyyy${c3}+oo++++++.
${c2}/hhdd+${c1}oddddddddddddhhhhhyyyys${c3}+oo+++++++.
${c2}/hhddd+${c1}odmmmdddddddhhhhyyyy${c3}+ooo++++++++.
${c2}/hhdddmo${c1}odmmmdddddhhhhhyyy${c3}+oooo++++++++.
${c2}/hdddmmms${c1}/dmdddddhhhhyyys${c3}+oooo+++++++++.
${c2}/hddddmmmy${c1}/hdddhhhhyyyyo${c3}+oooo++++++++++:
${c2}/hhdddmmmmy${c1}:yhhhhyyyyy+${c3}+oooo+++++++++++:
${c2}/hhddddddddy${c1}-syyyyyys+${c3}ooooo++++++++++++:
${c2}/hhhddddddddy${c1}-+yyyy+${c3}/ooooo+++++++++++++:
${c2}/hhhhhdddddhhy${c1}./yo:${c3}+oooooo+++++++++++++/
${c2}/hhhhhhhhhhhhhy${c1}:-.${c3}+sooooo+++++++++++///:
${c2}:sssssssssssso++${c1}${c3}`:/:--------.````````
EOF
        ;;

        "Container Linux by CoreOS"* | "Container_Linux"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}                .....
          .';:cccccccc:;'.
        ':ccccclc${c3}lllllllll${c1}cc:.
     .;cccccccc${c3}lllllllllllllll${c1}c,
    ;clllccccc${c3}llllllllllllllllll${c1}c,
  .cllclccccc${c3}lllll${c2}lll${c3}llllllllllll${c1}c:
  ccclclcccc${c3}cllll${c2}kWMMNKk${c3}llllllllll${c1}c:
 :ccclclcccc${c3}llll${c2}oWMMMMMMWO${c3}lllllllll${c1}c,
.ccllllllccc${c3}clll${c2}OMMMMMMMMM0${c3}lllllllll${c1}c
.lllllclcccc${c3}llll${c2}KMMMMMMMMMMo${c3}llllllll${c1}c.
.lllllllcccc${c3}clll${c2}KMMMMMMMMN0${c3}lllllllll${c1}c.
.cclllllcccc${c3}lllld${c2}xkkxxdo${c3}llllllllllc${c1}lc
 :cccllllllcccc${c3}lllccllllcclccc${c1}cccccc;
 .ccclllllllcccccccc${c3}lll${c1}ccccclccccccc
  .cllllllllllclcccclccclccllllcllc
    :cllllllllccclcllllllllllllcc;
     .cccccccccccccclcccccccccc:.
       .;cccclccccccllllllccc,.
          .';ccccclllccc:;..
                .....
EOF
        ;;

        "crux_small"|KISS*)
            set_colors 4 5 7 6
            read -rd '' ascii_data <<'EOF'
${c1}    ___
   (${c3}.· ${c1}|
   (${c2}<> ${c1}|
  / ${c3}__  ${c1}\\
 ( ${c3}/  \\ ${c1}/|
${c2}_${c1}/\\ ${c3}__)${c1}/${c2}_${c1})
${c2}\/${c1}-____${c2}\/
EOF
        ;;

        "CRUX"*)
            set_colors 4 5 7 6
            read -rd '' ascii_data <<'EOF'
${c1}         odddd
      oddxkkkxxdoo
     ddcoddxxxdoool
     xdclodod  olol
     xoc  xdd  olol
     xdc  ${c2}k00${c1}Okdlol
     xxd${c2}kOKKKOkd${c1}ldd
     xdco${c2}xOkdlo${c1}dldd
     ddc:cl${c2}lll${c1}oooodo
   odxxdd${c3}xkO000kx${c1}ooxdo
  oxdd${c3}x0NMMMMMMWW0od${c1}kkxo
 oooxd${c3}0WMMMMMMMMMW0o${c1}dxkx
docldkXW${c3}MMMMMMMWWN${c1}Odolco
xx${c2}dx${c1}kxxOKN${c3}WMMWN${c1}0xdoxo::c
${c2}xOkkO${c1}0oo${c3}odOW${c2}WW${c1}XkdodOxc:l
${c2}dkkkxkkk${c3}OKX${c2}NNNX0Oxx${c1}xc:cd
${c2} odxxdx${c3}xllod${c2}ddooxx${c1}dc:ldo
${c2}   lodd${c1}dolccc${c2}ccox${c1}xoloo
EOF
        ;;

        *"CrystalUX"*)
            set_colors 13 5
            read -rd '' ascii_data <<'EOF'
${c1}                        mysssym
${c1}                      mysssym
${c1}                    mysssym
${c1}                  mysssym
${c1}                mysssyd
${c1}              mysssyd    N
${c1}            mysssyd    mysym
${c1}          mysssyd      dysssym
${c1}        mysssyd          dysssym
${c1}      mysssyd              dysssym
${c1}      mysssyd              dysssym
${c1}        mysssyd          dysssym
${c1}          mysssyd      dysssym
${c1}            mysym    dysssym
${c1}              N    dysssym
${c1}                 dysssym
${c1}               dysssym
${c1}             dysssym
${c1}           dysssym
${c1}         dysssym
EOF
        ;;

        *"Cucumber"*)
            set_colors 2 3
            read -rd '' ascii_data <<'EOF'
${c1}           `.-://++++++//:-.`
        `:/+//${c2}::--------${c1}:://+/:`
      -++/:${c2}----..........----${c1}:/++-
    .++:${c2}---...........-......---${c1}:++.
   /+:${c2}---....-::/:/--//:::-....---${c1}:+/
 `++:${c2}--.....:---::/--/::---:.....--${c1}:++`
 /+:${c2}--.....--.--::::-/::--.--.....--${c1}:+/
-o:${c2}--.......-:::://--/:::::-.......--${c1}:o-
/+:${c2}--...-:-::---:::..:::---:--:-...--${c1}:+/
o/:${c2}-...-:.:.-/:::......::/:.--.:-...-${c1}:/o
o/${c2}--...::-:/::/:-......-::::::-/-...-${c1}:/o
/+:${c2}--..-/:/:::--:::..:::--::////-..--${c1}:+/
-o:${c2}--...----::/:::/--/:::::-----...--${c1}:o-
 /+:${c2}--....://:::.:/--/:.::://:....--${c1}:+/
 `++:${c2}--...-:::.--.:..:.--.:/:-...--${c1}:++`
   /+:${c2}---....----:-..-:----....---${c1}:+/
    .++:${c2}---..................---${c1}:++.
      -/+/:${c2}----..........----${c1}:/+/-
        `:/+//${c2}::--------:::${c1}/+/:`
           `.-://++++++//:-.`
EOF
        ;;

        "CyberOS"*)
            set_colors 50 32 57
            read -rd '' ascii_data <<'EOF'
${c3}             !M$EEEEEEEEEEEP
            .MMMMM000000Nr.
            ${c3}&MMMMMM${c2}MMMMMMMMMMMMM9
           ${c3}~MMM${c1}MMMM${c2}MMMMMMMMMMMMC
      ${c1}"    ${c3}M${c1}MMMMMMM${c2}MMMMMMMMMMs
    ${c1}iM${c2}MMM&&${c1}MMMMMMMM${c2}MMMMMMMM\\
   ${c1}BMMM${c2}MMMMM${c1}MMMMMMM${c2}MMMMMM${c3}"
  ${c1}9MMMMM${c2}MMMMMMM${c1}MMMM${c2}MMMM${c3}MMMf-
        ${c2}sMMMMMMMM${c1}MM${c2}M${c3}MMMMMMMMM3_
         ${c2}+ffffffff${c1}P${c3}MMMMMMMMMMMM0
                    ${c2}CMMMMMMMMMMM
                      }MMMMMMMMM
                        ~MMMMMMM
                          "RMMMM
                            .PMB
EOF
        ;;

                "dahlia"*)
                    set_colors 1 7 3
                    read -rd '' ascii_data <<'EOF'
${c1}
                  .#.
                *%@@@%*
        .,,,,,(&@@@@@@@&/,,,,,.
       ,#@@@@@@@@@@@@@@@@@@@@@#.
       ,#@@@@@@@&#///#&@@@@@@@#.
     ,/%&@@@@@%/,    .,(%@@@@@&#/.
   *#&@@@@@@#,.         .*#@@@@@@&#,
 .&@@@@@@@@@(            .(@@@@@@@@@&&.
#@@@@@@@@@@(               )@@@@@@@@@@@#
 °@@@@@@@@@@(            .(@@@@@@@@@@@°
   *%@@@@@@@(.           ,#@@@@@@@%*
     ,(&@@@@@@%*.     ./%@@@@@@%(,
       ,#@@@@@@@&(***(&@@@@@@@#.
       ,#@@@@@@@@@@@@@@@@@@@@@#.
        ,*****#&@@@@@@@&(*****,
               ,/%@@@%/.
                  ,#,
EOF
                ;;

        "debian_small")
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
${c1}  _____
 /  __ \\
|  /    |
|  \\___-
-_
  --_
EOF
        ;;

        "Debian"*)
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
${c2}       _,met$$$$$gg.
    ,g$$$$$$$$$$$$$$$P.
  ,g$$P"        """Y$$.".
 ,$$P'              `$$$.
',$$P       ,ggs.     `$$b:
`d$$'     ,$P"'   ${c1}.${c2}    $$$
 $$P      d$'     ${c1},${c2}    $$P
 $$:      $$.   ${c1}-${c2}    ,d$$'
 $$;      Y$b._   _,d$P'
 Y$$.    ${c1}`.${c2}`"Y$$$$P"'
${c2} `$$b      ${c1}"-.__
${c2}  `Y$$
   `Y$$.
     `$$b.
       `Y$$b.
          `"Y$b._
              `"""
EOF
        ;;

        "Deepin"*)
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c1}             ............
         .';;;;;.       .,;,.
      .,;;;;;;;.       ';;;;;;;.
    .;::::::::'     .,::;;,''''',.
   ,'.::::::::    .;;'.          ';
  ;'  'cccccc,   ,' :: '..        .:
 ,,    :ccccc.  ;: .c, '' :.       ,;
.l.     cllll' ., .lc  :; .l'       l.
.c       :lllc  ;cl:  .l' .ll.      :'
.l        'looc. .   ,o:  'oo'      c,
.o.         .:ool::coc'  .ooo'      o.
 ::            .....   .;dddo      ;c
  l:...            .';lddddo.     ,o
   lxxxxxdoolllodxxxxxxxxxc      :l
    ,dxxxxxxxxxxxxxxxxxxl.     'o,
      ,dkkkkkkkkkkkkko;.    .;o;
        .;okkkkkdl;.    .,cl:.
            .,:cccccccc:,.
EOF
        ;;

        "DesaOS")
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c1}███████████████████████
███████████████████████
███████████████████████
███████████████████████
████████               ███████
████████               ███████
████████               ███████
████████               ███████
████████               ███████
████████               ███████
████████               ███████
██████████████████████████████
██████████████████████████████
████████████████████████
████████████████████████
████████████████████████
EOF
        ;;

        "Devuan"*)
            set_colors 5 7
            read -rd '' ascii_data <<'EOF'
${c1}   ..,,;;;::;,..
           `':ddd;:,.
                 `'dPPd:,.
                     `:b$$b`.
                        'P$$$d`
                         .$$$$$`
                         ;$$$$$P
                      .:P$$$$$$`
                  .,:b$$$$$$$;'
             .,:dP$$$$$$$$b:'
      .,:;db$$$$$$$$$$Pd'`
 ,db$$$$$$$$$$$$$$b:'`
:$$$$$$$$$$$$b:'`
 `$$$$$bd:''`
   `'''`
EOF
        ;;

        "DracOS"*)
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
${c1}       `-:/-
          -os:
            -os/`
              :sy+-`
               `/yyyy+.
                 `+yyyyo-
                   `/yyyys:
`:osssoooo++-        +yyyyyy/`
   ./yyyyyyo         yo`:syyyy+.
      -oyyy+         +-   :yyyyyo-
        `:sy:        `.    `/yyyyys:
           ./o/.`           .oyyso+oo:`
              :+oo+//::::///:-.`     `.`
EOF
        ;;

        "DarkOs")
            set_colors 1 6 5 3 2
            read -rd '' ascii_data <<'EOF'

${c3}⠀⠀⠀⠀  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠢⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
${c1}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣶⠋⡆⢹⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
${c5}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡆⢀⣤⢛⠛⣠⣿⠀⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
${c6}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣶⣿⠟⣡⠊⣠⣾⣿⠃⣠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
${c2}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣯⣿⠀⠊⣤⣿⣿⣿⠃⣴⣧⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
${c1}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣶⣿⣿⡟⣠⣶⣿⣿⣿⢋⣤⠿⠛⠉⢁⣭⣽⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
${c4}  ⠀⠀⠀⠀⠀⠀ ⠀⣠⠖⡭⢉⣿⣯⣿⣯⣿⣿⣿⣟⣧⠛⢉⣤⣶⣾⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
${c5}⠀⠀⠀⠀⠀⠀⠀⠀⣴⣫⠓⢱⣯⣿⢿⠋⠛⢛⠟⠯⠶⢟⣿⣯⣿⣿⣿⣿⣿⣿⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
${c2}⠀⠀⠀⠀⠀⠀⢀⡮⢁⣴⣿⣿⣿⠖⣠⠐⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠛⠛⠛⢿⣶⣄⠀⠀⠀⠀⠀⠀⠀
${c3}⠀⠀⠀⠀⢀⣤⣷⣿⣿⠿⢛⣭⠒⠉⠀⠀⠀⣀⣀⣄⣤⣤⣴⣶⣶⣶⣿⣿⣿⣿⣿⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀
${c1}⠀⢀⣶⠏⠟⠝⠉⢀⣤⣿⣿⣶⣾⣿⣿⣿⣿⣿⣿⣟⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
${c6}⢴⣯⣤⣶⣿⣿⣿⣿⣿⡿⣿⣯⠉⠉⠉⠉⠀⠀⠀⠈⣿⡀⣟⣿⣿⢿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
${c5}⠀⠀⠀⠉⠛⣿⣧⠀⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠃⣿⣿⣯⣿⣦⡀⠀⠉⠻⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀
${c3}⠀⠀⠀⠀⠀⠀⠉⢿⣮⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⠀⣯⠉⠉⠛⢿⣿⣷⣄⠀⠈⢻⣆⠀⠀⠀⠀⠀⠀⠀⠀
${c2}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠢⠀⠀⠀⠀⠀⠀⠀⢀⢡⠃⣾⣿⣿⣦⠀⠀⠀⠙⢿⣿⣤⠀⠙⣄⠀⠀⠀⠀⠀⠀⠀
${c6}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢋⡟⢠⣿⣿⣿⠋⢿⣄⠀⠀⠀⠈⡄⠙⣶⣈⡄⠀⠀⠀⠀⠀⠀
${c1}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠚⢲⣿⠀⣾⣿⣿⠁⠀⠀⠉⢷⡀⠀⠀⣇⠀⠀⠈⠻⡀⠀⠀⠀⠀⠀
${c4}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢢⣀⣿⡏⠀⣿⡿⠀⠀⠀⠀⠀⠀⠙⣦⠀⢧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
${c3}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠿⣧⣾⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣮⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
${c5}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

EOF
        ;;

        "Itc"*)
            set_colors 1
            read -rd '' ascii_data <<'EOF'
${c1}....................-==============+...
${c1}....................-==============:...
${c1}...:===========-....-==============:...
${c1}...-===========:....-==============-...
${c1}....*==========+........-::********-...
${c1}....*===========+.:*====**==*+-.-......
${c1}....:============*+-..--:+**====*---...
${c1}......::--........................::...
${c1}..+-:+-.+::*:+::+:-++::++-.:-.*.:++:++.
${c1}..:-:-++++:-::--:+::-::.:++-++:++--:-:.    ⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
EOF
        ;;

        "dragonfly_old"*)
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
     ${c1}                   .-.
                 ${c3} ()${c1}I${c3}()
            ${c1} "==.__:-:__.=="
            "==.__/~|~\__.=="
            "==._(  Y  )_.=="
 ${c2}.-'~~""~=--...,__${c1}\/|\/${c2}__,...--=~""~~'-.
(               ..=${c1}\\=${c1}/${c2}=..               )
 `'-.        ,.-"`;${c1}/=\\${c2};"-.,_        .-'`
     `~"-=-~` .-~` ${c1}|=|${c2} `~-. `~-=-"~`
          .-~`    /${c1}|=|${c2}\    `~-.
       .~`       / ${c1}|=|${c2} \       `~.
   .-~`        .'  ${c1}|=|${c2}  `.        `~-.
 (`     _,.-="`  ${c1}  |=|${c2}    `"=-.,_     `)
  `~"~"`        ${c1}   |=|${c2}           `"~"~`
                 ${c1}  /=\\
                   \\=/
                    ^
EOF
        ;;

        "dragonfly_small"*)
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
${c2}   ,${c1}_${c2},
('-_${c1}|${c2}_-')
 >--${c1}|${c2}--<
(_-'${c1}|${c2}'-_)
    ${c1}|
    |
    |
EOF
        ;;

        "DragonFly"*)
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
${c2},--,           ${c1}|           ${c2},--,
${c2}|   `-,       ${c1},^,       ${c2},-'   |
${c2} `,    `-,   ${c3}(/ \)   ${c2},-'    ,'
${c2}   `-,    `-,${c1}/   \${c2},-'    ,-'
${c2}      `------${c1}(   )${c2}------'
${c2}  ,----------${c1}(   )${c2}----------,
${c2} |        _,-${c1}(   )${c2}-,_        |
${c2}  `-,__,-'   ${c1}\   /${c2}   `-,__,-'
${c1}              | |
              | |
              | |
              | |
              | |
              | |
              `|'
EOF
        ;;

        "Drauger"*)
            set_colors 1 7
            read -rd '' ascii_data <<'EOF'
${c1}                  -``-
                `:+``+:`
               `/++``++/.
              .++/.  ./++.
             :++/`    `/++:
           `/++:        :++/`
          ./+/-          -/+/.
         -++/.            ./++-
        :++:`              `:++:
      `/++-                  -++/`
     ./++.                    ./+/.
    -++/`                      `/++-
   :++:`                        `:++:
 `/++-                            -++/`
.:-.`..............................`.-:.
`.-/++++++++++++++++++++++++++++++++/-.`
EOF
        ;;

        "elementary_small"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c2}  _______
 / ____  \\
/  |  /  /\\
|__\\ /  / |
\\   /__/  /
 \\_______/
EOF
        ;;

        "Elementary"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c2}         eeeeeeeeeeeeeeeee
      eeeeeeeeeeeeeeeeeeeeeee
    eeeee  eeeeeeeeeeee   eeeee
  eeee   eeeee       eee     eeee
 eeee   eeee          eee     eeee
eee    eee            eee       eee
eee   eee            eee        eee
ee    eee           eeee       eeee
ee    eee         eeeee      eeeeee
ee    eee       eeeee      eeeee ee
eee   eeee   eeeeee      eeeee  eee
eee    eeeeeeeeee     eeeeee    eee
 eeeeeeeeeeeeeeeeeeeeeeee    eeeee
  eeeeeeee eeeeeeeeeeee      eeee
    eeeee                 eeeee
      eeeeeee         eeeeeee
         eeeeeeeeeeeeeeeee
EOF
        ;;

        "EndeavourOS"*)
            set_colors 1 5 4
            read -rd '' ascii_data <<'EOF'
${c1}                     ./${c2}o${c3}.
${c1}                   ./${c2}sssso${c3}-
${c1}                 `:${c2}osssssss+${c3}-
${c1}               `:+${c2}sssssssssso${c3}/.
${c1}             `-/o${c2}ssssssssssssso${c3}/.
${c1}           `-/+${c2}sssssssssssssssso${c3}+:`
${c1}         `-:/+${c2}sssssssssssssssssso${c3}+/.
${c1}       `.://o${c2}sssssssssssssssssssso${c3}++-
${c1}      .://+${c2}ssssssssssssssssssssssso${c3}++:
${c1}    .:///o${c2}ssssssssssssssssssssssssso${c3}++:
${c1}  `:////${c2}ssssssssssssssssssssssssssso${c3}+++.
${c1}`-////+${c2}ssssssssssssssssssssssssssso${c3}++++-
${c1} `..-+${c2}oosssssssssssssssssssssssso${c3}+++++/`
   ./++++++++++++++++++++++++++++++/:.
  `:::::::::::::::::::::::::------``
EOF
        ;;

        "Endless"*)
            set_colors 1 7
            read -rd '' ascii_data <<'EOF'
${c1}           `:+yhmNMMMMNmhy+:`
        -odMMNhso//////oshNMMdo-
      /dMMh+.              .+hMMd/
    /mMNo`                    `oNMm:
  `yMMo`                        `oMMy`
 `dMN-                            -NMd`
 hMN.                              .NMh
/MM/                  -os`          /MM/
dMm    `smNmmhs/- `:sNMd+   ``       mMd
MMy    oMd--:+yMMMMMNo.:ohmMMMNy`    yMM
MMy    -NNyyhmMNh+oNMMMMMy:.  dMo    yMM
dMm     `/++/-``/yNNh+/sdNMNddMm-    mMd
/MM/          `dNy:       `-::-     /MM/
 hMN.                              .NMh
 `dMN-                            -NMd`
  `yMMo`                        `oMMy`
    /mMNo`                    `oNMm/
      /dMMh+.              .+hMMd/
        -odMMNhso//////oshNMMdo-
           `:+yhmNMMMMNmhy+:`
EOF
        ;;

        "EuroLinux"*)
            set_colors 4 7
            read -rd '' ascii_data <<'EOF'
${c1}                __
         -wwwWWWWWWWWWwww-
        -WWWWWWWWWWWWWWWWWWw-
          \WWWWWWWWWWWWWWWWWWW-
  _Ww      `WWWWWWWWWWWWWWWWWWWw
 -W${c2}E${c1}Www                -WWWWWWWWW-
_WW${c2}U${c1}WWWW-                _WWWWWWWW
_WW${c2}R${c1}WWWWWWWWWWWWWWWWWWWWWWWWWWWWWW-
wWW${c2}O${c1}WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
WWW${c2}L${c1}WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWw
WWW${c2}I${c1}WWWWWWWWWWWWWWWWWWWWWWWWWWWWww-
wWW${c2}N${c1}WWWWw
 WW${c2}U${c1}WWWWWWw
 wW${c2}X${c1}WWWWWWWWww
   wWWWWWWWWWWWWWWWw
    wWWWWWWWWWWWWWWWw
       WWWWWWWWWWWWWw
           wWWWWWWWw
EOF
        ;;

        "Exherbo"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c2} ,
OXo.
NXdX0:    .cok0KXNNXXK0ko:.
KX  '0XdKMMK;.xMMMk, .0MMMMMXx;  ...
'NO..xWkMMx   kMMM    cMMMMMX,NMWOxOXd.
  cNMk  NK    .oXM.   OMMMMO. 0MMNo  kW.
  lMc   o:       .,   .oKNk;   ;NMMWlxW'
 ;Mc    ..   .,,'    .0M${c1}g;${c2}WMN'dWMMMMMMO
 XX        ,WMMMMW.  cM${c1}cfli${c2}WMKlo.   .kMk
.Mo        .WM${c1}GD${c2}MW.   XM${c1}WO0${c2}MMk        oMl
,M:         ,XMMWx::,''oOK0x;          NM.
'Ml      ,kNKOxxxxxkkO0XXKOd:.         oMk
 NK    .0Nxc${c3}:::::::::::::::${c2}fkKNk,      .MW
 ,Mo  .NXc${c3}::${c2}qXWXb${c3}::::::::::${c2}oo${c3}::${c2}lNK.    .MW
  ;Wo oMd${c3}:::${c2}oNMNP${c3}::::::::${c2}oWMMMx${c3}:${c2}c0M;   lMO
   'NO;W0c${c3}:::::::::::::::${c2}dMMMMO${c3}::${c2}lMk  .WM'
     xWONXdc${c3}::::::::::::::${c2}oOOo${c3}::${c2}lXN. ,WMd
      'KWWNXXK0Okxxo,${c3}:::::::${c2},lkKNo  xMMO
        :XMNxl,';:lodxkOO000Oxc. .oWMMo
          'dXMMXkl;,.        .,o0MMNo'
             ':d0XWMMMMWNNNNMMMNOl'
                   ':okKXWNKkl'
EOF
        ;;

        "fedora_small")
            set_colors 12
            read -rd '' ascii_data <<'EOF'
${c1}        ,'''''.
       |   ,.  |
       |  |  '_'
  ,....|  |..
.'  ,_;|   ..'
|  |   |  |
|  ',_,'  |
 '.     ,'
   '''''
EOF
        ;;

        "Fedora_old"* | "RFRemix"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}          /:-------------:\\
       :-------------------::
     :-----------${c2}/shhOHbmp${c1}---:\\
   /-----------${c2}omMMMNNNMMD  ${c1}---:
  :-----------${c2}sMMMMNMNMP${c1}.    ---:
 :-----------${c2}:MMMdP${c1}-------    ---\\
,------------${c2}:MMMd${c1}--------    ---:
:------------${c2}:MMMd${c1}-------    .---:
:----    ${c2}oNMMMMMMMMMNho${c1}     .----:
:--     .${c2}+shhhMMMmhhy++${c1}   .------/
:-    -------${c2}:MMMd${c1}--------------:
:-   --------${c2}/MMMd${c1}-------------;
:-    ------${c2}/hMMMy${c1}------------:
:--${c2} :dMNdhhdNMMNo${c1}------------;
:---${c2}:sdNMMMMNds:${c1}------------:
:------${c2}:://:${c1}-------------::
:---------------------://
EOF
        ;;

        "Fedora"*)
            set_colors 12 7
            read -rd '' ascii_data <<'EOF'
${c1}             .',;::::;,'.
         .';:cccccccccccc:;,.
      .;cccccccccccccccccccccc;.
    .:cccccccccccccccccccccccccc:.
  .;ccccccccccccc;${c2}.:dddl:.${c1};ccccccc;.
 .:ccccccccccccc;${c2}OWMKOOXMWd${c1};ccccccc:.
.:ccccccccccccc;${c2}KMMc${c1};cc;${c2}xMMc${c1};ccccccc:.
,cccccccccccccc;${c2}MMM.${c1};cc;${c2};WW:${c1};cccccccc,
:cccccccccccccc;${c2}MMM.${c1};cccccccccccccccc:
:ccccccc;${c2}oxOOOo${c1};${c2}MMM0OOk.${c1};cccccccccccc:
cccccc;${c2}0MMKxdd:${c1};${c2}MMMkddc.${c1};cccccccccccc;
ccccc;${c2}XM0'${c1};cccc;${c2}MMM.${c1};cccccccccccccccc'
ccccc;${c2}MMo${c1};ccccc;${c2}MMW.${c1};ccccccccccccccc;
ccccc;${c2}0MNc.${c1}ccc${c2}.xMMd${c1};ccccccccccccccc;
cccccc;${c2}dNMWXXXWM0:${c1};cccccccccccccc:,
cccccccc;${c2}.:odl:.${c1};cccccccccccccc:,.
:cccccccccccccccccccccccccccc:'.
.:cccccccccccccccccccccc:;,..
  '::cccccccccccccc::;,.
EOF
        ;;

        "Feren"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1} `----------`
 :+ooooooooo+.
-o+oooooooooo+-
..`/+++++++++++/...`````````````````
   .++++++++++++++++++++++++++/////-
    ++++++++++++++++++++++++++++++++//:`
    -++++++++++++++++++++++++++++++/-`
     ++++++++++++++++++++++++++++:.
     -++++++++++++++++++++++++/.
      +++++++++++++++++++++/-`
      -++++++++++++++++++//-`
        .:+++++++++++++//////-
           .:++++++++//////////-
             `-++++++---:::://///.
           `.:///+++.             `
          `.........
EOF
        ;;

        "freebsd_small")
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
${c1}/\\,-'''''-,/\\
\\_)       (_/
|           |
|           |
 ;         ;
  '-_____-'
EOF
        ;;

        FreeBSD*|HardenedBSD*)
            case $ascii_distro in
                *HardenedBSD*) set_colors 4 7 3 ;;
                *)             set_colors 1 7 3
            esac

            read -rd '' ascii_data <<'EOF'
   ${c2}```                        ${c1}`
  ${c2}` `.....---...${c1}....--.```   -/
  ${c2}+o   .--`         ${c1}/y:`      +.
  ${c2} yo`:.            ${c1}:o      `+-
    ${c2}y/               ${c1}-/`   -o/
   ${c2}.-                  ${c1}::/sy+:.
   ${c2}/                     ${c1}`--  /
  ${c2}`:                          ${c1}:`
  ${c2}`:                          ${c1}:`
   ${c2}/                          ${c1}/
   ${c2}.-                        ${c1}-.
    ${c2}--                      ${c1}-.
     ${c2}`:`                  ${c1}`:`
       .--             `--.
          .---.....----.
EOF
        ;;

        "FreeMiNT"*)
            set_colors 7
            read -rd '' ascii_data <<'EOF'
${c1}          ##
          ##         #########
                    ####      ##
            ####  ####        ##
####        ####  ##        ##
        ####    ####      ##  ##
        ####  ####  ##  ##  ##
            ####  ######
        ######  ##  ##  ####
      ####    ################
    ####        ##  ####
    ##            ####  ######
    ##      ##    ####  ####
    ##    ##  ##    ##  ##  ####
      ####  ##          ##  ##
EOF
        ;;

        "Frugalware"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}          `++/::-.`
         /o+++++++++/::-.`
        `o+++++++++++++++o++/::-.`
        /+++++++++++++++++++++++oo++/:-.``
       .o+ooooooooooooooooooosssssssso++oo++/:-`
       ++osoooooooooooosssssssssssssyyo+++++++o:
      -o+ssoooooooooooosssssssssssssyyo+++++++s`
      o++ssoooooo++++++++++++++sssyyyyo++++++o:
     :o++ssoooooo${c2}/-------------${c1}+syyyyyo+++++oo
    `o+++ssoooooo${c2}/-----${c1}+++++ooosyyyyyyo++++os:
    /o+++ssoooooo${c2}/-----${c1}ooooooosyyyyyyyo+oooss
   .o++++ssooooos${c2}/------------${c1}syyyyyyhsosssy-
   ++++++ssooooss${c2}/-----${c1}+++++ooyyhhhhhdssssso
  -s+++++syssssss${c2}/-----${c1}yyhhhhhhhhhhhddssssy.
  sooooooyhyyyyyh${c2}/-----${c1}hhhhhhhhhhhddddyssy+
 :yooooooyhyyyhhhyyyyyyhhhhhhhhhhdddddyssy`
 yoooooooyhyyhhhhhhhhhhhhhhhhhhhddddddysy/
-ysooooooydhhhhhhhhhhhddddddddddddddddssy
 .-:/+osssyyyysyyyyyyyyyyyyyyyyyyyyyyssy:
       ``.-/+oosysssssssssssssssssssssss
               ``.:/+osyysssssssssssssh.
                        `-:/+osyyssssyo
                                .-:+++`
EOF
        ;;

        "Funtoo"*)
            set_colors 5 7
            read -rd '' ascii_data <<'EOF'
${c1}   .dKXXd                         .
  :XXl;:.                      .OXo
.'OXO''  .''''''''''''''''''''':XNd..'oco.lco,
xXXXXXX, cXXXNNNXXXXNNXXXXXXXXNNNNKOOK; d0O .k
  kXX  xXo  KNNN0  KNN.       'xXNo   :c; 'cc.
  kXX  xNo  KNNN0  KNN. :xxxx. 'NNo
  kXX  xNo  loooc  KNN. oNNNN. 'NNo
  kXX  xN0:.       KNN' oNNNX' ,XNk
  kXX  xNNXNNNNNNNNXNNNNNNNNXNNOxXNX0Xl
  ...  ......................... .;cc;.
EOF
        ;;

        "GalliumOS"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}sooooooooooooooooooooooooooooooooooooo+:
yyooooooooooooooooooooooooooooooooo+/:::
yyysoooooooooooooooooooooooooooo+/::::::
yyyyyoooooooooooooooooooooooo+/:::::::::
yyyyyysoooooooooooooooooo++/::::::::::::
yyyyyyysoooooooooooooo++/:::::::::::::::
yyyyyyyyysoooooo${c2}sydddys${c1}+/:::::::::::::::
yyyyyyyyyysooo${c2}smMMMMMMMNd${c1}+::::::::::::::
yyyyyyyyyyyyo${c2}sMMMMMMMMMMMN${c1}/:::::::::::::
yyyyyyyyyyyyy${c2}dMMMMMMMMMMMM${c1}o//:::::::::::
yyyyyyyyyyyyy${c2}hMMMMMMMMMMMm${c1}--//::::::::::
yyyyyyyyyyyyyy${c2}hmMMMMMMMNy${c1}:..-://::::::::
yyyyyyyyyyyyyyy${c2}yyhhyys+:${c1}......://:::::::
yyyyyyyyyyyyyyys+:--...........-///:::::
yyyyyyyyyyyys+:--................://::::
yyyyyyyyyo+:-.....................-//:::
yyyyyyo+:-..........................://:
yyyo+:-..............................-//
o/:-...................................:
EOF
        ;;

        "Garuda"*)
            set_colors 7 7 3 7 2 4
            read -rd '' ascii_data <<'EOF'

${c3}
                     .%;888:8898898:
                   x;XxXB%89b8:b8%b88:
                .8Xxd                8X:.
              .8Xx;                    8x:.
            .tt8x          ${c6}.d${c3}            x88;
         .@8x8;          ${c6}.db:${c3}              xx@;
       ${c4},tSXX°          .bbbbbbbbbbbbbbbbbbbB8x@;
     .SXxx            bBBBBBBBBBBBBBBBBBBBbSBX8;
   ,888S                                     pd!
  8X88/                                       q
  GBB.
   ${c5}x%88        d888@8@X@X@X88X@@XX@@X@8@X.
     dxXd    dB8b8b8B8B08bB88b998888b88x.
      dxx8o                      .@@;.
        dx88                   .t@x.
          d:SS@8ba89aa67a853Sxxad.
            .d988999889889899dd.

EOF

        ;;

        "gentoo_small")
            set_colors 5 7
            read -rd '' ascii_data <<'EOF'
${c1} _-----_
(       \\
\    0   \\
${c2} \        )
 /      _/
(     _-
\____-
EOF
        ;;

        "Gentoo"*)
            set_colors 5 7
            read -rd '' ascii_data <<'EOF'
${c1}         -/oyddmdhs+:.
     -o${c2}dNMMMMMMMMNNmhy+${c1}-`
   -y${c2}NMMMMMMMMMMMNNNmmdhy${c1}+-
 `o${c2}mMMMMMMMMMMMMNmdmmmmddhhy${c1}/`
 om${c2}MMMMMMMMMMMN${c1}hhyyyo${c2}hmdddhhhd${c1}o`
.y${c2}dMMMMMMMMMMd${c1}hs++so/s${c2}mdddhhhhdm${c1}+`
 oy${c2}hdmNMMMMMMMN${c1}dyooy${c2}dmddddhhhhyhN${c1}d.
  :o${c2}yhhdNNMMMMMMMNNNmmdddhhhhhyym${c1}Mh
    .:${c2}+sydNMMMMMNNNmmmdddhhhhhhmM${c1}my
       /m${c2}MMMMMMNNNmmmdddhhhhhmMNh${c1}s:
    `o${c2}NMMMMMMMNNNmmmddddhhdmMNhs${c1}+`
  `s${c2}NMMMMMMMMNNNmmmdddddmNMmhs${c1}/.
 /N${c2}MMMMMMMMNNNNmmmdddmNMNdso${c1}:`
+M${c2}MMMMMMNNNNNmmmmdmNMNdso${c1}/-
yM${c2}MNNNNNNNmmmmmNNMmhs+/${c1}-`
/h${c2}MMNNNNNNNNMNdhs++/${c1}-`
`/${c2}ohdmmddhys+++/:${c1}.`
  `-//////:--.
EOF
        ;;

        "Pentoo"*)
            set_colors 5 7
            read -rd '' ascii_data <<'EOF'
${c2}           `:oydNNMMMMNNdyo:`
        :yNMMMMMMMMMMMMMMMMNy:
      :dMMMMMMMMMMMMMMMMMMMMMMd:
     oMMMMMMMho/-....-/ohMMMMMMMo
    oMMMMMMy.            .yMMMMMMo
   .MMMMMMo                oMMMMMM.
   +MMMMMm                  mMMMMM+
   oMMMMMh                  hMMMMMo
 //hMMMMMm//${c1}`${c2}          ${c1}`${c2}////mMMMMMh//
MMMMMMMMMMM${c1}/${c2}      ${c1}/o/`${c2}  ${c1}.${c2}smMMMMMMMMMMM
MMMMMMMMMMm      ${c1}`NMN:${c2}    ${c1}.${c2}yMMMMMMMMMM
MMMMMMMMMMMh${c1}:.${c2}              dMMMMMMMMM
MMMMMMMMMMMMMy${c1}.${c2}            ${c1}-${c2}NMMMMMMMMM
MMMMMMMMMMMd:${c1}`${c2}           ${c1}-${c2}yNMMMMMMMMMM
MMMMMMMMMMh${c1}`${c2}          ${c1}./${c2}hNMMMMMMMMMMMM
MMMMMMMMMM${c1}s${c2}        ${c1}.:${c2}ymMMMMMMMMMMMMMMM
MMMMMMMMMMN${c1}s:..-/${c2}ohNMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM

EOF
        ;;
	
        "glaucus"*)
            set_colors 5
            read -rd '' ascii_data <<'EOF'
${c1}             ,,        ,d88P             
           ,d8P    ,ad8888*               
         ,888P    d88888*     ,,ad8888P*
    d   d888P   a88888P*  ,ad8888888*     
  .d8  d8888:  d888888* ,d888888P*       
 .888; 88888b d8888888b8888888P           
 d8888J888888a88888888888888P*    ,d      
 88888888888888888888888888P   ,,d8*       
 888888888888888888888888888888888*       
 *8888888888888888888888888888888*        
  Y888888888P* `*``*888888888888*          
   *^888^*            *Y888P**
EOF
        ;;
	
        "gNewSense"*)
            set_colors 4 5 7 6
            read -rd '' ascii_data <<'EOF'
${c1}                     ..,,,,..
               .oocchhhhhhhhhhccoo.
        .ochhlllllllc hhhhhh ollllllhhco.
    ochlllllllllll hhhllllllhhh lllllllllllhco
 .cllllllllllllll hlllllo  +hllh llllllllllllllc.
ollllllllllhco''  hlllllo  +hllh  ``ochllllllllllo
hllllllllc'       hllllllllllllh       `cllllllllh
ollllllh          +llllllllllll+          hllllllo
 `cllllh.           ohllllllho           .hllllc'
    ochllc.            ++++            .cllhco
       `+occooo+.                .+ooocco+'
              `+oo++++      ++++oo+'
EOF
        ;;

        "GNOME"*)
            set_colors 4
            read -rd '' ascii_data <<'EOF'
${c1}                               ,@@@@@@@@,
                 @@@@@@      @@@@@@@@@@@@
        ,@@.    @@@@@@@    *@@@@@@@@@@@@
       @@@@@%   @@@@@@(    @@@@@@@@@@@&
       @@@@@@    @@@@*     @@@@@@@@@#
@@@@*   @@@@,              *@@@@@%
@@@@@.
 @@@@#         @@@@@@@@@@@@@@@@
         ,@@@@@@@@@@@@@@@@@@@@@@@,
      ,@@@@@@@@@@@@@@@@@@@@@@@@@@&
    .@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@@@@@@@@@
   @@@@@@@@@@@@@@@@@@@@@@@@(
   @@@@@@@@@@@@@@@@@@@@%
    @@@@@@@@@@@@@@@@
     @@@@@@@@@@@@*        @@@@@@@@/
      &@@@@@@@@@@        @@@@@@@@@*
        @@@@@@@@@@@,    @@@@@@@@@*
          ,@@@@@@@@@@@@@@@@@@@@&
              &@@@@@@@@@@@@@@
                     ...
EOF
        ;;

        "GNU")
            set_colors fg 7
            read -rd '' ascii_data <<'EOF'
${c1}    _-`````-,           ,- '- .
  .'   .- - |          | - -.  `.
 /.'  /                     `.   \
:/   :      _...   ..._      ``   :
::   :     /._ .`:'_.._\.    ||   :
::    `._ ./  ,`  :    \ . _.''   .
`:.      /   |  -.  \-. \\_      /
  \:._ _/  .'   .@)  \@) ` `\ ,.'
     _/,--'       .- .\,-.`--`.
       ,'/''     (( \ `  )
        /'/'  \    `-'  (
         '/''  `._,-----'
          ''/'    .,---'
           ''/'      ;:
             ''/''  ''/
               ''/''/''
                 '/'/'
                  `;
EOF
        ;;

        "GoboLinux"*)
            set_colors 5 4 6 2
            read -rd '' ascii_data <<'EOF'
${c1}  _____       _
 / ____|     | |
| |  __  ___ | |__   ___
| | |_ |/ _ \| '_ \ / _ \
| |__| | (_) | |_) | (_) |
 \_____|\___/|_.__/ \___/
EOF
        ;;

        "Grombyang"*)
            set_colors 4 2 1
            read -rd '' ascii_data <<'EOF'
${c1}            eeeeeeeeeeee
         eeeeeeeeeeeeeeeee
      eeeeeeeeeeeeeeeeeeeeeee
    eeeee       ${c2}.o+       ${c1}eeee
  eeee         ${c2}`ooo/         ${c1}eeee
 eeee         ${c2}`+oooo:         ${c1}eeee
eee          ${c2}`+oooooo:          ${c1}eee
eee          ${c2}-+oooooo+:         ${c1}eee
ee         ${c2}`/:oooooooo+:         ${c1}ee
ee        ${c2}`/+   +++    +:        ${c1}ee
ee              ${c2}+o+\             ${c1}ee
eee             ${c2}+o+\            ${c1}eee
eee        ${c2}//  \\ooo/  \\\        ${c1}eee
 eee      ${c2}//++++oooo++++\\\     ${c1}eee
  eeee    ${c2}::::++oooo+:::::   ${c1}eeee
    eeeee   ${c3}Grombyang OS ${c1}  eeee
      eeeeeeeeeeeeeeeeeeeeeee
         eeeeeeeeeeeeeeeee
EOF
        ;;

        "guix_small"*)
            set_colors 3 7 6 1 8
            read -rd '' ascii_data <<'EOF'
${c1}|.__          __.|
|__ \\        / __|
   \\ \\      / /
    \\ \\    / /
     \\ \\  / /
      \\ \\/ /
       \\__/
EOF
        ;;

        "Guix"*)
            set_colors 3 7 6 1 8
            read -rd '' ascii_data <<'EOF'
${c1} ..                             `.
 `--..```..`           `..```..--`
   .-:///-:::.       `-:::///:-.
      ````.:::`     `:::.````
           -//:`    -::-
            ://:   -::-
            `///- .:::`
             -+++-:::.
              :+/:::-
              `-....`
EOF
        ;;

        "haiku_small"*)
            set_colors 2 8
            read -rd '' ascii_data <<'EOF'
${c1}       ,^,
      /   \\
*--_ ;     ; _--*
\\   '"     "'   /
 '.           .'
.-'"         "'-.
 '-.__.   .__.-'
       |_|
EOF
        ;;

        "Haiku"*)
            set_colors 2 8
            read -rd '' ascii_data <<'EOF'
${c2}          :dc'
       'l:;'${c1},${c2}'ck.    .;dc:.
       co    ${c1}..${c2}k.  .;;   ':o.
       co    ${c1}..${c2}k. ol      ${c1}.${c2}0.
       co    ${c1}..${c2}k. oc     ${c1}..${c2}0.
       co    ${c1}..${c2}k. oc     ${c1}..${c2}0.
.Ol,.  co ${c1}...''${c2}Oc;kkodxOdddOoc,.
 ';lxxlxOdxkxk0kd${c1}oooll${c2}dl${c1}ccc:${c2}clxd;
     ..${c1}oOolllllccccccc:::::${c2}od;
       cx:ooc${c1}:::::::;${c2}cooolcX.
       cd${c1}.${c2}''cloxdoollc' ${c1}...${c2}0.
       cd${c1}......${c2}k;${c1}.${c2}xl${c1}....  .${c2}0.
       .::c${c1};..${c2}cx;${c1}.${c2}xo${c1}..... .${c2}0.
          '::c'${c1}...${c2}do${c1}..... .${c2}K,
                  cd,.${c1}....:${c2}O,${c1}
                    ':clod:'${c1}
                        ${c1}
EOF
        ;;

        "Huayra"*)
            set_colors 4 7
            read -rd '' ascii_data <<'EOF'
${c2}                     `
            .       .       `
       ``    -      .      .
        `.`   -` `. -  `` .`
          ..`-`-` + -  / .`     ```
          .--.+--`+:- :/.` .-``.`
            -+/so::h:.d-`./:`.`
              :hNhyMomy:os-...-.  ````
               .dhsshNmNhoo+:-``.```
                ${c1}`ohy:-${c2}NMds+::-.``
            ````${c1}.hNN+`${c2}mMNho/:-....````
       `````     `../dmNhoo+/:..``
    ````            .dh++o/:....`
.+s/`                `/s-.-.:.`` ````
::`                    `::`..`
                          .` `..
                                ``
EOF
        ;;

        "HydroOS"*)
            set_colors 1 2 3 4 5
            read -rd '' ascii_data <<'EOF'
${c1}
  _    _           _            ____   _____
 | |  | |         | |          / __ \ / ____|
 | |__| |_   _  __| |_ __ ___ | |  | | (___
 |  __  | | | |/ _` | '__/ _ \| |  | |\___ \
 | |  | | |_| | (_| | | | (_) | |__| |____) |
 |_|  |_|\__, |\__,_|_|  \___/ \____/|_____/
          __/ |
         |___/
EOF
        ;;

        "hyperbola_small"*)
            set_colors 8
            read -rd '' ascii_data <<'EOF'
${c1}    |`__.`/
    \____/
    .--.
   /    \\
  /  ___ \\
 / .`   `.\\
/.`      `.\\
EOF
        ;;

        "Hyperbola"*)
            set_colors 8
            read -rd '' ascii_data <<'EOF'
${c1}                     WW
                     KX              W
                    WO0W          NX0O
                    NOO0NW  WNXK0OOKW
                    W0OOOOOOOOOOOOKN
                     N0OOOOOOO0KXW
                       WNXXXNW
                 NXK00000KN
             WNK0OOOOOOOOOO0W
           NK0OOOOOOOOOOOOOO0W
         X0OOOOOOO00KK00OOOOOK
       X0OOOO0KNWW      WX0OO0W
     X0OO0XNW              KOOW
   N00KNW                   KOW
 NKXN                       W0W
WW                           W
EOF
        ;;

        "iglunix"*|"iglu"*)
            set_colors 8
            read -rd '' ascii_data <<'EOF'
${c1}     |
     |        |
              |
|    ________
|  /\   |    \
  /  \  |     \  |
 /    \        \ |
/      \________\
\      /        /
 \    /        /
  \  /        /
   \/________/
EOF
        ;;

        "januslinux"*|"janus"*|"Ataraxia Linux"*|"Ataraxia"*)
            set_colors 4 5 6 2
            read -rd '' ascii_data <<'EOF'
${c1}               'l:
        loooooo
          loooo coooool
 looooooooooooooooooool
  looooooooooooooooo
         lool   cooo
        coooooooloooooooo
     clooooo  ;lood  cloooo
  :loooocooo cloo      loooo
 loooo  :ooooool       loooo
looo    cooooo        cooooo
looooooooooooo      ;loooooo ${c2}looooooc
${c1}looooooooo loo   cloooooool    ${c2}looooc
${c1} cooo       cooooooooooo       ${c2}looolooooool
${c1}            cooo:     ${c2}coooooooooooooooooool
                       loooooooooooolc:   loooc;
                             cooo:    loooooooooooc
                            ;oool         looooooo:
                           coool          olc,
                          looooc   ,,
                        coooooc    loc
                       :oooool,    coool:, looool:,
                       looool:      ooooooooooooooo:
                       cooolc        .ooooooooooool
EOF
        ;;

        "Kaisen"*)
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
${c1}                          `
                  `:+oyyho.
             `+:`sdddddd/
        `+` :ho oyo++ohds-`
       .ho :dd.  .: `sddddddhhyso+/-
       ody.ddd-:yd- +hysssyhddddddddho`
       yddddddhddd` ` `--`   -+hddddddh.
       hddy-+dddddy+ohh/..+sddddy/:::+ys
      :ddd/sdddddddddd- oddddddd       `
     `yddddddddddddddd/ /ddddddd/
:.  :ydddddddddddddddddo..sddddddy/`
odhdddddddo- `ddddh+-``....-+hdddddds.
-ddddddhd:   /dddo  -ydddddddhdddddddd-
 /hdy:o - `:sddds   .`./hdddddddddddddo
  `/-  `+hddyosy+       :dddddddy-.-od/
      :sydds           -hddddddd`    /
       .+shd-      `:ohddddddddd`
                `:+ooooooooooooo:
EOF
        ;;

        "Kali"*)
            set_colors 4 8
            read -rd '' ascii_data <<'EOF'
${c1}..............
            ..,;:ccc,.
          ......''';lxO.
.....''''..........,:ld;
           .';;;:::;,,.x,
      ..'''.            0Xxoc:,.  ...
  ....                ,ONkc;,;cokOdc',.
 .                   OMo           ':${c2}dd${c1}o.
                    dMc               :OO;
                    0M.                 .:o.
                    ;Wd
                     ;XO,
                       ,d0Odlc;,..
                           ..',;:cdOOd::,.
                                    .:d;.':;.
                                       'd,  .'
                                         ;l   ..
                                          .o
                                            c
                                            .'
                                             .
EOF
        ;;

        "KaOS"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}                     ..
  .....         ..OSSAAAAAAA..
 .KKKKSS.     .SSAAAAAAAAAAA.
.KKKKKSO.    .SAAAAAAAAAA...
KKKKKKS.   .OAAAAAAAA.
KKKKKKS.  .OAAAAAA.
KKKKKKS. .SSAA..
.KKKKKS..OAAAAAAAAAAAA........
 DKKKKO.=AA=========A===AASSSO..
  AKKKS.==========AASSSSAAAAAASS.
  .=KKO..========ASS.....SSSSASSSS.
    .KK.       .ASS..O.. =SSSSAOSS:
     .OK.      .ASSSSSSSO...=A.SSA.
       .K      ..SSSASSSS.. ..SSA.
                 .SSS.AAKAKSSKA.
                    .SSS....S..
EOF
        ;;

        "KDE"*)
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c1}             `..---+/---..`
         `---.``   ``   `.---.`
      .--.`        ``        `-:-.
    `:/:     `.----//----.`     :/-
   .:.    `---`          `--.`    .:`
  .:`   `--`                .:-    `:.
 `/    `:.      `.-::-.`      -:`   `/`
 /.    /.     `:++++++++:`     .:    .:
`/    .:     `+++++++++++/      /`   `+`
/+`   --     .++++++++++++`     :.   .+:
`/    .:     `+++++++++++/      /`   `+`
 /`    /.     `:++++++++:`     .:    .:
 ./    `:.      `.:::-.`      -:`   `/`
  .:`   `--`                .:-    `:.
   .:.    `---`          `--.`    .:`
    `:/:     `.----//----.`     :/-
      .-:.`        ``        `-:-.
         `---.``   ``   `.---.`
             `..---+/---..`
EOF
        ;;

        "Kibojoe"*)
            set_colors 2 7 4
            read -rd '' ascii_data <<'EOF'
            ${c3}           ./+oooooo+/.
           -/+ooooo+/:.`
          ${c1}`${c3}yyyo${c2}+++/++${c3}osss${c1}.
         ${c1}+NMN${c3}yssssssssssss${c1}.
       ${c1}.dMMMMN${c3}sssssssssssy${c1}Ns`
      +MMMMMMMm${c3}sssssssssssh${c1}MNo`
    `hMMMMMNNNMd${c3}sssssssssssd${c1}MMN/
   .${c3}syyyssssssy${c1}NNmmmmd${c3}sssss${c1}hMMMMd:
  -NMmh${c3}yssssssssyhhhhyssyh${c1}mMMMMMMMy`
 -NMMMMMNN${c3}mdhyyyyyyyhdm${c1}NMMMMMMMMMMMN+
`NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd.
ods+/:-----://+oyydmNMMMMMMMMMMMMMMMMMN-
`                     .-:+osyhhdmmNNNmdo
EOF
        ;;

        "Kogaion"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}            ;;      ,;
           ;;;     ,;;
         ,;;;;     ;;;;
      ,;;;;;;;;    ;;;;
     ;;;;;;;;;;;   ;;;;;
    ,;;;;;;;;;;;;  ';;;;;,
    ;;;;;;;;;;;;;;, ';;;;;;;
    ;;;;;;;;;;;;;;;;;, ';;;;;
;    ';;;;;;;;;;;;;;;;;;, ;;;
;;;,  ';;;;;;;;;;;;;;;;;;;,;;
;;;;;,  ';;;;;;;;;;;;;;;;;;,
;;;;;;;;,  ';;;;;;;;;;;;;;;;,
;;;;;;;;;;;;, ';;;;;;;;;;;;;;
';;;;;;;;;;;;; ';;;;;;;;;;;;;
 ';;;;;;;;;;;;;, ';;;;;;;;;;;
  ';;;;;;;;;;;;;  ;;;;;;;;;;
    ';;;;;;;;;;;; ;;;;;;;;
        ';;;;;;;; ;;;;;;
           ';;;;; ;;;;
             ';;; ;;
EOF
        ;;

        "Korora"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c2}                ____________
             _add55555555554${c1}:
           _w?'${c1}``````````'${c2})k${c1}:
          _Z'${c1}`${c2}            ]k${c1}:
          m(${c1}`${c2}             )k${c1}:
     _.ss${c1}`${c2}m[${c1}`${c2},            ]e${c1}:
   .uY"^`${c1}`${c2}Xc${c1}`${c2}?Ss.         d(${c1}`
  jF'${c1}`${c2}    `@.  ${c1}`${c2}Sc      .jr${c1}`
 jr${c1}`${c2}       `?n_ ${c1}`${c2}$;   _a2"${c1}`
.m${c1}:${c2}          `~M${c1}`${c2}1k${c1}`${c2}5?!`${c1}`
:#${c1}:${c2}             ${c1}`${c2})e${c1}```
:m${c1}:${c2}             ,#'${c1}`
:#${c1}:${c2}           .s2'${c1}`
:m,________.aa7^${c1}`
:#baaaaaaas!J'${c1}`
 ```````````
EOF
        ;;

        "KSLinux"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1} K   K U   U RRRR   ooo
 K  K  U   U R   R o   o
 KKK   U   U RRRR  o   o
 K  K  U   U R  R  o   o
 K   K  UUU  R   R  ooo

${c2}  SSS   AAA  W   W  AAA
 S     A   A W   W A   A
  SSS  AAAAA W W W AAAAA
     S A   A WW WW A   A
  SSS  A   A W   W A   A
EOF
        ;;

        "Kubuntu"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}           `.:/ossyyyysso/:.
        .:oyyyyyyyyyyyyyyyyyyo:`
      -oyyyyyyyo${c2}dMMy${c1}yyyyyyysyyyyo-
    -syyyyyyyyyy${c2}dMMy${c1}oyyyy${c2}dmMMy${c1}yyyys-
   oyyys${c2}dMy${c1}syyyy${c2}dMMMMMMMMMMMMMy${c1}yyyyyyo
 `oyyyy${c2}dMMMMy${c1}syysoooooo${c2}dMMMMy${c1}yyyyyyyyo`
 oyyyyyy${c2}dMMMMy${c1}yyyyyyyyyyys${c2}dMMy${c1}sssssyyyo
-yyyyyyyy${c2}dMy${c1}syyyyyyyyyyyyyys${c2}dMMMMMy${c1}syyy-
oyyyysoo${c2}dMy${c1}yyyyyyyyyyyyyyyyyy${c2}dMMMMy${c1}syyyo
yyys${c2}dMMMMMy${c1}yyyyyyyyyyyyyyyyyysosyyyyyyyy
yyys${c2}dMMMMMy${c1}yyyyyyyyyyyyyyyyyyyyyyyyyyyyy
oyyyyysos${c2}dy${c1}yyyyyyyyyyyyyyyyyy${c2}dMMMMy${c1}syyyo
-yyyyyyyy${c2}dMy${c1}syyyyyyyyyyyyyys${c2}dMMMMMy${c1}syyy-
 oyyyyyy${c2}dMMMy${c1}syyyyyyyyyyys${c2}dMMy${c1}oyyyoyyyo
 `oyyyy${c2}dMMMy${c1}syyyoooooo${c2}dMMMMy${c1}oyyyyyyyyo
   oyyysyyoyyyys${c2}dMMMMMMMMMMMy${c1}yyyyyyyo
    -syyyyyyyyy${c2}dMMMy${c1}syyy${c2}dMMMy${c1}syyyys-
      -oyyyyyyy${c2}dMMy${c1}yyyyyysosyyyyo-
        ./oyyyyyyyyyyyyyyyyyyo/.
           `.:/oosyyyysso/:.`
EOF
        ;;

        "LEDE"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
    ${c1} _________
    /        /\
   /  LE    /  \
  /    DE  /    \
 /________/  LE  \
 \        \   DE /
  \    LE  \    /
   \  DE    \  /
    \________\/
EOF
        ;;

        "LaxerOS"*)
            set_colors 7 4
            read -rd '' ascii_data <<'EOF'
${c2}
                    /.
                 `://:-
                `//////:
               .////////:`
              -//////////:`
             -/////////////`
            :///////////////.
          `://////.```-//////-
         `://///:`     .//////-
        `//////:        `//////:
       .//////-          `://///:`
      -//////-            `://///:`
     -//////.               ://////`
    ://////`                 -//////.
   `/////:`                   ./////:
    .-::-`                     .:::-`

.:://////////////////////////////////::.
////////////////////////////////////////
.:////////////////////////////////////:.

EOF
        ;;

        "LibreELEC"*)
            set_colors 2 3 7 14 13
            read -rd '' ascii_data <<'EOF'
${c1}          :+ooo/.      ${c2}./ooo+:
${c1}        :+ooooooo/.  ${c2}./ooooooo+:
${c1}      :+ooooooooooo:${c2}:ooooooooooo+:
${c1}    :+ooooooooooo+-  ${c2}-+ooooooooooo+:
${c1}  :+ooooooooooo+-  ${c3}--  ${c2}-+ooooooooooo+:
${c1}.+ooooooooooo+-  ${c3}:+oo+:  ${c2}-+ooooooooooo+-
${c1}-+ooooooooo+-  ${c3}:+oooooo+:  ${c2}-+oooooooooo-
${c1}  :+ooooo+-  ${c3}:+oooooooooo+:  ${c2}-+oooooo:
${c1}    :+o+-  ${c3}:+oooooooooooooo+:  ${c2}-+oo:
${c4}     ./   ${c3}:oooooooooooooooooo:   ${c5}/.
${c4}   ./oo+:  ${c3}-+oooooooooooooo+-  ${c5}:+oo/.
${c4} ./oooooo+:  ${c3}-+oooooooooo+-  ${c5}:+oooooo/.
${c4}-oooooooooo+:  ${c3}-+oooooo+-  ${c5}:+oooooooooo-
${c4}.+ooooooooooo+:  ${c3}-+oo+-  ${c5}:+ooooooooooo+.
${c4}  -+ooooooooooo+:  ${c3}..  ${c5}:+ooooooooooo+-
${c4}    -+ooooooooooo+:  ${c5}:+ooooooooooo+-
${c4}      -+oooooooooo+:${c5}:+oooooooooo+-
${c4}        -+oooooo+:    ${c5}:+oooooo+-
${c4}          -+oo+:        ${c5}:+oo+-
${c4}            ..            ${c5}..
EOF
        ;;

        "Linux")
            set_colors fg 8 3
            read -rd '' ascii_data <<'EOF'
${c2}        #####
${c2}       #######
${c2}       ##${c1}O${c2}#${c1}O${c2}##
${c2}       #${c3}#####${c2}#
${c2}     ##${c1}##${c3}###${c1}##${c2}##
${c2}    #${c1}##########${c2}##
${c2}   #${c1}############${c2}##
${c2}   #${c1}############${c2}###
${c3}  ##${c2}#${c1}###########${c2}##${c3}#
${c3}######${c2}#${c1}#######${c2}#${c3}######
${c3}#######${c2}#${c1}#####${c2}#${c3}#######
${c3}  #####${c2}#######${c3}#####
EOF
        ;;

        "linuxlite_small"*)
            set_colors 3 7
            read -rd '' ascii_data <<'EOF'
${c1}   /\\
  /  \\
 / ${c2}/ ${c1}/
> ${c2}/ ${c1}/
\\ ${c2}\\ ${c1}\\
 \\_${c2}\\${c1}_\\
${c2}    \\
EOF
        ;;

        "Linux Lite"* | "Linux_Lite"*)
            set_colors 3 7
            read -rd '' ascii_data <<'EOF'
${c1}          ,xXc
      .l0MMMMMO
   .kNMMMMMWMMMN,
   KMMMMMMKMMMMMMo
  'MMMMMMNKMMMMMM:
  kMMMMMMOMMMMMMO
 .MMMMMMX0MMMMMW.
 oMMMMMMxWMMMMM:
 WMMMMMNkMMMMMO
:MMMMMMOXMMMMW
.0MMMMMxMMMMM;
:;cKMMWxMMMMO
'MMWMMXOMMMMl
 kMMMMKOMMMMMX:
 .WMMMMKOWMMM0c
  lMMMMMWO0MNd:'
   oollXMKXoxl;.
     ':. .: .'
              ..
                .
EOF
        ;;

        "LMDE"*)
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
         ${c2}`.-::---..
${c1}      .:++++ooooosssoo:.
    .+o++::.      `.:oos+.
${c1}   :oo:.`             -+oo${c2}:
${c1} ${c2}`${c1}+o/`    .${c2}::::::${c1}-.    .++-${c2}`
${c1}${c2}`${c1}/s/    .yyyyyyyyyyo:   +o-${c2}`
${c1}${c2}`${c1}so     .ss       ohyo` :s-${c2}:
${c1}${c2}`${c1}s/     .ss  h  m  myy/ /s`${c2}`
${c1}`s:     `oo  s  m  Myy+-o:`
`oo      :+sdoohyoydyso/.
 :o.      .:////////++:
${c1} `/++        ${c2}-:::::-
${c1}  ${c2}`${c1}++-
${c1}   ${c2}`${c1}/+-
${c1}     ${c2}.${c1}+/.
${c1}       ${c2}.${c1}:+-.
          `--.``
EOF
        ;;

        "Lubuntu"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}           `.:/ossyyyysso/:.
        `.:yyyyyyyyyyyyyyyyyy:.`
      .:yyyyyyyyyyyyyyyyyyyyyyyy:.
    .:yyyyyyyyyyyyyyyyyyyyyyyyyyyy:.
   -yyyyyyyyyyyyyy${c2}+hNMMMNh+${c1}yyyyyyyyy-
  :yy${c2}mNy+${c1}yyyyyyyy${c2}+Nmso++smMdhyysoo+${c1}yy:
 -yy${c2}+MMMmmy${c1}yyyyyy${c2}hh${c1}yyyyyyyyyyyyyyyyyyy-
.yyyy${c2}NMN${c1}yy${c2}shhs${c1}yyy${c2}+o${c1}yyyyyyyyyyyyyyyyyyyy.
:yyyy${c2}oNM+${c1}yyyy${c2}+sso${c1}yyyyyyy${c2}ss${c1}yyyyyyyyyyyyy:
:yyyyy${c2}+dNs${c1}yyyyyyy${c2}++${c1}yyyyy${c2}oN+${c1}yyyyyyyyyyyy:
:yyyyy${c2}oMMmhysso${c1}yyyyyyyyyy${c2}mN+${c1}yyyyyyyyyyy:
:yyyyyy${c2}hMm${c1}yyyyy${c2}+++${c1}yyyyyyy${c2}+MN${c1}yyyyyyyyyyy:
.yyyyyyy${c2}ohmy+${c1}yyyyyyyyyyyyy${c2}NMh${c1}yyyyyyyyyy.
 -yyyyyyyyyy${c2}++${c1}yyyyyyyyyyyy${c2}MMh${c1}yyyyyyyyy-
  :yyyyyyyyyyyyyyyyyyyyy${c2}+mMN+${c1}yyyyyyyy:
   -yyyyyyyyyyyyyyyyy${c2}+sdMMd+${c1}yyyyyyyy-
    .:yyyyyyyyy${c2}hmdmmNMNdy+${c1}yyyyyyyy:.
      .:yyyyyyy${c2}my${c1}yyyyyyyyyyyyyyy:.
        `.:yyyy${c2}s${c1}yyyyyyyyyyyyy:.`
           `.:/oosyyyysso/:.`
EOF
        ;;

        "Lunar"*)
            set_colors 4 7 3
            read -rd '' ascii_data <<'EOF'
${c1}`-.                                 `-.
  -ohys/-`                    `:+shy/`
     -omNNdyo/`          :+shmNNy/`
             ${c3}      -
                 /mMmo
                 hMMMN`
                 .NMMs
    ${c1}  -:+oooo+//: ${c3}/MN${c1}. -///oooo+/-`
     /:.`          ${c3}/${c1}           `.:/`
${c3}          __
         |  |   _ _ ___ ___ ___
         |  |__| | |   | .'|  _|
         |_____|___|_|_|__,|_|
EOF
        ;;

        "mac"*"_small")
            set_colors 2 3 1 5 4
            read -rd '' ascii_data <<'EOF'
${c1}       .:'
    _ :'_
${c2} .'`_`-'_``.
:________.-'
${c3}:_______:
:_______:
${c4} :_______`-;
${c5}  `._.-._.'
EOF
        ;;

        "mac"* | "Darwin")
            set_colors 2 3 1 1 5 4
            read -rd '' ascii_data <<'EOF'
${c1}                    c.'
                 ,xNMM.
               .OMMMMo
               lMM"
     .;loddo:.  .olloddol;.
   cKMMMMMMMMMMNWMMMMMMMMMM0:
${c2} .KMMMMMMMMMMMMMMMMMMMMMMMWd.
 XMMMMMMMMMMMMMMMMMMMMMMMX.
${c3};MMMMMMMMMMMMMMMMMMMMMMMM:
:MMMMMMMMMMMMMMMMMMMMMMMM:
${c4}.MMMMMMMMMMMMMMMMMMMMMMMMX.
 kMMMMMMMMMMMMMMMMMMMMMMMMWd.
 ${c5}'XMMMMMMMMMMMMMMMMMMMMMMMMMMk
  'XMMMMMMMMMMMMMMMMMMMMMMMMK.
    ${c6}kMMMMMMMMMMMMMMMMMMMMMMd
     ;KMMMMMMMWXXWMMMMMMMk.
       "cooc*"    "*coo'"
EOF
        ;;

        "mageia_small"*)
            set_colors 6 7
            read -rd '' ascii_data <<'EOF'
${c1}   *
    *
   **
${c2} /\\__/\\
/      \\
\\      /
 \\____/
EOF
        ;;

        "Mageia"*)
            set_colors 6 7
            read -rd '' ascii_data <<'EOF'
${c1}        .°°.
         °°   .°°.
         .°°°. °°
         .   .
          °°° .°°°.
      .°°°.   '___'
${c2}     .${c1}'___'     ${c2}   .
   :dkxc;'.  ..,cxkd;
 .dkk. kkkkkkkkkk .kkd.
.dkk.  ';cloolc;.  .kkd
ckk.                .kk;
xO:                  cOd
xO:                  lOd
lOO.                .OO:
.k00.              .00x
 .k00;            ;00O.
  .lO0Kc;,,,,,,;c0KOc.
     ;d00KKKKKK00d;
        .,KKKK,.
EOF
        ;;

        "MagpieOS"*)
            set_colors 2 1 3 5
            read -rd '' ascii_data <<'EOF'
${c1}        ;00000     :000Ol
     .x00kk00:    O0kk00k;
    l00:   :00.  o0k   :O0k.
  .k0k.     x${c2}d$dddd${c1}k'    .d00;
  k0k.      ${c2}.dddddl       ${c1}o00,
 o00.        ${c2}':cc:.        ${c1}d0O
.00l                       ,00.
l00.                       d0x
k0O                     .:k0o
O0k                 ;dO0000d.
k0O               .O0O${c2}xxxxk${c1}00:
o00.              k0O${c2}dddddd${c1}occ
'00l              x0O${c2}dddddo${c3};..${c1}
 x00.             .x00${c2}kxxd${c3}:..${c1}
 .O0x               .:oxxx${c4}Okl.${c1}
  .x0d                     ${c4},xx,${c1}
    .:o.          ${c4}.xd       ckd${c1}
       ..          ${c4}dxl     .xx;
                    :xxolldxd'
                      ;oxdl.
EOF
        ;;

        "Mandriva"* | "Mandrake"*)
            set_colors 4 3
            read -rd '' ascii_data <<'EOF'
${c2}                        ``
                       `-.
${c1}      `               ${c2}.---
${c1}    -/               ${c2}-::--`
${c1}  `++    ${c2}`----...```-:::::.
${c1} `os.      ${c2}.::::::::::::::-```     `  `
${c1} +s+         ${c2}.::::::::::::::::---...--`
${c1}-ss:          ${c2}`-::::::::::::::::-.``.``
${c1}/ss-           ${c2}.::::::::::::-.``   `
${c1}+ss:          ${c2}.::::::::::::-
${c1}/sso         ${c2}.::::::-::::::-
${c1}.sss/       ${c2}-:::-.`   .:::::
${c1} /sss+.    ${c2}..`${c1}  `--`    ${c2}.:::
${c1}  -ossso+/:://+/-`        ${c2}.:`
${c1}    -/+ooo+/-.              ${c2}`
EOF
        ;;

        "manjaro_small"*)
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c1}||||||||| ||||
||||||||| ||||
||||      ||||
|||| |||| ||||
|||| |||| ||||
|||| |||| ||||
|||| |||| ||||
EOF
        ;;

        "Manjaro"*)
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c1}██████████████████  ████████
██████████████████  ████████
██████████████████  ████████
██████████████████  ████████
████████            ████████
████████  ████████  ████████
████████  ████████  ████████
████████  ████████  ████████
████████  ████████  ████████
████████  ████████  ████████
████████  ████████  ████████
████████  ████████  ████████
████████  ████████  ████████
████████  ████████  ████████
EOF
        ;;

        "TeArch"*)
            set_colors 39 7 1
            read -rd '' ascii_data <<'EOF'
${c1}          @@@@@@@@@@@@@@
      @@@@@@@@@              @@@@@@
     @@@@@                     @@@@@
     @@                           @@
      @%                         @@
       @                         @
       @@@@@@@@@@@@@@@@@@@@@@@@ @@
       .@@@@@@@@@@@@/@@@@@@@@@@@@
       @@@@@@@@@@@@///@@@@@@@@@@@@
      @@@@@@@@@@@@@((((@@@@@@@@@@@@
     @@@@@@@@@@@#(((((((#@@@@@@@@@@@
    @@@@@@@@@@@#//////////@@@@@@@@@@&
    @@@@@@@@@@////@@@@@////@@@@@@@@@@
    @@@@@@@@//////@@@@@/////@@@@@@@@@
    @@@@@@@//@@@@@@@@@@@@@@@//@@@@@@@
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@     .@@@@@@@@@@@@@@@@@@@@@@@@@      @
 @@@@@@           @@@.           @@@@@@@
   @@@@@@@&@@@@@@@#  #@@@@@@@@@@@@@@@@
      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
          @@@@@@@@@@@@@@@@@@@@@
EOF
        ;;

        "Maui"*)
            set_colors 6 7
            read -rd '' ascii_data <<'EOF'
${c1}             `.-://////:--`
         .:/oooooooooooooooo+:.
      `:+ooooooooooooooooooooooo:`
    `:oooooooooooooooooooooooooooo/`
    ..```-oooooo/-`` `:oooooo+:.` `--
  :.      +oo+-`       /ooo/`       -/
 -o.     `o+-          +o/`         -o:
`oo`     ::`  :o/     `+.  .+o`     /oo.
/o+      .  -+oo-     `   /oo/     `ooo/
+o-        /ooo+`       .+ooo.     :ooo+
++       .+oooo:       -oooo+     `oooo+
:.      .oooooo`      :ooooo-     :oooo:
`      .oooooo:      :ooooo+     `ooo+-`
      .+oooooo`     -oooooo:     `o/-
      +oooooo:     .ooooooo.
     /ooooooo`     /ooooooo/       ..
    `:oooooooo/:::/ooooooooo+:--:/:`
      `:+oooooooooooooooooooooo+:`
         .:+oooooooooooooooo+:.
             `.-://////:-.`
EOF
        ;;

        "Mer"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}                         dMs
                         .-`
                       `y`-o+`
                        ``NMMy
                      .--`:++.
                    .hNNNNs
                    /MMMMMN
                    `ommmd/ +/
                      ````  +/
                     `:+sssso/-`
  .-::. `-::-`     `smNMNmdmNMNd/      .://-`
.ymNMNNdmNMMNm+`  -dMMh:.....+dMMs   `sNNMMNo
dMN+::NMMy::hMM+  mMMo `ohhy/ `dMM+  yMMy::-
MMm   yMM-  :MMs  NMN` `:::::--sMMh  dMM`
MMm   yMM-  -MMs  mMM+ `ymmdsymMMMs  dMM`
NNd   sNN-  -NNs  -mMNs-.--..:dMMh`  dNN
---   .--`  `--.   .smMMmdddmMNdo`   .--
                     ./ohddds+:`
                     +h- `.:-.
                     ./`.dMMMN+
                        +MMMMMd
                        `+dmmy-
                      ``` .+`
                     .dMNo-y.
                     `hmm/
                         .:`
                         dMs
EOF
        ;;

        "Minix"*)
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
${c2}   -sdhyo+:-`                -/syymm:
   sdyooymmNNy.     ``    .smNmmdysNd
   odyoso+syNNmysoyhhdhsoomNmm+/osdm/
    :hhy+-/syNNmddhddddddmNMNo:sdNd:
     `smNNdNmmNmddddddddddmmmmmmmy`
   `ohhhhdddddmmNNdmddNmNNmdddddmdh-
   odNNNmdyo/:/-/hNddNy-`..-+ydNNNmd:
 `+mNho:`   smmd/ sNNh :dmms`   -+ymmo.
-od/       -m${c1}mm${c2}mo -NN+ +m${c1}mm${c2}m-       yms:
+sms -.`    :so:  .NN+  :os/     .-`mNh:
.-hyh+:////-     -sNNd:`    .--://ohNs-
 `:hNNNNNNNMMd/sNMmhsdMMh/ymmNNNmmNNy/
  -+sNNNNMMNNNsmNMo: :NNmymNNNNMMMms:
    //oydNMMMMydMMNysNMMmsMMMMMNyo/`
       ../-yNMMy--/::/-.sMMmos+.`
           -+oyhNsooo+omy/```
              `::ohdmds-`
EOF
        ;;

        "linuxmint_small"*)
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c1} ___________
|_          \\
  | ${c2}| _____ ${c1}|
  | ${c2}| | | | ${c1}|
  | ${c2}| | | | ${c1}|
  | ${c2}\\__${c2}___/ ${c1}|
  \\_________/
EOF
        ;;

        "Linux Mint Old"* | "LinuxMintOld"* | "mint_old"*)
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c1}MMMMMMMMMMMMMMMMMMMMMMMMMmds+.
MMm----::-://////////////oymNMd+`
MMd      ${c2}/++                ${c1}-sNMd:
MMNso/`  ${c2}dMM    `.::-. .-::.` ${c1}.hMN:
ddddMMh  ${c2}dMM   :hNMNMNhNMNMNh: ${c1}`NMm
    NMm  ${c2}dMM  .NMN/-+MMM+-/NMN` ${c1}dMM
    NMm  ${c2}dMM  -MMm  `MMM   dMM. ${c1}dMM
    NMm  ${c2}dMM  -MMm  `MMM   dMM. ${c1}dMM
    NMm  ${c2}dMM  .mmd  `mmm   yMM. ${c1}dMM
    NMm  ${c2}dMM`  ..`   ...   ydm. ${c1}dMM
    hMM- ${c2}+MMd/-------...-:sdds  ${c1}dMM
    -NMm- ${c2}:hNMNNNmdddddddddy/`  ${c1}dMM
     -dMNs-${c2}``-::::-------.``    ${c1}dMM
      `/dMNmy+/:-------------:/yMMM
         ./ydNMMMMMMMMMMMMMMMMMMMMM
            .MMMMMMMMMMMMMMMMMMM
EOF
        ;;

        "Linux Mint"* | "LinuxMint"* | "mint"*)
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c2}             ...-:::::-...
${c2}          .-MMMMMMMMMMMMMMM-.
      .-MMMM${c1}`..-:::::::-..`${c2}MMMM-.
    .:MMMM${c1}.:MMMMMMMMMMMMMMM:.${c2}MMMM:.
   -MMM${c1}-M---MMMMMMMMMMMMMMMMMMM.${c2}MMM-
 `:MMM${c1}:MM`  :MMMM:....::-...-MMMM:${c2}MMM:`
 :MMM${c1}:MMM`  :MM:`  ``    ``  `:MMM:${c2}MMM:
.MMM${c1}.MMMM`  :MM.  -MM.  .MM-  `MMMM.${c2}MMM.
:MMM${c1}:MMMM`  :MM.  -MM-  .MM:  `MMMM-${c2}MMM:
:MMM${c1}:MMMM`  :MM.  -MM-  .MM:  `MMMM:${c2}MMM:
:MMM${c1}:MMMM`  :MM.  -MM-  .MM:  `MMMM-${c2}MMM:
.MMM${c1}.MMMM`  :MM:--:MM:--:MM:  `MMMM.${c2}MMM.
 :MMM${c1}:MMM-  `-MMMMMMMMMMMM-`  -MMM-${c2}MMM:
  :MMM${c1}:MMM:`                `:MMM:${c2}MMM:
   .MMM${c1}.MMMM:--------------:MMMM.${c2}MMM.
     '-MMMM${c1}.-MMMMMMMMMMMMMMM-.${c2}MMMM-'
       '.-MMMM${c1}``--:::::--``${c2}MMMM-.'
${c2}            '-MMMMMMMMMMMMM-'
${c2}               ``-:::::-``
EOF
        ;;

        "Live Raizo"* | "Live_Raizo"*)
            set_colors 3
            read -rd '' ascii_data <<'EOF'
${c1}             `......`
        -+shmNMMMMMMNmhs/.
     :smMMMMMmmhyyhmmMMMMMmo-
   -hMMMMd+:. `----` .:odMMMMh-
 `hMMMN+. .odNMMMMMMNdo. .yMMMMs`
 hMMMd. -dMMMMmdhhdNMMMNh` .mMMMh
oMMMm` :MMMNs.:sddy:-sMMMN- `NMMM+
mMMMs  dMMMo sMMMMMMd yMMMd  sMMMm
----`  .---` oNMMMMMh `---.  .----
              .sMMy:
               /MM/
              +dMMms.
             hMMMMMMN
            `dMMMMMMm:
      .+ss+sMNysMMoomMd+ss+.
     +MMMMMMN` +MM/  hMMMMMNs
     sMMMMMMm-hNMMMd-hMMMMMMd
      :yddh+`hMMMMMMN :yddy/`
             .hMMMMd:
               `..`
EOF
        ;;

        "mx_small"*)
            set_colors 4 6 7
            read -rd '' ascii_data <<'EOF'
${c3}    \\\\  /
     \\\\/
      \\\\
   /\\/ \\\\
  /  \\  /\\
 /    \\/  \\
/__________\\
EOF
        ;;

        "MX"*)
            set_colors 4 6 7
            read -rd '' ascii_data <<'EOF'
${c3}MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNMMMMMMMMM
MMMMMMMMMMNs..yMMMMMMMMMMMMMm: +NMMMMMMM
MMMMMMMMMN+    :mMMMMMMMMMNo` -dMMMMMMMM
MMMMMMMMMMMs.   `oNMMMMMMh- `sNMMMMMMMMM
MMMMMMMMMMMMN/    -hMMMN+  :dMMMMMMMMMMM
MMMMMMMMMMMMMMh-    +ms. .sMMMMMMMMMMMMM
MMMMMMMMMMMMMMMN+`   `  +NMMMMMMMMMMMMMM
MMMMMMMMMMMMMMNMMd:    .dMMMMMMMMMMMMMMM
MMMMMMMMMMMMm/-hMd-     `sNMMMMMMMMMMMMM
MMMMMMMMMMNo`   -` :h/    -dMMMMMMMMMMMM
MMMMMMMMMd:       /NMMh-   `+NMMMMMMMMMM
MMMMMMMNo`         :mMMN+`   `-hMMMMMMMM
MMMMMMh.            `oNMMd:    `/mMMMMMM
MMMMm/                -hMd-      `sNMMMM
MMNs`                   -          :dMMM
Mm:                                 `oMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
EOF
        ;;

        "Namib"*)
            set_colors 1
            read -rd '' ascii_data <<'EOF'
${c1}          .:+shysyhhhhysyhs+:.
       -/yyys              syyy/-
     -shy                      yhs-
   -yhs                          shy-
  +hy                              yh+
 +ds                                sd+
/ys                  so              sy/
sh                 smMMNdyo           hs
yo               ymMMMMNNMMNho        oy
N             ydMMMNNMMMMMMMMMmy       N
N         shmMMMMNNMMMMMMMMMMMMMNy     N
yo  ooshmNMMMNNNNMMMMMMMMMMMMMMMMMms  oy
sd yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy ds
/ys                                  sy/
 +ds                                sd+
  +hy                              yh+
   -yhs                          shy-
     -shy                      yhs-
       -/yyys              syyy/-
          .:+shysyhyhhysyhs+:.
EOF
        ;;

        "Neptune"*)
            set_colors 7
            read -rd '' ascii_data <<'EOF'
${c1}            ./+sydddddddys/-.
        .+ymNNdyooo/:+oooymNNmy/`
     `/hNNh/.`             `-+dNNy:`
    /mMd/.          .++.:oy/   .+mMd-
  `sMN/             oMMmdy+.     `oNNo
 `hMd.           `/ymy/.           :NMo
 oMN-          `/dMd:               /MM-
`mMy          -dMN+`                 mMs
.MMo         -NMM/                   yMs
 dMh         mMMMo:`                `NMo
 /MM/        /ymMMMm-               sMN.
  +Mm:         .hMMd`              oMN/
   +mNs.      `yNd/`             -dMm-
    .yMNs:    `/.`            `/yNNo`
      .odNNy+-`           .:ohNNd/.
         -+ymNNmdyyyyyyydmNNmy+.
             `-//sssssss//.
EOF
        ;;

        "netbsd_small"*)
            set_colors 5 7
            read -rd '' ascii_data <<'EOF'
${c2}\\\\${c1}\`-______,----__
${c2} \\\\        ${c1}__,---\`_
${c2}  \\\\       ${c1}\`.____
${c2}   \\\\${c1}-______,----\`-
${c2}    \\\\
     \\\\
      \\\\
EOF
        ;;

        "NetBSD"*)
            set_colors 5 7
            read -rd '' ascii_data <<'EOF'
${c1}                     `-/oshdmNMNdhyo+:-`
${c2}y${c1}/s+:-``    `.-:+oydNMMMMNhs/-``
${c2}-m+${c1}NMMMMMMMMMMMMMMMMMMMNdhmNMMMmdhs+/-`
 ${c2}-m+${c1}NMMMMMMMMMMMMMMMMMMMMmy+:`
  ${c2}-N/${c1}dMMMMMMMMMMMMMMMds:`
   ${c2}-N/${c1}hMMMMMMMMMmho:`
    ${c2}-N/${c1}-:/++/:.`
${c2}     :M+
      :Mo
       :Ms
        :Ms
         :Ms
          :Ms
           :Ms
            :Ms
             :Ms
              :Ms
EOF
        ;;

        "Netrunner"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}           .:oydmMMMMMMmdyo:`
        -smMMMMMMMMMMMMMMMMMMds-
      +mMMMMMMMMMMMMMMMMMMMMMMMMd+
    /mMMMMMMMMMMMMMMMMMMMMMMMMMMMMm/
  `hMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMy`
 .mMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd`
 dMMMMMMMMMMMMMMMMMMMMMMNdhmMMMMMMMMMMh
+MMMMMMMMMMMMMNmhyo+/-.   -MMMMMMMMMMMM/
mMMMMMMMMd+:.`           `mMMMMMMMMMMMMd
MMMMMMMMMMMdy/.          yMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMNh+`     +MMMMMMMMMMMMMMM
mMMMMMMMMMMMMMMMMMs    -NMMMMMMMMMMMMMMd
+MMMMMMMMMMMMMMMMMN.  `mMMMMMMMMMMMMMMM/
 dMMMMMMMMMMMMMMMMMy  hMMMMMMMMMMMMMMMh
 `dMMMMMMMMMMMMMMMMM-+MMMMMMMMMMMMMMMd`
  `hMMMMMMMMMMMMMMMMmMMMMMMMMMMMMMMMy
    /mMMMMMMMMMMMMMMMMMMMMMMMMMMMMm:
      +dMMMMMMMMMMMMMMMMMMMMMMMMd/
        -odMMMMMMMMMMMMMMMMMMdo-
           `:+ydmNMMMMNmhy+-`
EOF
        ;;

        "Nitrux"*)
            set_colors 4
            read -rd '' ascii_data <<'EOF'
${c1}`:/.
`/yo
`/yo
`/yo      .+:.
`/yo      .sys+:.`
`/yo       `-/sys+:.`
`/yo           ./sss+:.`
`/yo              .:oss+:-`
`/yo                 ./o///:-`
`/yo              `.-:///////:`
`/yo           `.://///++//-``
`/yo       `.-:////++++/-`
`/yo    `-://///++o+/-`
`/yo `-/+o+++ooo+/-`
`/s+:+oooossso/.`
`//+sssssso:.
`+syyyy+:`
:+s+-
EOF
        ;;

        "nixos_small")
            set_colors 4 6
            read -rd '' ascii_data <<'EOF'
  ${c1}  \\\\  \\\\ //
 ==\\\\__\\\\/ //
   //   \\\\//
==//     //==
 //\\\\___//
// /\\\\  \\\\==
  // \\\\  \\\\
EOF
        ;;

        "nixos_old"*)
            set_colors 4 6
            read -rd '' ascii_data <<'EOF'
${c1}          ::::.    ${c2}':::::     ::::'
${c1}          ':::::    ${c2}':::::.  ::::'
${c1}            :::::     ${c2}'::::.:::::
${c1}      .......:::::..... ${c2}::::::::
${c1}     ::::::::::::::::::. ${c2}::::::    ${c1}::::.
    ::::::::::::::::::::: ${c2}:::::.  ${c1}.::::'
${c2}           .....           ::::' ${c1}:::::'
${c2}          :::::            '::' ${c1}:::::'
${c2} ........:::::               ' ${c1}:::::::::::.
${c2}:::::::::::::                 ${c1}:::::::::::::
${c2} ::::::::::: ${c1}..              ${c1}:::::
${c2}     .::::: ${c1}.:::            ${c1}:::::
${c2}    .:::::  ${c1}:::::          ${c1}'''''    ${c2}.....
    :::::   ${c1}':::::.  ${c2}......:::::::::::::'
     :::     ${c1}::::::. ${c2}':::::::::::::::::'
${c1}            .:::::::: ${c2}'::::::::::
${c1}           .::::''::::.     ${c2}'::::.
${c1}          .::::'   ::::.     ${c2}'::::.
${c1}         .::::      ::::      ${c2}'::::.
EOF
        ;;

        "NixOS"*)
            set_colors 4 6
            read -rd '' ascii_data <<'EOF'
${c1}          ▗▄▄▄       ${c2}▗▄▄▄▄    ▄▄▄▖
${c1}          ▜███▙       ${c2}▜███▙  ▟███▛
${c1}           ▜███▙       ${c2}▜███▙▟███▛
${c1}            ▜███▙       ${c2}▜██████▛
${c1}     ▟█████████████████▙ ${c2}▜████▛     ${c1}▟▙
${c1}    ▟███████████████████▙ ${c2}▜███▙    ${c1}▟██▙
${c2}           ▄▄▄▄▖           ▜███▙  ${c1}▟███▛
${c2}          ▟███▛             ▜██▛ ${c1}▟███▛
${c2}         ▟███▛               ▜▛ ${c1}▟███▛
${c2}▟███████████▛                  ${c1}▟██████████▙
${c2}▜██████████▛                  ${c1}▟███████████▛
${c2}      ▟███▛ ${c1}▟▙               ▟███▛
${c2}     ▟███▛ ${c1}▟██▙             ▟███▛
${c2}    ▟███▛  ${c1}▜███▙           ▝▀▀▀▀
${c2}    ▜██▛    ${c1}▜███▙ ${c2}▜██████████████████▛
${c2}     ▜▛     ${c1}▟████▙ ${c2}▜████████████████▛
${c1}           ▟██████▙       ${c2}▜███▙
${c1}          ▟███▛▜███▙       ${c2}▜███▙
${c1}         ▟███▛  ▜███▙       ${c2}▜███▙
${c1}         ▝▀▀▀    ▀▀▀▀▘       ${c2}▀▀▀▘
EOF
        ;;

        "Nurunner"*)
            set_colors 4
            read -rd '' ascii_data <<'EOF'
${c1}                  ,xc
                ;00cxXl
              ;K0,   .xNo.
            :KO'       .lXx.
          cXk.    ;xl     cXk.
        cXk.    ;k:.,xo.    cXk.
     .lXx.    :x::0MNl,dd.    :KO,
   .xNx.    cx;:KMMMMMNo'dx.    ;KK;
 .dNl.    cd,cXMMMMMMMMMWd,ox'    'OK:
;WK.    'K,.KMMMMMMMMMMMMMWc.Kx     lMO
 'OK:    'dl'xWMMMMMMMMMM0::x:    'OK:
   .kNo    .xo'xWMMMMMM0;:O:    ;KK;
     .dXd.   .do,oNMMO;ck:    ;00,
        oNd.   .dx,;'cO;    ;K0,
          oNx.    okk;    ;K0,
            lXx.        :KO'
              cKk'    cXk.
                ;00:lXx.
                  ,kd.
EOF
        ;;

        "NuTyX"*)
            set_colors 4 1
            read -rd '' ascii_data <<'EOF'
${c1}                                      .
                                    .
                                 ...
                               ...
            ....     .........--.
       ..-++-----....--++++++---.
    .-++++++-.   .-++++++++++++-----..
  .--...  .++..-+++--.....-++++++++++--..
 .     .-+-. .**-            ....  ..-+----..
     .+++.  .*+.         +            -++-----.
   .+++++-  ++.         .*+.     .....-+++-----.
  -+++-++. .+.          .-+***++***++--++++.  .
 -+-. --   -.          -*- ......        ..--.
.-. .+-    .          -+.
.  .+-                +.
   --                 --
  -+----.              .-
  -++-.+.                .
 .++. --
  +.  ----.
  .  .+. ..
      -  .
      .
EOF
        ;;

        "OBRevenge"*)
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
${c1}   __   __
     _@@@@   @@@g_
   _@@@@@@   @@@@@@
  _@@@@@@M   W@@@@@@_
 j@@@@P        ^W@@@@
 @@@@L____  _____Q@@@@
Q@@@@@@@@@@j@@@@@@@@@@
@@@@@    T@j@    T@@@@@
@@@@@ ___Q@J@    _@@@@@
@@@@@fMMM@@j@jggg@@@@@@
@@@@@    j@j@^MW@P @@@@
Q@@@@@ggg@@f@   @@@@@@L
^@@@@WWMMP  ^    Q@@@@
 @@@@@_         _@@@@l
  W@@@@@g_____g@@@@@P
   @@@@@@@@@@@@@@@@l
    ^W@@@@@@@@@@@P
       ^TMMMMTll
EOF
        ;;

        "openbsd_small")
            set_colors 3 7 6 1 8
            read -rd '' ascii_data <<'EOF'
${c1}      _____
    \\-     -/
 \\_/         \\
 |        ${c2}O O${c1} |
 |_  <   )  3 )
 / \\         /
    /-_____-\\
EOF
        ;;

        "OpenBSD"*)
            set_colors 3 7 6 1 8
            read -rd '' ascii_data <<'EOF'
${c3}                                     _
                                    (_)
${c1}              |    .
${c1}          .   |L  /|   .         ${c3} _
${c1}      _ . |\ _| \--+._/| .       ${c3}(_)
${c1}     / ||\| Y J  )   / |/| ./
    J  |)'( |        ` F`.'/       ${c3} _
${c1}  -<|  F         __     .-<        ${c3}(_)
${c1}    | /       .-'${c3}. ${c1}`.  /${c3}-. ${c1}L___
    J \\      <    ${c3}\ ${c1} | | ${c5}O${c3}\\${c1}|.-' ${c3} _
${c1}  _J \\  .-    \\${c3}/ ${c5}O ${c3}| ${c1}| \\  |${c1}F    ${c3}(_)
${c1} '-F  -<_.     \\   .-'  `-' L__
__J  _   _.     >-'  ${c1})${c4}._.   ${c1}|-'
${c1} `-|.'   /_.          ${c4}\_|  ${c1} F
  /.-   .                _.<
 /'    /.'             .'  `\\
  /L  /'   |/      _.-'-\\
 /'J       ___.---'\|
   |\  .--' V  | `. `
   |/`. `-.     `._)
      / .-.\\
      \\ (  `\\
       `.\\
EOF
        ;;

        "openEuler"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}
                       (#####
                     (((########  #####
                    (((        ##########    __...__
             ((((((((           #######    /((((((###\
           (((((((((((   .......           \(((((####/
          ((((((    ((((#########            *******
    %((((((#          ((########
 /////(((((              ###
/////(((((((#   (((&
         (((((((((((((
          ((((((((((((
           (((((((((     ((((((###
                       /((((((######
                      //((((((######
                       /((((((#####
                        *********/
EOF
        ;;

        "OpenIndiana"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c2}                         .sy/
                         .yh+

           ${c1}-+syyyo+-     ${c2} /+.
         ${c1}+ddo/---/sdh/   ${c2} ym-
       ${c1}`hm+        `sms${c2}   ym-```````.-.
       ${c1}sm+           sm/ ${c2} ym-         +s
       ${c1}hm.           /mo ${c2} ym-         /h
       ${c1}omo           ym: ${c2} ym-       `os`
        ${c1}smo`       .ym+ ${c2}  ym-     .os-
     ``  ${c1}:ymy+///oyms- ${c2}   ym-  .+s+.
   ..`     ${c1}`:+oo+/-`  ${c2}    -//oyo-
 -:`                   .:oys/.
+-               `./oyys/.
h+`      `.-:+oyyyo/-`
`/ossssysso+/-.`
EOF
        ;;

        "openmamba"*)
            set_colors 7 2
            read -rd '' ascii_data <<'EOF'
${c1}                 `````
           .-/+ooooooooo+/:-`
        ./ooooooooooooooooooo+:.
      -+oooooooooooooooooooooooo+-
    .+ooooooooo+/:---::/+ooooooooo+.
   :oooooooo/-`          `-/oo${c2}s´${c1}oooo.${c2}s´${c1}
  :ooooooo/`                `${c2}sNds${c1}ooo${c2}sNds${c1}
 -ooooooo-                   ${c2}:dmy${c1}ooo${c2}:dmy${c1}
 +oooooo:                      :oooooo-
.ooooooo                        .://:`
:oooooo+                        ./+o+:`
-ooooooo`                      `oooooo+
`ooooooo:                      /oooooo+
 -ooooooo:                    :ooooooo.
  :ooooooo+.                .+ooooooo:
   :oooooooo+-`          `-+oooooooo:
    .+ooooooooo+/::::://oooooooooo+.
      -+oooooooooooooooooooooooo+-
        .:ooooooooooooooooooo+:.
           `-:/ooooooooo+/:.`
                 ``````
EOF
        ;;

        "OpenMandriva"*)
            set_colors 4
            read -rd '' ascii_data <<'EOF'
${c1}                  ``````
            `-:/+++++++//:-.`
         .:+++oooo+/:.``   ``
      `:+ooooooo+:.  `-:/++++++/:.`
     -+oooooooo:` `-++o+/::::://+o+/-
   `/ooooooooo-  -+oo/.`        `-/oo+.
  `+ooooooooo.  :os/`              .+so:
  +sssssssss/  :ss/                 `+ss-
 :ssssssssss`  sss`                  .sso
 ossssssssss  `yyo                    sys
`sssssssssss` `yys                   `yys
`sssssssssss:  +yy/                  +yy:
 oyyyyyyyyyys. `oyy/`              `+yy+
 :yyyyyyyyyyyo. `+yhs:.         `./shy/
  oyyyyyyyyyyys:` .oyhys+:----/+syhy+. `
  `syyyyyyyyyyyyo-` .:osyhhhhhyys+:``.:`
   `oyyyyyyyyyyyyys+-`` `.----.```./oo.
     /yhhhhhhhhhhhhhhyso+//://+osyhy/`
      `/yhhhhhhhhhhhhhhhhhhhhhhhhy/`
        `:oyhhhhhhhhhhhhhhhhhhyo:`
            .:+syhhhhhhhhys+:-`
                 ``....``
EOF
        ;;

        "OpenStage"*)
            set_colors 2
            read -rd '' ascii_data <<'EOF'
${c1}                 /(/
              .(((((((,
             /(((((((((/
           .(((((/,/(((((,
          *(((((*   ,(((((/
          (((((*      .*/((
         *((((/  (//(/*
         /((((*  ((((((((((,
      .  /((((*  (((((((((((((.
     ((. *((((/        ,((((((((
   ,(((/  (((((/     **   ,((((((*
  /(((((. .(((((/   //(((*  *(((((/
 .(((((,    ((/   .(((((/.   .(((((,
 /((((*        ,(((((((/      ,(((((
 /(((((((((((((((((((/.  /(((((((((/
 /(((((((((((((((((,   /(((((((((((/
     */(((((//*.      */((/(/(/*
EOF
        ;;

        "OpenWrt"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1} _______
|       |.-----.-----.-----.
|   -   ||  _  |  -__|     |
|_______||   __|_____|__|__|
         |__|
 ________        __
|  |  |  |.----.|  |_
|  |  |  ||   _||   _|
|________||__|  |____|
EOF
        ;;

        "Open Source Media Center"* | "osmc")
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}            -+shdmNNNNmdhs+-
        .+hMNho/:..``..:/ohNMh+.
      :hMdo.                .odMh:
    -dMy-                      -yMd-
   sMd-                          -dMs
  hMy       +.            .+       yMh
 yMy        dMs.        .sMd        yMy
:Mm         dMNMs`    `sMNMd        `mM:
yM+         dM//mNs``sNm//Md         +My
mM-         dM:  +NNNN+  :Md         -Mm
mM-         dM: `oNN+    :Md         -Mm
yM+         dM/+NNo`     :Md         +My
:Mm`        dMMNs`       :Md        `mM:
 yMy        dMs`         -ms        yMy
  hMy       +.                     yMh
   sMd-                          -dMs
    -dMy-                      -yMd-
      :hMdo.                .odMh:
        .+hMNho/:..``..:/ohNMh+.
            -+shdmNNNNmdhs+-
EOF
        ;;

        "Oracle"*)
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
${c1}
      `-/+++++++++++++++++/-.`
   `/syyyyyyyyyyyyyyyyyyyyyyys/.
  :yyyyo/-...............-/oyyyy/
 /yyys-                     .oyyy+
.yyyy`                       `syyy-
:yyyo                         /yyy/
.yyyy`                       `syyy-
 /yyys.                     .oyyyo
  /yyyyo:-...............-:oyyyy/`
   `/syyyyyyyyyyyyyyyyyyyyyyys+.
     `.:/+ooooooooooooooo+/:.`
EOF
        ;;

        "OS Elbrus"*)
            set_colors 4 7 3
            read -rd '' ascii_data <<'EOF'
${c1}   ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
   ██▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀██
   ██                       ██
   ██   ███████   ███████   ██
   ██   ██   ██   ██   ██   ██
   ██   ██   ██   ██   ██   ██
   ██   ██   ██   ██   ██   ██
   ██   ██   ██   ██   ██   ██
   ██   ██   ███████   ███████
   ██   ██                  ██
   ██   ██▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄██
   ██   ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀██
   ██                       ██
   ███████████████████████████
EOF
        ;;

        "PacBSD"*)
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
${c1}      :+sMs.
  `:ddNMd-                         -o--`
 -sMMMMh:                          `+N+``
 yMMMMMs`     .....-/-...           `mNh/
 yMMMMMmh+-`:sdmmmmmmMmmmmddy+-``./ddNMMm
 yNMMNMMMMNdyyNNMMMMMMMMMMMMMMMhyshNmMMMm
 :yMMMMMMMMMNdooNMMMMMMMMMMMMMMMMNmy:mMMd
  +MMMMMMMMMmy:sNMMMMMMMMMMMMMMMMMMMmshs-
  :hNMMMMMMN+-+MMMMMMMMMMMMMMMMMMMMMMMs.
 .omysmNNhy/+yNMMMMMMMMMMNMMMMMMMMMNdNNy-
 /hMM:::::/hNMMMMMMMMMMMm/-yNMMMMMMN.mMNh`
.hMMMMdhdMMMMMMMMMMMMMMmo  `sMMMMMMN mMMm-
:dMMMMMMMMMMMMMMMMMMMMMdo+  oMMMMMMN`smMNo`
/dMMMMMMMMMMMMMMMMMMMMMNd/` :yMMMMMN:-hMMM.
:dMMMMMMMMMMMMMMMMMMMMMNh`  oMMMMMMNo/dMNN`
:hMMMMMMMMMMMMMMMMMMMMMMNs--sMMMMMMMNNmy++`
 sNMMMMMMMMMMMMMMMMMMMMMMMmmNMMMMMMNho::o.
 :yMMMMMMMMMMMMMNho+sydNNNNNNNmysso/` -//
  /dMMMMMMMMMMMMMs-  ````````..``
   .oMMMMMMMMMMMMNs`               ./y:`
     +dNMMNMMMMMMMmy`          ``./ys.
      `/hMMMMMMMMMMMNo-``    `.+yy+-`
        `-/hmNMNMMMMMMmmddddhhy/-`
            `-+oooyMMMdsoo+/:.
EOF
        ;;

        "parabola_small"*)
            set_colors 5 7
            read -rd '' ascii_data <<'EOF'
${c1}  __ __ __  _
.`_//_//_/ / `.
          /  .`
         / .`
        /.`
       /`
EOF
        ;;

        "Parabola"*)
            set_colors 5 7
            read -rd '' ascii_data <<'EOF'
${c1}                          `.-.    `.
                   `.`  `:++.   `-+o+.
             `` `:+/. `:+/.   `-+oooo+
        ``-::-.:+/. `:+/.   `-+oooooo+
    `.-:///-  ..`   .-.   `-+oooooooo-
 `..-..`                 `+ooooooooo:
``                        :oooooooo/
                          `ooooooo:
                          `oooooo:
                          -oooo+.
                          +ooo/`
                         -ooo-
                        `+o/.
                        /+-
                       //`
                      -.
EOF
        ;;

        "Pardus"*)
            set_colors 3 7 6 1 8
            read -rd '' ascii_data <<'EOF'
${c1} .smNdy+-    `.:/osyyso+:.`    -+ydmNs.
/Md- -/ymMdmNNdhso/::/oshdNNmdMmy/. :dM/
mN.     oMdyy- -y          `-dMo     .Nm
.mN+`  sMy hN+ -:             yMs  `+Nm.
 `yMMddMs.dy `+`               sMddMMy`
   +MMMo  .`  .                 oMMM+
   `NM/    `````.`    `.`````    +MN`
   yM+   `.-:yhomy    ymohy:-.`   +My
   yM:          yo    oy          :My
   +Ms         .N`    `N.      +h sM+
   `MN      -   -::::::-   : :o:+`NM`
    yM/    sh   -dMMMMd-   ho  +y+My
    .dNhsohMh-//: /mm/ ://-yMyoshNd`
      `-ommNMm+:/. oo ./:+mMNmmo:`
     `/o+.-somNh- :yy: -hNmos-.+o/`
    ./` .s/`s+sMdd+``+ddMs+s`/s. `/.
        : -y.  -hNmddmNy.  .y- :
         -+       `..`       +-
EOF
        ;;

        "Parrot"*)
            set_colors 6 7
            read -rd '' ascii_data <<'EOF'
${c1}  `:oho/-`
`mMMMMMMMMMMMNmmdhy-
 dMMMMMMMMMMMMMMMMMMs`
 +MMsohNMMMMMMMMMMMMMm/
 .My   .+dMMMMMMMMMMMMMh.
  +       :NMMMMMMMMMMMMNo
           `yMMMMMMMMMMMMMm:
             /NMMMMMMMMMMMMMy`
              .hMMMMMMMMMMMMMN+
                  ``-NMMMMMMMMMd-
                     /MMMMMMMMMMMs`
                      mMMMMMMMsyNMN/
                      +MMMMMMMo  :sNh.
                      `NMMMMMMm     -o/
                       oMMMMMMM.
                       `NMMMMMM+
                        +MMd/NMh
                         mMm -mN`
                         /MM  `h:
                          dM`   .
                          :M-
                           d:
                           -+
                            -
EOF
        ;;

        "Parsix"*)
            set_colors 3 1 7 8
            read -rd '' ascii_data <<'EOF'
                 ${c2}-/+/:.
               ${c2}.syssssys.
       ${c1}.--.    ${c2}ssssssssso${c1}   ..--.
     :++++++:  ${c2}+ssssssss+${c1} ./++/+++:
    /+++++++++.${c2}.yssooooy`${c1}-+///////o-
    /++++++++++.${c2}+soooos:${c1}:+////////+-
     :+++++////o-${c2}oooooo-${c1}+/////////-
      `-/++//++-${c4}.-----.-${c1}:+/////:-
  ${c3}-://::--${c1}-:/:${c4}.--.````.--.${c1}:::-${c3}--::::::.
${c3}-/:::::::://:${c4}.:-`      `-:${c3}`:/:::::::--/-
${c3}/::::::::::/-${c4}--.        .-.${c3}-/://///::::/
${c3}-/:::::::::/:${c4}`:-.      .-:${c3}`:///////////-
 `${c3}-::::--${c1}.-://.${c4}---....---${c1}`:+/:-${c3}--::::-`
       ${c1}-/+///+o/-${c4}.----.${c1}.:oo+++o+.
     ${c1}-+/////+++o:${c2}syyyyy.${c1}o+++++++++:
    ${c1}.+////+++++-${c2}+sssssy+${c1}.++++++++++\
    ${c1}.+:/++++++.${c2}.yssssssy-${c1}`+++++++++:
     ${c1}:/+++++-  ${c2}+sssssssss  ${c1}-++++++-
       ${c1}`--`    ${c2}+sssssssso    ${c1}`--`
                ${c2}+sssssy+`
                 ${c2}`.::-`
EOF
        ;;

        "PCBSD"* | "TrueOS"*)
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
${c1}                       ..
                        s.
                        +y
                        yN
                       -MN  `.
                      :NMs `m
                    .yMMm` `No
            `-/+++sdMMMNs+-`+Ms
        `:oo+-` .yMMMMy` `-+oNMh
      -oo-     +NMMMM/       oMMh-
    .s+` `    oMMMMM/     -  oMMMhy.
   +s`- ::   :MMMMMd     -o `mMMMy`s+
  y+  h .Ny+oNMMMMMN/    sh+NMMMMo  +y
 s+ .ds  -NMMMMMMMMMMNdhdNMMMMMMh`   +s
-h .NM`   `hMMMMMMMMMMMMMMNMMNy:      h-
y- hMN`     hMMmMMMMMMMMMNsdMNs.      -y
m` mMMy`    oMMNoNMMMMMMo`  sMMMo     `m
m` :NMMMdyydMMMMo+MdMMMs     sMMMd`   `m
h-  `+ymMMMMMMMM--M+hMMN/    +MMMMy   -h
:y     `.sMMMMM/ oMM+.yMMNddNMMMMMm   y:
 y:   `s  dMMN- .MMMM/ :MMMMMMMMMMh  :y
 `h:  `mdmMMM/  yMMMMs  sMMMMMMMMN- :h`
   so  -NMMMN   /mmd+  `dMMMMMMMm- os
    :y: `yMMM`       `+NMMMMMMNo`:y:
      /s+`.omy      /NMMMMMNh/.+s:
        .+oo:-.     /mdhs+::oo+.
            -/o+++++++++++/-
EOF
        ;;

        "PCLinuxOS"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}            mhhhyyyyhhhdN
        dyssyhhhhhhhhhhhssyhN
     Nysyhhyo/:-.....-/oyhhhssd
   Nsshhy+.              `/shhysm
  dohhy/                    -shhsy
 dohhs`                       /hhys
N+hho   ${c2}+ssssss+-   .+syhys+   ${c1}/hhsy
ohhh`   ${c2}ymmo++hmm+`smmy/::+y`   ${c1}shh+
+hho    ${c2}ymm-  /mmy+mms          ${c1}:hhod
/hh+    ${c2}ymmhhdmmh.smm/          ${c1}.hhsh
+hhs    ${c2}ymm+::-`  /mmy`    `    ${c1}/hh+m
yyhh-   ${c2}ymm-       /dmdyosyd`  ${c1}`yhh+
 ohhy`  ${c2}://`         -/+++/-   ${c1}ohhom
 N+hhy-                      `shhoh
   sshho.                  `+hhyom
    dsyhhs/.            `:ohhhoy
      dysyhhhso///://+syhhhssh
         dhyssyhhhhhhyssyyhN
              mddhdhdmN
EOF
        ;;

        "Pengwin"*)
            set_colors 5 5 13
            read -rd '' ascii_data <<'EOF'
${c3}                     ...`
${c3}                     `-///:-`
${c3}                       .+${c2}ssys${c3}/
${c3}                        +${c2}yyyyy${c3}o    ${c2}
${c2}                        -yyyyyy:
${c2}           `.:/+ooo+/:` -yyyyyy+
${c2}         `:oyyyyyys+:-.`syyyyyy:
${c2}        .syyyyyyo-`   .oyyyyyyo
${c2}       `syyyyyy   `-+yyyyyyy/`
${c2}       /yyyyyy+ -/osyyyyyyo/.
${c2}       +yyyyyy-  `.-:::-.`
${c2}       .yyyyyy-
${c3}        :${c2}yyyyy${c3}o
${c3}         .+${c2}ooo${c3}+
${c3}           `.::/:.
EOF
        ;;

        "Peppermint"*)
            set_colors 1 15 3
            read -rd '' ascii_data <<'EOF'
${c1}               PPPPPPPPPPPPPP
${c1}           PPPP${c2}MMMMMMM${c1}PPPPPPPPPPP
${c1}         PPPP${c2}MMMMMMMMMM${c1}PPPPPPPP${c2}MM${c1}PP
${c1}       PPPPPPPP${c2}MMMMMMM${c1}PPPPPPPP${c2}MMMMM${c1}PP
${c1}     PPPPPPPPPPPP${c2}MMMMMM${c1}PPPPPPP${c2}MMMMMMM${c1}PP
${c1}    PPPPPPPPPPPP${c2}MMMMMMM${c1}PPPP${c2}M${c1}P${c2}MMMMMMMMM${c1}PP
${c1}   PP${c2}MMMM${c1}PPPPPPPPPP${c2}MMM${c1}PPPPP${c2}MMMMMMM${c1}P${c2}MM${c1}PPPP
${c1}   P${c2}MMMMMMMMMM${c1}PPPPPP${c2}MM${c1}PPPPP${c2}MMMMMM${c1}PPPPPPPP
${c1}  P${c2}MMMMMMMMMMMM${c1}PPPPP${c2}MM${c1}PP${c2}M${c1}P${c2}MM${c1}P${c2}MM${c1}PPPPPPPPPPP
${c1}  P${c2}MMMMMMMMMMMMMMMM${c1}PP${c2}M${c1}P${c2}MMM${c1}PPPPPPPPPPPPPPPP
${c1}  P${c2}MMM${c1}PPPPPPPPPPPPPPPPPPPPPPPPPPPPPP${c2}MMMMM${c1}P
${c1}  PPPPPPPPPPPPPPPP${c2}MMM${c1}P${c2}M${c1}P${c2}MMMMMMMMMMMMMMMM${c1}PP
${c1}  PPPPPPPPPPP${c2}MM${c1}P${c2}MM${c1}PPPP${c2}MM${c1}PPPPP${c2}MMMMMMMMMMM${c1}PP
${c1}   PPPPPPPP${c2}MMMMMM${c1}PPPPP${c2}MM${c1}PPPPPP${c2}MMMMMMMMM${c1}PP
${c1}   PPPP${c2}MM${c1}P${c2}MMMMMMM${c1}PPPPPP${c2}MM${c1}PPPPPPPPPP${c2}MMMM${c1}PP
${c1}    PP${c2}MMMMMMMMM${c1}P${c2}M${c1}PPPP${c2}MMMMMM${c1}PPPPPPPPPPPPP
${c1}     PP${c2}MMMMMMM${c1}PPPPPPP${c2}MMMMMM${c1}PPPPPPPPPPPP
${c1}       PP${c2}MMMM${c1}PPPPPPPPP${c2}MMMMMMM${c1}PPPPPPPP
${c1}         PP${c2}MM${c1}PPPPPPPP${c2}MMMMMMMMMM${c1}PPPP
${c1}           PPPPPPPPPP${c2}MMMMMMMM${c1}PPPP
${c1}               PPPPPPPPPPPPPP
EOF
        ;;

        "Pisi"*)
            set_colors 12 7 6 1 8
            read -rd '' ascii_data <<'EOF'
${c1}   \Fv/!-                      `:?lzC
${c1}   Q!::=zFx!  ${c2}`;v6WBCicl;`  ${c1},vCC\!::#.
${c1}  ,%:::,'` ${c2}+#%@@FQ@@.   ,cF%i${c1}``-',::a?
${c1}  +m:,'```${c2}}3,/@@Q\@@       "af-${c1} `-'"7f
  =o'.` ${c2}/m'   :Q@:Qg         ,kl${c1}  `.|o
  :k` '${c2}$+      'Narm           >d,${c1}  ii
   #`${c2}!p.        `C ,            'd+${c1} %'
${c2}   !0m                           `6Kv
   =a                              m+
  !A     !\L|:            :|L\!     $:
 .8`     Q''%Q#'        '#Q%''Q     `0-
 :6      E|.6QQu        uQQ6.|E      p:
  i{      \jts9?        ?9stj\      u\
   |a`            -''.            `e>
    ,m+     ${c1}'^ !`${c2}s@@@@a${c1}'"`+`${c2}     >e'
      !3|${c1}`|=>>r-  ${c2}'U%:${c1}  '>>>=:`\3!
       'xopE|      ${c2}`'${c1}     `ledoz-
    `;=>>+`${c2}`^llci/|==|/iclc;`${c1}'>>>>:
   `^`+~          ${c2}````${c1}          !!-^
EOF
        ;;

        "PNM Linux"* | "WHPNM Linux"*)
            set_colors 33 9 15 202
            read -rd '' ascii_data <<'EOF'

${c1}
               ``.---..` `--`
            ``.---........-:.${c2}-::`${c1}
           ${c2}./::-${c1}........${c2}--::.````${c1}
          ${c2}.:://:::${c1}----${c2}::::-..${c1}
          ..${c2}--:::::--::::++-${c1}.`
  ${c2}`-:-`${c1}   .-ohy+::${c2}-:::${c1}/sdmdd:.${c2}   `-:-
   .-:::${c1}...${c3}sNNmds$y${c1}o/+${c3}sy+NN$m${c1}d+.`${c2}-:::-.
     `.-:-${c1}./${c3}dN${c1}()${c3}yyooosd${c1}()${c3}$m${c1}dy${c2}-.::-.`${c1}
      ${c2}`.${c1}-...-${c3}+hNdyyyyyydmy${c1}:......${c2}`${c1}
 ``..--.....-${c3}yNNm${c4}hssssh${c3}mmdo${c1}.........```
`-:://:.....${c3}hNNNNN${c4}mddm${c3}NNNmds${c1}.....//::--`
  ```.:-...${c3}oNNNNNNNNNNNNNNmd/${c1}...:-.```
      .....${c3}hNNNNNNNNNNNNNNmds${c1}....`
      --...${c3}hNNNNNNNNNNNNNNmdo${c1}.....
      .:...${c3}/NNNNNNNNNNNNNNdd${c1}:....`
       `-...${c3}+mNNNNNNNNNNNmh${c1}:...-.
     ${c4}.:+o+/:-${c1}:+oo+///++o+/:-${c4}:/+ooo/:.
       ${c4}+oo/:o-            +oooooso.`
       ${c4}.`   `             `/  .-//-
EOF
        ;;

        "popos_small"* | "pop_os_small"*)
            set_colors 6 7
            read -rd '' ascii_data <<'EOF'
${c1}______
\\   _ \\        __
 \\ \\ \\ \\      / /
  \\ \\_\\ \\    / /
   \\  ___\\  /_/
    \\ \\    _
   __\\_\\__(_)_
  (___________)`
EOF
        ;;

        "Pop!_OS"* | "popos"* | "pop_os"*)
            set_colors 6 7
            read -rd '' ascii_data <<'EOF'
${c1}             /////////////
         /////////////////////
      ///////${c2}*767${c1}////////////////
    //////${c2}7676767676*${c1}//////////////
   /////${c2}76767${c1}//${c2}7676767${c1}//////////////
  /////${c2}767676${c1}///${c2}*76767${c1}///////////////
 ///////${c2}767676${c1}///${c2}76767${c1}.///${c2}7676*${c1}///////
/////////${c2}767676${c1}//${c2}76767${c1}///${c2}767676${c1}////////
//////////${c2}76767676767${c1}////${c2}76767${c1}/////////
///////////${c2}76767676${c1}//////${c2}7676${c1}//////////
////////////,${c2}7676${c1},///////${c2}767${c1}///////////
/////////////*${c2}7676${c1}///////${c2}76${c1}////////////
///////////////${c2}7676${c1}////////////////////
 ///////////////${c2}7676${c1}///${c2}767${c1}////////////
  //////////////////////${c2}'${c1}////////////
   //////${c2}.7676767676767676767,${c1}//////
    /////${c2}767676767676767676767${c1}/////
      ///////////////////////////
         /////////////////////
             /////////////
EOF
        ;;

        "Porteus"*)
            set_colors 6 7
            read -rd '' ascii_data <<'EOF'
${c1}             `.-:::-.`
         -+ydmNNNNNNNmdy+-
      .+dNmdhs+//////+shdmdo.
    .smmy+-`             ./sdy:
  `omdo.    `.-/+osssso+/-` `+dy.
 `yms.   `:shmNmdhsoo++osyyo-``oh.
 hm/   .odNmds/.`    ``.....:::-+s
/m:  `+dNmy:`   `./oyhhhhyyooo++so
ys  `yNmy-    .+hmmho:-.`     ```
s:  yNm+`   .smNd+.
`` /Nm:    +dNd+`
   yN+   `smNy.
   dm    oNNy`
   hy   -mNm.
   +y   oNNo
   `y`  sNN:
    `:  +NN:
     `  .mNo
         /mm`
          /my`
           .sy`
             .+:
                `
EOF
        ;;

        "postmarketos_small")
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c1}        /\\
       /  \\
      /    \\
      \\__   \\
    /\\__ \\  _\\
   /   /  \\/ __
  /   / ____/  \\
 /    \\ \\       \\
/_____/ /________\\
EOF
        ;;

        "PostMarketOS"*)
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c1}                 /\\
                /  \\
               /    \\
              /      \\
             /        \\
            /          \\
            \\           \\
          /\\ \\____       \\
         /  \\____ \\       \\
        /       /  \\       \\
       /       /    \\    ___\\
      /       /      \\  / ____
     /       /        \\/ /    \\
    /       / __________/      \\
   /        \\ \\                 \\
  /          \\ \\                 \\
 /           / /                  \\
/___________/ /____________________\\
EOF
        ;;

        "PuffOS"*)
            set_colors 3
            read -rd '' ascii_data <<'EOF'
${c1}
              _,..._,m,
            ,/'      '"";
           /             ".
         ,'mmmMMMMmm.      \
       _/-"^^^^^"""%#%mm,   ;
 ,m,_,'              "###)  ;,
(###%                 \#/  ;##mm.
 ^#/  __        ___    ;  (######)
  ;  //.\\     //.\\   ;   \####/
 _; (#\"//     \\"/#)  ;  ,/
@##\ \##/   =   `"=" ,;mm/
`\##>.____,...,____,<####@
EOF
        ;;

        "Proxmox"*)
            set_colors 7 202
            read -rd '' ascii_data <<'EOF'
${c1}         .://:`              `://:.
       `hMMMMMMd/          /dMMMMMMh`
        `sMMMMMMMd:      :mMMMMMMMs`
${c2}`-/+oo+/:${c1}`.yMMMMMMMh-  -hMMMMMMMy.`${c2}:/+oo+/-`
`:oooooooo/${c1}`-hMMMMMMMyyMMMMMMMh-`${c2}/oooooooo:`
  `/oooooooo:${c1}`:mMMMMMMMMMMMMm:`${c2}:oooooooo/`
    ./ooooooo+-${c1} +NMMMMMMMMN+ ${c2}-+ooooooo/.
      .+ooooooo+-${c1}`oNMMMMNo`${c2}-+ooooooo+.
        -+ooooooo/.${c1}`sMMs`${c2}./ooooooo+-
          :oooooooo/${c1}`..`${c2}/oooooooo:
          :oooooooo/`${c1}..${c2}`/oooooooo:
        -+ooooooo/.`${c1}sMMs${c2}`./ooooooo+-
      .+ooooooo+-`${c1}oNMMMMNo${c2}`-+ooooooo+.
    ./ooooooo+-${c1} +NMMMMMMMMN+ ${c2}-+ooooooo/.
  `/oooooooo:`${c1}:mMMMMMMMMMMMMm:${c2}`:oooooooo/`
`:oooooooo/`${c1}-hMMMMMMMyyMMMMMMMh-${c2}`/oooooooo:`
`-/+oo+/:`${c1}.yMMMMMMMh-  -hMMMMMMMy.${c2}`:/+oo+/-`
${c1}        `sMMMMMMMm:      :dMMMMMMMs`
       `hMMMMMMd/          /dMMMMMMh`
         `://:`              `://:`
EOF
        ;;

        "Puppy"* | "Quirky Werewolf"* | "Precise Puppy"*)
            set_colors 4 7
            read -rd '' ascii_data <<'EOF'
${c1}           `-/osyyyysosyhhhhhyys+-
  -ohmNNmh+/hMMMMMMMMNNNNd+dMMMMNM+
 yMMMMNNmmddo/NMMMNNNNNNNNNo+NNNNNy
.NNNNNNmmmddds:MMNNNNNNNNNNNh:mNNN/
-NNNdyyyhdmmmd`dNNNNNmmmmNNmdd/os/
.Nm+shddyooo+/smNNNNmmmmNh.   :mmd.
 NNNNy:`   ./hmmmmmmmNNNN:     hNMh
 NMN-    -++- +NNNNNNNNNNm+..-sMMMM-
.MMo    oNNNNo hNNNNNNNNmhdNNNMMMMM+
.MMs    /NNNN/ dNmhs+:-`  yMMMMMMMM+
 mMM+     .. `sNN+.      hMMMMhhMMM-
 +MMMmo:...:sNMMMMMms:` hMMMMm.hMMy
  yMMMMMMMMMMMNdMMMMMM::/+o+//dMMd`
   sMMMMMMMMMMN+:oyyo:sMMMNNMMMNy`
    :mMMMMMMMMMMMmddNMMMMMMMMmh/
      /dMMMMMMMMMMMMMMMMMMNdy/`
        .+hNMMMMMMMMMNmdhs/.
            .:/+ooo+/:-.
EOF
        ;;

        "pureos_small"*)
            set_colors 2 7 7
            read -rd '' ascii_data <<'EOF'
${c1} _____________
|  _________  |
| |         | |
| |         | |
| |_________| |
|_____________|
EOF
        ;;

        "PureOS"*)
            set_colors 2 7 7
            read -rd '' ascii_data <<'EOF'
${c1}dmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmd
dNm//////////////////////////////////mNd
dNd                                  dNd
dNd                                  dNd
dNd                                  dNd
dNd                                  dNd
dNd                                  dNd
dNd                                  dNd
dNd                                  dNd
dNd                                  dNd
dNm//////////////////////////////////mNd
dmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmd
EOF
        ;;

        "Qubes"*)
            set_colors 4 5 7 6
            read -rd '' ascii_data <<'EOF'
${c1}               `..--..`
            `.----------.`
        `..----------------..`
     `.------------------------.``
 `..-------------....-------------..`
.::----------..``    ``..----------:+:
:////:----..`            `..---:/ossso
:///////:`                  `/osssssso
:///////:                    /ssssssso
:///////:                    /ssssssso
:///////:                    /ssssssso
:///////:                    /ssssssso
:///////:                    /ssssssso
:////////-`                .:sssssssso
:///////////-.`        `-/osssssssssso
`//////////////:-```.:+ssssssssssssso-
  .-://////////////sssssssssssssso/-`
     `.:///////////sssssssssssssso:.
         .-:///////ssssssssssssssssss/`
            `.:////ssss+/+ssssssssssss.
                `--//-    `-/osssso/.
EOF
        ;;

        "Quibian"*)
            set_colors 3 7
            read -rd '' ascii_data <<'EOF'
${c1}            `.--::::::::--.`
        `.-:::-..``   ``..-::-.`
      .::::-`   .${c2}+${c1}:``       `.-::.`
    .::::.`    -::::::-`       `.::.
  `-:::-`    -:::::::::--..``     .::`
 `::::-     .${c2}oy${c1}:::::::---.```.:    `::`
 -::::  `.-:::::::::::-.```         `::
.::::.`-:::::::::::::.               `:.
-::::.:::::::::::::::                 -:
::::::::::::::::::::`                 `:
:::::::::::::::::::-                  `:
:::::::::::::::::::                   --
.:::::::::::::::::`                  `:`
`:::::::::::::::::                   -`
 .:::::::::::::::-                  -`
  `::::::::::::::-                `.`
    .::::::::::::-               ``
      `.--:::::-.
EOF
        ;;

        "Radix"*)
            set_colors 1 2
            read -rd '' ascii_data <<'EOF'
${c2}                .:oyhdmNo
             `/yhyoosdms`
            -o+/ohmmho-
           ..`.:/:-`
     `.--:::-.``${c1}
  .+ydNMMMMMMNmhs:`
`omMMMMMMMMMMMMMMNh-
oNMMMNmddhhyyhhhddmy.
mMMMMNmmddhhysoo+/:-`
yMMMMMMMMMMMMMMMMNNh.
-dmmmmmNNMMMMMMMMMMs`
 -+oossyhmMMMMMMMMd-
 `sNMMMMMMMMMMMMMm:
  `yMMMMMMNmdhhhh:
   `sNMMMMMNmmho.
    `+mMMMMMMMy.
      .yNMMMm+`
       `:yd+.
EOF
        ;;

        "Raspbian_small"*)
            set_colors 2 1
            read -rd '' ascii_data <<'EOF'
${c1}   ..    ,.
  :oo: .:oo:
  'o\\o o/o:
${c2} :: . :: . ::
:: :::  ::: ::
:'  '',.''  ':
 ::: :::: :::
 ':,  ''  ,:'
   ' ~::~ '
EOF
        ;;

        "Raspbian"*)
            set_colors 2 1
            read -rd '' ascii_data <<'EOF'
${c1}  `.::///+:/-.        --///+//-:``
 `+oooooooooooo:   `+oooooooooooo:
  /oooo++//ooooo:  ooooo+//+ooooo.
  `+ooooooo:-:oo-  +o+::/ooooooo:
   `:oooooooo+``    `.oooooooo+-
     `:++ooo/.        :+ooo+/.`
        ${c2}...`  `.----.` ``..
     .::::-``:::::::::.`-:::-`
    -:::-`   .:::::::-`  `-:::-
   `::.  `.--.`  `` `.---.``.::`
       .::::::::`  -::::::::` `
 .::` .:::::::::- `::::::::::``::.
-:::` ::::::::::.  ::::::::::.`:::-
::::  -::::::::.   `-::::::::  ::::
-::-   .-:::-.``....``.-::-.   -::-
 .. ``       .::::::::.     `..`..
   -:::-`   -::::::::::`  .:::::`
   :::::::` -::::::::::` :::::::.
   .:::::::  -::::::::. ::::::::
    `-:::::`   ..--.`   ::::::.
      `...`  `...--..`  `...`
            .::::::::::
             `.-::::-`
EOF
        ;;

        "Reborn OS"* | "Reborn"*)
            set_colors 2 2 8
            read -rd '' ascii_data <<'EOF'
${c3}
        mMMMMMMMMM  MMMMMMMMMm
       NM                    MN
      MM  ${c1}dddddddd  dddddddd  ${c3}MN
     mM  ${c1}dd                dd  ${c3}MM
        ${c1}dd  hhhhhh   hhhhh  dd
   ${c3}mM      ${c1}hh            hh      ${c3}Mm
  NM  ${c1}hd       ${c3}mMMMMMMd       ${c1}dh  ${c3}MN
 NM  ${c1}dd  hh   ${c3}mMMMMMMMMm   ${c1}hh  dd  ${c3}MN
NM  ${c1}dd  hh   ${c3}mMMMMMMMMMMm   ${c1}hh  dd  ${c3}MN
 NM  ${c1}dd  hh   ${c3}mMMMMMMMMm   ${c1}hh  dd  ${c3}MN
  NM  ${c1}hd       ${c3}mMMMMMMm       ${c1}dh  ${c3}MN
   mM      ${c1}hh            hh      ${c3}Mm
        ${c1}dd  hhhhhh  hhhhhh  dd
     ${c3}MM  ${c1}dd                dd  ${c3}MM
      MM  ${c1}dddddddd  dddddddd  ${c3}MN
       NM                    MN
        mMMMMMMMMM  MMMMMMMMMm
EOF
        ;;

        "Red Star"* | "Redstar"*)
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
${c1}                    ..
                  .oK0l
                 :0KKKKd.
               .xKO0KKKKd
              ,Od' .d0000l
             .c;.   .'''...           ..'.
.,:cloddxxxkkkkOOOOkkkkkkkkxxxxxxxxxkkkx:
;kOOOOOOOkxOkc'...',;;;;,,,'',;;:cllc:,.
 .okkkkd,.lko  .......',;:cllc:;,,'''''.
   .cdo. :xd' cd:.  ..';'',,,'',,;;;,'.
      . .ddl.;doooc'..;oc;'..';::;,'.
        coo;.oooolllllllcccc:'.  .
       .ool''lllllccccccc:::::;.
       ;lll. .':cccc:::::::;;;;'
       :lcc:'',..';::::;;;;;;;,,.
       :cccc::::;...';;;;;,,,,,,.
       ,::::::;;;,'.  ..',,,,'''.
        ........          ......
EOF
        ;;

        "Redcore"*)
            set_colors 1
            read -rd '' ascii_data <<'EOF'
${c1}                 RRRRRRRRR
               RRRRRRRRRRRRR
        RRRRRRRRRR      RRRRR
   RRRRRRRRRRRRRRRRRRRRRRRRRRR
 RRRRRRR  RRR         RRR RRRRRRRR
RRRRR    RR                 RRRRRRRRR
RRRR    RR     RRRRRRRR      RR RRRRRR
RRRR   R    RRRRRRRRRRRRRR   RR   RRRRR
RRRR   R  RRRRRRRRRRRRRRRRRR  R   RRRRR
RRRR     RRRRRRRRRRRRRRRRRRR  R   RRRR
 RRR     RRRRRRRRRRRRRRRRRRRR R   RRRR
  RRR    RRRRRRRRRRRRRRRRRRRR    RRRR
    RR   RRRRRRRRRRRRRRRRRRR    RRR
     RR   RRRRRRRRRRRRRRRRR    RRR
       RR   RRRRRRRRRRRRRR   RR
         R       RRRR      RR
EOF
        ;;

        "redhat_old" | "rhel_old"*)
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
${c1}             `.-..........`
            `////////::.`-/.
            -: ....-////////.
            //:-::///////////`
     `--::: `-://////////////:
     //////-    ``.-:///////// .`
     `://////:-.`    :///////::///:`
       .-/////////:---/////////////:
          .-://////////////////////.
${c2}         yMN+`.-${c1}::///////////////-`
${c2}      .-`:NMMNMs`  `..-------..`
       MN+/mMMMMMhoooyysshsss
MMM    MMMMMMMMMMMMMMyyddMMM+
 MMMM   MMMMMMMMMMMMMNdyNMMh`     hyhMMM
  MMMMMMMMMMMMMMMMyoNNNMMM+.   MMMMMMMM
   MMNMMMNNMMMMMNM+ mhsMNyyyyMNMMMMsMM
EOF
        ;;

        "Redhat"* | "Red Hat"* | "rhel"*)
            set_colors 1
            read -rd '' ascii_data <<'EOF'
${c1}           .MMM..:MMMMMMM
          MMMMMMMMMMMMMMMMMM
          MMMMMMMMMMMMMMMMMMMM.
         MMMMMMMMMMMMMMMMMMMMMM
        ,MMMMMMMMMMMMMMMMMMMMMM:
        MMMMMMMMMMMMMMMMMMMMMMMM
  .MMMM'  MMMMMMMMMMMMMMMMMMMMMM
 MMMMMM    `MMMMMMMMMMMMMMMMMMMM.
MMMMMMMM      MMMMMMMMMMMMMMMMMM .
MMMMMMMMM.       `MMMMMMMMMMMMM' MM.
MMMMMMMMMMM.                     MMMM
`MMMMMMMMMMMMM.                 ,MMMMM.
 `MMMMMMMMMMMMMMMMM.          ,MMMMMMMM.
    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
      MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:
         MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
            `MMMMMMMMMMMMMMMMMMMMMMMM:
                ``MMMMMMMMMMMMMMMMM'
EOF
        ;;

        "Refracted Devuan"* | "Refracted_Devuan"*)
            set_colors 8 7
            read -rd '' ascii_data <<'EOF'
${c2}                             A
                            VW
                           VVW\\
                         .yWWW\\
 ,;,,u,;yy;;v;uyyyyyyy  ,WWWWW^
    *WWWWWWWWWWWWWWWW/  $VWWWWw      ,
        ^*%WWWWWWVWWX  $WWWW**    ,yy
        ,    "**WWW/' **'   ,yy/WWW*`
       &WWWWwy    `*`  <,ywWW%VWWW*
     yWWWWWWWWWW*    .,   "**WW%W
   ,&WWWWWM*"`  ,y/  &WWWww   ^*
  XWWX*^   ,yWWWW09 .WWWWWWWWwy,
 *`        &WWWWWM  WWWWWWWWWWWWWww,
           (WWWWW` /#####WWW***********
           ^WWWW
            VWW
            Wh.
            V/
EOF
        ;;

        "Regata"*)
            set_colors 7 1 4 5 3 2
            read -rd '' ascii_data <<'EOF'
${c1}            ddhso+++++osydd
        dho/.`hh${c2}.:/+/:.${c1}hhh`:+yd
      do-hhhhhh${c2}/sssssss+`${c1}hhhhh./yd
    h/`hhhhhhh${c2}-sssssssss:${c1}hhhhhhhh-yd
  do`hhhhhhhhh${c2}`ossssssso.${c1}hhhhhhhhhh/d
 d/hhhhhhhhhhhh${c2}`/ossso/.${c1}hhhhhhhhhhhh.h
 /hhhhhhhhhhhh${c3}`-/osyso/-`${c1}hhhhhhhhhhhh.h
shh${c4}-/ooo+-${c1}hhh${c3}:syyso+osyys/`${c1}hhh${c5}`+oo`${c1}hhh/
h${c4}`ohhhhhhho`${c3}+yyo.${c1}hhhhh${c3}.+yyo`${c5}.sssssss.${c1}h`h
s${c4}:hhhhhhhhho${c3}yys`${c1}hhhhhhh${c3}.oyy/${c5}ossssssso-${c1}hs
s${c4}.yhhhhhhhy/${c3}yys`${c1}hhhhhhh${c3}.oyy/${c5}ossssssso-${c1}hs
hh${c4}./syyys+.${c1} ${c3}+yy+.${c1}hhhhh${c3}.+yyo`${c5}.ossssso/${c1}h`h
shhh${c4}``.`${c1}hhh${c3}`/syyso++oyys/`${c1}hhh${c5}`+++-`${c1}hh:h
d/hhhhhhhhhhhh${c3}`-/osyso+-`${c1}hhhhhhhhhhhh.h
 d/hhhhhhhhhhhh${c6}`/ossso/.${c1}hhhhhhhhhhhh.h
  do`hhhhhhhhh${c6}`ossssssso.${c1}hhhhhhhhhh:h
    h/`hhhhhhh${c6}-sssssssss:${c1}hhhhhhhh-yd
      h+.hhhhhh${c6}+sssssss+${c1}hhhhhh`/yd
        dho:.hhh${c6}.:+++/.${c1}hhh`-+yd
            ddhso+++++osyhd
EOF
        ;;

        "Regolith"*)
            set_colors 1
            read -rd '' ascii_data <<'EOF'
${c1}
                 ``....```
            `.:/++++++/::-.`
          -/+++++++:.`
        -++++++++:`
      `/++++++++-
     `/++++++++.                    -/+/
     /++++++++/             ``   .:+++:.
    -+++++++++/          ./++++:+++/-`
    :+++++++++/         `+++++++/-`
    :++++++++++`      .-/+++++++`
   `:++++++++++/``.-/++++:-:::-`      `
 `:+++++++++++++++++/:.`            ./`
:++/-:+++++++++/:-..              -/+.
+++++++++/::-...:/+++/-..````..-/+++.
`......``.::/+++++++++++++++++++++/.
         -/+++++++++++++++++++++/.
           .:/+++++++++++++++/-`
              `.-:://////:-.
EOF
        ;;

        "rocky_small"*)
            set_colors 2
                read -rd '' ascii_data <<'EOF'
${c1}    `-/+++++++++/-.`
 `-+++++++++++++++++-`
.+++++++++++++++++++++.
-+++++++++++++++++++++++.
+++++++++++++++/-/+++++++
+++++++++++++/.   ./+++++
+++++++++++:.       ./+++
+++++++++:`   `:/:`   .:/
-++++++:`   .:+++++:`
 .+++-`   ./+++++++++:`
  `-`   ./+++++++++++-
       -+++++++++:-.`
EOF
        ;;

        "rocky"*)
            set_colors 35
            read -rd '' ascii_data <<'EOF'
${c1}          __wgliliiligw_,
       _williiiiiiliilililw,
     _%iiiiiilililiiiiiiiiiii_
   .Qliiiililiiiiiiililililiilm.
  _iiiiiliiiiiililiiiiiiiiiiliil,
 .lililiiilililiiiilililililiiiii,
_liiiiiiliiiiiiiliiiiiF{iiiiiilili,
jliililiiilililiiili@`  ~ililiiiiiL
iiiliiiiliiiiiiili>`      ~liililii
liliiiliiilililii`         -9liiiil
iiiiiliiliiiiii~             "4lili
4ililiiiiilil~|      -w,       )4lf
-liiiiililiF'       _liig,       )'
 )iiiliii@`       _QIililig,
  )iiii>`       .Qliliiiililw
   )<>~       .mliiiiiliiiiiil,
            _gllilililiililii~
           giliiiiiiiiiiiiT`
          -^~$ililili@~~'
EOF
        ;;

        "Rosa"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}           ROSAROSAROSAROSAR
        ROSA               AROS
      ROS   SAROSAROSAROSAR   AROS
    RO   ROSAROSAROSAROSAROSAR   RO
  ARO  AROSAROSAROSARO      AROS  ROS
 ARO  ROSAROS         OSAR   ROSA  ROS
 RO  AROSA   ROSAROSAROSA    ROSAR  RO
RO  ROSAR  ROSAROSAROSAR  R  ROSARO  RO
RO  ROSA  AROSAROSAROSA  AR  ROSARO  AR
RO AROS  ROSAROSAROSA   ROS  AROSARO AR
RO AROS  ROSAROSARO   ROSARO  ROSARO AR
RO  ROS  AROSAROS   ROSAROSA AROSAR  AR
RO  ROSA  ROS     ROSAROSAR  ROSARO  RO
 RO  ROS     AROSAROSAROSA  ROSARO  AR
 ARO  ROSA   ROSAROSAROS   AROSAR  ARO
  ARO  OROSA      R      ROSAROS  ROS
    RO   AROSAROS   AROSAROSAR   RO
     AROS   AROSAROSAROSARO   AROS
        ROSA               SARO
           ROSAROSAROSAROSAR
EOF
        ;;

        "sabotage"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c2} .|'''.|      |     '||''|.    ..|''||
 ||..  '     |||     ||   ||  .|'    ||
  ''|||.    |  ||    ||'''|.  ||      ||
.     '||  .''''|.   ||    || '|.     ||
|'....|'  .|.  .||. .||...|'   ''|...|'

|''||''|     |      ..|'''.|  '||''''|
   ||       |||    .|'     '   ||  .
   ||      |  ||   ||    ....  ||''|
   ||     .''''|.  '|.    ||   ||
  .||.   .|.  .||.  ''|...'|  .||.....|
EOF
        ;;

        "Sabayon"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}            ...........
         ..             ..
      ..                   ..
    ..           ${c2}o           ${c1}..
  ..            ${c2}:W'            ${c1}..
 ..             ${c2}.d.             ${c1}..
:.             ${c2}.KNO              ${c1}.:
:.             ${c2}cNNN.             ${c1}.:
:              ${c2}dXXX,              ${c1}:
:   ${c2}.          dXXX,       .cd,   ${c1}:
:   ${c2}'kc ..     dKKK.    ,ll;:'    ${c1}:
:     ${c2}.xkkxc;..dkkkc',cxkkl       ${c1}:
:.     ${c2}.,cdddddddddddddo:.       ${c1}.:
 ..         ${c2}:lllllll:           ${c1}..
   ..         ${c2}',,,,,          ${c1}..
     ..                     ..
        ..               ..
          ...............
EOF
        ;;

        "Sailfish"*)
            set_colors 4 5 7 6
            read -rd '' ascii_data <<'EOF'
${c1}                 _a@b
              _#b (b
            _@@   @_         _,
          _#^@ _#*^^*gg,aa@^^
          #- @@^  _a@^^
          @_  *g#b
          ^@_   ^@_
            ^@_   @
             @(b (b
            #b(b#^
          _@_#@^
       _a@a*^
   ,a@*^
EOF
        ;;

        "SalentOS"*)
            set_colors 2 1 3 7
            read -rd '' ascii_data <<'EOF'
${c1}                 ``..``
        .-:+oshdNMMMMMMNdhyo+:-.`
  -oydmMMMMMMMMMMMMMMMMMMMMMMMMMMNdhs/
${c4} +hdddm${c1}NMMMMMMMMMMMMMMMMMMMMMMMMN${c4}mdddh+`
${c2}`MMMMMN${c4}mdddddm${c1}MMMMMMMMMMMM${c4}mdddddm${c3}NMMMMM-
${c2} mMMMMMMMMMMMN${c4}ddddhyyhhddd${c3}NMMMMMMMMMMMM`
${c2} dMMMMMMMMMMMMMMMMM${c4}oo${c3}MMMMMMMMMMMMMMMMMN`
${c2} yMMMMMMMMMMMMMMMMM${c4}hh${c3}MMMMMMMMMMMMMMMMMd
${c2} +MMMMMMMMMMMMMMMMM${c4}hh${c3}MMMMMMMMMMMMMMMMMy
${c2} :MMMMMMMMMMMMMMMMM${c4}hh${c3}MMMMMMMMMMMMMMMMMo
${c2} .MMMMMMMMMMMMMMMMM${c4}hh${c3}MMMMMMMMMMMMMMMMM/
${c2} `NMMMMMMMMMMMMMMMM${c4}hh${c3}MMMMMMMMMMMMMMMMM-
${c2}  mMMMMMMMMMMMMMMMM${c4}hh${c3}MMMMMMMMMMMMMMMMN`
${c2}  hMMMMMMMMMMMMMMMM${c4}hh${c3}MMMMMMMMMMMMMMMMm
${c2}  /MMMMMMMMMMMMMMMM${c4}hh${c3}MMMMMMMMMMMMMMMMy
${c2}   .+hMMMMMMMMMMMMM${c4}hh${c3}MMMMMMMMMMMMMms:
${c2}      `:smMMMMMMMMM${c4}hh${c3}MMMMMMMMMNh+.
${c2}          .+hMMMMMM${c4}hh${c3}MMMMMMdo:
${c2}             `:smMM${c4}yy${c3}MMNy/`
                 ${c2}.- ${c4}`${c3}:.
EOF
        ;;

        "Scientific"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}                 =/;;/-
                +:    //
               /;      /;
              -X        H.
.//;;;:;;-,   X=        :+   .-;:=;:;#;.
M-       ,=;;;#:,      ,:#;;:=,       ,@
:#           :#.=/++++/=.$=           #=
 ,#;         #/:+/;,,/++:+/         ;+.
   ,+/.    ,;@+,        ,#H;,    ,/+,
      ;+;;/= @.  ${c3}.H${c2}#${c3}#X   ${c1}-X :///+;
      ;+=;;;.@,  ${c2}.X${c3}M${c2}@$.  ${c1}=X.//;=#/.
   ,;:      :@#=        =$H:     .+#-
 ,#=         #;-///==///-//         =#,
;+           :#-;;;:;;;;-X-           +:
@-      .-;;;;M-        =M/;;;-.      -X
 :;;::;;-.    #-        :+    ,-;;-;:==
              ,X        H.
               ;/      #=
                //    +;
                 '////'
EOF
        ;;

        "Septor"*)
            set_colors 4 7 4
            read -rd '' ascii_data <<'EOF'
${c1}ssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssss
ssssssssss${c2};okOOOOOOOOOOOOOOko;${c1}ssssssssss
sssssssss${c2}oNWWWWWWWWWWWWWWWWWWNo${c1}sssssssss
ssssssss${c2}:WWWWWWWWWWWWWWWWWWWWWW:${c1}ssssssss
ssssssss${c2}lWWWWWk${c1}ssssssssss${c2}lddddd:${c1}ssssssss
ssssssss${c2}cWWWWWNKKKKKKKKKKKKOx:${c1}ssssssssss
${c3}yy${c1}sssssss${c2}OWWWWWWWWWWWWWWWWWWWWx${c1}sssssss${c3}yy
yyyyyyyyyy${c2}:kKNNNNNNNNNNNNWWWWWW:${c3}yyyyyyyy
yyyyyyyy${c2}sccccc;${c3}yyyyyyyyyy${c2}kWWWWW:${c3}yyyyyyyy
yyyyyyyy${c2}:WWWWWWNNNNNNNNNNWWWWWW;${c3}yyyyyyyy
yyyyyyyy${c2}.dWWWWWWWWWWWWWWWWWWWNd${c3}yyyyyyyyy
yyyyyyyyyy${c2}sdO0KKKKKKKKKKKK0Od;${c3}yyyyyyyyyy
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
EOF
        ;;

        "Serene"*)
            set_colors 6 6
            read -rd '' ascii_data <<'EOF'
${c1}              __---''''''---__
          .                      .
        :                          :
      -                       _______----_-
     s               __----'''     __----
 __h_            _-'           _-'     h
 '-._''--.._    ;           _-'         y
  :  ''-._  '-._/        _-'             :
  y       ':_       _--''                y
  m    .--'' '-._.;'                     m
  m   :        :                         m
  y    '.._     '-__                     y
  :        '--._    '''----___           :
   y            '--._         ''-- _    y
    h                '--._          :  h
     s                  __';         vs
      -         __..--''             -
        :_..--''                   :
          .                     _ .
            `''---______---''-``
EOF
        ;;

        "SharkLinux"*)
            set_colors 4 7
            read -rd '' ascii_data <<'EOF'
${c1}                              `:shd/
                          `:yNMMMMs
                       `-smMMMMMMN.
                     .+dNMMMMMMMMs
                   .smNNMMMMMMMMm`
                 .sNNNNNNNMMMMMM/
               `omNNNNNNNMMMMMMm
              /dNNNNNNNNMMMMMMM+
            .yNNNNNNNNNMMMMMMMN`
           +mNNNNNNNNNMMMMMMMMh
         .hNNNNNNNNNNMMMMMMMMMs
        +mMNNNNNNNNMMMMMMMMMMMs
      .hNMMNNNNMMMMMMMMMMMMMMMd
    .oNNNNNNNNNNMMMMMMMMMMMMMMMo
 `:+syyssoo++++ooooossssssssssso:
EOF
        ;;

        "Siduction"*)
            set_colors 4 4
            read -rd '' ascii_data <<'EOF'
${c1}                _aass,
               jQh: =$w
               QWmwawQW
               )$QQQQ@(   ..
         _a_a.   ~??^  syDY?Sa,
       _mW>-<$c       jWmi  imm.
       ]QQwayQE       4QQmgwmQQ`
        ?WWQWP'       -9QQQQQ@'._aas,
 _a%is.        .adYYs,. -"?!` aQB*~^3$c
_Qh;.nm       .QWc. {QL      ]QQp;..vmQ/
"QQmmQ@       -QQQggmQP      ]QQWmggmQQ(
 -???"         "$WQQQY`  __,  ?QQQQQQW!
        _yZ!?q,   -   .yWY!!Sw, "???^
       .QQa_=qQ       mQm>..vmm
        $QQWQQP       $QQQgmQQ@
         "???"   _aa, -9WWQQWY`
               _mB>~)$a  -~~
               mQms_vmQ.
               ]WQQQQQP
                -?T??"
EOF
        ;;

        "slackware_small"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}   ________
  /  ______|
  | |______
  \\______  \\
   ______| |
| |________/
|____________
EOF
        ;;

        "Slackware"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}                  :::::::
            :::::::::::::::::::
         :::::::::::::::::::::::::
       ::::::::${c2}cllcccccllllllll${c1}::::::
    :::::::::${c2}lc               dc${c1}:::::::
   ::::::::${c2}cl   clllccllll    oc${c1}:::::::::
  :::::::::${c2}o   lc${c1}::::::::${c2}co   oc${c1}::::::::::
 ::::::::::${c2}o    cccclc${c1}:::::${c2}clcc${c1}::::::::::::
 :::::::::::${c2}lc        cclccclc${c1}:::::::::::::
::::::::::::::${c2}lcclcc          lc${c1}::::::::::::
::::::::::${c2}cclcc${c1}:::::${c2}lccclc     oc${c1}:::::::::::
::::::::::${c2}o    l${c1}::::::::::${c2}l    lc${c1}:::::::::::
 :::::${c2}cll${c1}:${c2}o     clcllcccll     o${c1}:::::::::::
 :::::${c2}occ${c1}:${c2}o                  clc${c1}:::::::::::
  ::::${c2}ocl${c1}:${c2}ccslclccclclccclclc${c1}:::::::::::::
   :::${c2}oclcccccccccccccllllllllllllll${c1}:::::
    ::${c2}lcc1lcccccccccccccccccccccccco${c1}::::
      ::::::::::::::::::::::::::::::::
        ::::::::::::::::::::::::::::
           ::::::::::::::::::::::
                ::::::::::::
EOF
        ;;

        "SliTaz"*)
            set_colors 3 3
            read -rd '' ascii_data <<'EOF'
${c1}        @    @(               @
      @@   @@                  @    @/
     @@   @@                   @@   @@
    @@  %@@                     @@   @@
   @@  %@@@       @@@@@.       @@@@  @@
  @@@    @@@@    @@@@@@@    &@@@    @@@
   @@@@@@@ %@@@@@@@@@@@@ &@@@% @@@@@@@/
       ,@@@@@@@@@@@@@@@@@@@@@@@@@
  .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/
@@@@@@.  @@@@@@@@@@@@@@@@@@@@@  /@@@@@@
@@    @@@@@  @@@@@@@@@@@@,  @@@@@   @@@
@@ @@@@.    @@@@@@@@@@@@@%    #@@@@ @@.
@@ ,@@      @@@@@@@@@@@@@      @@@  @@
@   @@.     @@@@@@@@@@@@@     @@@  *@
@    @@     @@@@@@@@@@@@      @@   @
      @      @@@@@@@@@.     #@
       @      ,@@@@@       @
EOF
        ;;

        "SmartOS"*)
            set_colors 6 7
            read -rd '' ascii_data <<'EOF'
${c1}yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
yyyys             oyyyyyyyyyyyyyyyy
yyyys  yyyyyyyyy  oyyyyyyyyyyyyyyyy
yyyys  yyyyyyyyy  oyyyyyyyyyyyyyyyy
yyyys  yyyyyyyyy  oyyyyyyyyyyyyyyyy
yyyys  yyyyyyyyy  oyyyyyyyyyyyyyyyy
yyyys  yyyyyyyyyyyyyyyyyyyyyyyyyyyy
yyyyy                         syyyy
yyyyyyyyyyyyyyyyyyyyyyyyyyyy  syyyy
yyyyyyyyyyyyyyyy  syyyyyyyyy  syyyy
yyyyyyyyyyyyyyyy  oyyyyyyyyy  syyyy
yyyyyyyyyyyyyyyy  oyyyyyyyyy  syyyy
yyyyyyyyyyyyyyyy  syyyyyyyyy  syyyy
yyyyyyyyyyyyyyyy              yyyyy
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
EOF
        ;;

        "SkiffOS"*)
            set_colors 4 7
            read -rd '' ascii_data <<'EOF'
${c2}
             ,@@@@@@@@@@@w,_
  ${c2}====~~~,,.${c2}A@@@@@@@@@@@@@@@@@W,_
  ${c1}`||||||||||||||L{${c2}"@$@@@@@@@@B"
   ${c1}`|||||||||||||||||||||L{${c2}"$D
     ${c2}@@@@@@@@@@@@@@@@@@@@@${c1}_||||}==,
      ${c2}*@@@@@@@@@@@@@@@@@@@@@@@@@p${c1}||||==,
        ${c1}`'||LLL{{""${c2}@$B@@@@@@@@@@@@@@@p${c1}||
            ${c1}`~=|||||||||||L"${c2}$@@@@@@@@@@@
                   ${c1}````'"""""""${c2}'""""""""
EOF
            ;;

        "Solus"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c2}            -```````````
          `-+/------------.`
       .---:mNo---------------.
     .-----yMMMy:---------------.
   `------oMMMMMm/----------------`
  .------/MMMMMMMN+----------------.
 .------/NMMMMMMMMm-+/--------------.
`------/NMMMMMMMMMN-:mh/-------------`
.-----/NMMMMMMMMMMM:-+MMd//oso/:-----.
-----/NMMMMMMMMMMMM+--mMMMh::smMmyo:--
----+NMMMMMMMMMMMMMo--yMMMMNo-:yMMMMd/.
.--oMMMMMMMMMMMMMMMy--yMMMMMMh:-yMMMy-`
`-sMMMMMMMMMMMMMMMMh--dMMMMMMMd:/Ny+y.
`-/+osyhhdmmNNMMMMMm-/MMMMMMMmh+/ohm+
  .------------:://+-/++++++${c1}oshddys:
   -hhhhyyyyyyyyyyyhhhhddddhysssso-
    `:ossssssyysssssssssssssssso:`
      `:+ssssssssssssssssssss+-
         `-/+ssssssssssso+/-`
              `.-----..`
EOF
        ;;

        "Source Mage"* | "Source_Mage"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c2}       :ymNMNho.
.+sdmNMMMMMMMMMMy`
.-::/yMMMMMMMMMMMm-
      sMMMMMMMMMMMm/
     /NMMMMMMMMMMMMMm:
    .MMMMMMMMMMMMMMMMM:
    `MMMMMMMMMMMMMMMMMN.
     NMMMMMMMMMMMMMMMMMd
     mMMMMMMMMMMMMMMMMMMo
     hhMMMMMMMMMMMMMMMMMM.
     .`/MMMMMMMMMMMMMMMMMs
        :mMMMMMMMMMMMMMMMN`
         `sMMMMMMMMMMMMMMM+
           /NMMMMMMMMMMMMMN`
             oMMMMMMMMMMMMM+
          ./sd.-hMMMMMMMMmmN`
      ./+oyyyh- `MMMMMMMMMmNh
                 sMMMMMMMMMmmo
                 `NMMMMMMMMMd:
                  -dMMMMMMMMMo
                    -shmNMMms.
EOF
        ;;

        "Sparky"*)
            set_colors 1 7
            read -rd '' ascii_data <<'EOF'
${c1}
           .            `-:-`
          .o`       .-///-`
         `oo`    .:/++:.
         os+`  -/+++:` ``.........```
        /ys+`./+++/-.-::::::----......``
       `syyo`++o+--::::-::/+++/-``
       -yyy+.+o+`:/:-:sdmmmmmmmmdy+-`
::-`   :yyy/-oo.-+/`ymho++++++oyhdmdy/`
`/yy+-`.syyo`+o..o--h..osyhhddhs+//osyy/`
  -ydhs+-oyy/.+o.-: ` `  :/::+ydhy+```-os-
   .sdddy::syo--/:.     `.:dy+-ohhho    ./:
     :yddds/:+oo+//:-`- /+ +hy+.shhy:     ``
      `:ydmmdysooooooo-.ss`/yss--oyyo
        `./ossyyyyo+:-/oo:.osso- .oys
       ``..-------::////.-oooo/   :so
    `...----::::::::--.`/oooo:    .o:
           ```````     ++o+:`     `:`
                     ./+/-`        `
                   `-:-.
                   ``
EOF
        ;;

        "Star"*)
            set_colors 7
            read -rd '' ascii_data <<'EOF'
${c1}                   ./
                  `yy-
                 `y.`y`
    ``           s-  .y            `
    +h//:..`    +/    /o    ``..:/so
     /o``.-::/:/+      o/://::-.`+o`
      :s`     `.        .`     `s/
       .y.                    .s-
        `y-                  :s`
      .-//.                  /+:.
   .:/:.                       .:/:.
-+o:.                             .:+:.
-///++///:::`              .-::::///+so-
       ``..o/              d-....```
           s.     `/.      d
           h    .+o-+o-    h.
           h  -o/`   `/o:  s:
          -s/o:`       `:o/+/
          /s-             -yo
EOF
        ;;

        "SteamOS"*)
            set_colors 5 7
            read -rd '' ascii_data <<'EOF'
${c1}              .,,,,.
        .,'onNMMMMMNNnn',.
     .'oNMANKMMMMMMMMMMMNNn'.
   .'ANMMMMMMMXKNNWWWPFFWNNMNn.
  ;NNMMMMMMMMMMNWW'' ,.., 'WMMM,
 ;NMMMMV+##+VNWWW' .+;'':+, 'WMW,
,VNNWP+${c2}######${c1}+WW,  ${c2}+:    ${c1}:+, +MMM,
'${c2}+#############,   +.    ,+' ${c1}+NMMM
${c2}  '*#########*'     '*,,*' ${c1}.+NMMMM.
${c2}     `'*###*'          ,.,;###${c1}+WNM,
${c2}         .,;;,      .;##########${c1}+W
${c2},',.         ';  ,+##############'
 '###+. :,. .,; ,###############'
  '####.. `'' .,###############'
    '#####+++################'
      '*##################*'
         ''*##########*''
              ''''''
EOF
        ;;

        "sunos_small" | "solaris_small")
            set_colors 3 7
            read -rd '' ascii_data <<'EOF'
${c1}       .   .;   .
   .   :;  ::  ;:   .
   .;. ..      .. .;.
..  ..             ..  ..
 .;,                 ,;.
EOF
        ;;

        "SunOS" | "Solaris")
            set_colors 3 7
            read -rd '' ascii_data <<'EOF'
${c1}                 `-     `
          `--    `+-    .:
           .+:  `++:  -/+-     .
    `.::`  -++/``:::`./+/  `.-/.
      `++/-`.`          ` /++:`
  ``   ./:`                .: `..`.-
``./+/:-                     -+++:-
    -/+`                      :.
EOF
        ;;

        "openSUSE Leap"* | "openSUSE_Leap"*)
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c2}                 `-++:`
               ./oooooo/-
            `:oooooooooooo:.
          -+oooooooooooooooo+-`
       ./oooooooooooooooooooooo/-
      :oooooooooooooooooooooooooo:
    `  `-+oooooooooooooooooooo/-   `
 `:oo/-   .:ooooooooooooooo+:`  `-+oo/.
`/oooooo:.   -/oooooooooo/.   ./oooooo/.
  `:+ooooo+-`  `:+oooo+-   `:oooooo+:`
     .:oooooo/.   .::`   -+oooooo/.
        -/oooooo:.    ./oooooo+-
          `:+ooooo+-:+oooooo:`
             ./oooooooooo/.
                -/oooo+:`
                  `:/.
EOF
        ;;

        "t2"*)
            set_colors 7 4
            read -rd '' ascii_data <<'EOF'
${c2}
TTTTTTTTTT
    tt   ${c1}222${c2}
    tt  ${c1}2   2${c2}
    tt     ${c1}2${c2}
    tt    ${c1}2${c2}
    tt  ${c1}22222${c2}
EOF
        ;;

        "openSUSE Tumbleweed"* | "openSUSE_Tumbleweed"*)
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c2}                                     ......
     .,cdxxxoc,.               .:kKMMMNWMMMNk:.
    cKMMN0OOOKWMMXo. ;        ;0MWk:.      .:OMMk.
  ;WMK;.       .lKMMNM,     :NMK,             .OMW;
 cMW;            'WMMMN   ,XMK,                 oMM'
.MMc               ..;l. xMN:                    KM0
'MM.                   'NMO                      oMM
.MM,                 .kMMl                       xMN
 KM0               .kMM0. .dl:,..               .WMd
 .XM0.           ,OMMK,    OMMMK.              .XMK
   oWMO:.    .;xNMMk,       NNNMKl.          .xWMx
     :ONMMNXMMMKx;          .  ,xNMWKkxllox0NMWk,
         .....                    .:dOOXXKOxl,
EOF
        ;;

        "opensuse_small" | "suse_small"*)
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c1}  _______
__|   __ \\
     / .\\ \\
     \\__/ |
   _______|
   \\_______
__________/
EOF
        ;;

        "openSUSE"* | "open SUSE"* | "SUSE"*)
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c2}           .;ldkO0000Okdl;.
       .;d00xl:^''''''^:ok00d;.
     .d00l'                'o00d.
   .d0Kd'${c1}  Okxol:;,.          ${c2}:O0d.
  .OK${c1}KKK0kOKKKKKKKKKKOxo:,      ${c2}lKO.
 ,0K${c1}KKKKKKKKKKKKKKK0P^${c2},,,${c1}^dx:${c2}    ;00,
.OK${c1}KKKKKKKKKKKKKKKk'${c2}.oOPPb.${c1}'0k.${c2}   cKO.
:KK${c1}KKKKKKKKKKKKKKK: ${c2}kKx..dd ${c1}lKd${c2}   'OK:
dKK${c1}KKKKKKKKKOx0KKKd ${c2}^0KKKO' ${c1}kKKc${c2}   dKd
dKK${c1}KKKKKKKKKK;.;oOKx,..${c2}^${c1}..;kKKK0.${c2}  dKd
:KK${c1}KKKKKKKKKK0o;...^cdxxOK0O/^^'  ${c2}.0K:
 kKK${c1}KKKKKKKKKKKKK0x;,,......,;od  ${c2}lKk
 '0K${c1}KKKKKKKKKKKKKKKKKKKK00KKOo^  ${c2}c00'
  'kK${c1}KKOxddxkOO00000Okxoc;''   ${c2}.dKk'
    l0Ko.                    .c00l'
     'l0Kk:.              .;xK0l'
        'lkK0xl:;,,,,;:ldO0kl'
            '^:ldxkkkkxdl:^'
EOF
        ;;

        "SwagArch"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c2}        .;ldkOKXXNNNNXXK0Oxoc,.
   ,lkXMMNK0OkkxkkOKWMMMMMMMMMM;
 'K0xo  ..,;:c:.     `'lKMMMMM0
     .lONMMMMMM'         `lNMk'
${c2}    ;WMMMMMMMMMO.              ${c1}....::...
${c2}    OMMMMMMMMMMMMKl.       ${c1}.,;;;;;ccccccc,
${c2}    `0MMMMMMMMMMMMMM0:         ${c1}.. .ccccccc.
${c2}      'kWMMMMMMMMMMMMMNo.   ${c1}.,:'  .ccccccc.
${c2}        `c0MMMMMMMMMMMMMN,${c1},:c;    :cccccc:
${c2} ckl.      `lXMMMMMMMMMX${c1}occcc:.. ;ccccccc.
${c2}dMMMMXd,     `OMMMMMMWk${c1}ccc;:''` ,ccccccc:
${c2}XMMMMMMMWKkxxOWMMMMMNo${c1}ccc;     .cccccccc.
${c2} `':ldxO0KXXXXXK0Okdo${c1}cccc.     :cccccccc.
                    :ccc:'     `cccccccc:,
                                   ''
EOF
        ;;

        "Tails"*)
            set_colors 5 7
            read -rd '' ascii_data <<'EOF'
${c1}      ``
  ./yhNh
syy/Nshh         `:o/
N:dsNshh  █   `ohNMMd
N-/+Nshh      `yMMMMd
N-yhMshh       yMMMMd
N-s:hshh  █    yMMMMd so//.
N-oyNsyh       yMMMMd d  Mms.
N:hohhhd:.     yMMMMd  syMMM+
Nsyh+-..+y+-   yMMMMd   :mMM+
+hy-      -ss/`yMMMM     `+d+
  :sy/.     ./yNMMMMm      ``
    .+ys- `:+hNMMMMMMy/`
      `hNmmMMMMMMMMMMMMdo.
       dMMMMMMMMMMMMMMMMMNh:
       +hMMMMMMMMMMMMMMMMMmy.
         -oNMMMMMMMMMMmy+.`
           `:yNMMMds/.`
              .//`
EOF
        ;;

        "Trisquel"*)
            set_colors 4 6
            read -rd '' ascii_data <<'EOF'
${c1}                         ▄▄▄▄▄▄
                      ▄█████████▄
      ▄▄▄▄▄▄         ████▀   ▀████
   ▄██████████▄     ████▀   ▄▄ ▀███
 ▄███▀▀   ▀▀████     ███▄   ▄█   ███
▄███   ▄▄▄   ████▄    ▀██████   ▄███
███   █▀▀██▄  █████▄     ▀▀   ▄████
▀███      ███  ███████▄▄  ▄▄██████
${c1} ▀███▄   ▄███  █████████████${c2}████▀
${c1}  ▀█████████    ███████${c2}███▀▀▀
    ▀▀███▀▀     ██████▀▀
               ██████▀   ▄▄▄▄
              █████▀   ████████
              █████   ███▀  ▀███
               ████▄   ██▄▄▄  ███
                █████▄   ▀▀  ▄██
                  ██████▄▄▄████
                     ▀▀█████▀▀
EOF
        ;;

        "Ubuntu Cinnamon"* | "Ubuntu-Cinnamon"*)
            set_colors 1 7
            read -rd '' ascii_data <<'EOF'
${c1}            .-/+oooooooo+/-.
        `:+oooooooooooooooooo+:`
      -+oooooooooooooooooooooooo+-
    .ooooooooooooooooooo${c2}:ohNd${c1}oooooo.
   /oooooooooooo${c2}:/+oo++:/ohNd${c1}ooooooo/
  +oooooooooo${c2}:osNdhyyhdNNh+:+${c1}oooooooo+
 /ooooooooo${c2}/dN/${c1}ooooooooo${c2}/sNNo${c1}ooooooooo/
.ooooooooo${c2}oMd:${c1}oooooooooooo${c2}:yMy${c1}ooooooooo.
+ooooo${c2}:+o/Md${c1}oooooo${c2}:sm/${c1}oo/ooo${c2}yMo${c1}oooooooo+
ooo${c2}:sdMdosMo${c1}ooooo${c2}oNMd${c1}//${c2}dMd+${c1}o${c2}:so${c1}ooooooooo
oooo${c2}+ymdosMo${c1}ooo${c2}+mMm${c1}+/${c2}hMMMMMh+hs${c1}ooooooooo
+oooooo${c2}:${c1}:${c2}/Nm:${c1}/${c2}hMNo${c1}:y${c2}MMMMMMMMMM+${c1}oooooooo+
.ooooooooo${c2}/NNMNy${c1}:o${c2}NMMMMMMMMMMo${c1}ooooooooo.
/oooooooooo${c2}:yh:${c1}+m${c2}MMMMMMMMMMd/${c1}ooooooooo/
  +oooooooooo${c2}+${c1}/h${c2}mMMMMMMNds//o${c1}oooooooo+
   /oooooooooooo${c2}+:////:o/ymMd${c1}ooooooo/
    .oooooooooooooooooooo${c2}/sdh${c1}oooooo.
      -+oooooooooooooooooooooooo+-
        `:+oooooooooooooooooo+:`
            .-/+oooooooo+/-.
EOF
        ;;

        "Ubuntu Budgie"* | "Ubuntu-Budgie"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c2}           ./oydmMMMMMMmdyo/.
        :smMMMMMMMMMMMhs+:++yhs:
     `omMMMMMMMMMMMN+`        `odo`
    /NMMMMMMMMMMMMN-            `sN/
  `hMMMMmhhmMMMMMMh               sMh`
 .mMmo-     /yMMMMm`              `MMm.
 mN/       yMMMMMMMd-              MMMm
oN-        oMMMMMMMMMms+//+o+:    :MMMMo
m/          +NMMMMMMMMMMMMMMMMm. :NMMMMm
M`           .NMMMMMMMMMMMMMMMNodMMMMMMM
M-            sMMMMMMMMMMMMMMMMMMMMMMMMM
mm`           mMMMMMMMMMNdhhdNMMMMMMMMMm
oMm/        .dMMMMMMMMh:      :dMMMMMMMo
 mMMNyo/:/sdMMMMMMMMM+          sMMMMMm
 .mMMMMMMMMMMMMMMMMMs           `NMMMm.
  `hMMMMMMMMMMM.oo+.            `MMMh`
    /NMMMMMMMMMo                sMN/
     `omMMMMMMMMy.            :dmo`
        :smMMMMMMMh+-`   `.:ohs:
           ./oydmMMMMMMdhyo/.
EOF
        ;;

        "Ubuntu-GNOME"*)
            set_colors 4 5 7 6
            read -rd '' ascii_data <<'EOF'
${c3}          ./o.
        .oooooooo
      .oooo```soooo
    .oooo`     `soooo
   .ooo`   ${c4}.o.${c3}   `\/ooo.
   :ooo   ${c4}:oooo.${c3}   `\/ooo.
    sooo    ${c4}`ooooo${c3}    \/oooo
     \/ooo    ${c4}`soooo${c3}    `ooooo
      `soooo    ${c4}`\/ooo${c3}    `soooo
${c4}./oo    ${c3}`\/ooo    ${c4}`/oooo.${c3}   `/ooo
${c4}`\/ooo.   ${c3}`/oooo.   ${c4}`/oooo.${c3}   ``
${c4}  `\/ooo.    ${c3}/oooo     ${c4}/ooo`
${c4}     `ooooo    ${c3}``    ${c4}.oooo
${c4}       `soooo.     .oooo`
         `\/oooooooooo`
            ``\/oo``
EOF
        ;;

        "Ubuntu MATE"* | "Ubuntu-MATE"*)
            set_colors 2 7
            read -rd '' ascii_data <<'EOF'
${c1}            .:/+oossssoo+/:.`
        `:+ssssssssssssssssss+:`
      -+sssssssssssssss${c2}y${c1}ssssssss+-
    .osssssssssssss${c2}yy${c1}ss${c2}mMmh${c1}ssssssso.
   /sssssssss${c2}ydmNNNmmd${c1}s${c2}mMMMMNdy${c1}sssss/
 `+ssssssss${c2}hNNdy${c1}sssssss${c2}mMMMMNdy${c1}ssssss+`
 +sssssss${c2}yNNh${c1}ss${c2}hmNNNNm${c1}s${c2}mMmh${c1}s${c2}ydy${c1}sssssss+
-sssss${c2}y${c1}ss${c2}Nm${c1}ss${c2}hNNh${c1}ssssss${c2}y${c1}s${c2}hh${c1}ss${c2}mMy${c1}sssssss-
+ssss${c2}yMNdy${c1}ss${c2}hMd${c1}ssssssssss${c2}hMd${c1}ss${c2}NN${c1}sssssss+
sssss${c2}yMMMMMmh${c1}sssssssssssss${c2}NM${c1}ss${c2}dMy${c1}sssssss
sssss${c2}yMMMMMmhy${c1}ssssssssssss${c2}NM${c1}ss${c2}dMy${c1}sssssss
+ssss${c2}yMNdy${c1}ss${c2}hMd${c1}ssssssssss${c2}hMd${c1}ss${c2}NN${c1}sssssss+
-sssss${c2}y${c1}ss${c2}Nm${c1}ss${c2}hNNh${c1}ssssssss${c2}dh${c1}ss${c2}mMy${c1}sssssss-
 +sssssss${c2}yNNh${c1}ss${c2}hmNNNNm${c1}s${c2}mNmh${c1}s${c2}ymy${c1}sssssss+
  +ssssssss${c2}hNNdy${c1}sssssss${c2}mMMMMmhy${c1}ssssss+
   /sssssssss${c2}ydmNNNNmd${c1}s${c2}mMMMMNdh${c1}sssss/
    .osssssssssssss${c2}yy${c1}ss${c2}mMmdy${c1}sssssso.
      -+sssssssssssssss${c2}y${c1}ssssssss+-
        `:+ssssssssssssssssss+:`
            .:/+oossssoo+/:.

EOF
        ;;

        "ubuntu_old")
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
${c1}                         ./+o+-
${c2}                 yyyyy- ${c1}-yyyyyy+
${c2}              ${c2}://+//////${c1}-yyyyyyo
${c3}          .++ ${c2}.:/++++++/-${c1}.+sss/`
${c3}        .:++o:  ${c2}/++++++++/:--:/-
${c3}       o:+o+:++.${c2}`..```.-/oo+++++/
${c3}      .:+o:+o/.${c2}          `+sssoo+/
${c2} .++/+:${c3}+oo+o:`${c2}             /sssooo.
${c2}/+++//+:${c3}`oo+o${c2}               /::--:.
${c2}+/+o+++${c3}`o++o${c1}               ++////.
${c2} .++.o+${c3}++oo+:`${c1}             /dddhhh.
${c3}      .+.o+oo:.${c1}          `oddhhhh+
${c3}       +.++o+o`${c1}`-````.:ohdhhhhh+
${c3}        `:o+++ ${c1}`ohhhhhhhhyo++os:
${c3}          .o:${c1}`.syhhhhhhh/${c3}.oo++o`
${c1}              /osyyyyyyo${c3}++ooo+++/
${c1}                  ````` ${c3}+oo+++o:
${c3}                         `oo++.
EOF
        ;;

        "Ubuntu Studio"* | "Ubuntu-Studio")
            set_colors 6 7
            read -rd '' ascii_data <<'EOF'
${c1}              ..-::::::-.`
         `.:+++++++++++${c2}ooo${c1}++:.`
       ./+++++++++++++${c2}sMMMNdyo${c1}+/.
     .++++++++++++++++${c2}oyhmMMMMms${c1}++.
   `/+++++++++${c2}osyhddddhys${c1}+${c2}osdMMMh${c1}++/`
  `+++++++++${c2}ydMMMMNNNMMMMNds${c1}+${c2}oyyo${c1}++++`
  +++++++++${c2}dMMNhso${c1}++++${c2}oydNMMmo${c1}++++++++`
 :+${c2}odmy${c1}+++${c2}ooysoohmNMMNmyoohMMNs${c1}+++++++:
 ++${c2}dMMm${c1}+${c2}oNMd${c1}++${c2}yMMMmhhmMMNs+yMMNo${c1}+++++++
`++${c2}NMMy${c1}+${c2}hMMd${c1}+${c2}oMMMs${c1}++++${c2}sMMN${c1}++${c2}NMMs${c1}+++++++.
`++${c2}NMMy${c1}+${c2}hMMd${c1}+${c2}oMMMo${c1}++++${c2}sMMN${c1}++${c2}mMMs${c1}+++++++.
 ++${c2}dMMd${c1}+${c2}oNMm${c1}++${c2}yMMNdhhdMMMs${c1}+y${c2}MMNo${c1}+++++++
 :+${c2}odmy${c1}++${c2}oo${c1}+${c2}ss${c1}+${c2}ohNMMMMmho${c1}+${c2}yMMMs${c1}+++++++:
  +++++++++${c2}hMMmhs+ooo+oshNMMms${c1}++++++++
  `++++++++${c2}oymMMMMNmmNMMMMmy+oys${c1}+++++`
   `/+++++++++${c2}oyhdmmmmdhso+sdMMMs${c1}++/
     ./+++++++++++++++${c2}oyhdNMMMms${c1}++.
       ./+++++++++++++${c2}hMMMNdyo${c1}+/.
         `.:+++++++++++${c2}sso${c1}++:.
              ..-::::::-..
EOF
        ;;

        "ubuntu_small")
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
${c1}         _
     ---(_)
 _/  ---  \\
(_) |   |
  \\  --- _/
     ---(_)
EOF
        ;;

        "Ubuntu"* | "i3buntu"*)
            set_colors 1 7 3
            read -rd '' ascii_data <<'EOF'
${c1}            .-/+oossssoo+\-.
        ´:+ssssssssssssssssss+:`
      -+ssssssssssssssssssyyssss+-
    .ossssssssssssssssss${c2}dMMMNy${c1}sssso.
   /sssssssssss${c2}hdmmNNmmyNMMMMh${c1}ssssss\
  +sssssssss${c2}hm${c1}yd${c2}MMMMMMMNddddy${c1}ssssssss+
 /ssssssss${c2}hNMMM${c1}yh${c2}hyyyyhmNMMMNh${c1}ssssssss\
.ssssssss${c2}dMMMNh${c1}ssssssssss${c2}hNMMMd${c1}ssssssss.
+ssss${c2}hhhyNMMNy${c1}ssssssssssss${c2}yNMMMy${c1}sssssss+
oss${c2}yNMMMNyMMh${c1}ssssssssssssss${c2}hmmmh${c1}ssssssso
oss${c2}yNMMMNyMMh${c1}sssssssssssssshmmmh${c1}ssssssso
+ssss${c2}hhhyNMMNy${c1}ssssssssssss${c2}yNMMMy${c1}sssssss+
.ssssssss${c2}dMMMNh${c1}ssssssssss${c2}hNMMMd${c1}ssssssss.
 \ssssssss${c2}hNMMM${c1}yh${c2}hyyyyhdNMMMNh${c1}ssssssss/
  +sssssssss${c2}dm${c1}yd${c2}MMMMMMMMddddy${c1}ssssssss+
   \sssssssssss${c2}hdmNNNNmyNMMMMh${c1}ssssss/
    .ossssssssssssssssss${c2}dMMMNy${c1}sssso.
      -+sssssssssssssssss${c2}yyy${c1}ssss+-
        `:+ssssssssssssssssss+:`
            .-\+oossssoo+/-.
EOF
        ;;

        "Univention"*)
            set_colors 1 7
            read -rd '' ascii_data <<'EOF'
${c1}         ./osssssssssssssssssssssso+-
       `ohhhhhhhhhhhhhhhhhhhhhhhhhhhhy:
       shhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh-
   `-//${c2}sssss${c1}/hhhhhhhhhhhhhh+${c2}s${c1}.hhhhhhhhh+
 .ohhhy${c2}sssss${c1}.hhhhhhhhhhhhhh.${c2}sss${c1}+hhhhhhh+
.yhhhhy${c2}sssss${c1}.hhhhhhhhhhhhhh.${c2}ssss${c1}:hhhhhh+
+hhhhhy${c2}sssss${c1}.hhhhhhhhhhhhhh.${c2}sssss${c1}yhhhhh+
+hhhhhy${c2}sssss${c1}.hhhhhhhhhhhhhh.${c2}sssss${c1}yhhhhh+
+hhhhhy${c2}sssss${c1}.hhhhhhhhhhhhhh.${c2}sssss${c1}yhhhhh+
+hhhhhy${c2}sssss${c1}.hhhhhhhhhhhhhh.${c2}sssss${c1}yhhhhh+
+hhhhhy${c2}sssss${c1}.hhhhhhhhhhhhhh.${c2}sssss${c1}yhhhhh+
+hhhhhy${c2}sssss${c1}.hhhhhhhhhhhhhh.${c2}sssss${c1}yhhhhh+
+hhhhhy${c2}sssss${c1}.hhhhhhhhhhhhhh.${c2}sssss${c1}yhhhhh+
+hhhhhy${c2}ssssss${c1}+yhhhhhhhhhhy/${c2}ssssss${c1}yhhhhh+
+hhhhhh:${c2}sssssss${c1}:hhhhhhh+${c2}.ssssssss${c1}yhhhhy.
+hhhhhhh+`${c2}ssssssssssssssss${c1}hh${c2}sssss${c1}yhhho`
+hhhhhhhhhs+${c2}ssssssssssss${c1}+hh+${c2}sssss${c1}/:-`
-hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhho
 :yhhhhhhhhhhhhhhhhhhhhhhhhhhhh+`
   -+ossssssssssssssssssssss+:`
EOF
        ;;

        "Venom"*)
            set_colors 8 4
            read -rd '' ascii_data <<'EOF'
${c1}   :::::::          :::::::
   mMMMMMMm        dMMMMMMm
   /MMMMMMMo      +MMMMMMM/
    yMMMMMMN      mMMMMMMy
     NMMMMMMs    oMMMMMMm
     +MMMMMMN:   NMMMMMM+
      hMMMMMMy  sMMMMMMy
      :NMMMMMM::NMMMMMN:
       oMMMMMMyyMMMMMM+
        dMMMMMMMMMMMMh
        /MMMMMMMMMMMN:
         sMMMMMMMMMMo
          mMMMMMMMMd
          +MMMMMMMN:
            ::::::
EOF
        ;;

        "void_small")
            set_colors 2 8
            read -rd '' ascii_data <<'EOF'
${c1}    _______
 _ \\______ -
| \\  ___  \\ |
| | /   \ | |
| | \___/ | |
| \\______ \\_|
 -_______\\
EOF
        ;;

        "Void"*)
            set_colors 2 8
            read -rd '' ascii_data <<'EOF'
${c1}                __.;=====;.__
            _.=+==++=++=+=+===;.
             -=+++=+===+=+=+++++=_
        .     -=:``     `--==+=++==.
       _vi,    `            --+=++++:
      .uvnvi.       _._       -==+==+.
     .vvnvnI`    .;==|==;.     :|=||=|.
${c2}+QmQQm${c1}pvvnv; ${c2}_yYsyQQWUUQQQm #QmQ#${c1}:${c2}QQQWUV$QQm.
${c2} -QQWQW${c1}pvvo${c2}wZ?.wQQQE${c1}==<${c2}QWWQ/QWQW.QQWW${c1}(: ${c2}jQWQE
${c2}  -$QQQQmmU'  jQQQ@${c1}+=<${c2}QWQQ)mQQQ.mQQQC${c1}+;${c2}jWQQ@'
${c2}   -$WQ8Y${c1}nI:   ${c2}QWQQwgQQWV${c1}`${c2}mWQQ.jQWQQgyyWW@!
${c1}     -1vvnvv.     `~+++`        ++|+++
      +vnvnnv,                 `-|===
       +vnvnvns.           .      :=-
        -Invnvvnsi..___..=sv=.     `
          +Invnvnvnnnnnnnnvvnn;.
            ~|Invnvnvvnvvvnnv}+`
               -~|{*l}*|~
EOF

        ;;

        "LangitKetujuh"*)
            set_colors 7 4
            read -rd '' ascii_data <<'EOF'
${c1}
   L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L
      'L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L
   L7L.   'L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L
   L7L7L7L                             L7L7L7L
   L7L7L7L                             L7L7L7L
   L7L7L7L             L7L7L7L7L7L7L7L7L7L7L7L
   L7L7L7L                'L7L7L7L7L7L7L7L7L7L
   L7L7L7L                    'L7L7L7L7L7L7L7L
   L7L7L7L                             L7L7L7L
   L7L7L7L                             L7L7L7L
   L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L.   'L7L
   L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L.
   L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L7L
${c2}
EOF
        ;;

       "semc"*)
            set_colors 2 8 1
            read -rd '' ascii_data <<'EOF'
${c1}            /\
     ______/  \
    /      |()| ${c2}E M C
${c1}   |   (-- |  |
    \   \  |  |
.----)   | |__|
|_______/ / ${c3}"${c1}  \
              ${c3}"
            "
EOF

        ;;

        "Obarun"*)
            set_colors 6 6 7 1
            read -rd '' ascii_data <<'EOF'
${c1}                    ,;::::;
                ;cooolc;,
             ,coool;
           ,loool,
          loooo;
        :ooool
       cooooc            ,:ccc;
      looooc           :oooooool
     cooooo          ;oooooooooo,
    :ooooo;         :ooooooooooo
    oooooo          oooooooooooc
   :oooooo         :ooooooooool
   loooooo         ;oooooooool
   looooooc        .coooooooc
   cooooooo:           ,;co;
   ,ooooooool;       ,:loc
    cooooooooooooloooooc
     ;ooooooooooooool;
       ;looooooolc;
EOF
        ;;

        *"[Windows 11]"*|*"on Windows 11"*|\
        "Windows 11"* |"windows11")
            set_colors 6 7
            read -rd '' ascii_data <<'EOF'
${c1}
################  ################
################  ################
################  ################
################  ################
################  ################
################  ################
################  ################
 
################  ################
################  ################
################  ################
################  ################
################  ################
################  ################
################  ################
EOF
        ;;

        *"[Windows 10]"*|*"on Windows 10"*|"Windows 8"*|\
        "Windows 10"* |"windows10"|"windows8")
            set_colors 6 7
            read -rd '' ascii_data <<'EOF'
${c1}                                ..,
                    ....,,:;+ccllll
      ...,,+:;  cllllllllllllllllll
,cclllllllllll  lllllllllllllllllll
llllllllllllll  lllllllllllllllllll
llllllllllllll  lllllllllllllllllll
llllllllllllll  lllllllllllllllllll
llllllllllllll  lllllllllllllllllll
llllllllllllll  lllllllllllllllllll

llllllllllllll  lllllllllllllllllll
llllllllllllll  lllllllllllllllllll
llllllllllllll  lllllllllllllllllll
llllllllllllll  lllllllllllllllllll
llllllllllllll  lllllllllllllllllll
`'ccllllllllll  lllllllllllllllllll
       `' \\*::  :ccllllllllllllllll
                       ````''*::cll
                                 ``
EOF
        ;;

        "Windows"*)
            set_colors 1 2 4 3
            read -rd '' ascii_data <<'EOF'
${c1}        ,.=:!!t3Z3z.,
       :tt:::tt333EE3
${c1}       Et:::ztt33EEEL${c2} @Ee.,      ..,
${c1}      ;tt:::tt333EE7${c2} ;EEEEEEttttt33#
${c1}     :Et:::zt333EEQ.${c2} $EEEEEttttt33QL
${c1}     it::::tt333EEF${c2} @EEEEEEttttt33F
${c1}    ;3=*^```"*4EEV${c2} :EEEEEEttttt33@.
${c3}    ,.=::::!t=., ${c1}`${c2} @EEEEEEtttz33QF
${c3}   ;::::::::zt33)${c2}   "4EEEtttji3P*
${c3}  :t::::::::tt33.${c4}:Z3z..${c2}  ``${c4} ,..g.
${c3}  i::::::::zt33F${c4} AEEEtttt::::ztF
${c3} ;:::::::::t33V${c4} ;EEEttttt::::t3
${c3} E::::::::zt33L${c4} @EEEtttt::::z3F
${c3}{3=*^```"*4E3)${c4} ;EEEtttt:::::tZ`
${c3}             `${c4} :EEEEtttt::::z7
                 "VEzjt:;;z>*`
EOF
        ;;

        "Xubuntu"*)
            set_colors 4 7 1
            read -rd '' ascii_data <<'EOF'
${c1}           `.:/ossyyyysso/:.
        `.yyyyyyyyyyyyyyyyyyyy.`
      `yyyyyyyyyyyyyyyyyyyyyyyyyy`
    `yyyyyyyyyyyyyyyyyyyy${c2}::${c1}yyyyyyyy`
   .yyyyyyyyyyy${c2}/+:${c1}yyyyyyy${c2}ds${c1}yyy${c2}+y${c1}yyyy.
  yyyyyyy${c2}:o/${c1}yy${c2}dMMM+${c1}yyyyy${c2}/M+${c1}y${c2}:hM+${c1}yyyyyy
 yyyyyyy${c2}+MMMy${c1}y${c2}mMMMh${c1}yyyyy${c2}yM::mM+${c1}yyyyyyyy
`yyyyyyy${c2}+MMMMysMMMd${c1}yyyyy${c2}dh:mN+${c1}yyyyyyyyy`
yyyyyyyy${c2}:NMMMMmMMMMmmdhyy+/y:${c1}yyyyyyyyyyy
yyyyyyyy${c2}+MMMMMMMMMMMMMMMMMMNho:${c1}yyyyyyyyy
yyyyyyyy${c2}mMMMMMMMMMMMMMMMMMMMMMMy${c1}yyyyyyyy
yyyyyyy${c2}+MMMMMMMMMMMMMMMMMMMMMMMM/${c1}yyyyyyy
`yyyyyy${c2}sMMMMMMMMMMMMMMMMMMMMMMmo${c1}yyyyyyy`
 yyyyyy${c2}oMMMMMMMMMMMMMMMMMMMmy+${c1}yyyyyyyyy
  yyyyy${c2}:mMMMMMMMMMMMMMMNho/${c1}yyyyyyyyyyy
   .yyyy${c2}:yNMMMMMMMNdyo:${c1}yyyyyyyyyyyyy.
    `yyyyyy${c2}:/++/::${c1}yyyyyyyyyyyyyyyyy`
      `yyyyyyyyyyyyyyyyyyyyyyyyyy`
        `.yyyyyyyyyyyyyyyyyyyy.`
           `.:/oosyyyysso/:.`
EOF
        ;;
                "IRIX"*)
                    set_colors 4 7
                    read -rd '' ascii_data <<'EOF'
${c1}           ./ohmNd/  +dNmho/-
     `:+ydNMMMMMMMM.-MMMMMMMMMdyo:.
   `hMMMMMMNhs/sMMM-:MMM+/shNMMMMMMh`
   -NMMMMMmo-` /MMM-/MMM- `-omMMMMMN.
 `.`-+hNMMMMMNhyMMM-/MMMshmMMMMMmy+...`
+mMNds:-:sdNMMMMMMMyyMMMMMMMNdo:.:sdMMm+
dMMMMMMmy+.-/ymNMMMMMMMMNmy/-.+hmMMMMMMd
oMMMMmMMMMNds:.+MMMmmMMN/.-odNMMMMmMMMM+
.MMMM-/ymMMMMMmNMMy..hMMNmMMMMMmy/-MMMM.
 hMMM/ `/dMMMMMMMN////NMMMMMMMd/. /MMMh
 /MMMdhmMMMmyyMMMMMMMMMMMMhymMMMmhdMMM:
 `mMMMMNho//sdMMMMM//NMMMMms//ohNMMMMd
  `/so/:+ymMMMNMMMM` mMMMMMMMmh+::+o/`
     `yNMMNho-yMMMM` NMMMm.+hNMMNh`
     -MMMMd:  oMMMM. NMMMh  :hMMMM-
      -yNMMMmooMMMM- NMMMyomMMMNy-
        .omMMMMMMMM-`NMMMMMMMmo.
          `:hMMMMMM. NMMMMMh/`
             .odNm+  /dNms.
EOF
                ;;
        "Zorin"*)
            set_colors 4 6
            read -rd '' ascii_data <<'EOF'
${c1}        `osssssssssssssssssssso`
       .osssssssssssssssssssssso.
      .+oooooooooooooooooooooooo+.


  `::::::::::::::::::::::.         .:`
 `+ssssssssssssssssss+:.`     `.:+ssso`
.ossssssssssssssso/.       `-+ossssssso.
ssssssssssssso/-`      `-/osssssssssssss
.ossssssso/-`      .-/ossssssssssssssso.
 `+sss+:.      `.:+ssssssssssssssssss+`
  `:.         .::::::::::::::::::::::`


      .+oooooooooooooooooooooooo+.
       -osssssssssssssssssssssso-
        `osssssssssssssssssssso`
EOF
        ;;

        *)
            case $kernel_name in
                *"BSD")
                    set_colors 1 7 4 3 6
                    read -rd '' ascii_data <<'EOF'
${c1}             ,        ,
            /(        )`
            \ \___   / |
            /- _  `-/  '
           (${c2}/\/ \ ${c1}\   /\
           ${c2}/ /   | `    ${c1}\
           ${c3}O O   ${c2}) ${c1}/    |
           ${c2}`-^--'${c1}`<     '
          (_.)  _  )   /
           `.___/`    /
             `-----' /
${c4}<----.     __ / __   \
${c4}<----|====${c1}O)))${c4}==${c1}) \) /${c4}====|
<----'    ${c1}`--' `.__,' \
             |        |
              \       /       /\
         ${c5}______${c1}( (_  / \______/
       ${c5},'  ,-----'   |
       `--{__________)
EOF
                ;;

                "Darwin")
                    set_colors 2 3 1 1 5 4
                    read -rd '' ascii_data <<'EOF'
${c1}                    c.'
                 ,xNMM.
               .OMMMMo
               lMMM"
     .;loddo:.  .olloddol;.
   cKMMMMMMMMMMNWMMMMMMMMMM0:
${c2} .KMMMMMMMMMMMMMMMMMMMMMMMWd.
 XMMMMMMMMMMMMMMMMMMMMMMMX.
${c3};MMMMMMMMMMMMMMMMMMMMMMMM:
:MMMMMMMMMMMMMMMMMMMMMMMM:
${c4}.MMMMMMMMMMMMMMMMMMMMMMMMX.
 kMMMMMMMMMMMMMMMMMMMMMMMMWd.
 ${c5}'XMMMMMMMMMMMMMMMMMMMMMMMMMMk
  'XMMMMMMMMMMMMMMMMMMMMMMMMK.
    ${c6}kMMMMMMMMMMMMMMMMMMMMMMd
     ;KMMMMMMMWXXWMMMMMMMk.
       "cooc*"    "*coo'"
EOF
                ;;

                "GNU"*)
                    set_colors fg 7
                    read -rd '' ascii_data <<'EOF'
${c1}    _-`````-,           ,- '- .
  .'   .- - |          | - -.  `.
 /.'  /                     `.   \
:/   :      _...   ..._      ``   :
::   :     /._ .`:'_.._\.    ||   :
::    `._ ./  ,`  :    \ . _.''   .
`:.      /   |  -.  \-. \\_      /
  \:._ _/  .'   .@)  \@) ` `\ ,.'
     _/,--'       .- .\,-.`--`.
       ,'/''     (( \ `  )
        /'/'  \    `-'  (
         '/''  `._,-----'
          ''/'    .,---'
           ''/'      ;:
             ''/''  ''/
               ''/''/''
                 '/'/'
                  `;
EOF
                ;;

                "Linux")
                    set_colors fg 8 3
                    read -rd '' ascii_data <<'EOF'
${c2}        #####
${c2}       #######
${c2}       ##${c1}O${c2}#${c1}O${c2}##
${c2}       #${c3}#####${c2}#
${c2}     ##${c1}##${c3}###${c1}##${c2}##
${c2}    #${c1}##########${c2}##
${c2}   #${c1}############${c2}##
${c2}   #${c1}############${c2}###
${c3}  ##${c2}#${c1}###########${c2}##${c3}#
${c3}######${c2}#${c1}#######${c2}#${c3}######
${c3}#######${c2}#${c1}#####${c2}#${c3}#######
${c3}  #####${c2}#######${c3}#####
EOF
                ;;
        "Profelis SambaBOX"* | "SambaBOX"*)
            set_colors 3 6
            read -rd '' ascii_data <<'EOF'
${c1}
                    #
               *////#####
           /////////#########(
      .((((((/////    ,####(#(((((
  /#######(((*             (#(((((((((.
//((#(#(#,        ((##(        ,((((((//
//////        #(##########(       //////
//////    ((#(#(#(#(##########(/////////
/////(    (((((((#########(##((((((/////
/(((#(                             ((((/
####(#                             ((###
#########(((/////////(((((((((,    (#(#(
########(   /////////(((((((*      #####
####///,        *////(((         (((((((
.///////////                .//(((((((((
     ///////////,       *(/////((((*
         ,/(((((((((##########/.
             .((((((#######
                  ((##*
EOF
        ;;

                "SunOS")
                    set_colors 3 7
                    read -rd '' ascii_data <<'EOF'
${c1}                 `-     `
          `--    `+-    .:
           .+:  `++:  -/+-     .
    `.::`  -++/``:::`./+/  `.-/.
      `++/-`.`          ` /++:`
  ``   ./:`                .: `..`.-
``./+/:-                     -+++:-
    -/+`                      :.
EOF
                ;;

                "IRIX"*)
                    set_colors 4 7
                    read -rd '' ascii_data <<'EOF'
${c1}           ./ohmNd/  +dNmho/-
     `:+ydNMMMMMMMM.-MMMMMMMMMdyo:.
   `hMMMMMMNhs/sMMM-:MMM+/shNMMMMMMh`
   -NMMMMMmo-` /MMM-/MMM- `-omMMMMMN.
 `.`-+hNMMMMMNhyMMM-/MMMshmMMMMMmy+...`
+mMNds:-:sdNMMMMMMMyyMMMMMMMNdo:.:sdMMm+
dMMMMMMmy+.-/ymNMMMMMMMMNmy/-.+hmMMMMMMd
oMMMMmMMMMNds:.+MMMmmMMN/.-odNMMMMmMMMM+
.MMMM-/ymMMMMMmNMMy..hMMNmMMMMMmy/-MMMM.
 hMMM/ `/dMMMMMMMN////NMMMMMMMd/. /MMMh
 /MMMdhmMMMmyyMMMMMMMMMMMMhymMMMmhdMMM:
 `mMMMMNho//sdMMMMM//NMMMMms//ohNMMMMd
  `/so/:+ymMMMNMMMM` mMMMMMMMmh+::+o/`
     `yNMMNho-yMMMM` NMMMm.+hNMMNh`
     -MMMMd:  oMMMM. NMMMh  :hMMMM-
      -yNMMMmooMMMM- NMMMyomMMMNy-
        .omMMMMMMMM-`NMMMMMMMmo.
          `:hMMMMMM. NMMMMMh/`
             .odNm+  /dNms.
EOF
                ;;

            esac
        ;;
    esac

    # Overwrite distro colors if '$ascii_colors' doesn't
    # equal 'distro'.
    [[ ${ascii_colors[0]} != distro ]] && {
        color_text=off
        set_colors "${ascii_colors[@]}"
    }
}

main() {
    cache_uname
    get_os

    # Load default config.
    eval "$config"

    get_args "$@"
    [[ $verbose != on ]] && exec 2>/dev/null
    get_simple "$@"
    get_distro
    get_bold
    get_distro_ascii
    [[ $stdout == on ]] && stdout

    # Minix doesn't support these sequences.
    [[ $TERM != minix && $stdout != on ]] && {
        # If the script exits for any reason, unhide the cursor.
        trap 'printf "\e[?25h\e[?7h"' EXIT

        # Hide the cursor and disable line wrap.
        printf '\e[?25l\e[?7l'
    }

    image_backend
    get_cache_dir
    old_functions
    print_info
    dynamic_prompt

    # w3m-img: Draw the image a second time to fix
    # rendering issues in specific terminal emulators.
    [[ $image_backend == *w3m* ]] && display_image
    [[ $image_backend == *ueberzug* ]] && display_image

    # Add neofetch info to verbose output.
    err "Neofetch command: $0 $*"
    err "Neofetch version: $version"

    [[ $verbose == on ]] && printf %b "$err" >&2

    # If `--loop` was used, constantly redraw the image.
    while [[ $image_loop == on && $image_backend == w3m ]]; do
        display_image
        sleep 1
    done

    return 0
}

main "$@"
