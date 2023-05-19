local o,g,w,b,fn = vim.opt,vim.g,vim.wo,vim.bo,vim.fn

local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd.packadd('packer.nvim')
  if pcall(require, 'plugins') then
    vim.cmd.sleep('100m')
    require('packer').sync()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'PackerComplete',
      once = true,
      callback = function()
        vim.sleep('100m')
        vim.cmd.quitall()
      end
    })
  end
elseif pcall(require, 'impatient') then
  require('impatient')
end

require('plugins')
-- require('completion')

vim.cmd.filetype('plugin', 'indent', 'on')
vim.cmd.syntax('on')
g.loaded_spellfile_plugin = 1
-- for sniprun
g.markdown_fenced_languages = { "javascript", "typescript", "bash", "lua", "python" }

o.autoindent    = true  -- Maintain indent
o.breakindent   = true  -- Maintain visually wrapped indent
o.cursorline    = true  -- Highlight current line
o.expandtab     = true  -- Insert spaces when pressing tab
o.incsearch     = true  -- Show matches
o.modeline      = true  -- Use the modeline
o.showcmd       = true  -- Show me what I'm typing
o.showmatch     = true  -- Do not show matching brackets by flickering
o.splitright    = true  -- Put a new window on the right
o.splitbelow    = true  -- Put a new window below an existing one
o.termguicolors = true  -- True color support
o.undofile      = true  -- Maintain undo history between sessions
o.wildmenu      = true  -- Command-line completion
o.wrapscan      = true  -- Wrap search
o.backup        = false -- Don't make backups before writing
o.writebackup   = false -- Don't keep backups after writing

w.wrap           = false -- Don't wrap lines
w.number         = true  -- Print the line number in front of each line
w.relativenumber = true  -- Show the relative line number
w.list           = true  -- Use list mode to show listchars

o.belloff        = 'all'  -- Turn off bell
o.backupcopy     = 'yes'  -- Overwrite files to update
o.clipboard      = 'unnamedplus'
o.diffopt        = { 'iblank', 'iwhiteeol', 'internal', 'filler', 'closeoff' }
o.completeopt    = { 'menu', 'menuone', 'noselect' }
o.breakindentopt = { min = '20', shift = '0', 'sbr' }
o.wildmode       = { 'longest:full', 'full' }
o.wildoptions    = { 'pum','tagfile' }
o.sessionoptions = { 'blank', 'buffers', 'curdir', 'folds', 'help', 'tabpages', 'winsize', 'winpos', 'terminal', 'localoptions' }
o.shortmess      = 'caOstTIF'
o.inccommand     = 'nosplit'
-- o.guifont        = 'UbuntuMono NF:h15'
o.shada          = "'100,<50,s100,h,r/tmp,r/mnt,r~/Private"
o.cedit          = '<c-f>'
o.commentstring  = '# %s'  -- Default commentstring
o.virtualedit    = 'all'   -- Allow cursor where there's no actual character
o.winbar         = '%=%m %f'

-- Use a non-breaking space to suppress the tilde at the end of the buffer
-- o.fillchars      = 'vert:│,fold:▀,eob: '
-- o.listchars      = 'tab:▸ ,trail:-,extends:»,precedes:«,nbsp: '
o.fillchars      = {vert = '│', fold = '▀', eob = ' '}
o.listchars      = {tab = '▸ ', trail = '-', extends = '»', precedes = '«', nbsp = ' '}

o.foldlevel     = 2
o.foldminlines  = 30
o.undolevels    = 1000
o.history       = 5000
o.cmdheight     = 3
o.tabpagemax    = 20
o.laststatus    = 3     -- only show a statusline on the last window
o.previewheight = 14
o.pumheight     = 14
o.tabstop       = 2
b.tabstop       = 2
o.scrolloff     = 4
o.shiftwidth    = 2
b.shiftwidth    = 2
o.softtabstop   = 2
b.softtabstop   = 2
o.sidescroll    = 6
o.sidescrolloff = 6

g.mapleader = ','
g.maplocalleader = '\\'

