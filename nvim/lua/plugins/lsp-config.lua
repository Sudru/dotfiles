return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- Import dependencies
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap

		-- Diagnostic Configuration
		local function setup_diagnostics()
			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					show_header = true,
					source = "always",
					border = "rounded",
					focusable = false,
				},
			})

			-- Configure diagnostic symbols
			local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end
		end

		-- Keymap Setup
		local function setup_keymaps()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }
					local mappings = {
						{ "n", "gR", "<cmd>Telescope lsp_references<CR>", "Show LSP references" },
						{ "n", "gD", vim.lsp.buf.declaration, "Go to declaration" },
						{ "n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Show LSP definitions" },
						{ "n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Show LSP implementations" },
						{ "n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Show LSP type definitions" },
						{ { "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "See available code actions" },
						{ "n", "<leader>rn", vim.lsp.buf.rename, "Smart rename" },
						{ "n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics" },
						{ "n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics" },
						{ "n", "[d", vim.diagnostic.goto_prev, "Go to previous diagnostic" },
						{ "n", "]d", vim.diagnostic.goto_next, "Go to next diagnostic" },
						{ "n", "K", vim.lsp.buf.hover, "Show documentation" },
						{ "n", "<leader>rs", ":LspRestart<CR>", "Restart LSP" },
					}

					-- Apply keymaps
					for _, map in ipairs(mappings) do
						opts.desc = map[4]
						keymap.set(map[1], map[2], map[3], opts)
					end
				end,
			})
		end

		-- Server Configuration
		local function setup_servers()
			local capabilities = cmp_nvim_lsp.default_capabilities()

			mason_lspconfig.setup_handlers({
				-- Default server handler
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,
				-- Specific configuration for Emmet
				["emmet_ls"] = function()
					lspconfig["emmet_ls"].setup({
						capabilities = capabilities,
						filetypes = { "html", "css", "javascript" },
					})
				end,
				-- Specific configuration for Lua
				["lua_ls"] = function()
					lspconfig["lua_ls"].setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
								completion = { callSnippet = "Replace" },
							},
						},
					})
				end,
			})
		end

		-- Call setup functions
		setup_diagnostics()
		setup_keymaps()
		setup_servers()
	end,
}
