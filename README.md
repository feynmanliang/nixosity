# nixosity

Install on WSL NixOS:

```sh 
nixos-rebuild --switch .#sextant
``````

Install `home-manager` standalone:

```sh 
nix run github:nix-community/home-manager -- --flake ./home-manager/ switch
```

## FAQ

private mount namespace not permitted

`sudo ln -s ~/.nix-portable/nix /nix`
