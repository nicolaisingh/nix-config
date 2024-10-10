{ config, lib, pkgs, ... }:

# home-manager options:
# https://nix-community.github.io/home-manager/options.html

let
  host = import <host-config>;
  packages = pkgs.callPackage ./packages.nix {};
  kdePackages = pkgs.callPackage ./kde-packages.nix {};
  plasmaManager = fetchTarball {
    url = "https://github.com/nix-community/plasma-manager/archive/trunk.tar.gz";
    sha256 = "sha256:1klg72573cyy28kxr62fm72jpx5c9hwpg2zlmcw8n8xsczvm64zr";
  };
in {
  home.username = host.username;
  home.homeDirectory = "/home/${host.username}";
  home.packages = packages ++ kdePackages;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  imports = [
    (import "${plasmaManager}/modules") # KDE-specific
  ];

  programs.home-manager.enable = true;

  programs.java.enable = true;
  programs.java.package = pkgs.jdk;

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
          flex-direction: column-reverse !important;
        }

        #sidebar-switcher-arrow {
          transform: rotate(180deg);
        }

        /* hide sidebar close button */
        #sidebar-close {
          visibility: collapse;
        }

        /* decrease size of the sidebar header */
        #sidebar-header {
          font-size: 1.2em !important;
          padding: 2px 6px 2px 3px !important;
        }
        #sidebar-header .toolbarbutton-icon {
          width: 14px !important;
          height: 14px !important;
          opacity: 0.6 !important;
        }

        /* for private browsing mode */
        #main-window[privatebrowsingmode="temporary"] {
          #TabsToolbar {
            visibility: visible !important;
          }
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

  programs.msmtp.enable = true;

  programs.offlineimap.enable = false;

  programs.zsh = {
    enable = true;
  };
  accounts.email = {
    accounts.proton = {
      primary = true;
      userName = "nicolaisingh@pm.me";
      address = "nicolaisingh@pm.me";
      aliases = [ "nicolaisingh@protonmail.com" ];
      realName = host.fullname;
      passwordCommand = ["echo" "${host.secrets.proton}"];

      imap = {
        host = "127.0.0.1";
        port = 1143;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };

      offlineimap = {
        enable = false;
        extraConfig = {
          remote = {
            type = "IMAP";
            remotehost = "127.0.0.1";
            remoteuser = "nicolaisingh@pm.me";
            ssl = "no";

            # Skip syncing folders
            folderfilter = "lambda foldername: foldername not in ['All Mail']";
          };
        };
      };

      smtp = {
        host = "127.0.0.1";
        port = 1025;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };

      msmtp = {
        enable = true;
        # msmtp --serverinfo --tls --tls-certcheck=off
        tls.fingerprint = host.smtp.fingerprint;
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  home.file.".mairixrc".text = ''
    base=~/Maildir
    maildir=proton/*...
    mformat=maildir
    omit=zz_mairix-*
    database=~/.mairixdatabase
  '';

  # XFCE-specific
  # xfconf.settings = {
  #   xsettings = {
  #     "Gtk/KeyThemeName" = "Emacs";
  #   };
  # };

  # KDE-specific
  programs.plasma = import ./plasma.nix;
}
