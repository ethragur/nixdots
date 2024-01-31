{ config, pkgs, lib, ... }:
{
  options.modules.cli.helix.enable = lib.mkEnableOption ''
    Enable helix config
  '';

  config = lib.mkIf config.modules.cli.helix.enable {
    stylix.targets.helix.enable = true;
    programs.helix = {
      enable = true;
      languages = with pkgs; {
        language = [
          { name = "nix"; auto-format = true; indent = { tab-width = 4; unit = " "; }; }
          { name = "gdscript"; file-types = [ "gd" ]; language-servers = [ "gdscript" ]; indent = { tab-width = 4; unit = ""; }; }
          { name = "yaml"; file-types = [ "yaml" "yml" ]; language-servers = [ "yaml-language-server" ]; indent = { tab-width = 4; unit = ""; }; }
        ];
        language-server = {
          nil = {
            command = "${pkgs.nil}/bin/nil";
            config.nil = {
              formatting.command = [ "${nixpkgs-fmt}/bin/nixpkgs-fmt" ];
              nix.flake.autoEvalInputs = true;
            };
          };
          gdscript = {
            command = "${pkgs.netcat}/bin/nc";
            args = [ "127.0.0.1" "6005" ];
          };
          rust-analyzer = {
            command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
            formatter = {
              command = "${pkgs.rustfmt}";
            };
            auto-format = true;
          };
          yaml-language-server = {
            command = "${pkgs.yaml-language-server}/bin/yaml-language-server";
          };
        };
      };
      settings = {
        editor = {
          line-number = "relative";
          lsp.display-messages = true;
          cursorline = true;
          color-modes = true;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          indent-guides.render = true;
          insert-final-newline = false;
          bufferline = "always";
          auto-pairs = false;
        };
        # Thanks to: https://github.com/LGUG2Z/helix-vim
        keys.normal = {
          "A-h" = ":buffer-previous";
          "A-l" = ":buffer-next";
          space.space = "file_picker";
          "0" = "goto_line_start";
          "$" = "goto_line_end";
          G = "goto_file_end";
          "%" = "match_brackets";
          D = [ "extend_to_line_end" "yank_main_selection_to_clipboard" "delete_selection" ];
        };
        keys.select = {
          "{" = [ "extend_to_line_bounds" "goto_prev_paragraph" ];
          "}" = [ "extend_to_line_bounds" "goto_next_paragraph" ];
          "0" = "goto_line_start";
          G = "goto_file_end";
          "%" = "match_brackets";
          D = [ "extend_to_line_end" "yank_main_selection_to_clipboard" "delete_selection" ];
        };
        #  "$" = "goto_line_end";
        #  C-o = ":config-open";
        #  C-r = ":config-reload";
        #  C-h = "select_prev_sibling";
        #  C-j = "shrink_selection";
        #  C-k = "expand_selection";
        #  C-l = "select_next_sibling";
        #  o = [ "open_below" "insert_mode" ];
        #  O = [ "open_above" "insert_mode" ];
        #  "{" = [ "goto_prev_paragraph" "collapse_selection" ];
        #  "}" = [ "goto_next_paragraph" "collapse_selection" ];
        #  "^" = "goto_first_nonwhitespace";
        #  G = "goto_file_end";
        #  "%" = "match_brackets";
        #  V = [ "select_mode" "extend_to_line_bounds" ];
        #  C = [ "extend_to_line_end" "yank_main_selection_to_clipboard" "delete_selection" "insert_mode" ];
        #  D = [ "extend_to_line_end" "yank_main_selection_to_clipboard" "delete_selection" ];
        #  S = "surround_add";
        #  x = "delete_selection";
        #  p = [ "paste_clipboard_after" "collapse_selection" ];
        #  P = [ "paste_clipboard_before" "collapse_selection" ];
        #  Y = [ "extend_to_line_end" "yank_main_selection_to_clipboard" "collapse_selection" ];
        #  w = [ "move_next_word_start" "move_char_right" "collapse_selection" ];
        #  W = [ "move_next_long_word_start" "move_char_right" "collapse_selection" ];
        #  e = [ "move_next_word_end" "collapse_selection" ];
        #  E = [ "move_next_long_word_end" "collapse_selection" ];
        #  b = [ "move_prev_word_start" "collapse_selection" ];
        #  B = [ "move_prev_long_word_start" "collapse_selection" ];
        #  i = [ "insert_mode" "collapse_selection" ];
        #  a = [ "append_mode" "collapse_selection" ];
        #  u = [ "undo" "collapse_selection" ];
        #  esc = [ "collapse_selection" "keep_primary_selection" ];
        #  "*" = [ "move_char_right" "move_prev_word_start" "move_next_word_end" "search_selection" "search_next" ];
        #  "#" = [ "move_char_right" "move_prev_word_start" "move_next_word_end" "search_selection" "search_prev" ];
        #  j = "move_line_down";
        #  k = "move_line_up";
        #};
        #keys.normal.d = {
        #  d = [ "extend_to_line_bounds" "yank_main_selection_to_clipboard" "delete_selection" ];
        #  t = [ "extend_till_char" ];
        #  s = [ "surround_delete" ];
        #  i = [ "select_textobject_inner" ];
        #  a = [ "select_textobject_around" ];
        #  j = [ "select_mode" "extend_to_line_bounds" "extend_line_below" "yank_main_selection_to_clipboard" "delete_selection" "normal_mode" ];
        #  down = [ "select_mode" "extend_to_line_bounds" "extend_line_below" "yank_main_selection_to_clipboard" "delete_selection" "normal_mode" ];
        #  k = [ "select_mode" "extend_to_line_bounds" "extend_line_above" "yank_main_selection_to_clipboard" "delete_selection" "normal_mode" ];
        #  up = [ "select_mode" "extend_to_line_bounds" "extend_line_above" "yank_main_selection_to_clipboard" "delete_selection" "normal_mode" ];
        #  G = [ "select_mode" "extend_to_line_bounds" "goto_last_line" "extend_to_line_bounds" "yank_main_selection_to_clipboard" "delete_selection" "normal_mode" ];
        #  w = [ "move_next_word_start" "yank_main_selection_to_clipboard" "delete_selection" ];
        #  W = [ "move_next_long_word_start" "yank_main_selection_to_clipboard" "delete_selection" ];
        #  g = { g = [ "select_mode" "extend_to_line_bounds" "goto_file_start" "extend_to_line_bounds" "yank_main_selection_to_clipboard" "delete_selection" "normal_mode" ]; };
        #};
        #keys.normal.y = {
        #  y = [ "extend_to_line_bounds" "yank_main_selection_to_clipboard" "normal_mode" "collapse_selection" ];
        #  j = [ "select_mode" "extend_to_line_bounds" "extend_line_below" "yank_main_selection_to_clipboard" "collapse_selection" "normal_mode" ];
        #  down = [ "select_mode" "extend_to_line_bounds" "extend_line_below" "yank_main_selection_to_clipboard" "collapse_selection" "normal_mode" ];
        #  k = [ "select_mode" "extend_to_line_bounds" "extend_line_above" "yank_main_selection_to_clipboard" "collapse_selection" "normal_mode" ];
        #  up = [ "select_mode" "extend_to_line_bounds" "extend_line_above" "yank_main_selection_to_clipboard" "collapse_selection" "normal_mode" ];
        #  G = [ "select_mode" "extend_to_line_bounds" "goto_last_line" "extend_to_line_bounds" "yank_main_selection_to_clipboard" "collapse_selection" "normal_mode" ];
        #  w = [ "move_next_word_start" "yank_main_selection_to_clipboard" "collapse_selection" "normal_mode" ];
        #  W = [ "move_next_long_word_start" "yank_main_selection_to_clipboard" "collapse_selection" "normal_mode" ];
        #  g = { g = [ "select_mode" "extend_to_line_bounds" "goto_file_start" "extend_to_line_bounds" "yank_main_selection_to_clipboard" "collapse_selection" "normal_mode" ]; };
        #};
        #keys.insert = {
        #  esc = [ "collapse_selection" "normal_mode" ];
        #};
        #keys.select = {
        #  "{" = [ "extend_to_line_bounds" "goto_prev_paragraph" ];
        #  "}" = [ "extend_to_line_bounds" "goto_next_paragraph" ];
        #  "0" = "goto_line_start";
        #  "$" = "goto_line_end";
        #  "^" = "goto_first_nonwhitespace";
        #  G = "goto_file_end";
        #  D = [ "extend_to_line_bounds" "delete_selection" "normal_mode" ];
        #  C = [ "goto_line_start" "extend_to_line_bounds" "change_selection" ];
        #  "%" = "match_brackets";
        #  S = "surround_add";
        #  u = [ "switch_to_lowercase" "collapse_selection" "normal_mode" ];
        #  U = [ "switch_to_uppercase" "collapse_selection" "normal_mode" ];
        #  i = "select_textobject_inner";
        #  a = "select_textobject_around";
        #  tab = [ "insert_mode" "collapse_selection" ];
        #  C-a = [ "append_mode" "collapse_selection" ];
        #  k = [ "extend_line_up" "extend_to_line_bounds" ];
        #  j = [ "extend_line_down" "extend_to_line_bounds" ];
        #  d = [ "yank_main_selection_to_clipboard" "delete_selection" ];
        #  x = [ "yank_main_selection_to_clipboard" "delete_selection" ];
        #  y = [ "yank_main_selection_to_clipboard" "normal_mode" "flip_selections" "collapse_selection" ];
        #  Y = [ "extend_to_line_bounds" "yank_main_selection_to_clipboard" "goto_line_start" "collapse_selection" "normal_mode" ];
        #  p = "replace_selections_with_clipboard";
        #  P = "paste_clipboard_before";
        #  esc = [ "collapse_selection" "keep_primary_selection" "normal_mode" ];

        #};
      };
    };
  };
}