g.man_hardwrap=0
g.ft_man_folding_enable=1

g.edge_style = 'aura'
g.edge_enable_italic = 1
g.edge_disable_italic_comment = 1
g.edge_transparent_background = 1

-- set foldmethod=expr
-- set foldexpr=nvim_treesitter#foldexpr()

local ignores = {
  '*.o',
  '*.obj,*~',
  '*.git*',
  '*.meteor*',
  '*vim/backups*',
  '*sass-cache*',
  '*mypy_cache*',
  '*__pycache__*',
  '*cache*',
  '*logs*',
  '*node_modules*',
  '**/node_modules/**',
  '*DS_Store*',
  '*.gem',
  'log/**',
  'tmp/**',
}
-- o.wildignore = table.concat(ignores, ',')
o.wildignore = ignores
local skip = {
  '/tmp/*', '*.gpg',
  '/mnt/*', '/etc/*', '/proc/*',
  '{COMMIT_EDIT,TAG_EDIT,MERGE_,}MSG'
}
-- o.backupskip = table.concat(skip, ',')
o.backupskip = skip
local suffixes = {
  '.bak', '~', '.o', '.h',
  '.info', '.swp', '.obj',
  '.pdf', '.xml', '.csv',
  '.pdf', '.xml', '.csv',
  '.git', '.tar', '.tgz',
  '.xz', '.zst', '.deb',
  '.cpio', '.dll', '.md5',
  '.log', '.7z', '.so',
  '.pkg', '.jpg', '.jpeg',
  '.mp3', '.wav', '.gif',
  '.webm', '.pyc', '.pyg'
}
-- o.suffixes = table.concat(suffixes, ',')
o.suffixes = suffixes

-- for s:dir in ["view","swap","back","undo"]
--   if !isdirectory(expand(g:xch."/".s:dir))
--     call mkdir(expand(g:xch."/".s:dir), 'p', 0740)
--   endif
-- endfor
-- let &viewdir   = expand(g:xch."/view")
-- let &directory = expand(g:xch."/swap")."//,/tmp//"
-- let &backupdir = expand(g:xch."/back")."//,/tmp//"
-- let &undodir   = expand(g:xch."/undo")."//,/tmp//"

-- could also use os.getenv('XDG_CONFIG_HOME')..'/nvim/' ?
local xch = fn.stdpath('config')
local xdh = fn.stdpath('data')

for _, d in ipairs({"/view","/swap","/back","/undo","/sess"}) do
  if fn.isdirectory(xdh..d) == 0 then
    fn.mkdir(xdh..d, 'p', 755)
  end
end

o.viewdir   = xdh..'/view//' -- Store files for :mkview
o.backupdir = xdh..'/back//' -- Use backup files
o.directory = xdh..'/swap//' -- Use Swap files
o.undodir   = xdh..'/undo//' -- Set the undo directory

g.tex_flavor = 'latex'

local keymap = vim.keymap
keymap.set('n', '<s-esc>', '<cmd>qa<cr>',
  {
    desc = 'Exit with Shift+Escape unless there are some buffers which have been changed.'
  }
)
-- keymap.set('n', '<left>',  '<cmd>tabp<cr>')
keymap.set('n', '<left>',
  function()
    if vim.fn.winnr() == vim.fn.winnr("h") then
        return "<cmd>tabprev<cr>"
    else
        return "<C-w>h"
    end
  end,
  {
    remap = false, expr = true, silent = true,
    desc = 'Move the cursor to the previous tab or split.'
  }
)
keymap.set('n', '<down>',
  function()
    if vim.fn.winnr() == vim.fn.winnr("j") then
        return "<cmd>tabprev<cr>"
    else
        return "<C-w>j"
    end
  end,
  {
    remap = false, expr = true, silent = true,
    desc = 'Move the cursor to the previous tab or lower split.'
  }
)
-- keymap.set('n', '<right>', '<cmd>tabn<cr>')
keymap.set('n', '<right>',
  function()
    if vim.fn.winnr() == vim.fn.winnr("l") then
        return "<cmd>tabnext<cr>"
    else
        return "<C-w>l"
    end
  end,
  {
    remap = false, expr = true, silent = true,
    desc = 'Move the cursor to the next tab or split.'
  }
)
keymap.set('n', '<up>',
  function()
    if vim.fn.winnr() == vim.fn.winnr("k") then
        return "<cmd>tabnext<cr>"
    else
        return "<C-w>k"
    end
  end,
  {
    remap = false, expr = true, silent = true,
    desc = 'Move the cursor to the next tab or upper split.'
  }
)

