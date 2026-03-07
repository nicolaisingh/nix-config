final: prev: {
  reaper = prev.reaper.overrideAttrs (oldAttrs: rec {
    version = "7.61";
    src = prev.fetchurl {
      url = "https://www.reaper.fm/files/7.x/reaper761_linux_x86_64.tar.xz";
      hash = "sha256-NioXFiUNO2TzJn0xhoQKEWb8OD7HD8O+sHAf4enopxg=";
    };
  });
}
