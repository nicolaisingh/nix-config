{ pkgs }:

let
  current = import <current>;

  spotify-oldver = (import (pkgs.fetchzip {
    # Version: 1.1.26.501.gbe11e53b-15
    url = "https://github.com/nixos/nixpkgs/archive/388ed4e09f3bf9de1b14d043cc0ba5b03183b09b.zip";
    sha256 = "1cac7x3bfbffkcpa1wz03gn4l1w1x8fyhav523vp098nx0klm3l5";
  }) {
    config = pkgs.config;
  }).spotify;

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
  bandwhich
  bc
  binutils
  breeze-gtk
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
  gcc
  genymotion
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
  lm_sensors
  lshw
  lsof
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
  xsel
  youtube-dl
  zip
  zlib
  zoom-us

  # Spotify
  nur.repos.instantos.spotify-adblock
  libgnurl
  (pkgs.writeShellScriptBin "spotify-noads" ''
        LD_PRELOAD=~/.nix-profile/lib/spotify-adblock.so:~/.nix-profile/lib/libgnurl.so spotify >/dev/null &
      '')
  (spotify-oldver.overrideAttrs (oldAttrs: {
    postInstall = ''
        substituteInPlace $out/share/applications/spotify.desktop \
          --replace "Exec=spotify" "Exec=spotify-noads"
        '';
  }))
]
