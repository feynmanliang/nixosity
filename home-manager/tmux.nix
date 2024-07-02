{ pkgs, ... }:
let
  tmux-super-fingers = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "tmux-super-fingers";
      version = "unstable-2024-06-13";
      src = pkgs.fetchFromGitHub {
        owner = "artemave";
        repo = "tmux_super_fingers";
        rev = "6b27a8c7a2a2ed97b8dd38d18cf403b6250c42b9";
        sha256 = "sha256-lJ6EDJbSj4jhVcG1rLfhTil2fx55S7HhCWkDuhdy5NE=";
      };
    };
in 
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    prefix = "C-a";
    terminal = "screen-256color";
    historyLimit = 100000;
    plugins = with pkgs;
      [
        tmuxPlugins.better-mouse-mode
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavour 'frappe'
            set -g @catppuccin_window_tabs_enabled on
            set -g @catppuccin_date_time "%H:%M"
          '';
        }
        tmuxPlugins.pain-control
        tmuxPlugins.sensible
        tmuxPlugins.yank
        {
          plugin = tmux-super-fingers;
          extraConfig = "set -g @super-fingers-key f";
        }
        # needs to be after right status edits, see https://haseebmajid.dev/posts/2023-07-10-setting-up-tmux-with-nix-home-manager/
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-boot 'on'
            set -g @continuum-save-interval '10' # minutes
          '';
        }
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-vim 'session'
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
          '';
        }
      ];
  };
}
