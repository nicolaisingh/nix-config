{ pkgs }:

let
  host = import <host-config>;

  cura-appimage = pkgs.appimageTools.wrapType2 {
    name = "cura";
    src = pkgs.fetchurl {
      url = "https://github.com/Ultimaker/Cura/releases/download/5.4.0/UltiMaker-Cura-5.4.0-linux-modern.AppImage";
      sha256 = "sha256-QVv7Wkfo082PH6n6rpsB79st2xK2+Np9ivBg/PYZd74=";
    };
    profile = with pkgs; ''
      export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
    '';
  };

  guarda = pkgs.appimageTools.wrapType2 {
    # Use wrapType1 if `file -k' on the AppImage shows an ISO 9660
    # CD-ROM filesystem
    name = "guarda";
    src = /. + builtins.toPath "/home/${host.username}/ct/Guarda-1.0.20.AppImage";
    profile = with pkgs; ''
      export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
    '';
  };

  idea-community-pkg = with pkgs; jetbrains.idea-community.override {
    jdk = jdk; # JDK isn't detected without this
  };

  radix-wallet = pkgs.appimageTools.wrapType2 {
    name = "radix-wallet";
    src = /. + builtins.toPath "/home/${host.username}/ct/Radix-Wallet-1.6.0.AppImage";
    profile = with pkgs; ''
      export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
    '';
  };

  texlive-pkg = with pkgs; texlive.combine {
    inherit (texlive)
      booktabs
      cabin
      capt-of
      enumitem
      geometry
      hyperref
      libertine
      lipsum
      ly1
      mathdesign
      scheme-medium
      wrapfig;
  };

in with pkgs; [
  appimage-run
  at
  awscli2
  aws-sam-cli
  bandwhich
  bc
  bind
  binutils
  black
  bruno
  calc
  calibre
  ccl
  chiaki
  cifs-utils
  clisp
  clojure
  colorpicker
  cups-filters
  cura-appimage
  dbeaver-bin
  dbus
  dbus-broker
  ditaa
  dmidecode
  docker-compose
  dragon
  emacsPackages.cask
  evince
  exfat
  exiftool
  exiv2
  feh
  ffmpeg-full
  file
  flutter
  freecad
  gcc
  gimp
  git-filter-repo
  glxinfo
  gnome3.adwaita-icon-theme
  gnumake
  gnupg
  gnutls
  google-cloud-sdk
  gparted
  graphviz
  guarda
  harfbuzz
  hdparm
  hicolor-icon-theme
  home-manager
  hsetroot
  htop
  idea-community-pkg
  imagemagick
  inetutils
  inkscape
  inotify-tools
  isync # mbsync
  jansson
  jq
  kde-gtk-config
  kotlin
  killall
  libavif
  libnotify
  libreoffice
  libressl
  lm_sensors
  localsend
  lshw
  lsof
  lxmenu-data
  # mairix
  masterpdfeditor
  mermaid-cli
  mitscheme
  mmc-utils
  mp3gain
  mpg123
  mtr
  multimarkdown
  mupdf
  ncurses
  neofetch
  nixfmt-rfc-style
  nixos-option
  nmap
  nicotine-plus
  nil
  nodePackages.pyright
  nodePackages.typescript-language-server
  nodejs
  nomacs
  obs-studio
  openvpn
  p7zip
  parted
  (pass.withExtensions (exts: [ exts.pass-otp]))
  pciutils
  pcmanfm
  picard
  picom
  pinentry-all
  plantuml
  protonmail-bridge
  protonmail-bridge-gui
  (python311.withPackages (ps: with ps; [pip pyflakes setuptools tomlkit virtualenv]))
  qmk
  qmk-udev-rules
  qrencode
  racket
  radix-wallet
  rar
  ripgrep
  sbcl
  scrcpy
  shntool
  sieveshell
  silver-searcher
  slic3r
  smartmontools
  sqlite
  sweethome3d.application
  syncthing
  tcpdump
  tdesktop
  teams-for-linux
  texlive-pkg
  thermald
  thunderbird
  tlp
  transmission
  tree
  unstable.androidStudioPackages.beta # android-studio
  unstable.android-tools
  quodlibet-full
  unstable.tor-browser-bundle-bin
  unzip
  usbutils
  vim
  vivaldi
  vivaldi-ffmpeg-codecs
  vlc
  vorbis-tools
  vorbisgain
  w3m
  wayland-utils
  webcamoid
  wget
  wirelesstools
  xclip
  xdotool
  xorg.libXaw
  xorg.libXft
  xorg.libXpm
  xorg.xev
  xorg.xwininfo
  xsel
  yt-dlp
  z-lua
  zbar
  zip
  zlib
  zoom-us

  # bitcoin
  bitcoin
  clightning
  cpuminer
  electrum
  wasabiwallet

  # golang
  go
  go-swagger
  godef  # Code definition
  gopls  # Language server

]
