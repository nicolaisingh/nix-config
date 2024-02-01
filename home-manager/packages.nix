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

  # freezer-extracted = pkgs.appimageTools.extractType2 {
  #   name = "freezer";
  #   src = /. + builtins.toPath "/home/${host.username}/sw/Freezer-1.1.21.AppImage";
  # };

  # freezer = pkgs.appimageTools.wrapType2 {
  #   name = "freezer";
  #   src = /. + builtins.toPath "/home/${host.username}/sw/Freezer-1.1.21.AppImage";
  #   profile = with pkgs; ''
  #     export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  #   '';

  #   extraInstallCommands = ''
  #     install -m 444 -D ${freezer-extracted}/freezer.png $out/share/icons/hicolor/256x256/apps/freezer.png
  #     ${pkgs.desktop-file-utils}/bin/desktop-file-install --dir $out/share/applications \
  #       --set-key Exec --set-value $out/bin/freezer \
  #       ${freezer-extracted}/freezer.desktop
  #   '';

  #   extraPkgs = pkgs: with pkgs; [ xorg.libxshmfence ];
  # };

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
  calc
  calibre
  ccl
  chiaki
  cifs-utils
  clisp
  clojure
  colorpicker
  cura-appimage
  dbeaver
  dbus
  dbus-broker
  ditaa
  dmidecode
  docker-compose
  dragon
  evince
  exfat
  exiftool
  exiv2
  feh
  ffmpeg-full
  file
  freecad
  # freezer
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
  jansson
  jq
  kde-gtk-config
  killall
  libavif
  libnotify
  libreoffice
  libressl
  lm_sensors
  lshw
  lsof
  lxmenu-data
  masterpdfeditor
  mitscheme
  mmc-utils
  mp3gain
  mpg321
  mtr
  multimarkdown
  mupdf
  ncurses
  neofetch
  nixos-option
  nmap
  nodejs
  nomacs
  obs-studio
  openvpn
  p7zip
  parted
  pass
  pciutils
  pcmanfm
  picard
  picom
  plantuml
  protonmail-bridge
  (python39.withPackages(ps: with ps; [pip pyflakes tomlkit]))
  racket
  radix-wallet
  rar
  sbcl
  scrcpy
  shntool
  silver-searcher
  slic3r
  smartmontools
  sqlite
  sweethome3d.application
  syncthing
  tcpdump
  tdesktop
  texlive-pkg
  thermald
  thunderbird
  tlp
  transmission
  tree
  unstable.androidStudioPackages.beta # android-studio
  unstable.android-tools
  unstable.nyxt
  unstable.quodlibet-full
  unstable.tor-browser-bundle-bin
  unzip
  usbutils
  vim
  vivaldi
  vivaldi-ffmpeg-codecs
  vlc
  vorbis-tools
  vorbisgain
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
  youtube-dl
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
  gocode # Code completion
  godef  # Code definition
  gopls  # Language server

]
