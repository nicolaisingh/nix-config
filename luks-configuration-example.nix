# LUKS
{
  boot.initrd.luks.devices = {
    "DEVICENAME" = {
      device = "/dev/disk/by-uuid/DEVICEUUID";
    };
    "DEVICE2NAME" = {
      device = "/dev/disk/by-uuid/DEVICE2UUID";
    };
  };
}