keymap.set('n', '<s-down>', '<cmd>sp +te | sleep 1 | resize 8 | startinsert<CR>', { desc = 'Open a terminal window in a split below' })

-- TODO: make this a function and check that the spell setting is true
keymap.set('n', '<leader>1', '1z=', { desc = 'Pick the first spelling suggestion.'})

-- in memory of Gilles Castel
keymap.set('i', '<c-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u', { desc = 'Pick the first spelling suggestion for mistakes before the cursor (with undo).'})

-- TODO: remove highlights when the cursor is no longer on a match
keymap.set('n', '<c-l>', '<cmd>nohlsearch<cr>', { desc = 'Remove search highlights.'})

keymap.set('n', 'gf', '<C-w>gf', { desc = 'Open a new tab page and edit the file name under the cursor.'})
keymap.set('n', 'gF', '<C-w>gF', { desc = 'Open a new tab page and edit the file name under the cursor and jump to the line number following the file name.'})

keymap.set('n', 'Q', '<nop>', { desc = 'I rather like Q to be a bit less accessible with gQ.' })

keymap.set('t', '<esc>', '<c-\\><c-n>', { desc = 'Escape "insert" mode in the terminal.'})

keymap.set('n', '<space>', 'zxzjzo', { desc = 'Update folds and open the next one.'})
keymap.set('n', '<leader><space>', 'zxzkzo[z', { desc = 'Update folds and open the previous one.'})
keymap.set('v', '<', '<gv', { desc = 'Reselect the visual block after indent' })
keymap.set('v', '>', '>gv', { desc = 'Reselect the visual block after outdent' })

keymap.set('c', '<Left>', '<Space><BS><Left>', { desc = 'Move the cursor left instead of selecting a match.' })
keymap.set('c', '<Right>', '<Space><BS><Right>', { desc = 'Move the cursor right instead of selecting a match.' })

-- FIX: Error detected while processing TextYankPost
keymap.set('v', 'y', 'ygv<esc>', { desc = 'Move the cursor back to where it was in visual mode before yanking'})

keymap.set('x', 'p',
  function()
    return 'pgv"' .. vim.v.register .. 'y'
  end,
  { remap = false, expr = true }
)

keymap.set('n', 'dd',
  function()
    if vim.api.nvim_get_current_line():match("^%s*$") then
      return "\"_dd"
    else
      return "dd"
    end
  end,
  {
    remap = false, expr = true,
    desc = 'Delete blank lines or lines with only whitespace without affecting the normal registers.'
  }
)

keymap.set({'n', 'v'}, '0',
  function()
    local current_col = fn.virtcol('.')
    vim.cmd.normal('_')
    local first_char = fn.virtcol('.')
    if (current_col == first_char) then
      fn.cursor('.',1)
    end
  end,
  { desc = 'Toggle jumping to the first character and column on the line.' }
)

-- TODO: review logic
keymap.set({'n', 'v'}, '-',
  function()
    local current_col = fn.virtcol('.')
    if w.wrap then
      -- vim.cmd.normal('<End>')
      vim.cmd('normal <End>')
    elseif (o.virtualedit == nil) then
      -- cmd.normal('g$')
      vim.cmd('normal g$')
    else
      -- cmd.normal('$')
      vim.cmd('normal $')
    end
    local last_char = fn.virtcol('.')
    if (current_col == last_char) then
      if (b.textwidth ~= nil) then
      -- if (w.textwidth ~= nil and o.virtualedit ~= nil) then
        -- cmd.execute(args = {"normal", b.textwidth..'|'})
        vim.cmd('execute "normal "'..b.textwidth..'|')
      end
    end
  end,
  { desc = 'Toggle jumping to the last character and column on the line.' }
)

