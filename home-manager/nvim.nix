{ inputs
, lib
, config
, pkgs
, ...
}: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile."nvim".source = pkgs.stdenv.mkDerivation {
    name = "NvChad";
    src = builtins.fetchGit {
      url = "https://github.com/NvChad/NvChad.git";
      rev = "164e8cc7fcb9006a1edd4ddfc98bf8c7f4fe2e0d";
    };
    installPhase = ''
      mkdir -p $out
      cp -r ./* $out/
      cd $out/
      cp -r ${./my_nvchad_config} $out/lua/custom
    '';
  };
}
