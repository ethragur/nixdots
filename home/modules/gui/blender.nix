{ config, pkgs, lib, ... }:
{
    options.modules.gui.blender.enable = lib.mkEnableOption ''
        Enable blender config
        '';

    config = lib.mkIf config.modules.gui.blender.enable {
        home.packages = with pkgs; [
            blender-hip
        ];
    };
}



