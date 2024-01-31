{ config, pkgs, lib, ... }:
{
    options.modules.gui.godot.enable = lib.mkEnableOption ''
        Enable godot config
        '';

    config = lib.mkIf config.modules.gui.godot.enable {
        home.packages = with pkgs; [
            unstable.godot_4
        ];
    };
}




