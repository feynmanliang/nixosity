{ pkgs, ... }: {
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  home.packages = [
    pkgs.git
    pkgs.tmux
    pkgs.neovim

    pkgs.nixpkgs-fmt

    pkgs.jq
    pkgs.yq-go

    pkgs.btop
    pkgs.dnsutils
  ];

  programs = {
    bash.enable = true;

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      userName = "Feynman Liang";
      userEmail = "feynman.liang@gmail.com";
    };

    starship.enable = true;
  };

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "24.05";
}
