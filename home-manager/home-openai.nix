{ config, lib, pkgs, username, ... }:
{
  # Reuse the base home configuration, then override host-specific bits.
  imports = [ ./home.nix ];

  programs = {
    git = {
      userEmail = lib.mkForce "feynman@openai.com";
    };

    bash = {
      bashrcExtra = lib.mkAfter ''
        # nix-darwin's interactive bash setup resets PATH and drops Homebrew on macOS.
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

        if [ -f "$HOME/.bashrc.openai" ]; then
          source "$HOME/.bashrc.openai"
        fi
        if [ -f "$HOME/.openai-secrets" ]; then
          source "$HOME/.openai-secrets"
        fi
      '';
      profileExtra = ''
        # Managed by Home Manager (J3WK3WGTW2)
        . "$HOME/.local/bin/env"
        . "$HOME/.cargo/env"
        # OpenAI shprofile (if customising, comment out to prevent it getting readded)
        for file in "/Users/feynman/.openai/shprofile"/*; do
            source "$file"
        done
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
