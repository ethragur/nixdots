{ config, pkgs, lib, ... }:
{
    options.modules.cli.neovim.enable = lib.mkEnableOption ''
        Enable neovim config
        '';

    config = lib.mkIf config.modules.cli.neovim.enable {
        home.sessionVariables = {
            EDITOR = "nvim";
        };

        stylix.targets.vim.enable = true;
        programs.fzf.enable = true;
        programs.neovim = {
            enable = true;
            defaultEditor = true;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;
            extraLuaConfig = builtins.readFile(./default_config.lua);
            plugins = with pkgs.vimPlugins; [
            {
                plugin = lualine-nvim;
                type = "lua";
                config = builtins.readFile(./plugins/lualine-nvim.lua);
            }
            {
                plugin = barbar-nvim;
                type = "lua";
            }
            {
                plugin = indent-blankline-nvim-lua;
                type = "lua";
            }
            {
                plugin = fzf-lua;
                type = "lua";
            }
            {
                plugin = nvim-web-devicons;
            }
            {
                plugin = nvim-lspconfig;
                type = "lua";
                config = builtins.readFile(./plugins/nvim-lspconfig.lua);
            }
            {
                plugin = nvim-cmp;
                type = "lua";
            }
            {
                plugin = cmp-buffer;
                type = "lua";
            }
            {
                plugin = cmp-path;
                type = "lua";
            }
            {
                plugin = cmp-nvim-lsp;
                type = "lua";
            }
            {
                plugin = luasnip;
                type = "lua";
            }
            {
                plugin = cmp_luasnip;
                type = "lua";
            }
            {
                plugin = rust-tools-nvim;
                type = "lua";
            }
            #{
            #    plugin = nvim-treesitter;
            #    type = "lua";
            #    config = builtins.readFile(./plugins/nvim-treesitter.lua);
            #}
            #{
            #    plugin = nvim-tree-lua;
            #    type = "lua";
            #    config = builtins.readFile(./plugins/nvim-tree-lua.lua);
            #}
#{
#    plugin = rose-pine;
#    type = "lua";
#    config = "vim.cmd('colorscheme rose-pine')";
#}
            {
                plugin = gitsigns-nvim;
                type = "lua";
            }
            {
                plugin = alpha-nvim;
                type = "lua";
                config = builtins.readFile(./plugins/alpha-nvim.lua);
            }
            ];

            extraPackages = with pkgs; [
                fzf
                    gcc
                    python3
                    deno
                    nil
                    nixpkgs-fmt
                    nodePackages.pyright
                    nodePackages.dockerfile-language-server-nodejs
                    nodePackages.vscode-html-languageserver-bin
                    nodePackages.vscode-json-languageserver-bin
                    nodePackages.vscode-css-languageserver-bin
                    nodePackages.typescript-language-server
                    nodePackages.vue-language-server
                    nodePackages.yaml-language-server
                    nodePackages.bash-language-server
                    ansible-language-server
                    php82
                    php82Packages.psalm
                    php82Packages.composer
                    gopls
                    cargo
                    rustc
                    rust-analyzer
                    ];

        };
    };
}

