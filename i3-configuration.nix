# FIXME
{ current, lib, pkgs }:

let
  mod = "Mod4";
  borderWidth = 3;
in {
  # https://github.com/nix-community/home-manager/blob/master/modules/services/window-managers/i3-sway/i3.nix#blob-path
  enable = true;

  config = {
    # assigns = {};
    bars = [];

    colors = {
      background = "#ffffff";

      focused = {
        background = "#285577";
        border = "#4c7899";
        childBorder = "#285577";
        indicator = "#2e9ef4";
        text = "#ffffff";
      };

      focusedInactive = {
        background = "#5f676a";
        border = "#333333";
        childBorder = "#5f676a";
        indicator = "#484e50";
        text = "#ffffff";
      };

      unfocused = {
        background = "#222222";
        border = "#333333";
        childBorder = "#222222";
        indicator = "#292d2e";
        text = "#888888";
      };

      urgent = {
        background = "#900000";
        border = "#2f343a";
        childBorder = "#900000";
        indicator = "#900000";
        text = "#ffffff";
      };

      placeholder = {
        # indicator and border are ignored
        background = "#0c0c0c";
        border = "#000000";
        childBorder = "#0c0c0c";
        indicator = "#000000";
        text = "#ffffff";
      };
    };

    floating = {
      border = borderWidth;
      # criteria = [];
      titlebar = true;
    };

    focus = {
      followMouse = false;
      # forceWrapping = false;
      # mouseWarping = true;
      # newWindow = "smart";
    };

    fonts = {
      names = [ "Noto Sans" ];
      size = 9.0;
    };

    # gaps = {
    # inner = 5;
    # outer = 5;

    # horizontal = null;
    # vertical = null;
    # left = null;
    # top = null;
    # right = null;
    # bottom = null;
    # smartBorders = "off";
    # smartGaps = false;
    # };

    keybindings = lib.mkOptionDefault {
      "${mod}+h" = "focus left";
      "${mod}+j" = "focus down";
      "${mod}+k" = "focus up";
      "${mod}+l" = "focus right";

      "${mod}+Shift+h" = "move left";
      "${mod}+Shift+j" = "move down";
      "${mod}+Shift+k" = "move up";
      "${mod}+Shift+l" = "move right";

      "${mod}+b" = "split h";

      # Use KDE logoff screen
      "${mod}+Shift+e" = "exec --no-startup-id qdbus org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout -1 -1 -1";

      "${mod}+Shift+Return" = "exec --no-startup-id emacsclient -c";
      "${mod}+Shift+d" = "exec --no-startup-id ${pkgs.rofi}/bin/rofi -show window";
    };

    # keycodebindings = {};
    menu = "${pkgs.rofi}/bin/rofi -show drun";

    modes = {
      resize = {
        Left = "resize shrink width 10 px or 10 ppt";
        Up = "resize shrink height 10 px or 10 ppt";
        Right = "resize grow width 10 px or 10 ppt";
        Down = "resize grow height 10 px or 10 ppt";
        h = "resize shrink width 10 px or 10 ppt";
        k = "resize shrink height 10 px or 10 ppt";
        l = "resize grow width 10 px or 10 ppt";
        j = "resize grow height 10 px or 10 ppt";

        Escape = "mode default";
        Return = "mode default";
      };
    };

    modifier = "${mod}";

    startup = [
      { command = "feh --bg-scale ${current.user.wallpaper}"; always = false; notification = false; }
      { command = "i3-msg 'workspace number 1'"; always = false; notification = false; }
    ];

    terminal = "konsole";

    window = {
      border = borderWidth;
      titlebar = true;
    };

    workspaceAutoBackAndForth = false;
    workspaceLayout = "stacked";
    # workspaceOutputAssign = [];
  };

  extraConfig = ''
      # Kill the KDE desktop window
      for_window [title="Desktop — Plasma"] kill; floating enable; border none

      # Plasma compatibility improvements
      for_window [window_role="pop-up"] floating enable
      for_window [window_role="task_dialog"] floating enable

      for_window [class="yakuake"] floating enable
      # for_window [class="systemsettings"] floating enable
      for_window [class="plasmashell"] floating enable;
      for_window [class="Plasma"] floating enable; border none
      for_window [title="plasma-desktop"] floating enable; border none
      for_window [title="win7"] floating enable; border none
      for_window [class="krunner"] floating enable; border none
      for_window [class="Kmix"] floating enable; border none
      for_window [class="Klipper"] floating enable; border none
      for_window [class="Plasmoidviewer"] floating enable; border none
      for_window [class="(?i)*nextcloud*"] floating disable
      # for_window [class="plasmashell" window_type="notification"] border none, move right 700px, move down 450px
      no_focus [class="plasmashell" window_type="notification"]
    '';
}
