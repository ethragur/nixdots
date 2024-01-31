{ nixpak
, ...
}:
{ config, pkgs, lib, ... }:
{
  options.modules.gui.gaming.enable = lib.mkEnableOption ''
    Enable gaming config
  '';

  config = lib.mkIf config.modules.gui.gaming.enable {
    home.packages = with pkgs; [
    ];
  };
}



