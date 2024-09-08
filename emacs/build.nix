{
  nixpkgs ? <nixpkgs>,
  ...
}:
let
  pkgs = import nixpkgs {};
in
pkgs.callPackage ./emacs-dev.nix {
  # gnulib = pkgs.gnulib.overrideAttrs (oldAttrs: rec {
  #     version = "20240906";
  #     src = pkgs.fetchgit {
  #       url = "https://git.savannah.gnu.org/r/gnulib.git";
  #       rev = "e87d09bee37eeb742b8a34c9054cd2ebde22b835";
  #       sha256 = "GO/s0p+uATiQChC8ScAJstLWRD2EtL1LOyxoWnJZ2i4=";
  #     };
  # });
}
