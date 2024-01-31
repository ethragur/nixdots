{ config, lib, pkgs, ... }:
{
    options.modules.llama.enable = lib.mkEnableOption ''
        Enable llama.cpp config
        '';

    config = lib.mkIf config.modules.llama.enable {
        nixpkgs.config.packageOverrides = pkgs: {
            llama-cpp = (
                    builtins.getFlake "github:ggerganov/llama.cpp"
                    ).packages.${builtins.currentSystem}.default;
        };
        environment.systemPackages = with pkgs; [ llama-cpp ];
    };
}


