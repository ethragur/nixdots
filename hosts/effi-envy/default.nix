{
  imports = [
    ../../hosts
  ];


  modules.hosts = {
    hostName = "effi-envy";
    hostId = "1482f1f4";
    wireless = true;
    display.outputs = [
      { xname = "DisplayPort-1"; wname = "eDP-1"; vrr = "off"; posx = "0"; posy = "0"; mode = "1920x1080"; rate = "60.007"; workspaces = [ 1 2 3 4 5 6 7 8 9 0 ]; "bar" = true; }
    ];
    amdcpu = true;
    amdgpu = true;
    isLaptop = true;

    fileSystems = {
      "/" =
        {
          device = "/dev/disk/by-uuid/9953e272-19f6-4c7d-a244-ad7f1302f4ae";
          fsType = "xfs";
        };

      "/boot" =
        {
          device = "/dev/disk/by-uuid/7941-8477";
          fsType = "vfat";
        };
    };
    swapDevices = [{ device = "/dev/disk/by-uuid/ac3a4336-28a5-429e-a3ae-d928f120536b"; }];

  };

  modules.nfsmount = {
    enable = true;
    from = "192.168.0.199:/data";
    to = "/mnt/nfs";
  };
}

