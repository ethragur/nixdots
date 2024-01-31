{ config, pkgs, lib, ... }:
{
    options.modules.gui.firefox.enable = lib.mkEnableOption ''
        Enable firefox config
        '';

    config = lib.mkIf config.modules.gui.firefox.enable {
        home.packages = with pkgs; [
            firefox
        ];
        programs.firefox = {
            enable = true;
            profiles = {
                default = {
                    isDefault = true;
                    settings = {
                        "media.ffmpeg.vaapi.enabled" = true;
                    };
                };
            };
        };

    };
}



