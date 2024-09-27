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
	use 'tanvirtin/monokai.nvim'

	-- PLUGINS
	use {"ellisonleao/glow.nvim", config = function() require("glow").setup() end}
	use 'nvim-treesitter/nvim-treesitter'
	use {
		'nvim-neo-tree/neo-tree.nvim',
		branch = "v3.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			"3rd/image.nvim"
		}
	}
	use 'NvChad/nvim-colorizer.lua'
	use {
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	}
	use 'williamboman/mason-lspconfig.nvim'
	use 'neovim/nvim-lspconfig'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	
	use 'nvim-telescope/telescope.nvim'

	use "lukas-reineke/indent-blankline.nvim"
	use 'hrsh7th/nvim-cmp'
	use 'L3MON4D3/LuaSnip'
	use 'onsails/lspkind.nvim'
	use 'williamboman/mason.nvim'
	use 'folke/trouble.nvim'
	use 'hoob3rt/lualine.nvim'

	use 'mrjones2014/smart-splits.nvim'
	use 'mrjones2014/legendary.nvim'
	use "numToStr/FTerm.nvim"

	use {
		'goolord/alpha-nvim',
		requires = { 'echasnovski/mini.icons' },
		config = function ()
			require'alpha'.setup(require'alpha.themes.dashboard'.config)
		end
	}
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

-- {{{ NEOTREE 
require('neo-tree').setup({
	popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
	filesystem = {
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = false,
			hide_hidden = false
		},
		hijack_netrw_behavior = "open_default"
	}
})
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
mason_lspconfig.setup();
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

-- {{{ FTERM
require('FTerm').setup({
    border = 'double',
    dimensions  = {
        height = 0.9,
        width = 0.9,
    },
})
vim.keymap.set('t', '<F3>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
-- }}}

-- {{{ LEGENDARY
require('legendary').setup({
	keymaps = {
		{ '<F2>', ':Neotree toggle<CR>' },
		{ '<F3>', '<CMD>lua require("FTerm").toggle()<CR>' },
		{ 'ff', '<cmd>Telescope find_files<cr>' },
		{ 'fg', '<cmd>Telescope live_grep<cr>' },
		{ 'fb', '<cmd>Telescope buffers<cr>' },
		{ 'fh', '<cmd>Telescope help_tags<cr>' }
	},
	commands = {},
	funcs = {},
	autocmds = {},
	extensions = {
		smart_splits = {
			directions = { 'h', 'j', 'k', 'l' },
			mods = {
				move = '<C>',
				resize = '<M>',
			},
		},
	},
})

-- }}}

require("ibl").setup() -- indent blank lines
require("telescope").setup()
require("colorizer").setup()

vim.cmd("colorscheme catppuccin-macchiato")
