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
  jansson,
  lcms,
  lib,
  libXaw,
  libXpm,
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
  version = "30.0.90";
  src = builtins.fetchGit {
    name = "emacs";
    url = /home/${host.username}/src/emacs;
    rev = "89c99891b2b3ab087cd7e824cef391ef26800ab4";
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
    jansson
    lcms
    libXaw
    libXpm
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
  ];

  postUnpack = ''
    # cd emacs
    # rm aclocal.m4     # Enable if encountering an error related to stdbit.h
    # git clean -fdx    # If the above still doesn't work
    # cd ..
  '';

  configureFlags = [
    "--with-small-ja-dic"
    "--with-native-compilation"
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
