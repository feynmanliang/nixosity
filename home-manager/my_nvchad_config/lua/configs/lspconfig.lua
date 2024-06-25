-- EXAMPLE 
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls", "terraformls", "pyright" }

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

-- yamlls with schemastore
-- lspconfig.yamlls.setup {
--   on_attach = on_attach,
--   on_init = on_init,
--   capabilities = capabilities,
--   settings = {
--     yaml = {
--       schemaStore = {
--         -- You must disable built-in schemaStore support if you want to use
--         -- this plugin and its advanced options like `ignore`.
--         enable = false,
--         -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
--         url = "",
--       },
--       schemas = require('schemastore').yaml.schemas(),
--       -- schemas = vim.tbl_deep_extend(
--       --   'error',
--       --   require('schemastore').yaml.schemas(),
--       --   {
--       --     kubernetes = "*.yaml",
--       --   }
--       -- )
--     },
--   },
-- }
lspconfig.yamlls.setup(require("yaml-companion").setup({
  -- Built in file matchers
  builtin_matchers = {
    -- Detects Kubernetes files based on content
    kubernetes = { enabled = true },
    kubernetes_crd = { enabled = true },
    cloud_init = { enabled = true },
  },

  -- Additional schemas available in Telescope picker
  schemas = {
    {
      name = "Kubernetes 1.22.4",
      uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.4-standalone-strict/all.json",
    },
  },

  -- Pass any additional options that will be merged in the final LSP config
  lspconfig = {
    settings = {
      redhat = { telemetry = { enabled = false } },
    },
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  },
}))

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

