require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>fW", "<cmd> Telescope grep_string <cr>")
map("n", "<leader>gd", "<cmd> Lspsaga finder <cr>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
