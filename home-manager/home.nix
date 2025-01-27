# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ lib
, config
, pkgs
, neovim-nightly-overlay
, nvchad4nix
, username
, ...
}: {
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      (final: prev: {
        nvchad = nvchad4nix.packages."${pkgs.system}".nvchad;
      })
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

    #./nvim.nix
    nvchad4nix.homeManagerModule
    ./tmux.nix
  ];


  home = {
    username = username;
    homeDirectory = if pkgs.stdenv.isDarwin
      then "/Users/${username}"
      else "/home/${username}";
    # sessionVariables = {
    #   SSL_CERT_FILE = "/home/${username}/.nix-portable/ca-bundle.crt";
    # };
  };

  # Add stuff for your user as you see fit:
  programs = {
    atuin = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "https://atuin.kube.home";
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
        gbdm = "git branch --merged | grep -Ev \"(^\\*|master|main|dev)\" | xargs git branch -d";
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
      extraConfig = {
        push = {
          autoSetupRemote = true;
        };
        merge = {
          tool = "nvimdiff";
        };
      };
    };

    k9s.enable = true;

    lazygit.enable = true;

    nvchad.enable = true;

    starship.enable = true;

    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
  };

  home.packages = with pkgs; [
    nixpkgs-fmt

    kubectl
    kubelogin
    kubelogin-oidc
    kubectx

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
    xsel

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
