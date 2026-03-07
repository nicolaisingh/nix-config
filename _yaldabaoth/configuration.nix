{
  config,
  pkgs,
  lib,
  options,
  ...
}:

let
  host = import <host-config>;
  doesNotMatch = regex: str: builtins.match regex str == null;
  configPath = "/home/${host.username}/nix";

in
{

  musnix.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
    packageOverrides = pkgs: rec {
      unstable = unstablePkgs;
      nur = nurPkgs;
    };
  };

  nixpkgs.overlays = [
    # (import ./overlays/emacs-localbuild.nix)
    (import ./overlays/reaper.nix)
  ];

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 8080 ];

  services.dovecot2 = {
    enable = true;
    enableImap = true;
    mailLocation = "maildir:~/Maildir:INBOX=~/Maildir/.INBOX:LAYOUT=fs";
    enablePAM = false; # Use userdb and passdb below
    sieve.globalExtensions = [ "fileinto" ];
    extraConfig = ''
      # Log a line for each authentication attempt failure.
      auth_verbose = yes
      passdb {
        driver = passwd-file
        args = /etc/dovecot/passwd
      }
      userdb {
        driver = passwd-file
        args = /etc/dovecot/passwd
        default_fields = uid=vmail gid=vmail home=/var/vmail/%u
      }
    '';
  };
  environment.etc."dovecot/passwd".text = import ./dovecot/passwd.nix;

  services.emacs.enable = true;
  # services.emacs.package = pkgs.emacs;
  services.emacs.package = pkgs.callPackage ./emacs/emacs-dev.nix { };

  services.flatpak.enable = true;

  services.fwupd.enable = true;

  # To include systemd timer units
  # systemctl --user start offlineimap.service
  # systemctl --user start offlineimap.timer
  services.offlineimap.enable = false;

  services.power-profiles-daemon.enable = false;

  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  services.samba = {
    enable = true;
    nmbd.enable = false;
    openFirewall = true;
    # Don't forget to do smbpasswd -a USER to set the user's samba password.
    settings = {
      "global" = {
        "server role" = "standalone server";
        "hosts allow" = "192.168.70.100 127.";
      };
      "public" = {
        "comment" = "Public stuff";
        "path" = "/hdd/pub";
        "writable" = "no";
        "printable" = "no";
      };
    };
  };

  services.syncthing = {
    enable = false; # don't start on boot
    user = builtins.getEnv "USER";
    dataDir = "/home/${host.username}/sync";
  };

  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    settings = {
      download-dir = "/home/${host.username}/Downloads/torrent/completed";
      incomplete-dir-enabled = true;
      incomplete-dir = "/home/${host.username}/Downloads/torrent";
    };
  };

  services.libinput = {
    enable = true;
    touchpad.tappingDragLock = false;
    touchpad.disableWhileTyping = true;
    touchpad.naturalScrolling = true;
  };

  # X11 windowing system
  services.xserver = {
    enable = true;

    xkb = {
      layout = "us";
      variant = "dvorak";
      options = "ctrl:nocaps,shift:both_capslock";
    };

    autoRepeatDelay = 250;
    autoRepeatInterval = 50;
    displayManager.sessionCommands = ''
      ${pkgs.xorg.xset}/bin/xset r rate 250 50
    '';
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  # Scanners
  hardware.sane.enable = true;

  users.users."${host.username}" = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [
      "adbusers"
      "audio"
      "networkmanager"
      "syncthing"
      "transmission"
      "vmail"
      "wheel"
    ];
  };

  users.users.vmail = {
    description = "Dovecot virtual mail user";
    isSystemUser = true;
    group = "vmail";
    home = "/var/vmail";
    homeMode = "770";
    createHome = true;
  };
  users.groups.vmail = { };

  environment.systemPackages = with pkgs; [
    ntfs3g # Needs to be installed in the system config
  ];

  systemd.services.mbsync = {
    description = "mbsync mailbox sync";
    serviceConfig = {
      Type = "oneshot";
      User = "vmail";
      ExecStart = "${pkgs.isync}/bin/mbsync -a";
    };
  };

  systemd.timers.mbsync = {
    description = "mbsync maibox sync timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      Unit = "mbsync.service";
      OnCalendar = "*:0/5"; # Every 5 minutes
    };
  };

  systemd.user.services.mairix = {
    enable = false;
    description = "Mairix: Index and search mail folders";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.mairix}/bin/mairix";
      TimeoutSec = 120;
    };
  };

  systemd.user.timers.mairix = {
    enable = false;
    description = "Timer for mairix";
    wantedBy = [ "default.target" ];
    timerConfig = {
      Unit = "mairix.service";
      OnCalendar = "*:00:00"; # Every hour
      Persistent = true;
    };
  };

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

}
