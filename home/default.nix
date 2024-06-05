inputs:
{ config, pkgs, lib, osConfig, flake-inputs, ... }:
{

  imports = [
    ./modules/cli/nnn
    ./modules/cli/neovim
    ./modules/cli/helix
    ./modules/gui/desktop-environment
    (import ./modules/gui/desktop-environment/sway inputs)
    ./modules/gui/desktop-environment/i3
    ./modules/gui/desktop-environment/eww
    ./modules/gui/alacritty
    ./modules/gui/firefox.nix
    ./modules/gui/mpv
    ./modules/theme.nix
    (import ./modules/gui/gaming.nix inputs)
    ./modules/gui/blender.nix
    ./modules/gui/godot.nix
    ./modules/cli/zsh.nix
    flake-inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
  programs.alacritty.enable = true;

  modules.cli.zsh.enable = true;
  modules.cli.neovim.enable = true;
  modules.cli.helix.enable = true;
  modules.gui.desktop-environment.enable = true;
  modules.gui.gaming.enable = true;
  modules.gui.desktop-environment.sway.enable = true;
  modules.gui.desktop-environment.i3.enable = false;
  modules.gui.alacritty.enable = true;
  modules.gui.firefox.enable = true;
  modules.gui.mpv.enable = true;

  services.flatpak.enable = true;


  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
  ];

  # services.flatpak.update.auto = {
  # enable = true;
  # onCalendar = "weekly"; # Default value
  # };


  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
  xdg.systemDirs.data = [ "/usr/share" "/usr/local/share" "/var/lib/flatpak/exports/share" "$HOME/.local/share/flatpak/exports/share" ];





}
