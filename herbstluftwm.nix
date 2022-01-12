{ config, lib, pkgs, ... }:

let current = import <current>;
    configPath = "/home/${current.user.username}/nix";
in {
  # X11 windowing system
  services.xserver = {
    enable = true;

    # Enable herbstluftwm window manager (hlwm)
    windowManager.herbstluftwm = {
      enable = true;
      configFile = ./herbstluftwm-autostart;
    };

    displayManager = {
      # Custom session for KDE+hlwm combo
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
    };
  };
}
