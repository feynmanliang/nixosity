-- EXAMPLE 
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- Avoid hitting OS file-descriptor limits from LSP file watching.
capabilities.workspace = capabilities.workspace or {}
capabilities.workspace.didChangeWatchedFiles = capabilities.workspace.didChangeWatchedFiles or {}
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

local ok_watchfiles, watchfiles = pcall(require, "vim.lsp._watchfiles")
if ok_watchfiles then
  local orig_watchfunc = watchfiles._watchfunc

  watchfiles._watchfunc = function(path, opts, callback)
    local ok, cancel_or_err = pcall(orig_watchfunc, path, opts, callback)
    if ok then
      return cancel_or_err
    end

    if type(cancel_or_err) == "string" and cancel_or_err:find "EMFILE" then
      vim.schedule(function()
        vim.notify(
          string.format("LSP file watching disabled for %s (too many open files)", path),
          vim.log.levels.WARN
        )
      end)
      return function() end
    end

    error(cancel_or_err)
  end
end

local util = require "lspconfig.util"
local servers = { "html", "cssls", "terraformls", "pyright" }

local function with_base_config(config)
  return vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }, config or {})
end

local function configure(server, config)
  vim.lsp.config(server, with_base_config(config))
  return server
end

local enabled_servers = {}

for _, server in ipairs(servers) do
  table.insert(enabled_servers, configure(server))
end

table.insert(enabled_servers, configure("ts_ls", {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    vim.keymap.set("n", "<leader>ro", function()
      vim.lsp.buf.execute_command({
        command = "_typescript.organizeImports",
        arguments = { vim.fn.expand "%:p" },
      })
    end, { buffer = bufnr, remap = false })
  end,
  root_dir = function(bufnr, on_dir)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local deno_root = util.root_pattern("deno.json", "deno.jsonc")(filename)
    if deno_root then
      return
    end

    local node_root = util.root_pattern("package.json")(filename)
    if node_root then
      on_dir(node_root)
    end
  end,
  workspace_required = true,
}))

table.insert(enabled_servers, configure("nextls", {
  cmd = { "nextls", "--stdio" },
  init_options = {
    extensions = {
      credo = { enable = true },
    },
    experimental = {
      completions = { enable = true },
    },
  },
}))

table.insert(enabled_servers, configure("yamlls", require("yaml-companion").setup({
  builtin_matchers = {
    kubernetes = { enabled = true },
    kubernetes_crd = { enabled = true },
    cloud_init = { enabled = true },
  },
  schemas = {
    {
      name = "Kubernetes 1.22.4",
      uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.4-standalone-strict/all.json",
    },
  },
  lspconfig = {
    settings = {
      redhat = { telemetry = { enabled = false } },
    },
  },
})))

table.insert(enabled_servers, configure("denols", {
  root_dir = function(bufnr, on_dir)
    local root = util.root_pattern("deno.json", "deno.jsonc")(vim.api.nvim_buf_get_name(bufnr))
    if root then
      on_dir(root)
    end
  end,
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
}))

vim.lsp.enable(enabled_servers)
