{
  imports = [
    ../../hosts
  ];


  modules.hosts = {
    hostName = "effi-desktop";
    hostId = "c9544ae6";
    interfaces = {
      enp4s0.ipv4.addresses = [{
        address = "192.168.0.171";
        prefixLength = 24;
      }];
    };
    defaultGateway = "192.168.0.1";
    display.outputs = [
      { xname = "DisplayPort-1"; wname = "DP-2"; vrr = "on"; posx = "3840"; posy = "0"; mode = "2560x1440"; rate = "143.912"; workspaces = [ 1 3 5 7 9 ]; "bar" = true; }
      { xname = "DisplayPort-2"; wname = "DP-3"; vrr = "off"; posx = "0"; posy = "0"; mode = "3840x2160"; rate = "59.997"; workspaces = [ 2 4 6 8 ]; "bar" = true; }
      { xname = "HDMI-A-0"; wname = "HDMI-A-1"; vrr = "off"; posx = "6400"; posy = "0"; mode = "1920x1080"; rate = "60.000"; workspaces = [ 0 ]; "bar" = true; }
    ];
    amdcpu = true;
    amdgpu = true;
    fileSystems = {
      "/" =
        {
          device = "/dev/disk/by-uuid/48bfaac9-8776-41d5-9265-87eafe7ae8de";
          fsType = "xfs";
        };

      "/mnt/data" =
        {
          device = "/dev/disk/by-uuid/2b6c9175-86e2-431d-9d63-0d8ebad1425a";
          fsType = "btrfs";
        };

      "/boot" =
        {
          device = "/dev/disk/by-uuid/816B-3C5F";
          fsType = "vfat";
        };
    };

    swapDevices = [{ device = "/dev/disk/by-uuid/2e322a31-575d-499a-80e1-c165f68ccdf6"; }];

  };

  # modules.nfsmount = {
  # enable = true;
  # from = "192.168.0.199:/data";
  # to = "/mnt/nfs";
  # };
}
