{
  enable = true;

  shortcuts = {
    "KDE Keyboard Layout Switcher"."Switch to Last-Used Keyboard Layout" = [ ];
    "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Alt+K";
    "ksmserver"."Log Out" = "Meta+Shift+Esc";
    "kwin"."Expose" = [ ];
    "kwin"."ExposeAll" = [ ];
    "kwin"."ExposeClass" = [ ];
    "kwin"."ExposeClassCurrentDesktop" = [ ];
    "kwin"."Suspend Compositing" = "Meta+Shift+F12";
    "kwin"."Switch to Desktop 1" = [ ];
    "kwin"."Switch to Desktop 2" = [ ];
    "kwin"."Switch to Desktop 3" = [ ];
    "kwin"."Switch to Desktop 4" = [ ];
    "plasmashell"."show dashboard" = [ ];
    "services/emacsclient.desktop"."_launch" = "Meta+Shift+Return";
    "services/org.kde.konsole.desktop"."_launch" = "Meta+Return";
    "services/org.kde.krunner.desktop"."RunClipboard" = [ ];
    "services/org.kde.krunner.desktop"."_launch" = ["Search" "Meta+Space"];
  };

  configFile = {
    # Emacs window settings
    "kwinrulesrc"."53e033ce-9cec-4761-aa89-5622cfc5c6b8"."Description" = "Emacs settings";
    "kwinrulesrc"."53e033ce-9cec-4761-aa89-5622cfc5c6b8"."desktopfile" = "/run/current-system/sw/share/applications/emacs.desktop";
    "kwinrulesrc"."53e033ce-9cec-4761-aa89-5622cfc5c6b8"."desktopfilerule" = 4;
    "kwinrulesrc"."53e033ce-9cec-4761-aa89-5622cfc5c6b8"."strictgeometryrule" = 2;
    "kwinrulesrc"."53e033ce-9cec-4761-aa89-5622cfc5c6b8"."wmclass" = "Emacs";
    "kwinrulesrc"."53e033ce-9cec-4761-aa89-5622cfc5c6b8"."wmclassmatch" = 1;
    "kwinrulesrc"."General"."count" = 1;
    "kwinrulesrc"."General"."rules" = "53e033ce-9cec-4761-aa89-5622cfc5c6b8";

    # Disable file indexer
    "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;

    # Keyboard settings
    "kcminputrc"."Keyboard"."RepeatDelay" = 250;
    "kcminputrc"."Keyboard"."RepeatRate" = 50;

    # Font settings
    "kdeglobals"."General"."XftAntialias" = true;
    "kdeglobals"."General"."XftHintStyle" = "hintfull";
    "kdeglobals"."General"."XftSubPixel" = "rgb";

    # No animations
    "kdeglobals"."KDE"."AnimationDurationFactor" = 0;
    # "kdeglobals"."KDE"."AnimationDurationFactor" = 0.7071067811865475;

    # Klipper
    "klipperrc"."General"."IgnoreImages" = false;
    "klipperrc"."General"."MaxClipItems" = 1000;
    "klipperrc"."General"."SyncClipboards" = true;

    # Krunner
    "krunnerrc"."General"."ActivateWhenTypingOnDesktop" = false;
    "krunnerrc"."General"."FreeFloating" = true;
    "krunnerrc"."Plugins"."baloosearchEnabled" = false;
    "krunnerrc"."Plugins"."browserhistoryEnabled" = false;
    "krunnerrc"."Plugins"."browsertabsEnabled" = false;

    # Splash screen
    "ksplashrc"."KSplash"."Engine" = "none";
    "ksplashrc"."KSplash"."Theme" = "None";

    # Don't show window previews on Alt+Tab
    "kwinrc"."TabBox"."HighlightWindows" = false;

    # Focus follows mouse
    "kwinrc"."Windows"."FocusPolicy" = "FocusFollowsMouse";

    # Always maximize new windows
    #"kwinrc"."Windows"."Placement" = "Maximizing";

    # Remove borders when windows are maximized
    "kwinrc"."Windows"."BorderlessMaximizedWindows" = true;

    # Keyboard layouts
    "kxkbrc"."Layout"."DisplayNames" = "DV,US";
    "kxkbrc"."Layout"."LayoutList" = "us,us";
    "kxkbrc"."Layout"."Use" = true;
    "kxkbrc"."Layout"."VariantList" = "dvorak,";

    # Dolphin settings
    "dolphinrc"."General"."EditableUrl" = true;
    "dolphinrc"."General"."ShowFullPath" = true;
  };

  powerdevil = {
    AC = {
      autoSuspend.action = "nothing";
      dimDisplay = {
        enable = true;
        idleTimeOut = 180;
      };
      powerButtonAction = "showLogoutScreen";
      turnOffDisplay = {
        idleTimeout = 300;
        idleTimeoutWhenLocked = "immediately";
      };
      whenLaptopLidClosed = "doNothing";
    };
    battery = {
      autoSuspend.action = "nothing";
      dimDisplay = {
        enable = true;
        idleTimeOut = 180;
      };
      powerButtonAction = "showLogoutScreen";
      turnOffDisplay = {
        idleTimeout = 300;
        idleTimeoutWhenLocked = "immediately";
      };
      whenLaptopLidClosed = "doNothing";
    };
    lowBattery = {
      autoSuspend.action = "nothing";
      dimDisplay = {
        enable = true;
        idleTimeOut = 60;
      };
      powerButtonAction = "showLogoutScreen";
      turnOffDisplay = {
        idleTimeout = 120;
        idleTimeoutWhenLocked = "immediately";
      };
      whenLaptopLidClosed = "doNothing";
    };
  };
}
