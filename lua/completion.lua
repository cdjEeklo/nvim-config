local cmp     = require('cmp')
local luasnip = require('luasnip')
local kind    = require('lspkind')
local lsp     = require('lspconfig')
local lspcfg  = require 'lspconfig.configs'
local navic   = require('nvim-navic')
local deno    = require('deno-nvim')

for _, ft in pairs({'javascript','typescript','javascriptreact','typescriptreact'}) do
  luasnip.filetype_extend(ft, { 'html', 'css' })
end
luasnip.config.setup({
  update_events = 'TextChanged,TextChangedI',
  enable_autosnippets = true
})
require('luasnip.loaders.from_lua').lazy_load({paths = vim.fn.stdpath('config') .. '/lua/snippets.lua'})
-- require('luasnip.loaders.from_vscode').lazy_load()

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
  local active_clients = vim.lsp.get_active_clients()
  if client.name == 'denols' then
    for _, client_ in pairs(active_clients) do
      -- stop tsserver if denols is already active
      if client_.name == 'tsserver' then client_.stop() end
    end
  elseif client.name == 'tsserver' then
    for _, client_ in pairs(active_clients) do
      -- prevent tsserver from starting if denols is already active
      if client_.name == 'denols' then client.stop() end
    end
  end
  if client.server_capabilities.colorProvider then
    require('document-color').buf_attach(bufnr)
  end
  if not client.name == 'emmet_language_server' then
    require('folding').on_attach()
  end
  if client.server_capabilities.documentSymbolProvider and not navic.is_available(bufnr) then
    navic.attach(client, bufnr)
  end
end

-- deno-nvim will setup lsp-config for denols
-- otherwise don't forget to add the root_dir option to prevent using it for typescript files in a node project
-- root_dir = lsp.util.root_pattern('deno.json', 'deno.jsonc')
-- lsp.denols.setup{ capabilities = cap, on_attach = on_a, init_options = { lint = true } }
deno.setup({
  dap = {
    adapter = {
      executable = {
        args = {vim.fn.stdpath('data')..'mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}'},
      }
    }
  },
  server = {
    on_attach = on_a,
    capabilites = cap,
    root_dir = lsp.util.root_pattern('deno.json', 'deno.jsonc'),
    init_options = { lint = true },
    settings = {
      deno = {
        inlayHints = {
          parameterNames = { enabled = 'all' },
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

if not lspcfg.emmet_language_server then
  lspcfg.emmet_language_server = {
    default_config = {
      cmd = { "emmet-language-server", "--stdio" },
      root_dir = lsp.util.root_pattern('.git'),
      settings = {}
    }
  }
end
        -- --- @type table<string, any> https://docs.emmet.io/customization/preferences/
        -- preferences = {},
        -- --- @type "always" | "never" Defaults to `"always"`
        -- showExpandedAbbreviation = "always",
        -- --- @type boolean Defaults to `true`
        -- showAbbreviationSuggestions = true,
        -- --- @type boolean Defaults to `false`
        -- showSuggestionsAsSnippets = false,
        -- --- @type table<string, any> https://docs.emmet.io/customization/syntax-profiles/
        -- syntaxProfiles = {},
        -- --- @type table<string, string> https://docs.emmet.io/customization/snippets/#variables
        -- variables = {},
        -- --- @type string[]
        -- excludeLanguages = {}, }

lsp.tailwindcss.setup{
  capabilities = cap,
  on_attach = on_a,
  root_dir = lsp.util.root_pattern('deno.json', 'deno.jsonc', 'package.json'),
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          { "cva\\(([^)]*)\\)",
           "[\"'`]([^\"'`]*).*?[\"'`]" },
        },
      },
    },
  },
}

lsp.cssls.setup{ capabilities = cap, on_attach = on_a }
lsp.html.setup{ capabilities = cap, on_attach = on_a }
lsp.custom_elements_ls.setup{ capabilities = cap, on_attach = on_a }
lsp.emmet_language_server.setup{ capabilities = cap, on_attach = on_a, filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' } }
lsp.tsserver.setup{ capabilities = cap, on_attach = on_a, single_file_support = true, root_dir = lsp.util.find_node_modules_ancestor }
lsp.prismals.setup{ capabilities = cap, on_attach = on_a, single_file_support = true, root_dir = lsp.util.find_node_modules_ancestor }
lsp.gdscript.setup{ capabilities = cap, on_attach = on_a }
lsp.clangd.setup{ capabilities = cap, on_attach = on_a }
lsp.yamlls.setup {
  settings = {
    yaml = {
      schemaStore = { enable = false },
      schemas = require('schemastore').yaml.schemas{
        select = {
          'GitHub Action',
          'GitVersion',
          'gitlab-ci',
          '.build.yml',
          'dependabot.json',
          'Jekyll',
          '.mocharc',
          '.pre-commit-config.yml',
          '.pre-commit-hooks.yml',
          'prisma.yml',
          'Read the Docs',
          'JSON Resume',
          '.travis.yml',
          'tslint.json',
          'docker-compose.yml',
          'Mason Registry',
          '.clang-format',
        },
      },
    },
  },
}
lsp.jsonls.setup {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas {
        select = {
          '.postcssrc',
          '.csslintrc',
          '.eslintrc',
          'package.json',
          'JSONPatch',
          'JSON Resume',
          'tsconfig.json',
          'Deno',
        },
      },
      validate = { enable = true },
    },
  },
}

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
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

  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      {
        name = 'cmdline_history',
        max_item_count = 5,
        keyword_length = 3
      },
      {
        name = 'cmdline',
        max_item_count = 3,
        keyword_length = 3,
        keyword_pattern = [[^\@<!Man\s]]
      },
      {
        name = 'path',
        max_item_count = 2,
        keyword_length = 6
      },
    }),
  })

  cmp.setup.cmdline('@', {
    sources = cmp.config.sources({
      { name = 'path' },
      { name = 'cmdline', keyword_pattern = [[^\@<!Man\s]] },
    }),
  })

  cmp.setup {
    mapping = cmp.mapping.preset.insert({
      ['<C-k>'] = cmp.mapping.scroll_docs(-4),
      ['<C-j>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.close(),
      ['<c-y>'] = cmp.mapping(
      cmp.mapping.disable, { 'i', 'c', 's' }
      ),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<C-l>'] = cmp.mapping(function(fallback)
        -- NOTE: experimental
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<C-h>'] = cmp.mapping(function(fallback)
        if luasnip.choice_active() then
          luasnip.change_choice(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<CR>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm({ select = true })
        else
          -- TODO: find and replicate my old MyCR() vimscript function
          fallback()
        end
      end, { 'i', 's' }),
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
          luasnip = '[snip]',
          nvim_lsp = '[LSP]',
          path = '[path]',
          buffer = '[buf]',
          -- emmet_ls = '[emmet]',
          nvim_lua = '[api]',
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
