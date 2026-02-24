{ config, lib, pkgs, username, ... }:
{
  # Reuse the base home configuration, then override host-specific bits.
  imports = [ ./home.nix ];

  programs = {
    git = {
      userEmail = lib.mkForce "feynman@openai.com";
    };

    bash = {
      # Append sourcing of the OpenAI-specific bashrc, if present
      bashrcExtra = lib.mkAfter ''
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
