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

  texlive-pkg = with pkgs; texlive.combine {
    inherit (texlive)
      cabin
      geometry
      hyperref
      libertine
      ly1
      mathdesign
      scheme-medium;
  };

in with pkgs; [

  appimage-run
  ark
  at
  bandwhich
  bc
  binutils
  breeze-gtk
  calc
  calibre
  chromium
  cifs-utils
  dbus
  dbus-broker
  ditaa
  dragon
  exiv2
  feh
  ffmpeg-full
  file
  freezer
  gcc
  gimp
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
  k3b
  kate
  kcalc
  kcharselect
  kcolorchooser
  kde-gtk-config
  kdenlive
  killall
  kmenuedit
  ktimer
  ktorrent
  libreoffice
  libressl
  lm_sensors
  lshw
  lsof
  mitscheme
  mp3gain
  ncat
  ncurses
  neofetch
  nodejs
  nomacs
  okular
  openvpn
  p7zip
  parted
  pciutils
  picard
  picom
  qt5Full
  shntool
  smartmontools
  syncthing
  tcpdump
  tdesktop
  texlive-pkg
  thermald
  tlp
  tor-browser-bundle-bin
  tree
  unstable.android-studio
  unstable.quodlibet-full
  unzip
  usbutils
  vim
  vivaldi
  vorbisgain
  wget
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
]
