{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nvchad-starter = {
      url = "path:home-manager/my_nvchad_config";
      flake = false;
    };
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nvchad-starter.follows = "nvchad-starter";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixos-wsl
    , home-manager
    , nix-darwin
    , neovim-nightly-overlay
    , nix4nvchad
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        nixie = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          # > Our main nixos configuration file <
          modules = [
            ./nixie/configuration.nix
            home-manager.nixosModules.home-manager
            {
              # home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.feynman = import ./home-manager/home.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
              home-manager.extraSpecialArgs = {
                inherit (inputs) nixpkgs nix4nvchad;
                username = "feynman";
              };
            }
          ];
        };
        sextant = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          system = "x86_64-linux";
          # > Our main nixos configuration file <
          modules = [
            ./sextant/configuration.nix
            nixos-wsl.nixosModules.wsl
            home-manager.nixosModules.home-manager
            {
              # home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nixos = import ./home-manager/home.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
              home-manager.extraSpecialArgs = {
                inherit (inputs) nixpkgs neovim-nightly-overlay;
                username = "nixos";
              };
            }
          ];
        };
      };
      darwinConfigurations = {
        admins-MacBook-Pro-3301 = let
          system = "x86_64-darwin";
          username = "admin";
        in nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit system username; };
          modules = [ 
            ./darwinnix/configuration.nix
            home-manager.darwinModules.home-manager {
              home-manager = {
                useUserPackages = true;
                users.${username} = import ./home-manager/home.nix;

                extraSpecialArgs = {
                  inherit (inputs) nixpkgs nix4nvchad;
                  inherit username;
                };
              };
            }
          ];
        };
        Lupings-Mac-mini-7841 = let
          system = "aarch64-darwin";
          username = "feynman";
        in nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit system username; };
          modules = [ 
            ./darwinnix/configuration.nix 
            home-manager.darwinModules.home-manager {
              home-manager = {
                useUserPackages = true;
                users.${username} = import ./home-manager/home.nix;

                extraSpecialArgs = {
                  inherit (inputs) nixpkgs nix4nvchad;
                  inherit username;
                };
              };
            }
          ];
        };
        J3WK3WGTW2 = let
          system = "aarch64-darwin";
          username = "feynman";
        in nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit system username; };
          modules = [ 
            ./darwinnix/configuration.nix 
            home-manager.darwinModules.home-manager {
              home-manager = {
		            backupFileExtension = "backup";
                useUserPackages = true;
                users.${username} = import ./home-manager/home.nix;

                extraSpecialArgs = {
                  inherit (inputs) nixpkgs nix4nvchad;
                  inherit username;
                };
              };
            }
          ];
        };
      };
    };
}
