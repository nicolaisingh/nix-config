{ pkgs }:

let
  host = import <host-config>;

  cura-appimage = pkgs.appimageTools.wrapType2 {
    pname = "cura";
    version = "5.10.1";
    src = pkgs.fetchurl {
      url = "https://github.com/Ultimaker/Cura/releases/download/5.10.1/UltiMaker-Cura-5.10.1-linux-X64.AppImage";
      sha256 = "sha256-c89GkgfOSY4hriY66GUCgBYiiJJspM9Fg07lne+KXgw=";
    };
    profile = with pkgs; ''
      export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
    '';
  };

  guarda = pkgs.appimageTools.wrapType2 {
    # Use wrapType1 if `file -k' on the AppImage shows an ISO 9660
    # CD-ROM filesystem
    pname = "guarda";
    version = "1.0.20";
    src = /. + builtins.toPath "/home/${host.username}/ct/Guarda-1.0.20.AppImage";
    profile = with pkgs; ''
      export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
    '';
  };

  idea-community-pkg =
    with pkgs;
    jetbrains.idea-community.override {
      jdk = jdk; # JDK isn't detected without this
    };

  radix-wallet = pkgs.appimageTools.wrapType2 {
    pname = "radix-wallet";
    version = "1.6.0";
    src = /. + builtins.toPath "/home/${host.username}/ct/Radix-Wallet-1.6.0.AppImage";
    profile = with pkgs; ''
      export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
    '';
  };

  texlive-pkg =
    with pkgs;
    texlive.combine {
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
        wrapfig
        ;
    };

in
with pkgs;
[
  (android-studio.withSdk
    (androidenv.composeAndroidPackages {
      platformVersions = [
        "33"
        "34"
        "35"
      ];
      includeSources = true;
    }).androidsdk
  )
  adwaita-icon-theme
  appimage-run
  ardour
  asciidoctor-with-extensions
  at
  audacity
  awscli2
  aws-sam-cli
  bandwhich
  bc
  bind
  binutils
  black
  bruno
  calc
  calf
  calibre
  ccl
  chiaki
  cifs-utils
  clisp
  clojure
  cups-filters
  cura-appimage
  dbeaver-bin
  dbus
  dbus-broker
  ditaa
  dmidecode
  docker-compose
  easyeffects
  emacsPackages.cask
  evince
  exfat
  exiftool
  exiv2
  eyedropper
  feh
  ffmpeg-full
  file
  flutter
  freecad
  gcc
  gimp
  git-filter-repo
  glxinfo
  gnucash
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
  kotlin
  killall
  libavif
  liberation-sans-narrow
  liberation_ttf
  libnotify
  libreoffice
  libressl
  librewolf
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
  monaspace
  mp3gain
  mpg123
  mtr
  multimarkdown
  mupdf
  ncurses
  neofetch
  nicotine-plus
  nil
  nixfmt-rfc-style
  nixos-option
  nmap
  nodePackages.prettier
  nodePackages.typescript-language-server
  nodejs
  noise-repellent
  nomacs
  obs-studio
  openvpn
  p7zip
  pandoc
  parted
  (pass.withExtensions (exts: [ exts.pass-otp ]))
  pciutils
  pcmanfm
  picard
  picom
  pinentry-all
  plantuml
  protonmail-bridge
  protonmail-bridge-gui
  (python311.withPackages (
    ps: with ps; [
      flask
      pip
      pyflakes
      setuptools
      tomlkit
      virtualenv
    ]
  ))
  pyright
  qmk
  qmk-udev-rules
  qrencode
  quodlibet-full
  racket
  radix-wallet
  rar
  ripgrep
  rst2pdf
  rubyPackages.rdoc
  sbcl
  scrcpy
  shntool
  sieveshell
  silver-searcher
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
  tree
  unstable.aider-chat
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
  godef # Code definition
  gopls # Language server

]
