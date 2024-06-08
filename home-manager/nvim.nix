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

  xdg.configFile."nvim/init.lua" = {
    source = ./my_nvchad_config/init.lua;
  };

  xdg.configFile."nvim/lua" = {
    source = ./my_nvchad_config/lua;
  };
}
