{ config, pkgs, inputs, ... }:
{
  imports =
    [
      ./modules/nfsmount.nix
      ./modules/tailscale.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.enableRedistributableFirmware = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  nix.settings.trusted-users = [ "root" "@wheel" ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
  ];

  services.resolved.enable = true;
  #nixpkgs.overlays = [ (import ./overlays/godot.nix) ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  virtualisation.podman.enable = true;


  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Calibre
  services.udisks2.enable = true;


  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  i18n.defaultLocale = "en_US.UTF-8";

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway --sessions  ${config.services.xserver.displayManager.sessionData.desktops}/share/xsessions:${config.services.xserver.displayManager.sessionData.desktops}/share/wayland-sessions";
        user = "greeter";
      };
    };
  };
  environment.etc."greetd/environments".text = ''
    sway
    zsh
  '';

  security.pam.services.greetd.enableGnomeKeyring = true;

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    p7zip
    htop
  ];

  services.openssh.enable = true;
  services.openssh.ports = [ 222 ];
  services.openssh.settings.PermitRootLogin = "yes";

  system.stateVersion = "24.05";


  stylix.image = pkgs.fetchurl {
    url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
  };
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";

  services.flatpak.enable = true;
  environment.etc.hosts.mode = "0644";

  security.pam.services.swaylock = { };
  xdg = {
    portal = {
      wlr = {
        enable = true;
        settings = {
          screencast = {
            max_fps = 30;
          };
        };
      };
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = [
            "gtk"
          ];
        };
      };
    };
  };
}