keymap.set('i', '<C-;>',
  function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { fn.strftime('%F') })
  end,
  { desc = 'Insert the current date (MS Excel-like shortcut)' }
)

keymap.set('i', '<C-S-;>',
  function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { fn.strftime('%R') })
  end,
  { desc = 'Insert the current time (MS Excel-like shortcut)' }
)

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    keymap.set('n', 'K', vim.lsp.buf.hover, { noremap=true, silent=true, buffer = args.buf })
    keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { noremap=true, silent=true, buffer = args.buf })
    keymap.set('n', 'gi', vim.lsp.buf.implementation, { noremap=true, silent=true, buffer = args.buf })
    keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap=true, silent=true, buffer = args.buf })
    keymap.set('n', '<space>D', vim.lsp.buf.type_definition, { noremap=true, silent=true, buffer = args.buf })
    keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, { noremap=true, silent=true, buffer = args.buf })
    keymap.set('n', '<space>ca', vim.lsp.buf.code_action, { noremap=true, silent=true, buffer = args.buf })
    keymap.set('n', '<space>rn', vim.lsp.buf.rename, { noremap=true, silent=true, buffer = args.buf })
    if not (args.data and args.data.client_id) then
      return
    end
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    require('lsp-inlayhints').on_attach(client, args.buf)
  end,
})

vim.api.nvim_create_augroup('onWrite', {clear = true})
vim.api.nvim_create_autocmd('BufWritePre', {
  group = 'onWrite',
  pattern = '*.tsx,*.ts,*.jsx,*.js',
  callback = function ()
    vim.lsp.buf.format()
  end,
})
vim.api.nvim_create_autocmd('BufWritePost', {
  group = 'onWrite',
  pattern = 'plugins.lua',
  callback = function ()
    require('packer').compile()
  end,
})

vim.api.nvim_create_augroup('help', {clear=true})
vim.api.nvim_create_autocmd('FileType', {
  group    = 'help',
  pattern  = { 'man',  'help' },
  callback = function()
    keymap.set('n', 'q', '<Cmd>bwipeout<cr>', { silent=true, buffer=true, desc='close window and delete buffer' })
  end
})
vim.api.nvim_create_autocmd('BufWinEnter', {
  group    = 'help',
  pattern  = { 'man://*,',  '*/nvim/runtime/doc/*' },
  -- once     = true,
  callback = function()
    vim.api.nvim_exec('wincmd L', nil)
    vim.api.nvim_exec('silent vertical resize 80', nil)
  end
})
vim.api.nvim_create_autocmd('FileType', {
  group    = 'help',
  pattern  = 'help',
  callback = function()
    keymap.set('n', '<enter>'    , '<c-]>', { silent=true, buffer=true, desc='jump to specific subjects by using tags' })
    keymap.set('n', '<backspace>', '<c-o>', { silent=true, buffer=true, desc='jump back to the previous subject' })
    keymap.set('n', '<tab>',   "/\\([\\|*']\\)\\zs\\S*\\ze\\1<cr>", { silent=true, buffer=true, desc='select next tag' })
    keymap.set('n', '<s-tab>', "?\\([\\|*']\\)\\zs\\S*\\ze\\1<cr>", { silent=true, buffer=true, desc='select prev tag' })
  end
})

vim.api.nvim_create_augroup('sniprun', {clear=true})
vim.api.nvim_create_autocmd('FileType', {
  group    = 'sniprun',
  pattern  = 'markdown',
  callback = function()
    keymap.set('v', 'f', '<Plug>SnipRun', {silent = true})
    keymap.set('n', '<leader>f', '<Plug>SnipRunOperator', {silent = true})
    keymap.set('n', '<leader>ff', '<Plug>SnipRun', {silent = true})
  end
})
