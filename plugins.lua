local p = require("gen.plugin-names")

local plugins = {
	{ name = "MY_CFG", dir = my_cfg_dir, priority = 1000, lazy = false },
}

for name, path in pairs(p) do
	table.insert(plugins, { dir = path })
end

require("lazy").setup(plugins, {
	-- defaults = { lazy = true },
})
