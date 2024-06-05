{
  imports = [
    ../../hosts
  ];


  modules.hosts = {
    hostName = "effi-rpb4";
    hostId = "dca63249";
    interfaces = {
      end0.ipv4.addresses = [{
        address = "192.168.0.199";
        prefixLength = 24;
      }];
    };
    defaultGateway = "192.168.0.1";
    display.outputs = [ ];
    amdcpu = false;
    amdgpu = false;
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
        options = [ "noatime" ];
      };
    };
  };

}
