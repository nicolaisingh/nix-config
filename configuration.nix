{ config, pkgs, lib, options, ... }:

let
  host = import <host-config>;
  doesNotMatch = regex: str: builtins.match regex str == null;
  configPath = "/home/${host.username}/nix";

  # NUR
  # To get sha256: nix-prefetch-url --unpack URL
  nurPkgs = import (fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
    sha256 = "03cr3vr466lplarzs7q7qi6na0m5f84y652zxmfz28k0va0d807j";
  }) {
    inherit pkgs;
  };

  # nixos-unstable
  unstablePkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    sha256 = "0wjfikwmnk105bxwwxmkqcbf0nz5n7qp8f4z8lgwwlf3avf4jk1k";
  }) {
    config = config.nixpkgs.config;
  };
in {
  imports = [
    ./hardware-configuration.nix
    ./luks-configuration.nix
    ./nvidia-configuration.nix

    # herbstluftwm (hlwm) + XFCE desktop
    # ./herbstluftwm-configuration.nix
    # ./xfce-configuration.nix

    # KDE desktop
    ./kde-configuration.nix

    ./home-manager-configuration.nix
  ];

  nix.nixPath = (builtins.filter (x: doesNotMatch "(nixos-config=.+)" x) options.nix.nixPath.default) ++
                [ "nixos-config=${configPath}/configuration.nix" ] ++
                [ "host-config=${configPath}/host-configuration.nix" ];

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: rec {
      unstable = unstablePkgs;
      nur = nurPkgs;
    };
  };

  nixpkgs.overlays = [
    # (import ./overlays/emacs-localbuild.nix)
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3;

  # Kernel parameters
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
    "kernel.nmi_watchdog" = 0;
    "kernel.watchdog" = 0;
  };

  # Networking
  networking.hostName = "yaldabaoth";
  networking.networkmanager.enable = true;

  ## Setting random will prevent connecting to some Bluetooth devices
  # networking.networkmanager.wifi.macAddress = "random";
  # networking.networkmanager.ethernet.macAddress = "random";
  networking.networkmanager.dns = "none";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 8080 ];

  time.timeZone = "Asia/Manila";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    #   font = "Lat2-Terminus16";
    #   keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  fonts = {
    packages = with pkgs; [
      dina-font
      gohufont
      fantasque-sans-mono
      fira
      hermit
      inconsolata
      libertine
      lmodern
      source-code-pro
      source-sans-pro
      source-serif-pro
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.zsh.enable = true;

  services.dbus.enable = true;

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
  # services.emacs.package = pkgs.emacs29;
  services.emacs.package = pkgs.callPackage ./emacs/emacs-dev.nix {};

  services.flatpak.enable = true;

  # To include systemd timer units
  # systemctl --user start offlineimap.service
  # systemctl --user start offlineimap.timer
  services.offlineimap.enable = false;

  services.openssh.enable = true;

  services.postgresql.enable = false;
  services.postgresql.package = pkgs.postgresql;

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.epson-escpr ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.samba = {
    enable = true;
    enableNmbd = false;
    openFirewall = true;
    extraConfig = ''
    # Don't forget to do smbpasswd -a USER to set the user's samba password.
    [global]
      server role = standalone server
      hosts allow = 192.168.70.100 127.
    [public]
      comment = Public stuff
      path = /hdd/pub
      writable = no
      printable = no
    '';
  };

  services.syncthing = {
    enable = false; # don't start on boot
    user = builtins.getEnv "USER";
    dataDir = "/home/${host.username}/sync";
  };

  services.thermald.enable = true;

  services.transmission.enable = true;
  services.transmission.settings = {
    download-dir = "/home/${host.username}/Downloads/torrent/completed";
    incomplete-dir-enabled = true;
    incomplete-dir = "/home/${host.username}/Downloads/torrent";
  };

  services.tlp.enable = false;
  services.tlp.settings = {
    TLP_DEFAULT_MODE = ''"AC"'';

    # Permit disk spin down for HDD (set to 128 to disable)
    DISK_DEVICES = ''"nvme0n1 sda"'';
    DISK_APM_LEVEL_ON_AC = ''"127 254"'';
    DISK_APM_LEVEL_ON_BAT = ''"127 254"'';

    # Disable wifi power saving
    WIFI_PWR_ON_AC = ''"off"'';
    WIFI_PWR_ON_BAT = ''"off"'';

    # Disable sound power saving
    SOUND_POWER_SAVE_ON_AC = ''"0"'';
    SOUND_POWER_SAVE_ON_BAT = ''"0"'';
    SOUND_POWER_SAVE_CONTROLLER = ''"N"'';

    # Disable USB autosuspending
    USB_AUTOSUSPEND = ''"0"'';
  };

  services.udev.packages = [ pkgs.via ];

  services.libinput = {
    enable = true;
    touchpad.tappingDragLock = false;
    touchpad.disableWhileTyping = true;
    touchpad.naturalScrolling = true;
  };

  services.displayManager = {
    # Autologin
    autoLogin.enable = true;
    autoLogin.user = host.username;
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

  # Keyboard/QMK
  hardware.keyboard.qmk.enable = true;

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

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
  users.groups.vmail = {};

  environment.systemPackages = with pkgs; [
    ntfs3g # Needs to be installed in the system config
    via
  ];

  environment.shellAliases = {
    ".." = "cd ..";
    "df" = "df -h";
    "ll" = "ls -lh";
  };

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
      Persistent = true;
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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
