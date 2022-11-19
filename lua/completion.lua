local cmp     = require('cmp')
local luasnip = require('luasnip')
local kind    = require('lspkind')
local lsp     = require('lspconfig')
local navic   = require('nvim-navic')
local deno    = require('deno-nvim')

luasnip.config.setup({enable_autosnippets = true})
require('luasnip.loaders.from_lua').lazy_load({paths = vim.fn.stdpath('config') .. "/snippets"})
require('luasnip.loaders.from_vscode').lazy_load()

local cap = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
if cap.textDocument.completion.completionItem then
  cap.textDocument.completion.completionItem.snippetSupport = true
end
if cap.textDocument.completionItem then
  cap.textDocument.completionItem.snippetSupport = true
end
if cap.textDocument.colorProvider then
  cap.textDocument.colorProvider = true
end
local on_a = function(client, bufnr)
  if client.server_capabilities.colorProvider then
    require("document-color").buf_attach(bufnr)
  end
  navic.attach(client, bufnr)
end

-- deno-nvim will setup lsp-config for denols
-- otherwise don't forget to add the root_dir option to prevent using it for typescript files in a node project
-- root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc")
-- lsp.denols.setup{ capabilities = cap, on_attach = on_a, init_options = { lint = true } }
deno.setup({
  server = {
    on_attach = on_a,
    capabilites = cap,
    init_options = { lint = true },
    settings = {
      deno = {
        inlayHints = {
          parameterNames = { enabled = "all" },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
        }
      }
    }
  }
})

lsp.cssls.setup{ capabilities = cap, on_attach = on_a }
lsp.html.setup{ capabilities = cap, on_attach = on_a }
lsp.tailwindcss.setup{ capabilities = cap, on_attach = on_a }
lsp.tsserver.setup{ capabilities = cap, on_attach = on_a, root_dir = lsp.util.root_pattern("package.json") }
lsp.gdscript.setup{ capabilities = cap, on_attach = on_a }
lsp.clangd.setup{ capabilities = cap, on_attach = on_a }

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function setup(mysources)
   cmp.setup.cmdline({ '/', '?' }, {
    sources = {
      {
        name = 'buffer',
        max_item_count = 5,
        keyword_length = 3,
      },
      {
        name = 'cmdline_history',
        max_item_count = 5,
        keyword_length = 3,
      },
    }
  })

  cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
      {
        name = 'cmdline_history',
        max_item_count = 5,
        keyword_length = 3
      },
      {
        name = "cmdline",
        max_item_count = 3,
        keyword_length = 3,
        keyword_pattern = [[^\@<!Man\s]]
      },
      {
        name = "path",
        max_item_count = 2,
        keyword_length = 6
      },
    }),
  })

  cmp.setup.cmdline("@", {
    sources = cmp.config.sources({
      { name = "path" },
      { name = "cmdline", keyword_pattern = [[^\@<!Man\s]] },
    }),
  })

  cmp.setup {
    mapping = cmp.mapping.preset.insert({
      ["<C-k>"] = cmp.mapping.scroll_docs(-4),
      ["<C-j>"] = cmp.mapping.scroll_docs(4),
      ["<C-e>"] = cmp.mapping.close(),
      ["<c-y>"] = cmp.mapping(
      cmp.mapping.disable, { 'i', 'c', 's' }
      ),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-l>"] = cmp.mapping(function(fallback)
        -- NOTE: experimental
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-h>"] = cmp.mapping(function(fallback)
        if luasnip.choice_active() then
          luasnip.change_choice(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<CR>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm({ select = true })
        else
          -- TODO: find and replicate my old MyCR() vimscript function
          fallback()
        end
      end, { "i", "s" }),
    }),

    -- the order of your sources matter
    -- you can configure:
    --   keyword_length
    --   priority
    --   max_item_count
    --   (more?)
    sources = sources,
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },

    formatting = {
      format = kind.cmp_format {
        with_text = true,
        menu = {
          luasnip = "[snip]",
          nvim_lsp = "[LSP]",
          path = "[path]",
          buffer = "[buf]",
          -- emmet_ls = "[emmet]",
          nvim_lua = "[api]",
        },
      },
    },

  }

cmp.setup.filetype({ 'html' , 'css', 'scss' }, {
  sources = {
    { name = 'luasnip',     keyword_length = 2 },
    { name = 'cmp-tw2css',  keyword_length = 2 },
    { name = 'nvim_lsp',    keyword_length = 3 }
  }
})
end

return { setup = setup }
