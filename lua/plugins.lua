local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
  use 'lewis6991/impatient.nvim'
  use 'wbthomason/packer.nvim'
  use {
    'williamboman/mason.nvim',
    config = function() require("mason").setup() end
  }
  use {
    'williamboman/mason-lspconfig.nvim',
    after = 'mason.nvim',
    config = function()
      require("mason-lspconfig").setup{
        automatic_installation = true
      }
    end
  }
  use {
    'jayp0521/mason-nvim-dap.nvim',
    after = { 'mason.nvim', 'nvim-dap' },
    config = function()
      require("mason-nvim-dap").setup{
        automatic_installation = true
      }
    end
  }
  use {
    'mrshmllow/document-color.nvim',
    config = function() require('document-color').setup{mode = "background"} end
  }
  use {
    'neovim/nvim-lspconfig',
    after = 'mason-lspconfig.nvim'
  }
  use {
    'mfussenegger/nvim-dap',
    config = function() require('debugging') end
  }
  use 'onsails/lspkind-nvim'
  use 'ibhagwan/smartyank.nvim'
  use 'cohama/lexima.vim'
  use 'tjdevries/complextras.nvim'
  local cmp_suffix = {
    "nvim-lsp", "path", "buffer", "cmdline",
    "nvim-lsp-signature-help", "nvim-lua"
  }
  local cmp_sources = {
    { name = 'luasnip', keyword_length = 1 },
    { name = 'spell', keyword_length = 5 }
  }
  use {
    'dmitmel/cmp-cmdline-history',
    after='nvim-cmp'
  }
  use {
    'jcha0713/cmp-tw2css',
    config = function() require('cmp-tw2css').setup() end
  }
  use {
    'saadparwaiz1/cmp_luasnip',
    requires={'L3MON4D3/LuaSnip','hrsh7th/nvim-cmp'},
    after={'LuaSnip','nvim-cmp'}
  }
  use {
    'rafamadriz/friendly-snippets',
    requires='L3MON4D3/LuaSnip',
    after='LuaSnip'
  }
  use {
    'dsznajder/vscode-react-javascript-snippets',
    requires='L3MON4D3/LuaSnip',
    after='LuaSnip'
  }
  use {
    'f3fora/cmp-spell',
    after='nvim-cmp'
  }
  for _, suffix in pairs(cmp_suffix) do
    use {
      'hrsh7th/cmp-' .. suffix,
      requires='hrsh7th/nvim-cmp',
      after='nvim-cmp'
    }
    table.insert(cmp_sources, {
      name = string.gsub(suffix, '-', '_'), keyword_length = 3
    })
  end
  use {
    'hrsh7th/nvim-cmp',
    requires = 'neovim/nvim-lspconfig',
    after = 'nvim-lspconfig',
    config = function() require('completion').setup(cmp_sources) end
  }

  use {
    'SmiteshP/nvim-navic',
    after = 'nvim-lspconfig'
  }
  use {
    'kevinhwang91/nvim-bqf',
    ft = 'qf'
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup{
        context_commentstring = { enable = true },
        indent = { enable = true },
        highlight = { enable = true },
        ensure_installed = {
          'bash', 'c', 'css', 'html', 'http', 'json',
          'typescript', 'tsx', 'javascript', 'lua',
          'php', 'python', 'regex'
        },
      }
    end,
  }
  use {
    'nvim-neotest/neotest',
    ft = { 'python', 'typescript', 'javasript' },
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'antoinemadec/FixCursorHold.nvim',
      'haydenmeade/neotest-jest',
      'nvim-neotest/neotest-python'
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-jest')({
            jestCommand = 'npm test --',
            jestConfigFile = 'jest.config.json',
            env = {
              CI = true,
              NODE_OPTIONS='--experimental-vm-modules'
            },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          }),
          require('neotest-python')
        }
      })
      vim.api.nvim_create_user_command('Test',
        function()
          return require("neotest").run.run({strategy = "dap"})
        end,
        { nargs = 0 }
      )
    end
  }
  use {
    'numToStr/Comment.nvim',
    config = function() require('Comment').setup{ ignore = '^$' } end
  }
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup{
        'css';
        'sass';
        'html';
        'javascript';
      }
    end
  }
  use {
    'folke/tokyonight.nvim',
    config = function()
      require('tokyonight').setup{
        transparent = true,
        dim_inactive = true,
        on_highlights = function(highlights, colors)
          highlights.MsgArea = { bg = colors.none }
        end,
      }
      vim.cmd.colorscheme{'tokyonight'}
    end,
  }
  use {
    'booperlv/nvim-gomove',
    disable = true,
    config = function()
      require("gomove").setup {
        map_defaults = true,
        reindent = true,
        move_past_end_col = true,
        ignore_indent_lh_dup = true,
      }
    end
  }
  use {
    'monaqa/dial.nvim',
    disable = true,
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group{
        -- default augends used when no group name is specified
        default = {
          augend.integer.alias.decimal,   -- nonnegative decimal number (0, 1, 2, 3, ...)
          augend.integer.alias.hex,       -- nonnegative hex number  (0x01, 0x1a1f, etc.)
          augend.date.alias["%Y/%m/%d"],  -- date (2022/02/19, etc.)
        },
        -- augends used when group with name `mygroup` is specified
        mygroup = {
          augend.integer.alias.decimal,
          augend.constant.alias.bool,    -- boolean value (true <-> false)
          augend.date.alias["%m/%d/%Y"], -- date (02/19/2022, etc.)
        }
      }
    end
  }
end)

