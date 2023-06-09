local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local ok, lazy = pcall(require, 'lazy')
if not ok then
  print('Could not require lazy!')
  print('Exiting from plugins/init.lua')
  return
end

lazy.setup({
  -- Without lazy loading
  -----------------------
  -- Lualine, barbar and catppuccin
  -- are also not being lazy loaded.
  'elixir-editors/vim-elixir',
  { 'kylechui/nvim-surround', config = function() require('plugins.nvim-surround') end, },
  { 'chrisgrieser/nvim-various-textobjs', config = function() require('plugins.nvim-various-textobjs') end, },

  -- Colors and visuals
  ---------------------
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      require('plugins.catppuccin')
      require('plugins.gitsigns').setColors()
      require('plugins.lualine').setColors()
      require('plugins.barbar').setColors()
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function() require('plugins.gitsigns').setup() end,
    event = 'BufRead',
  },
  { 'hoob3rt/lualine.nvim', config = function() require('plugins.lualine').setup() end, },
  {
    'romgrk/barbar.nvim',
    init = function() vim.cmd([[let bufferline = get(g:, 'bufferline', {'icons': v:false,'no_name_title': '[No Name]'})]]) end,
    config = function() require('plugins.barbar').setup() end,
  },
  {
    'NvChad/nvim-colorizer.lua',
    cmd = { 'ColorizerToggle', 'ColorizerAttachToBuffer', 'ColorizerDetachFromBuffer', 'ColorizerReloadAllBuffers', },
    config = function() require('plugins.colorizer') end,
  },

  -- Useful or somewhat useful commands
  -------------------------------------
  {
    'numToStr/Comment.nvim',
    keys = {
      { mode = 'n', 'gc', },
      { mode = 'n', 'gb', },
      { mode = 'v', 'gc', },
      { mode = 'v', 'gb', },
    },
    config = function() require('plugins.Comment') end,
  },
  {
    'kyazdani42/nvim-tree.lua',
    keys = require('plugins.nvim-tree').keys(),
    config = function() require('plugins.nvim-tree').setup() end,
  },
  {
    'monaqa/dial.nvim',
    keys = {
      { mode = 'n', '<C-a>' },
      { mode = 'n', '<C-x>' },
      { mode = 'v', '<C-a>' },
      { mode = 'v', '<C-x>' },
      { mode = 'v', 'g<C-a>' },
      { mode = 'v', 'g<C-x>' },
    },
    config = function() require('plugins.dial') end,
  },
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    init = function() require('plugins.undotree') end
  },

  -- Clojure things
  -----------------
  -- { 'Olical/conjure', ft = { 'clojure' }, },
  -- { 'guns/vim-sexp', ft = { 'clojure' }, },

  -- Telescope
  ------------
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    keys = require('plugins.telescope').keys(),
    config = function() require('plugins.telescope').setup() end,
    dependencies = {
      { 'nvim-lua/plenary.nvim', },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        config = function() require('telescope').load_extension('fzf') end,
      },
      {
        'debugloop/telescope-undo.nvim',
        config = function() require('telescope').load_extension('undo') end,
      },
      {
        'molecule-man/telescope-menufacture',
        config = function() require('telescope').load_extension('menufacture') end,
      },
    },
  },

  -- Tmux related plugins
  -----------------------
  {
    'aserowy/tmux.nvim',
    keys = { '<C-h>', '<C-j>', '<C-k>', '<C-l>', },
    config = function() require('plugins.tmux') end,
  },
  {
    'christoomey/vim-tmux-runner',
    enabled = function() return os.getenv('TMUX') ~= nil end,
    cmd = { 'VtrAttachToPane', 'VtrSendCommand', 'VtrSendCtrlD', 'VtrSendCtrlC', }
  },

  -- LSP
  ------
  {
    'williamboman/mason.nvim',
    event = 'BufRead',
    cmd = 'Mason',
    config = function() require('plugins.lsp') end,
    dependencies = {
      { 'folke/neodev.nvim', },
      { 'j-hui/fidget.nvim', },
      { 'williamboman/mason-lspconfig.nvim', },
      { 'jose-elias-alvarez/typescript.nvim', },
      { 'neovim/nvim-lspconfig', },
    },
  },

  -- Testar esse aqui também, aproveitar que eu já uso o lualine.
  -- Alternativa para o fidget.
  -- 'arkav/lualine-lsp-progress',
  -- 'jose-elias-alvarez/null-ls.nvim',
  -- https://github.com/jay-babu/mason-nvim-dap.nvim
  -- https://github.com/jay-babu/mason-null-ls.nvim

  -- TreeSitter
  -------------

  -- Completion and things that write in general
  ----------------------------------------------
  { 'tpope/vim-ragtag', keys = '<C-x>', },
  { 'mattn/emmet-vim', keys = '<C-y>', },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    config = function() require('plugins.cmp') end,
    dependencies = {
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lua',
    },
  },
  { 'L3MON4D3/LuaSnip',     lazy = true, config = function() require('plugins.luasnip') end, },
  { 'onsails/lspkind-nvim', lazy = true, },
  { 'hrsh7th/cmp-nvim-lsp', lazy = true, },

  -- Weird, but using lexima for endwise complete and putting new line + indent
  -- when, eg, pressing enter inside parens.
  -- I think nvim-autopairs should be able to do it, but having lexima as well
  -- is apparently make it buggy
  { 'cohama/lexima.vim',     event = 'InsertEnter', config = function() require('plugins.lexima') end, },
  { 'windwp/nvim-autopairs', event = 'InsertEnter', config = function() require('plugins.nvim-autopairs') end, },
  { 'alvan/vim-closetag',    event = 'InsertEnter', config = function() require('plugins.vim-closetag') end, },
},
{
  lockfile = vim.fn.stdpath('config') .. '/plugins-lock.json',
  install = {
    colorscheme = { 'catppuccin', 'habamax' },
  },
  ui = {
    icons = {
      cmd = '👊',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🔑',
      plugin = '🔌',
      runtime = '🏃',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
