# nixosity

## WSL

Install on WSL NixOS:

```sh 
nixos-rebuild --switch .#sextant
``````

## NixOS

Install `home-manager` standalone:

```sh 
nix run github:nix-community/home-manager -- --flake ./home-manager/ switch
```

# nix-darwin

Install on OSX:

```sh
sudo nix run nix-darwin/master#darwin-rebuild -- --flake .#Feynmans-MacBook-Air-10 switch
```

Subsequent switches:

```sh
sudo darwin-rebuild --flake .#Feynmans-MacBook-Air-10 switch
```

## FAQ

private mount namespace not permitted

`sudo ln -s ~/.nix-portable/nix /nix`
