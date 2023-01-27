require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
	},
	indent = { enable = true, disable = { "python" } },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<c-space>",
			node_incremental = "<c-space>",
		},
	},
	playground = { enable = true },
	context_commentstring = { enable = true },
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["a/"] = "@comment.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>pl"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>ph"] = "@parameter.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = { ["]m"] = "@function.outer" },
			goto_next_end = { ["]M"] = "@function.outer" },
			goto_previous_start = { ["[m"] = "@function.outer" },
			goto_previous_end = { ["[M"] = "@function.outer" },
		},
	},
})

-- {{{ refactoring
vim.keymap.set("n", "<leader>ms", require("spectre").open, { desc = "open spectre panel" })
vim.keymap.set("v", "<leader>ms", require("spectre").open_visual)

require("refactoring").setup({})

-- helper fn to make passing these functions to which_key easier
local function refactor(name)
	return function()
		require("refactoring").refactor(name)
	end
end

require("which-key").register({
	name = "refactoring",
	b = { refactor("Extract Block"), "Extract Block" },
	i = { refactor("Inline Variable"), "Inline Variable" },
}, {
	prefix = "<leader>r",
})
require("which-key").register({
	name = "refactoring",
	e = { refactor("Extract Function"), "Extract Function" },
	f = { refactor("Extract Function To File"), "Extract Function To File" },
	v = { refactor("Extract Variable"), "Extract Variable" },
	i = { refactor("Inline Variable"), "Inline Variable" },
}, {
	prefix = "<leader>r",
	mode = "v",
})
-- }}}

-- {{{ fancy tree sitter stuff
require("syntax-tree-surfer").setup()

-- Visual Selection from Normal Mode
vim.keymap.set("n", "vx", "<cmd>STSSelectMasterNode<cr>")
vim.keymap.set("n", "vn", "<cmd>STSSelectCurrentNode<cr>")

-- Select Nodes in Visual Mode
vim.keymap.set("x", "J", "<cmd>STSSelectNextSiblingNode<cr>")
vim.keymap.set("x", "K", "<cmd>STSSelectPrevSiblingNode<cr>")
vim.keymap.set("x", "H", "<cmd>STSSelectParentNode<cr>")
vim.keymap.set("x", "L", "<cmd>STSSelectChildNode<cr>")

-- Swapping Nodes in Visual Mode
vim.keymap.set("x", "<A-j>", "<cmd>STSSwapNextVisual<cr>")
vim.keymap.set("x", "<A-k>", "<cmd>STSSwapPrevVisual<cr>")
vim.keymap.set("v", "<C-j>", "<cmd>STSSwapNextVisual<cr>")
vim.keymap.set("v", "<C-k>", "<cmd>STSSwapPrevVisual<cr>")
-- }}}