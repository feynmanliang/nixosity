{ neovim-nightly-overlay, pkgs , ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    package = neovim-nightly-overlay.packages.${pkgs.system}.default;
  };

  xdg.configFile."nvim/init.lua" = {
    source = ./my_nvchad_config/init.lua;
  };

  xdg.configFile."nvim/lua" = {
    source = ./my_nvchad_config/lua;
  };
}
