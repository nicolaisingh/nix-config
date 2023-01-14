# For Nvidia Optimus laptops
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
in {
  environment.systemPackages = [
    nvidia-offload
    dragonDesktopItem
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:00:02:0";
    nvidiaBusId = "PCI:01:00:0";
  };
}
