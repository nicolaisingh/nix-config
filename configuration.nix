{ config, lib, pkgs, options, ... }:

let entities = import <entities>;
    current = import <current>;
    configPath = "/home/${current.user.username}/nix";
    doesNotMatch = regex: str: builtins.match regex str == null;

    # To get sha256: nix-prefetch-url --unpack URL
    homeManagerTarball = fetchTarball {
      url = "https://github.com/rycee/home-manager/archive/release-21.05.tar.gz";
      sha256 = "0nznlb2xgkvdav6d4qls2w81m3p3h4hdbwbp2nwqkiszkp7j1bln";
    };

    nurTarball = fetchTarball {
      url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
      sha256 = "1j735jpgnjdcp2z4ka1hsb2v9aq0nb2fqj5ncj0piy8nn1c8yz2n";
    };
    nurPkgs = import nurTarball {
      inherit pkgs;
    };

    unstableTarball = fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
      sha256 = "152kxfk11mgwg8gx0s1rgykyydfb7s746yfylvbwk5mk5cv4z9nv";
    };
    unstablePkgs = import unstableTarball {
      config = config.nixpkgs.config;
    };
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
        unstable = unstablePkgs;

        # Load NUR
        nur = nurPkgs;
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
      timeout = 3;
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
    nameservers = [ "1.1.1.1" "8.8.8.8" ];

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Open ports in the firewall
    # firewall.allowedTCPPorts = [ 80 443 ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  # Recommended when using pipewire
  security.rtkit.enable = true;

  services = {
    # Emacs
    emacs = {
      enable = true;
      package = pkgs.emacs-localbuild;
    };

    # Pipewire
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
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

      desktopManager = {
        xterm.enable = false;
      };

      # Use plasma5 DE
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;

      # Enable i3 window manager
      windowManager.i3 = {
        enable = true;
        # package = pkgs.i3-gaps;
      };

      # Enable herbstluftwm window manager (hlwm)
      windowManager.herbstluftwm = {
        enable = true;
        configFile = ./herbstluftwm-autostart;
      };

      displayManager = {
        # Autologin user
        autoLogin= {
          enable = true;
          user = current.user.username;
        };
        session = [
          {
            manage = "window";
            name = "my-herbstluftwm";
            # The default session doesn't run hlwm in the background
            start = let
              hlwmConfig = "herbstluftwm-autostart";
              configFileClause = lib.optionalString (hlwmConfig != null)
                ''-c "${configPath}/${hlwmConfig}"'';
            in
              ''
                # Enable this if using KDE with a custom WM
                export KDEWM="${pkgs.herbstluftwm}/bin/herbstluftwm"
                ${pkgs.herbstluftwm}/bin/herbstluftwm ${configFileClause} &
              '';
          }
        ];
        # See nixos-option `displayManager.session` for possible values
        # defaultSession = "plasma5";
        # defaultSession = "plasma5+i3";
        defaultSession = "plasma5+my-herbstluftwm";
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
    # Switched to pipewire (see services.pipewire)
    pulseaudio = {
      enable = false;
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
    "hc" = "herbstclient ";
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
