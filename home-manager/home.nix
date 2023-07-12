{ config, lib, pkgs, ... }:

# home-manager options:
# https://nix-community.github.io/home-manager/options.html

let
  host = import <host-config>;
  packages = pkgs.callPackage ./packages.nix {};
in {
  home.username = host.username;
  home.homeDirectory = "/home/${host.username}";
  home.packages = packages;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  programs.java.enable = true;
  programs.java.package = pkgs.jdk;

  programs.emacs.enable = true;
  programs.emacs.package = pkgs.emacs29;

  programs.git = {
    enable = true;
    userName = host.fullname;
    userEmail = host.email;
    aliases = {
      s = "status";
      plog = "log --graph --format=format:'%C(red)%h%C(reset)%C(auto)%d%C(reset) %s%C(blue) -- %an %C(magenta)(%ar)%C(reset)'";
      dlog = "log --graph --format=format:'%C(red)%h%C(reset)%C(auto)%d%C(reset)%n'";
      dummy-commit = "!f() { echo 'this is a sample edit' >> `git rev-parse --abbrev-ref HEAD`; git commit -a -m 'test commit'; }; f";
    };
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    profiles = {
      myprofile = {
        id = 0;
        settings = {
          # http://kb.mozillazine.org/Accessibility.tabfocus
          # Make Tab focus only on text and form fields
          "accessibility.tabfocus" = 3;

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

  programs.chromium = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      "e" = "emacsclient";
      "ee" = "emacsclient -c -a ''";
      "grep" = "grep --color=auto";
      "hc" = "herbstclient ";
      "Less" = "less";
    };
  };

  programs.rofi = {
    enable = true;
    cycle = true;
    font = "Source Sans Pro 10";
    theme = "android_notification";
    extraConfig = {
      modi = "window,run,ssh,drun";
      show-icons = true;
      kb-row-up = "Control+p,Control+r,Control+comma,Up";
      kb-row-down = "Control+n,Control+s,Control+period,Down";
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  xfconf.settings = {
    xsettings = {
      "Gtk/KeyThemeName" = "Emacs";
    };
  };
}
