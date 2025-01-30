-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Variables
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

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require('lazy').setup({
	spec = {
		-- Lualine
		{
			'hoob3rt/lualine.nvim',
			opts = {
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
		},

		-- Treesitter
		{ 
			'nvim-treesitter/nvim-treesitter',
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = 'all',
					highlight = {
						enable = true,
						additional_vim_regex_highlighting = false,
					},
				})
			end
		},

		-- Neo-tree
		{ 
			'nvim-neo-tree/neo-tree.nvim',
			dependencies = {
				'nvim-lua/plenary.nvim',
				'nvim-tree/nvim-web-devicons',
				's1n7ax/nvim-window-picker',
				'MunifTanjim/nui.nvim',
				'3rd/image.nvim'
			},
			opts = {
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
			}
		},

		-- Legendary
		{
			'mrjones2014/legendary.nvim',
			opts = {
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
			}
		},

		-- Barbar
		{
			'romgrk/barbar.nvim',
			opts = {
				animation = false,
				clickable = false,
				icons = {
					button = '',
					pinned = {button = '', filename = true},
				},
				tabpages = false,
			}
		},

		-- FTerm
		{
			'numToStr/FTerm.nvim',
			opts = {
				border = 'double',
				dimensions  = {
					height = 0.9,
					width = 0.9,
			    },
			},
			config = function()
				vim.keymap.set('t', '<F3>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
			end
		},

		-- Cursorline & Word highlight
		{
			'ya2s/nvim-cursorline',
			opts = {
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
			}
		},

		-- Marks
		{
			'chentoast/marks.nvim',
			opts = {
				sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
				bookmark_0 = {
					sign = "⚑",
					annotate = true,
				},
			}
		},

		-- Indent lines
		{ 
			'lukas-reineke/indent-blankline.nvim', 
			config = function()
				require("ibl").setup({})
			end
		},

		-- Modern folds
		{
			'kevinhwang91/nvim-ufo', 
			dependencies = 'kevinhwang91/promise-async',
			config = function()
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
			end
		},

		-- CMP
		{
			'hrsh7th/nvim-cmp',
			dependencies = {
				'hrsh7th/cmp-cmdline',
				'hrsh7th/cmp-path',
				'hrsh7th/cmp-buffer',
				'hrsh7th/cmp-nvim-lsp',

				'L3MON4D3/LuaSnip',
				'saadparwaiz1/cmp_luasnip'
			},
			config = function()
				local cmp = require('cmp')
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
			end
		},

		-- LSP
		{
			'williamboman/mason.nvim',
			dependencies = {
				'williamboman/mason-lspconfig.nvim',
				'neovim/nvim-lspconfig',
				'onsails/lspkind.nvim'
			},
			config = function()
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

				local mason_lspconfig = require('mason-lspconfig')
				require('mason').setup()
				mason_lspconfig.setup()
				mason_lspconfig.setup_handlers({
					function (server_name)
						lspconfig[server_name].setup({})
					end,
				})
			end,
		},

		-- Others
		{ 'mrjones2014/smart-splits.nvim', opts = {} }, -- Smart splits
		{ 'nvim-telescope/telescope.nvim', opts = {} }, -- Telescope
		{ 'f-person/git-blame.nvim', opts = { enabled = false } }, -- Git Blame
		{ 'numToStr/Comment.nvim', opts = {} }, -- Comments
		{ 'ellisonleao/glow.nvim', opts = {} }, -- Markdown previewer
		{ 'folke/trouble.nvim', opts = {} }, -- Diagnostics
		{ 'NvChad/nvim-colorizer.lua', opts = {} }, -- Colorizer

		-- Themes
		'folke/tokyonight.nvim'
	},
	install = { colorscheme = { "tokyonight-night" } },
	checker = { enabled = false },
})

vim.cmd("colorscheme tokyonight-night")
