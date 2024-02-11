{ config, lib, ... }:
{

  imports = [
    ../modules/amd.nix
  ];

  options.modules.hosts.hostName = lib.mkOption { type = lib.types.str; };
  options.modules.hosts.hostId = lib.mkOption { type = lib.types.str; };
  options.modules.hosts.wireless = lib.mkOption { type = lib.types.bool; default = false; };
  options.modules.hosts.interfaces = lib.mkOption {
    type = lib.types.anything;
    default = { };
  };
  options.modules.hosts.defaultGateway = lib.mkOption { type = lib.types.nullOr lib.types.str; };

  options.modules.hosts.display.outputs = lib.mkOption {
    type = lib.types.anything;
    default = [
      { xname = "DisplayPort-1"; wname = "DP-2"; vrr = "on"; posx = "3840"; posy = "0"; mode = "2560x1440"; rate = "143.912"; workspaces = [ 1 3 5 7 9 ]; "bar" = true; }
      { xname = "DisplayPort-2"; wname = "DP-3"; vrr = "off"; posx = "0"; posy = "0"; mode = "3840x2160"; rate = "59.997"; workspaces = [ 2 4 6 8 ]; "bar" = true; }
      { xname = "HDMI-A-0"; wname = "HDMI-A-1"; vrr = "off"; posx = "6400"; posy = "0"; mode = "1920x1080"; rate = "60.000"; workspaces = [ 0 ]; "bar" = true; }
    ];
  };

  options.modules.hosts.amdcpu = lib.mkOption { type = lib.types.bool; default = true; };
  options.modules.hosts.amdgpu = lib.mkOption { type = lib.types.bool; default = true; };
  options.modules.hosts.isLaptop = lib.mkOption { type = lib.types.bool; default = false; };
  options.modules.hosts.isServer = lib.mkOption { type = lib.types.bool; default = false; };

  options.modules.hosts.fileSystems = lib.mkOption {
    type = lib.types.anything;
    default = { };
  };

  options.modules.hosts.swapDevices = lib.mkOption {
    type = lib.types.anything;
    default = { };
  };

  config = {
    services.resolved.enable = true;
    networking = {
      hostId = config.modules.hosts.hostId;
      hostName = config.modules.hosts.hostName;
      nameservers = [ "9.9.9.9" "149.112.112.112" "2620:fe::fe" "2620:fe::9" ];
      dhcpcd.enable = config.modules.hosts.wireless;
      wireless.iwd = {
        enable = config.modules.hosts.wireless;
      };
      interfaces = config.modules.hosts.interfaces;
      defaultGateway = config.modules.hosts.defaultGateway;
      nftables.enable = true;
      firewall = {
        enable = true;
        allowedTCPPorts = [ 222 ];
      };
    };

    modules.amd.enable = config.modules.hosts.amdgpu;
    hardware.steam-hardware.enable = config.modules.hosts.amdgpu && !config.modules.hosts.isLaptop && !config.modules.hosts.isServer;

    fileSystems = config.modules.hosts.fileSystems;
    swapDevices = config.modules.hosts.swapDevices;

    hardware.cpu.amd.updateMicrocode = config.modules.hosts.amdcpu;
  };
}
