{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    ../../modules/amd.nix
  ];

  options.hosts.display.outputs = lib.mkOption {
    type = lib.types.anything;
    default = [
      { xname = "DisplayPort-1"; wname = "eDP-1"; vrr = "off"; posx = "0"; posy = "0"; mode = "1920x1080"; rate = "60.007"; workspaces = [ 0 1 2 3 4 5 6 7 8 9 ]; "bar" = true; }
    ];
  };


  config = {
    modules.amd.enable = true;
    networking = {
      hostName = "effi-desktop";
      hostId = "1482f1f4";
      nameservers = [ "1.1.1.1" "1.1.1.2" ];
      dhcpcd.enable = true;
      wireless.iwd = {
        enable = true;
      };
      interfaces.wlo1 = { };
      nftables.enable = true;
      firewall = {
        enable = true;
        allowedTCPPorts = [ 222 8188 ];
      };
    };

    hardware.steam-hardware.enable = true;

    modules.nfsmount = {
      enable = true;
      from = "192.168.0.199:/data";
      to = "/mnt/nfs";
    };
    # fileSystems."/" =
    #   {
    #     device = "/dev/disk/by-uuid/48bfaac9-8776-41d5-9265-87eafe7ae8de";
    #     fsType = "xfs";
    #   };

    # fileSystems."/mnt/data" =
    #   {
    #     device = "/dev/disk/by-uuid/2b6c9175-86e2-431d-9d63-0d8ebad1425a";
    #     fsType = "btrfs";
    #   };

    # fileSystems."/boot" =
    #   {
    #     device = "/dev/disk/by-uuid/816B-3C5F";
    #     fsType = "vfat";
    #   };

    # swapDevices =
    #   [{ device = "/dev/disk/by-uuid/2e322a31-575d-499a-80e1-c165f68ccdf6"; }];
  };
}
