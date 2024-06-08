{ pkgs, ... }: {
  home.packages = [
    pkgs.git
    pkgs.tmux
    pkgs.neovim

    pkgs.nixpkgs-fmt
  ];

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    bash.enable = true;
  };

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "24.05";
}
