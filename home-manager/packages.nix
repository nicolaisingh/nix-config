{ pkgs }:

let
  host = import <host-config>;

  # emacs-default = pkgs.writeShellScriptBin "emacs-default" ''
  #   exec ${pkgs.emacs}/bin/emacs "$@"
  # '';

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
    src = /. + builtins.toPath "/home/${host.username}/ct/Guarda-1.0.12.AppImage";
    profile = with pkgs; ''
      export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
    '';
  };

  idea-community-pkg = with pkgs; jetbrains.idea-community.override {
    jdk = jdk; # JDK isn't detected without this
  };

  radix-wallet = pkgs.appimageTools.wrapType2 {
    name = "radix-wallet";
    src = /. + builtins.toPath "/home/${host.username}/ct/Radix-Wallet-1.3.3.AppImage";
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
  awscli2
  bandwhich
  bc
  bind
  binutils
  calc
  calibre
  cifs-utils
  colorpicker
  cura
  dbeaver
  dbus
  dbus-broker
  ditaa
  dmidecode
  dragon
  # emacs-default
  # emacs-localbuild
  evince
  exfat
  exiv2
  feh
  ffmpeg-full
  file
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
  mtr
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
  pciutils
  pcmanfm
  picard
  picom
  plantuml
  postman
  python
  python3
  racket
  radix-wallet
  rar
  scrcpy
  shntool
  silver-searcher
  slic3r
  smartmontools
  sweethome3d.application
  syncthing
  tcpdump
  tdesktop
  texlive-pkg
  thermald
  tlp
  transmission
  tree
  unstable.android-studio
  unstable.android-tools
  unstable.nyxt
  unstable.quodlibet-full
  unstable.tor-browser-bundle-bin
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
  xdotool
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
