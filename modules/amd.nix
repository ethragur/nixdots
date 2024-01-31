{ config, lib, pkgs, ... }:
{
  options.modules.amd.enable = lib.mkEnableOption ''
    Enable AMD GPU module
  '';

  config = lib.mkIf config.modules.amd.enable {
    nixpkgs.config.allowUnfree = true;
    boot.kernelModules = [ "kvm-amd" "amdgpu" ];
    hardware.opengl.extraPackages = with pkgs; [
      rocmPackages.miopen-opencl
      rocmPackages.rocm-runtime
      rocmPackages.rocminfo
    ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
    programs.corectrl = {
      enable = true;
      gpuOverclock = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };
    };

  };
}


