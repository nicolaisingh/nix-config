{ config, lib, pkgs, ... }:

# home-manager options:
# https://nix-community.github.io/home-manager/options.html

let current = import <current>;
    kdePackages = pkgs.callPackage ./packages-kde.nix {};
    myPackages = pkgs.callPackage ./packages.nix {};
    xfcePackages = pkgs.callPackage ./packages-xfce.nix {};
in {
  home = {
    username = current.user.username;
    homeDirectory = "/home/${current.user.username}";
    packages = myPackages ++ xfcePackages;
  };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = current.user.name;
    userEmail = current.user.email;
    aliases = {
      s = "status";
      plog = "log --graph --format=format:'%C(red)%h%C(reset)%C(auto)%d%C(reset) %s%C(blue) -- %an %C(magenta)(%ar)%C(reset)'";
      dlog = "log --graph --format=format:'%C(red)%h%C(reset)%C(auto)%d%C(reset)%n'";
      dummy-commit = "!f() { echo 'this is a sample edit' >> `git rev-parse --abbrev-ref HEAD`; git commit -a -m 'test commit'; }; f";
    };
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    profiles = {
      myprofile = {
        id = 0;
        settings = {
          "browser.search.suggest.enabled" = false;
          "browser.startup.homepage" = "about:blank";
          "general.smoothScroll" = false;
          "signon.rememberSignons" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
        userChrome = ''
        /* hide tab bar */
        #TabsToolbar {
          visibility: collapse !important;
        }

        /* sidebar header to bottom */
        #sidebar-box {
          -moz-box-direction: reverse;
        }

        #sidebar-switcher-arrow {
          transform: rotate(180deg);
        }

        /* hide sidebar close button */
        #sidebar-close {
          visibility: collapse;
        }
        '';
      };
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      "e" = "emacsclient";
      "ee" = "emacsclient -c -a ''";
      "grep" = "grep --color=auto";
      "Less" = "less";
    };
  };

  programs.rofi = {
    enable = true;
    cycle = true;
    font = "Noto Sans 10";
    theme = "Arc-Dark";
    extraConfig = {
      modi = "window,run,ssh,drun";
    };
  };

  xsession.windowManager.i3 = import ./i3.nix {
    inherit current lib pkgs;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";
}
