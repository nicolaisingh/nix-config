# self: corresponds to the final package set. You should use this set
# for the dependencies of all packages specified in your overlay.
# Sometimes called final.

# super: corresponds to the result of the evaluation of the previous
# stages of Nixpkgs. It does not contain any of the packages added by
# the current overlay, nor any of the following overlays. This set
# should be used either to refer to packages you wish to override, or
# to access functions defined in Nixpkgs.  Sometimes called prev.

self: super:

let
  nixos = import <nixpkgs/nixos> {};
  unstable = nixos.pkgs.unstable;
in {
  emacs-localbuild = (unstable.emacs.override {
    nativeComp = true;
    srcRepo = true;
  }).overrideAttrs (oldAttrs: rec {
    version = "localbuild";
    name = "emacs-${version}";
    pname = "emacs-${version}";
    patches = [
      ./patches/clean-env.patch
	    ./patches/tramp-detect-wrapped-gvfsd.patch
    ];
    src = /ssd/emacs;
  });
}
