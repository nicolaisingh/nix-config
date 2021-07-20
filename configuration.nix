{ config, lib, pkgs, options, ... }:

let entities = import <entities>;
    current = import <current>;
    configPath = "/home/${current.user.username}/nix";
    doesNotMatch = regex: str: builtins.match regex str == null;

    homeManagerTarball = fetchTarball {
      url = "https://github.com/rycee/home-manager/archive/release-21.05.tar.gz";
      # To get sha256: nix-prefetch-url --unpack URL
      sha256 = "06w327cvbqpi2fpl5rqk664vrl0ls0jqfkzx8vgvbcn1pmxsl0y3";
    };

    nurTarball = fetchTarball {
      url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
      sha256 = "1a4lgg02g5vsg8ci40mnhizsqywa9jn6zh0nakvcp8ywa86krbz9";
    };

    unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in {
  imports = [
    (import "${homeManagerTarball}/nixos")
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  nix.nixPath = (builtins.filter (x: doesNotMatch "nixos-config=.+" x) options.nix.nixPath.default) ++
                [ "nixos-config=${configPath}/configuration.nix" ] ++
                [ "entities=${configPath}/entities.nix" ] ++
                [ "current=${configPath}/current.nix" ];

  nixpkgs = {
    config = {
      allowUnfree = true;

      packageOverrides = pkgs: rec {
        # Load nixos-unstable
        unstable = import unstableTarball {
          config = config.nixpkgs.config;
        };

        # Load NUR
        nur = import nurTarball {
          inherit pkgs;
        };
      };
    };

    overlays = [
      (import ./overlays/emacs-overlay.nix)
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    users."${current.user.username}" = (import ./home.nix);
  };

  # acpi_osi flag:
  # https://github.com/Bumblebee-Project/Bumblebee/issues/764#issuecomment-234494238
  boot = {
    kernelParams = [ "pci=noaer" "acpi_osi=\"!Windows 2015\"" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  time.timeZone = "Asia/Manila";
  i18n.defaultLocale = "en_US.UTF-8";
  console.font = "lat2-14";
  console.keyMap = "us";

  fonts = {
    fonts = with pkgs; [
      source-code-pro source-serif-pro source-sans-pro
      libertine
      lmodern
    ];
  };

  networking = {
    hostName = current.machine.hostname;
    #wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    networkmanager = {
      enable = true;
      wifi.macAddress = "random";
      ethernet.macAddress = "random";

      # Don't mess with the static nameservers
      dns = "none";
    };

    hosts = {} // entities.hosts;

    # Force to false, flag is now deprecated
    useDHCP = false;

    interfaces.enp2s0 = {
      useDHCP = false;
    };

    interfaces.wlp3s0 = {
      useDHCP = false;
      ipv4.addresses = [{ address = current.machine.address; prefixLength = 24; }];
    };

    defaultGateway = { address = entities.cypress.gatewayAddress; interface = "wlp3s0"; };
    nameservers = [ "1.1.1.1" ];

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Open ports in the firewall
    # firewall.allowedTCPPorts = [ 80 443 ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  services = {
    # Emacs
    emacs = {
      enable = true;
      package = pkgs.emacs-localbuild;
    };

    # Syncthing
    syncthing = {
      enable = false; # don't start on boot
      user = builtins.getEnv "USER";
      dataDir = ''/home/${builtins.getEnv "USER"}/sync'';
    };

    # TLP
    tlp = {
      enable = true;
      settings = {
        TLP_DEFAULT_MODE = ''"AC"'';

        # Permit disk spin down for HDD on battery
        DISK_DEVICES = ''"nvme0n1 sda"'';
        DISK_APM_LEVEL_ON_AC = ''"254 128"'';
        DISK_APM_LEVEL_ON_BAT = ''"254 127"'';
      };
    };

    # X11 windowing system
    xserver = {
      enable = true;

      # Key repetition rate
      autoRepeatDelay = 250;
      autoRepeatInterval = 50;
      # Settings above are not being respected (in KDE, set keyboard
      # settings to `Leave unchanged' for this to take effect)
      displayManager.sessionCommands = ''
        ${pkgs.xlibs.xset}/bin/xset r rate 250 50
      '';

      # Use plasma5 DE
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;

      # Autologin user
      displayManager = {
        autoLogin= {
          enable = true;
          user = current.user.username;
        };
        defaultSession = "plasma5";
      };

      # Touchpad
      libinput = {
        enable = true;

        touchpad = {
          tappingDragLock = false;
          disableWhileTyping = true;
          naturalScrolling = true;
        };
      };

      # Keymap
      layout = "us";
      # xkbOptions = "eurosign:e";
    };

    dbus.enable = true;
    flatpak.enable = true;
    openssh.enable = true;
    printing.enable = true; # CUPS
    thermald.enable = true;
  };

  hardware = {
    # Audio
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };

    # Bluetooth
    bluetooth = {
      enable = true;
      package = pkgs.bluezFull;
      powerOnBoot = false;
    };
  };

  users.users."${current.user.username}" = {
    isNormalUser = true;
    isSystemUser = false;
    extraGroups = [ "wheel" "networkmanager" "audio" "syncthing" "adbusers" ];
  };

  environment.systemPackages = with pkgs; [
    # Needs to be installed in the system config
    ntfs3g
  ];

  environment.shellAliases = {
    ".." = "cd ..";
    "df" = "df -h";
  };

  programs.adb.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
