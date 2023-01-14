{ config, lib, pkgs, ... }:

let
  host = import <host-config>;
  configPath = "/home/${host.username}/nix/herbstluftwm";
in {
  # herbstluftwm window manager (hlwm)
  services.xserver.windowManager.herbstluftwm.enable = true;
  services.xserver.windowManager.herbstluftwm.configFile = ./herbstluftwm/autostart;

  services.xserver.displayManager = {
    session = [
      {
        manage = "window";
        name = "my-herbstluftwm";
        # The default session doesn't run hlwm in the background
        start = let
          hlwmConfig = "autostart";
          configFileClause = lib.optionalString (hlwmConfig != null)
            ''-c "${configPath}/${hlwmConfig}"'';
        in
          ''
            # Enable this if using KDE with a custom WM
            # export KDEWM="${pkgs.herbstluftwm}/bin/herbstluftwm"

            ${pkgs.herbstluftwm}/bin/herbstluftwm ${configFileClause} &
          '';
      }
    ];
  };
}
