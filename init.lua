vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.fillchars = { eob = ' ', fold = ' ', foldclose = ' ', foldopen = ' ', foldsep = ' ' }

vim.o.foldcolumn = '0'
vim.o.foldlevel = 99
vim.o.foldenable = true
vim.o.foldlevelstart = 99

vim.o.wrap = false

vim.opt.shortmess:append("I")

vim.opt.termguicolors = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- {{{ PACKAGES
require('packer').startup(function()
	use 'wbthomason/packer.nvim'  -- Package manager itself

	-- Themes
	use 'catppuccin/nvim'
	use 'folke/tokyonight.nvim'

	-- Neo-Tree (File Explorer)
	use 'nvim-neo-tree/neo-tree.nvim'
	use 'nvim-lua/plenary.nvim'
	use 'nvim-tree/nvim-web-devicons'
	use 's1n7ax/nvim-window-picker'
	use 'MunifTanjim/nui.nvim'
	use '3rd/image.nvim'

	-- LSP & CMP
	use 'williamboman/mason.nvim'
	use 'williamboman/mason-lspconfig.nvim'

	use 'neovim/nvim-lspconfig'
	use 'onsails/lspkind.nvim'

	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'

	use 'saadparwaiz1/cmp_luasnip'
	use 'hrsh7th/nvim-cmp' -- Completions
	use 'L3MON4D3/LuaSnip' -- Snippet Engine


	-- OTHER
	use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'} -- Modern folds
	use 'ya2s/nvim-cursorline' -- Highlight cursor words and lines
	use 'nvim-treesitter/nvim-treesitter' -- Highlighter
	use 'NvChad/nvim-colorizer.lua' -- Colorizer
	use 'numToStr/Comment.nvim' -- Auto-comment
	use 'nvim-telescope/telescope.nvim' -- Fuzzy finder
	use 'lukas-reineke/indent-blankline.nvim' -- Indent Line
	use 'hoob3rt/lualine.nvim' -- Status Bar
	use 'mrjones2014/smart-splits.nvim' -- Split Manager
	use 'romgrk/barbar.nvim' -- Tabs Manager
	use 'mrjones2014/legendary.nvim' -- Keymap Manager
	use 'numToStr/FTerm.nvim' -- Floating Terminal
	use 'lewis6991/gitsigns.nvim' -- Git Signs
	use 'ellisonleao/glow.nvim' -- Markdown previewer
	use 'f-person/git-blame.nvim' -- Git Blame
	use 'folke/trouble.nvim' -- Diagnostics
	use 'chentoast/marks.nvim' -- Simple marks to move around

	use {
		'goolord/alpha-nvim',
		requires = { 'echasnovski/mini.icons' },
		config = function ()
			require'alpha'.setup(require'alpha.themes.dashboard'.config)
		end
	}
end)
-- }}}

-- {{{ TREESITTER
require('nvim-treesitter.configs').setup {
	ensure_installed = 'all',
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}
-- }}}

-- {{{ NEOTREE 
require('neo-tree').setup({
	close_if_last_window = true,
	popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
	filesystem = {
		filtered_items = {
			visible = false,
			hide_dotfiles = true,
			hide_gitignored = false,
			hide_hidden = true
		},
		hijack_netrw_behavior = 'open_default'
	},
	window = {
		position = 'right',
	},
})
-- }}}

-- {{{ LUALINE
require('lualine').setup {
	options = {
		icons_enabled = true,
		-- component_separators = { left = '|', right = '|' },
		-- section_separators = { left = '', right = '' },
		component_separators = { left = '', right = ''},
	    section_separators = { left = '', right = ''},
		always_divide_middle = true,
	},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch', 'diff', 'diagnostics'},
		lualine_c = {'filename', 'lsp_progress'},
		lualine_x = {'encoding', 'filetype'},
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
	extensions = {},
	options = { disabled_filetypes = {'neo-tree'} }
}
-- }}}

-- {{{ CMP
local cmp = require('cmp')
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local lspconfig = require('lspconfig')
local util = require('lspconfig/util')

lspconfig.rust_analyzer.setup({
	filetypes = { "rust" },
	root_dir = util.root_pattern("Cargo.toml"),
	settings = {
		['rust-analyzer'] = {
			cargo = {
				allFeatures = true;
			}
		}
	}
})

cmp.setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	window = {},
	mapping = cmp.mapping.preset.insert({
		['<C-Up>'] = cmp.mapping.scroll_docs(-4),
		['<C-Down>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({ { name = 'nvim_lsp' }, { name = 'luasnip' } }, { { name = 'buffer' } }),
	formatting = {
		format = require('lspkind').cmp_format({
			mode = 'symbol',
			maxwidth = 50,
			ellipsis_char = '...',
			show_labelDetails = true,
			before = function (entry, vim_item)
				return vim_item
			end
		})
	}
})

cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = 'buffer' } }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

mason.setup()
mason_lspconfig.setup()
mason_lspconfig.setup_handlers({
	function (server_name)
		lspconfig[server_name].setup({})
	end,
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
		{ '<F3>', ':lua require("FTerm").toggle()<CR>' },
		{ '<F4>', ':GitBlameToggle<CR>' },
		{ '<F5>', ':Trouble diagnostics<CR>' },

		{ 'ff', ':Telescope find_files<CR>' },
		{ 'fg', ':Telescope live_grep<CR>' },
		{ 'fb', ':Telescope buffers<CR>' },
		{ 'fh', ':Telescope help_tags<CR>' },
		{ 'fc', ':Telescope colorscheme<CR>'},

		{ 'zR', ':lua require("ufo").openAllFolds()<CR>' },
		{ 'zM', ':lua require("ufo").closeAllFolds()<CR>' },

		{ 'gt', ':BufferNext<CR>' },
		{ 'gT', ':BufferPrevious<CR>' },
		{ '<A-c>', ':BufferClose<CR>' },
		{ '<A-p>', ':BufferPin<CR>' },
		{ '<A-Left>', ':BufferPrevious<CR>' },
		{ '<A-Right>', ':BufferNext<CR>' },
		{ '<A-Up>', ':BufferPick<CR>' },
		{ '<A-Down>', ':BufferPick<CR>' },
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

-- {{{ BARBAR
require('barbar').setup({
	animation = false,
	clickable = false,
	icons = {
		button = '',
		pinned = {button = '', filename = true},
	},
	tabpages = false,
})
-- }}}

-- {{{ UFO
local ufo_handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (' 󰁂 %d '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, {suffix, 'MoreMsg'})
    return newVirtText
end

require('ufo').setup({
	fold_virt_text_handler = ufo_handler,
    provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
    end
})
-- }}}

-- {{{ Cursor Line
require('nvim-cursorline').setup({
	cursorline = {
		enable = true,
		timeout = 0,
		number = false,
	},
	cursorword = {
		enable = true,
		min_length = 3,
		hl = { underline = true },
	}
})
-- }}}

-- {{{ Marks
require'marks'.setup {
	sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
	bookmark_0 = {
		sign = "⚑",
		annotate = true,
	},
}
-- }}}

require('gitblame').setup({ enabled = false })
require('Comment').setup()
require('ibl').setup()
require('telescope').setup()
require('colorizer').setup()
require('glow').setup()
require('trouble').setup()

vim.cmd("colorscheme tokyonight-night")
