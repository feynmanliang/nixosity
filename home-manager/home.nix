# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, lib
, config
, pkgs
, neovim-nightly-overlay
, username
, ...
}: {
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    ./nvim.nix
    ./tmux.nix
  ];


  home = {
    username = username;
    homeDirectory = "/home/${username}";
    sessionVariables = {
      SSL_CERT_FILE = "/home/${username}/.nix-portable/ca-bundle.crt";
    };
  };

  # Add stuff for your user as you see fit:
  programs = {
    atuin = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_addres = "https://atuin.kube.home";
        search_mode = "fuzzy";
        enter_accept = false;
      };
    };

    bash = {
      enable = true;
      bashrcExtra = ''
        export PATH="$HOME/.nix-profile/bin:$PATH:$HOME/bin:$HOME/.local/bin"
      '';

      shellAliases = {
        k = "kubectl";
      };
    };

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

    k9s.enable = true;

    starship.enable = true;

    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
  };

  home.packages = with pkgs; [
    nixpkgs-fmt

    kubectl
    ripgrep
    jq
    yq-go

    htop
    btop

    unzip
    dnsutils

    # for tmux
    lsof
    file
    xdg-utils

    # for neovim
    python3
    nodejs
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
