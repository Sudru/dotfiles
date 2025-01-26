return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		local keymap = vim.keymap -- for conciseness
		local neotree = require("neo-tree")
		neotree.setup({
			window = {
				position = "right",
				width = 30,
				mappings = {
					["P"] = { "toggle_preview", config = { use_float = false, use_image_nvim = true } },
					["<C-b>"] = "toggle",
				},
			},
		})
		keymap.set("n", "<C-b>", "<Cmd>Neotree toggle<CR>")
	end,
}
