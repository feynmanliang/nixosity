require "nvchad.options"

-- add yours here!

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

-- Treesitter based folds
-- https://www.reddit.com/r/neovim/comments/16xz3q9/treesitter_highlighted_folds_are_now_in_neovim/
o.foldcolumn = "auto"
o.foldlevelstart = 1
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- o.foldtext = require("modules.foldtext")
