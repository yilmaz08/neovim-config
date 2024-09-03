vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.fillchars = { eob = ' ' }

vim.opt.foldmethod = 'marker'

vim.opt.shortmess:append("I")

-- {{{ PACKAGES
require('packer').startup(function()
  use 'wbthomason/packer.nvim'  -- Package manager itself

  -- THEMES
  use 'catppuccin/nvim'
  use 'navarasu/onedark.nvim'
  use 'Mofiqul/vscode.nvim'

  -- PLUGINS
  use {
    'nvim-treesitter/nvim-treesitter',
	-- run = ":TSUpdate"
  }
  
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'

  use "lukas-reineke/indent-blankline.nvim"
  use 'hrsh7th/nvim-cmp'
  use 'L3MON4D3/LuaSnip'
  use 'onsails/lspkind.nvim'
  use {
    'vyfor/cord.nvim',
    run = './build || .\\build',
    config = function()
      require('cord').setup()
    end,
  }
  use 'williamboman/mason.nvim'
  use 'folke/trouble.nvim'
  use 'hoob3rt/lualine.nvim'
end)
-- }}}

-- {{{ NVIM TREESITTER
require('nvim-treesitter.configs').setup {
 ensure_installed = "all",
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
-- }}}

-- {{{ LUALINE
require('lualine').setup { -- status line
  options = {
    icons_enabled = true,
    component_separators = { left = '|', right = '|' },
    section_separators = { left = '', right = '' },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename', 'lsp_progress'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
-- }}}

-- {{{ CMP
local cmp = require('cmp')
cmp.setup({
  snippet = {
  expand = function(args)
    require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {},
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
	['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

local lspkind = require('lspkind')
cmp.setup {
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',
      maxwidth = 50,
      ellipsis_char = '...',
      show_labelDetails = true,
      before = function (entry, vim_item)
        return vim_item
      end
    })
  }
}

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

mason.setup()
mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",
    "tsserver",
    "emmet_ls",
    "cssls",
    "pyright",
    "volar",
    "gopls",
  }
});

mason_lspconfig.setup_handlers {
  function (server_name)
    lspconfig[server_name].setup {}
  end,
  ["volar"] = function()
    lspconfig.volar.setup({
      filetypes = { "vue" },
      init_options = {
        vue = {
          hybridMode = false,
        },
        typescript = {
          tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
        },
      },
    })
  end,
}
-- }}}

-- {{{ rust_analyzer
local util = require('lspconfig/util')
lspconfig.rust_analyzer.setup({
  filetypes = {"rust"},
  root_dir = util.root_pattern("Cargo.toml"),
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true;
      },
    },
  },
})
-- }}}

-- {{{ CORD.NVIM
require('cord').setup {
  usercmds = true,                              -- Enable user commands
  log_level = 'error',                          -- One of 'trace', 'debug', 'info', 'warn', 'error', 'off'
  timer = {
    interval = 1500,                            -- Interval between presence updates in milliseconds (min 500)
    reset_on_idle = false,                      -- Reset start timestamp on idle
    reset_on_change = false,                    -- Reset start timestamp on presence change
  },
  editor = {
    image = nil,                                -- Image ID or URL in case a custom client id is provided
    client = 'neovim',                          -- vim, neovim, lunarvim, nvchad, astronvim or your application's client id
    tooltip = 'The Superior Text Editor',       -- Text to display when hovering over the editor's image
  },
  display = {
    show_time = true,                           -- Display start timestamp
    show_repository = false,                     -- Display 'View repository' button linked to repository url, if any
    show_cursor_position = false,               -- Display line and column number of cursor's position
    swap_fields = false,                        -- If enabled, workspace is displayed first
    swap_icons = false,                         -- If enabled, editor is displayed on the main image
    workspace_blacklist = {},                   -- List of workspace names to hide
  },
  lsp = {
    show_problem_count = false,                 -- Display number of diagnostics problems
    severity = 1,                               -- 1 = Error, 2 = Warning, 3 = Info, 4 = Hint
    scope = 'workspace',                        -- buffer or workspace
  },
  idle = {
    enable = true,                              -- Enable idle status
    show_status = true,                         -- Display idle status, disable to hide the rich presence on idle
    timeout = 300000,                           -- Timeout in milliseconds after which the idle status is set, 0 to display immediately
    disable_on_focus = false,                   -- Do not display idle status when neovim is focused
    text = 'Idle',                              -- Text to display when idle
    tooltip = '💤',                             -- Text to display when hovering over the idle image
  },
  text = {
    viewing = 'Viewing files',                     -- Text to display when viewing a readonly file
    editing = 'Editing files',                     -- Text to display when editing a file
    file_browser = 'Browsing files',      -- Text to display when browsing files (Empty string to disable)
    plugin_manager = 'Managing plugins',  -- Text to display when managing plugins (Empty string to disable)
    lsp_manager = 'Configuring LSP',      -- Text to display when managing LSP servers (Empty string to disable)
    vcs = 'Committing changes',           -- Text to display when using Git or Git-related plugin (Empty string to disable)
    workspace = 'in Arch Linux',                        -- Text to display when in a workspace (Empty string to disable)
  },
  buttons = {
    --{
	  --label = 'View Repository',                -- Text displayed on the button
      --url = 'git',                              -- URL where the button leads to ('git' = automatically fetch Git repository URL)
    --},
    -- {
    --   label = 'View Plugin',
    --   url = 'https://github.com/vyfor/cord.nvim',
    -- }
  },
  assets = nil,                                 -- Custom file icons, see the wiki*
}

-- }}}

require("ibl").setup() -- indent blank lines

vim.cmd("colorscheme catppuccin-macchiato")
