{ config, pkgs, lib, ... }:
{
    options.modules.theme.image = lib.mkOption { 
        type = lib.types.str; 
        default = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    };
    options.modules.theme.image_sha256 = lib.mkOption { 
        type = lib.types.str; 
        default = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
    };
    options.modules.theme.base16theme = lib.mkOption { 
        type = lib.types.str; default = "rose-pine"; 
    };

    config = {
        stylix.image = pkgs.fetchurl {
            url = config.modules.theme.image;
            sha256 = config.modules.theme.image_sha256;
        };
        stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.modules.theme.base16theme}.yaml";

        home.packages = with pkgs; [
            noto-fonts
                noto-fonts-cjk
                noto-fonts-emoji
                fira-code
                fira-code-symbols
                nerdfonts
        ];
        stylix.polarity = "dark";

        stylix.fonts = {
            serif = {
                package = pkgs.noto-fonts;
                name = "Noto Serif";
            };

            sansSerif = {
                package = pkgs.noto-fonts;
                name = "Noto Sans";
            };

            monospace = {
                package = pkgs.fira-code;
                name = "Fira Code";
            };

            emoji = {
                package = pkgs.noto-fonts-emoji;
                name = "Noto Color Emoji";
            };
            sizes = {
                applications = 12;
                desktop = 12;
                popups = 12;
            };
        };

    };
}




