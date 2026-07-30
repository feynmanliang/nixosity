{ config, lib, pkgs, username, ... }:
let
  openaiShellHook = kind: ''
    # OpenAI ${kind} (if customising, comment out to prevent it getting readded)
    for file in "$HOME/.openai/${kind}"/*; do
      source "$file"
    done
  '';
in
{
  # Reuse the base home configuration, then override host-specific bits.
  imports = [ ./home.nix ];

  programs = {
    git = {
      userEmail = lib.mkForce "feynman@openai.com";
    };

    zsh = {
      initContent = lib.mkAfter ''
        # nix-darwin's interactive zsh setup resets PATH and drops Homebrew on macOS.
        # Restore Homebrew while preserving the OpenAI virtualenv and Nix priority.
        if [ -x /opt/homebrew/bin/brew ]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi

        if [ -n "''${VIRTUAL_ENV-}" ]; then
          path_prepend "''${VIRTUAL_ENV}/bin"
        fi

        path_prepend "/run/current-system/sw/bin"
        path_prepend "/etc/profiles/per-user/$USER/bin"
        path_prepend "$HOME/.nix-profile/bin"

        # Home Manager backs up the previous OpenAI-managed zsh config on first switch.
        if [ -f "$HOME/.zshrc.backup" ]; then
          source "$HOME/.zshrc.backup"
        fi
        if [ -f "$HOME/.openai-secrets" ]; then
          source "$HOME/.openai-secrets"
        fi

        ${openaiShellHook "shrc"}
      '';
      profileExtra = ''
        # Managed by Home Manager (J3WK3WGTW2)
        . "$HOME/.local/bin/env"
        . "$HOME/.cargo/env"

        ${openaiShellHook "shprofile"}
      '';
    };
  };

  home.packages = with pkgs; [
    jujutsu
  ];

  home.file.".config/jj/config.toml".text = ''
    [user]
    name = "Feynman Liang"
    email = "feynman@openai.com"

    [ui]
    default-command = "log"

    [aliases]
    l = ["log", "-r", "::@"]
    s = ["status"]
  '';
}
