{
  lib,
  stdenv,
  autoreconfHook,
  pkg-config,

  Xaw3d,
  acl,
  attr,
  cairo,
  dbus,
  fetchpatch,
  giflib,
  gnutls,
  gpm,
  harfbuzz,
  jansson,
  lcms,
  libXaw,
  libXpm,
  libgccjit,
  libjpeg,
  libotf,
  libpng,
  librsvg,
  libselinux,
  libtiff,
  libwebp,
  libxml2,
  m17n_lib,
  ncurses,
  sqlite,
  substituteAll,
  systemd,
  texinfo,
  tree-sitter,
}:

let
  # For native compilation (copied from nixpkgs emacs)
  libGccJitLibraryPaths = [
    "${lib.getLib libgccjit}/lib/gcc"
    "${lib.getLib stdenv.cc.libc}/lib"
    "${lib.getLib stdenv.cc.cc.libgcc}/lib"
  ];
in
stdenv.mkDerivation rec {
  pname = "emacs-dev";
  version = "30.0.50";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  # For native compilation
  env = {
    NATIVE_FULL_AOT = "1";
    LIBRARY_PATH = lib.concatStringsSep ":" libGccJitLibraryPaths;
  };

  buildInputs = [
    Xaw3d
    acl
    attr
    cairo
    dbus
    giflib
    gnutls
    gpm
    harfbuzz
    jansson
    lcms
    libXaw
    libXpm
    libgccjit
    libjpeg
    libotf
    libpng
    librsvg
    libselinux
    libtiff
    libwebp
    libxml2
    m17n_lib
    ncurses
    sqlite
    systemd
    tree-sitter
  ];

  configureFlags = [
    "--with-small-ja-dic"
    "--with-xinput2"
    "--with-native-compilation"
    # "--program-transform-name='s/$/-dev/'"
  ];

  preBuild = ''
    buildFlagsArray+=(CFLAGS="-O3")
  '';

  # Also copied from nixpkgs emacs
  patches = [
    (substituteAll {
      src = ./native-comp-driver-options.patch;
      backendPath = (lib.concatStringsSep " "
        (builtins.map (x: ''"-B${x}"'') ([
          # Paths necessary so the JIT compiler finds its libraries:
          "${lib.getLib libgccjit}/lib"
        ] ++ libGccJitLibraryPaths ++ [
          # Executable paths necessary for compilation (ld, as):
          "${lib.getBin stdenv.cc.cc}/bin"
          "${lib.getBin stdenv.cc.bintools}/bin"
          "${lib.getBin stdenv.cc.bintools.bintools}/bin"
        ])));
    })
  ];

  src = /hdd/src/emacs;
}
