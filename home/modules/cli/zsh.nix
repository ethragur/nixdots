{ config, pkgs, lib, ... }:
{
    options.modules.cli.zsh.enable = lib.mkEnableOption ''
        Enable zsh config
        '';

    config = lib.mkIf config.modules.cli.zsh.enable {
        programs.zsh = {
            enable = true;
            shellAliases = {
                ll = "ls -l";
                dd = "dd status=progress";
                mkdir = "mkdir -pv";
                cx = "chmod +x";
                update = "nixos-rebuild switch --use-remote-sudo --flake /home/effi/Documents/Development/nixdots/";
            };
            defaultKeymap = "emacs";
            enableCompletion = true;
            enableAutosuggestions = true;
            syntaxHighlighting.enable = true;
            historySubstringSearch.enable = true;
        };
        programs.starship.enable = true;
    };
}



