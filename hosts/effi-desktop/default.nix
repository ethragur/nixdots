{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    ../../modules/amd.nix
  ];

  options.hosts.display.outputs = lib.mkOption {
    type = lib.types.anything;
    default = [
      { xname = "DisplayPort-1"; wname = "DP-2"; vrr = "on"; posx = "3840"; posy = "0"; mode = "2560x1440"; rate = "143.912"; workspaces = [ 1 3 5 7 9 ]; "bar" = true; }
      { xname = "DisplayPort-2"; wname = "DP-3"; vrr = "off"; posx = "0"; posy = "0"; mode = "3840x2160"; rate = "59.997"; workspaces = [ 2 4 6 8 ]; "bar" = true; }
      { xname = "HDMI-A-0"; wname = "HDMI-A-1"; vrr = "off"; posx = "6400"; posy = "0"; mode = "1920x1080"; rate = "60.000"; workspaces = [ 0 ]; "bar" = true; }
    ];
  };


  config = {
    modules.amd.enable = true;
    networking = {
      hostId = "c9544ae6";
      hostName = "effi-desktop";
      nameservers = [ "8.8.8.8" "8.8.4.4" ];
      dhcpcd.enable = false;
      interfaces.enp4s0 = { };
      interfaces.enp4s0.ipv4.addresses = [{
        address = "192.168.0.171";
        prefixLength = 24;
      }];
      defaultGateway = "192.168.0.1";
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
    fileSystems."/" =
      {
        device = "/dev/disk/by-uuid/48bfaac9-8776-41d5-9265-87eafe7ae8de";
        fsType = "xfs";
      };

    fileSystems."/mnt/data" =
      {
        device = "/dev/disk/by-uuid/2b6c9175-86e2-431d-9d63-0d8ebad1425a";
        fsType = "btrfs";
      };

    fileSystems."/boot" =
      {
        device = "/dev/disk/by-uuid/816B-3C5F";
        fsType = "vfat";
      };

    swapDevices =
      [{ device = "/dev/disk/by-uuid/2e322a31-575d-499a-80e1-c165f68ccdf6"; }];
  };
}
