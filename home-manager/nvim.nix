{ pkgs , ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    package = pkgs.nvchad;
  };

  xdg.configFile."nvim/init.lua" = {
    source = ./my_nvchad_config/init.lua;
  };

  xdg.configFile."nvim/lua" = {
    source = ./my_nvchad_config/lua;
  };
}
