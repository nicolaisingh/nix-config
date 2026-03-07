{ pkgs, hostname, ... }:
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # TODO
    # Manually run using `nix-store --optimise`
    # auto-optimise-store = true;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = {
      "kernel.sysrq" = 1;
      # "kernel.nmi_watchdog" = 0;
      # "kernel.watchdog" = 0;
    };
  };

  environment.shellAliases = {
    ".." = "cd ..";
    "df" = "df -h";
    "ll" = "ls -lh";
    "o" = "nixos-option";
  };

  networking = {
    hostName = hostname;
    enableIPv6 = false;
    networkmanager = {
      enable = true;
    };
  };

  time.timeZone = "Asia/Manila";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    useXkbConfig = true; # use xkb.options in tty.
  };

  fonts = {
    packages = with pkgs; [
      atkinson-hyperlegible-mono
      atkinson-hyperlegible-next
    ];
  };

  users.users.nas = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    nixd
    nixfmt
    vim
    wget
  ];

  services = {
    emacs = {
      enable = true;
      defaultEditor = true;
      startWithGraphical = true;
      package = pkgs.emacs-pgtk;
    };

    openssh.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "dvorak";
        options = "ctrl:nocaps,shift:both_capslock";
      };
      # autoRepeatDelay = 250;
      # autoRepeatInterval = 50;
      #displayManager.sessionCommands = ''
      #  ${pkgs.xorg.xset}/bin/xset r rate 250 50
      #'';
    };
  };

  programs = {
    git.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    firefox.enable = true;
    nix-ld = {
      enable = true;
    };
  };

}
