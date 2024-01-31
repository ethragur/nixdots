{ config, pkgs, lib, ... }:
{
    options.modules.cli.nnn.enable = lib.mkEnableOption ''
        Enable nnn config
        '';

    config = lib.mkIf config.modules.cli.nnn.enable {
        programs.nnn.enable = true;
    };
}

