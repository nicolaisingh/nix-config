{
  Xaw3d,
  acl,
  attr,
  autoreconfHook,
  cairo,
  dbus,
  gettext,
  giflib,
  git,
  gnulib,
  gnutls,
  gpm,
  harfbuzz,
  imagemagick,
  lcms,
  lib,
  libXaw,
  libXpm,
  libXrandr,
  libgcc,
  libgccjit,
  libjpeg,
  libllvm,
  libotf,
  libpng,
  librsvg,
  libselinux,
  libtiff,
  libwebp,
  libxml2,
  m17n_lib,
  ncurses,
  pkg-config,
  sqlite,
  stdenv,
  substituteAll,
  systemd,
  texinfo,
  tree-sitter,
  zlib,
}:

let
  host = import <host-config>;

  # For native compilation (copied from nixpkgs emacs)
  libGccJitLibraryPaths = [
    "${lib.getLib libgccjit}/lib/gcc"
    "${lib.getLib stdenv.cc.libc}/lib"
    "${lib.getLib stdenv.cc.cc.libgcc}/lib"
  ];
in
stdenv.mkDerivation rec {
  pname = "emacs-dev";
  version = "30.1";
  src = builtins.fetchGit {
    name = "emacs";
    url = /home/${host.username}/src/emacs;
    rev = "8ac894e2246f25d2a2a97d866b10e6e0b0fede5a";
  };

  nativeBuildInputs = [
    autoreconfHook
    git
    pkg-config
    texinfo
  ];

  # For native compilation
  env = {
    NATIVE_FULL_AOT = "1";
    LIBRARY_PATH = lib.concatStringsSep ":" libGccJitLibraryPaths;
  };

  enableParallelBuilding = true;

  buildInputs = [
    Xaw3d
    acl
    attr
    cairo
    dbus
    gettext
    giflib
    gnulib
    gnutls
    gpm
    harfbuzz
    imagemagick
    lcms
    libXaw
    libXpm
    libXrandr
    libgcc
    libgccjit
    libjpeg
    libllvm
    libotf
    libpng
    librsvg
    libselinux
    libtiff
    libwebp
    libxml2
    m17n_lib
    ncurses
    pkg-config
    sqlite
    systemd
    tree-sitter
    zlib
  ];

  postUnpack = ''
    # cd emacs
    # rm aclocal.m4     # Enable if encountering an error related to stdbit.h
    # git clean -fdx    # If the above still doesn't work
    # cd ..
  '';

  configureFlags = [
    "--with-small-ja-dic"
    "--with-imagemagick"
    # "--program-transform-name='s/$/-dev/'"
  ];

  preBuild = ''
    buildFlagsArray+=(CFLAGS="-O4")
  '';

  # Also copied from nixpkgs emacs
  patches = [
    (substituteAll {
      src = ./native-comp-driver-options.patch;
      backendPath = (
        lib.concatStringsSep " " (
          builtins.map (x: ''"-B${x}"'') (
            [
              # Paths necessary so the JIT compiler finds its libraries:
              "${lib.getLib libgccjit}/lib"
            ]
            ++ libGccJitLibraryPaths
            ++ [
              # Executable paths necessary for compilation (ld, as):
              "${lib.getBin stdenv.cc.cc}/bin"
              "${lib.getBin stdenv.cc.bintools}/bin"
              "${lib.getBin stdenv.cc.bintools.bintools}/bin"
            ]
          )
        )
      );
    })
  ];

  # TAGS location: /run/current-system/sw/share/emacs/VERSION/lisp/TAGS
  installTargets = [
    "tags"
    "install"
  ];

  postInstall = ''
    ln -s ${src} $out/share/emacs/source
  '';
}
