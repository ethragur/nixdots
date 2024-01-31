{ pkgs, lib, config, ... }: {
  options.modules.gui.alacritty.enable = lib.mkEnableOption "Enable personal alacritty config";

  config = lib.mkIf config.modules.gui.alacritty.enable {

    stylix.targets.alacritty.enable = true;
    home.sessionVariables.TERMINAL = "alacritty";
    programs.alacritty.settings = {
        env = {
            TERM = "xterm-256color";
        };
    };
  };
}
