{
  imports = [
    ../../hosts
  ];


  modules.hosts = {
    hostName = "effi-steamdeck";
    hostId = "f8e58953";
    wireless = true;
    display.outputs = [
    ];
    amdcpu = true;
    amdgpu = false;
    fileSystems = {
      "/" =
        {
          device = "/dev/disk/by-uuid/ff0abecb-bfc5-44b6-9316-85f125ef3b01";
          fsType = "xfs";
        };


      "/boot" =
        {
          device = "/dev/disk/by-uuid/29EE-DB25";
          fsType = "vfat";
          options = [ "fmask=0077" "dmask=0077" ];
        };
    };

    swapDevices = [{ device = "/dev/disk/by-uuid/f41bd631-35e9-4e88-8494-a76f82813882"; }];

  };

  modules.gui.desktop-environment.enable = false;
  modules.gui.gaming.enable = false;
  modules.gui.desktop-environment.sway.enable = false;
  modules.gui.desktop-environment.i3.enable = false;
  # modules.nfsmount = {
  # enable = true;
  # from = "192.168.0.199:/data";
  # to = "/mnt/nfs";
  # };
}
