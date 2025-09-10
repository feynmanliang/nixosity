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
      '';
      profileExtra = ''
        # Managed by Home Manager (J3WK3WGTW2)
        if [ -f "$HOME/.bash_profile.openai" ]; then
          source "$HOME/.bash_profile.openai"
        fi
      '';
    };
  };
}

