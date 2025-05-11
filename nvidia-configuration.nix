# For Nvidia Optimus laptops
# https://nixos.wiki/wiki/Nvidia
{ pkgs, lib, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';

  dragonDesktopItem = pkgs.makeDesktopItem {
    # Based on `nix eval nixos.dragon.outpath`/share/applications/org.kde.dragonplayer.desktop
    desktopName = "Dragon Player - nvidia offload";
    genericName = "Video Player - nvidia offload";
    name = "dragon";
    exec = "nvidia-offload dragon %U";
    categories = [ "Qt" "KDE" "AudioVideo" "Player" ];
    icon = "dragonplayer";
    mimeTypes = [
      "video/ogg"
      "video/x-theora+ogg"
      "video/x-ogm+ogg"
      "video/x-ms-wmv"
      "video/x-msvideo"
      "video/x-ms-asf"
      "video/x-matroska"
      "video/mpeg"
      "video/avi"
      "video/quicktime"
      "video/vnd.rn-realvideo"
      "video/x-flic"
      "video/mp4"
      "video/x-flv"
      "video/webm"
      "application/x-cd-image"
    ];
  };

  freecadDesktopItem = pkgs.makeDesktopItem {
    desktopName = "FreeCAD - nvidia offload";
    genericName = "CAD - nvidia offload";
    name = "freecad";
    exec = "nvidia-offload freecad %F";
    categories = [ "Graphics" "Science" "Education" "Engineering" ];
    icon = "org.freecadweb.FreeCAD";
    mimeTypes = [ "application/x-extension-fcstd" ];
    startupNotify = true;
    terminal = false;
    type = "Application";
  };
in {
  environment.systemPackages = [
    nvidia-offload
    dragonDesktopItem
    freecadDesktopItem
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia.prime = {
    # Offload mode
    offload.enable = true;

    # Sync mode
    # sync.enable = true;

    intelBusId = "PCI:00:02:0";
    nvidiaBusId = "PCI:01:00:0";
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
  };
}
