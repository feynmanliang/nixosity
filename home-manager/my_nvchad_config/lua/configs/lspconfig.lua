-- EXAMPLE 
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls", "terraformls" }

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- typescript
lspconfig.tsserver.setup {
  on_init = on_init,
  capabilities = capabilities,
  -- on_attach = on_attach,
  on_attach = function (client, bufnr)
    on_attach(client, bufnr);
    vim.keymap.set('n', '<leader>ro', function()
      vim.lsp.buf.execute_command({
        command = "_typescript.organizeImports",
        arguments = { vim.fn.expand("%:p") }
      })
    end, { buffer = bufnr,  remap = false });
  end,
  root_dir = function (filename, bufnr)
    local denoRootDir = lspconfig.util.root_pattern("deno.json", "deno.json")(filename);
    if denoRootDir then
      -- print('this seems to be a deno project; returning nil so that tsserver does not attach');
      return nil;
      -- else
      -- print('this seems to be a ts project; return root dir based on package.json')
    end

    return lspconfig.util.root_pattern("package.json")(filename);
  end,
  single_file_support = false,
}

-- elixir
lspconfig.nextls.setup {
  cmd = { "nextls", "--stdio" },
  init_options = {
    extensions = {
      credo = { enable = true }
    },
    experimental = {
      completions = { enable = true }
    }
  },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

-- yamlls
lspconfig.yamlls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    yaml = {
      schemas = {
        kubernetes = "/*.yaml"
      }
    }
  }
}

-- denols
lspconfig.denols.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
  init_options = {
    lint = true,
    unstable = true,
    suggest = {
      imports = {
        hosts = {
          ["https://deno.land"] = true,
          ["https://cdn.nest.land"] = true,
          ["https://crux.land"] = true,
        },
      },
    },
  },
}
