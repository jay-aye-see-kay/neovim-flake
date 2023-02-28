-- must be first
require("mini.basics").setup({
	options = {
		basic = true, -- Basic options ('termguicolors', 'number', 'ignorecase', and many more)
		extra_ui = false, -- Extra UI features ('winblend', 'cmdheight=0', ...)
		win_borders = "bold", -- Presets for window borders ('single', 'double', ...)
	},
	mappings = {
		basic = true, -- Basic mappings (better 'jk', save with Ctrl+S, ...)
		windows = true, -- Window navigation with <C-hjkl>, resize with <C-arrow>
		option_toggle_prefix = [[\]],
		move_with_alt = false,
	},
	autocommands = {
		basic = false,
		relnum_in_visual_mode = false,
	},
})
vim.keymap.del("t", "<C-w>") -- mini.basics sets this to Focus other window, leave default

require("mini.ai").setup()
require("mini.starter").setup()
require("mini.align").setup({
	mappings = {
		start = "gl",
		start_with_preview = "gL",
	},
})

require("mini.misc").setup_restore_cursor()

vim.keymap.set("n", "<c-w>z", require("mini.misc").zoom)
vim.keymap.set("n", "<c-w><c-z>", require("mini.misc").zoom)

vim.g.miniindentscope_disable = true
vim.keymap.set("n", "\\I", function()
	vim.g.miniindentscope_disable = not vim.g.miniindentscope_disable
end, { desc = "toggle indentscope" })
require("mini.indentscope").setup()

require("mini.move").setup({
	mappings = {
		left = "",
		right = "",
		line_left = "",
		line_right = "",
		down = "]e",
		up = "[e",
		line_down = "]e",
		line_up = "[e",
	},
})

require("mini.bracketed").setup({
	comment = { suffix = "c" },
	diagnostic = { suffix = "d" },
	file = { suffix = "f" },
	quickfix = { suffix = "q" },
	-- disabled keymaps
	buffer = { suffix = "" },
	conflict = { suffix = "" },
	indent = { suffix = "" },
	jump = { suffix = "" },
	location = { suffix = "" },
	oldfile = { suffix = "" },
	treesitter = { suffix = "" },
	undo = { suffix = "" },
	window = { suffix = "" },
	yank = { suffix = "" },
})
