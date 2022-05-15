{ pkgs }:

let
  current = import <current>;

  freezer-extracted = pkgs.appimageTools.extractType2 {
    name = "freezer";
    src = /. + builtins.toPath "/home/${current.user.username}/sw/Freezer-1.1.21.AppImage";
  };

  freezer = pkgs.appimageTools.wrapType2 {
    name = "freezer";
    src = /. + builtins.toPath "/home/${current.user.username}/sw/Freezer-1.1.21.AppImage";
    profile = with pkgs; ''
      export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
    '';

    extraInstallCommands = ''
      install -m 444 -D ${freezer-extracted}/freezer.png $out/share/icons/hicolor/256x256/apps/freezer.png
      ${pkgs.desktop-file-utils}/bin/desktop-file-install --dir $out/share/applications \
        --set-key Exec --set-value $out/bin/freezer \
        ${freezer-extracted}/freezer.desktop
    '';

    extraPkgs = pkgs: with pkgs; [ xorg.libxshmfence ];
  };

  guarda = pkgs.appimageTools.wrapType2 {
    # Use wrapType1 if `file -k' on the AppImage shows an ISO 9660
    # CD-ROM filesystem
    name = "guarda";
    src = /. + builtins.toPath "/home/${current.user.username}/ct/Guarda-1.0.12.AppImage";
    profile = with pkgs; ''
      export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
    '';
  };

  idea-community-pkg = with pkgs; jetbrains.idea-community.override {
    jdk = jdk; # JDK isn't detected without this
  };

  radix-wallet = pkgs.appimageTools.wrapType2 {
    name = "radix-wallet";
    src = /. + builtins.toPath "/home/${current.user.username}/ct/Radix-Wallet-1.3.3.AppImage";
    profile = with pkgs; ''
      export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
    '';
  };

  texlive-pkg = with pkgs; texlive.combine {
    inherit (texlive)
      cabin
      enumitem
      geometry
      hyperref
      libertine
      ly1
      mathdesign
      scheme-medium;
  };

in with pkgs; [

  appimage-run
  at
  bandwhich
  bc
  bind
  binutils
  blueman
  calc
  calibre
  chromium
  cifs-utils
  dbus
  dbus-broker
  ditaa
  dragon
  evince
  exfat
  exiv2
  feh
  ffmpeg-full
  file
  freezer
  fuse_exfat
  gcc
  gimp
  google-cloud-sdk
  glxinfo
  gnome3.adwaita-icon-theme
  gnumake
  gnupg
  gnutls
  gparted
  guarda
  gwenview
  harfbuzz
  hdparm
  hicolor-icon-theme
  home-manager
  htop
  idea-community-pkg
  imagemagick
  inetutils
  inkscape
  jansson
  jq
  kde-gtk-config
  killall
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
  mupdf
  ncat
  ncurses
  neofetch
  nodejs
  nomacs
  unstable.nyxt
  openvpn
  p7zip
  parted
  pciutils
  pcmanfm
  picard
  picom
  python
  python3
  qt5Full
  racket
  radix-wallet
  rar
  scrcpy
  shntool
  smartmontools
  sweethome3d.application
  # sweethome3d.furniture-editor
  # sweethome3d.textures-editor
  syncthing
  tcpdump
  tdesktop
  texlive-pkg
  thermald
  tlp
  transmission
  unstable.tor-browser-bundle-bin
  tree
  unstable.android-studio
  unstable.quodlibet-full
  unzip
  usbutils
  vim
  vivaldi
  vivaldi-ffmpeg-codecs
  vorbisgain
  webcamoid
  wget
  wirelesstools
  xclip
  xlibsWrapper
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
