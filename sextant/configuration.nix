# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs
, lib
, config
, pkgs
, ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    # ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

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
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        # Opinionated: disable global registry
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;

        # configure binary caches from nix community and cachix

        # given the users in this list the right to specify additional substituters via:
        #    1. `nixConfig.substituters` in `flake.nix`
        #    2. command line args `--options substituters http://xxx`
        trusted-users = [ "nixos" ];

        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];

        trusted-public-keys = [
          # the default public key of cache.nixos.org, it's built-in, no need to add it here
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          # nix community's cache server public key
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
      # Opinionated: disable channels
      channel.enable = false;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  networking.hostName = "sextant";

  # configure NixOS-WSL
  wsl.enable = true;
  wsl.defaultUser = "nixos";
  wsl.interop.register = true;

  # for patching vscode-server
  environment.systemPackages = [
    pkgs.wget
  ];
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };

  # ssh
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
      KbdInteractiveAuthentication = true;
    };
  };

  # docker
  users.users."nixos".extraGroups = [ "docker" ];
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = false;
    };
  };

  # woodpark.lan cluster CA
  security.pki.certificates = [
  ''
  -----BEGIN CERTIFICATE-----
  MIIBkjCCATigAwIBAgIQUsfkUhF4WhDFXnovCxMDLjAKBggqhkjOPQQDAjApMQsw
  CQYDVQQGEwJVUzEaMBgGA1UEAxMRa3ViZS5ob21lIHJvb3QgQ0EwHhcNMjQxMjI4
  MTY0NzQ5WhcNMjUwMzI4MTY0NzQ5WjApMQswCQYDVQQGEwJVUzEaMBgGA1UEAxMR
  a3ViZS5ob21lIHJvb3QgQ0EwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAASMQs82
  LUtaaMzThOLNEn3zxRqGwrgTAzpNi8M4sFcM6HFnGWYinbDmaf3RQEurqX+xwc8d
  GQS+UVk+PcTjZyeUo0IwQDAOBgNVHQ8BAf8EBAMCAqQwDwYDVR0TAQH/BAUwAwEB
  /zAdBgNVHQ4EFgQU97yoKLME6u0KrSXYF0uoVKCIyZIwCgYIKoZIzj0EAwIDSAAw
  RQIgJe0TVvYa1WJWiPC3pViAIeKdowxCzOTThsSeQI9AgBgCIQCPpWrQRW/c95u9
  Xq/uVC7M0BT8tfwfls8x7MllhpKDRg==
  -----END CERTIFICATE-----
  ''
  ];


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
