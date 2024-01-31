{ config, lib, ... }:
{
    options.modules.nfsmount.enable = lib.mkEnableOption ''
        Enable wireguard config
        '';

    options.modules.nfsmount.from = lib.mkOption { type = lib.types.str; };

    options.modules.nfsmount.to = lib.mkOption { type = lib.types.str; };


    config = lib.mkIf config.modules.nfsmount.enable {
        fileSystems.${config.modules.nfsmount.to} = {
            device = config.modules.nfsmount.from;
            fsType = "nfs";
            options = [ "nofail" "x-systemd.device-timeout=1" "noatime" ];
        };
    };
}


