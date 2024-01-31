{ config, pkgs, lib, ... }:
{
  options.modules.gui.desktop-environment.eww.enable = lib.mkEnableOption ''
    Enable personal eww status bar
  '';

  config = lib.mkIf config.modules.gui.desktop-environment.eww.enable {
      programs.eww.enable = true;
      programs.eww.configDir = ./config;
  };
}
