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
    src = pkgs.fetchFromGitHub {
      owner = "NvChad";
      repo = "starter";
      rev = "aad624221adc6ed4e14337b3b3f2b74136696b53";
      hash = "sha256-2HNqPdnIVkX+d5OxjsRbL3SoY8l5Ey7/Y274Pi5uZW4=";
    };
    installPhase = ''
      mkdir -p $out
      cp -r ./* $out/
      cd $out/
      cp -r ${./my_nvchad_config} $out/lua/custom
    '';
  };
}
