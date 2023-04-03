local h = require("_cfg.helpers")
vim.g.unception_block_while_host_edits = true

-- basic core stuff {{{
-- disable ex mode
h.map("n", "Q", "<nop>")
h.map("n", "gQ", "<nop>")

h.map("i", "<c-a>", "<nop>") -- disable insert repeating
vim.cmd([[ set list listchars=tab:»·,trail:·,nbsp:· ]]) -- Display extra whitespace
vim.cmd([[ set shada=!,'1000,<50,s10,h ]]) -- increase oldfile saved ( default is !,'100,<50,s10,h )

h.autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
	command = "setlocal cursorline",
})
h.autocmd({ "WinLeave" }, {
	callback = function()
		if vim.bo.filetype ~= "neo-tree" then
			vim.cmd("setlocal nocursorline")
		end
	end,
})

-- prefer spaces over tabs
vim.cmd([[ set tabstop=2 ]])
vim.cmd([[ set softtabstop=2 ]])
vim.cmd([[ set shiftwidth=2 ]])
vim.cmd([[ set expandtab ]])

h.autocmd({ "TextYankPost" }, { command = "silent! lua vim.highlight.on_yank()" })

-- modern copy paste keymaps
h.map("i", "<C-v>", "<C-r>+")
h.map("v", "<C-c>", '"+y')

-- spelling
vim.opt.spellcapcheck = nil -- ignore capitalisation

-- vim.o.inccommand = "nosplit" --Incremental live completion
vim.wo.relativenumber = true --Make line numbers default

vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 4
-- }}}

-- visuals look nice {{{
vim.api.nvim_set_var("vim_json_syntax_conceal", 0)
vim.o.background = "light"
require("github-theme").setup({
	dark_float = true,
	dark_sidebar = true,
	sidebars = { "qf", "terminal", "neo-tree" },
})
vim.cmd.colorscheme("github_light")

local navic = require("nvim-navic")

-- modify the theme so sections don't change color with mode
local lualine_theme = vim.deepcopy(require("lualine.utils.loader").load_theme("auto"))
lualine_theme.insert = nil
lualine_theme.replace = nil
lualine_theme.visual = nil
lualine_theme.command = nil

require("lualine").setup({
	options = {
		theme = lualine_theme,
		globalstatus = true,
		disabled_filetypes = {
			winbar = { "", "neo-tree", "Outline", "fugitive" },
		},
	},
	sections = {
		lualine_a = { "vim.fs.basename(vim.fn.getcwd())" },
		lualine_b = { "branch", "diff" },
		lualine_c = { "diagnostics" },
		lualine_x = { "lsp_progress", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	winbar = {
		lualine_b = { { "filename", path = 1 } },
		lualine_c = { { navic.get_location, cond = navic.is_available } },
	},
	inactive_winbar = {
		lualine_b = { { "filename", path = 1 } },
	},
	tabline = {
		lualine_a = {
			{
				"tabs",
				mode = 1,
				max_length = vim.o.columns,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				fmt = function(_, context)
					local winnr = vim.fn.tabpagewinnr(context.tabnr)
					local tabcwd = vim.fs.basename(vim.fn.getcwd(winnr, context.tabnr))
					return "[" .. context.tabnr .. ": " .. tabcwd .. "]"
				end,
			},
		},
	},
})
vim.o.showtabline = 1
-- }}}

-- {{{ misc and UI stuff
h.map("n", "<leader>u", "<cmd>MundoToggle<cr>")
vim.g.mundo_preview_bottom = 1
vim.g.mundo_width = 40
vim.g.mundo_preview_height = 20
-- }}}
