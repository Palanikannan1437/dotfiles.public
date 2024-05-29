local lsp_zero = require("lsp-zero")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()
local luasnip = require("luasnip")
local nnoremap = require("palani.keymap").nnoremap
local icons = require("palani.icons")

mason.setup({})
mason_lspconfig.setup({
	ensure_installed = {
		"lua_ls",
		"html",
		"cssls",
		"bashls",
		"gopls",
		"tailwindcss",
		"rust_analyzer",
	},

	handlers = {
		lsp_zero.default_setup,
		-- to avoid global variable vim error
		lua_ls = function()
			local lua_opts = {
				-- cmd = {...},
				-- filetypes { ...},
				-- capabilities = {},
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							-- Tells lua_ls where to find all the Lua files that you have loaded
							-- for your neovim configuration.
							library = {
								"${3rd}/luv/library",
								unpack(vim.api.nvim_get_runtime_file("", true)),
							},
							-- If lua_ls is really slow on your computer, you can try this instead:
							-- library = { vim.env.VIMRUNTIME },
						},
						completion = {
							callSnippet = "Replace",
						},
						-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
						-- diagnostics = { disable = { 'missing-fields' } },
					},
				},
			}
			require("lspconfig").lua_ls.setup(lua_opts)
		end,
	},
})

lsp_zero.on_attach(function(client, bufnr)
	lsp_zero.default_keymaps({ buffer = bufnr })
	local options = { buffer = bufnr, remap = false }

	if vim.bo.filetype == "typescript" or vim.bo.filetype == "typescriptreact" then
		nnoremap("gD", "<cmd>vsplit | TSToolsGoToSourceDefinition<CR>", options)
		nnoremap("gd", "<cmd>TSToolsGoToSourceDefinition<CR>", options)

		-- for typescript types go to definition works best with the lsp and
		-- function overloads
		nnoremap("gu", vim.lsp.buf.definition, options)
		nnoremap("gU", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", options)
		nnoremap("tgu", vim.lsp.buf.type_definition, options)
		nnoremap("tgu", "<cmd>vsplit | lua vim.lsp.buf.type_definition()<CR>", options)

		nnoremap("tami", "<cmd>TSToolsAddMissingImports<CR>", options)
		nnoremap("toi", "<cmd>TSToolsOrganizeImports<CR>", options)
		nnoremap("tsi", "<cmd>TSToolsSortImports<CR>", options)
		nnoremap("tru", "<cmd>TSToolsRemoveUnusedImports<CR>", options)
		nnoremap("tfa", "<cmd>TSToolsFixAll<CR>", options)
		nnoremap("trnf", "<cmd>TSToolsRenameFile<CR>", options)
	else
		nnoremap("gu", vim.lsp.buf.type_definition, options)
		nnoremap("gU", "<cmd>vsplit | lua vim.lsp.buf.type_definition()<CR>", options)
		nnoremap("gd", vim.lsp.buf.definition, options)
		nnoremap("gD", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", options)
	end

	local diagnostic_goto = function(next, severity)
		local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
		severity = severity and vim.diagnostic.severity[severity] or nil
		return function()
			go({ severity = severity })
		end
	end
	nnoremap("]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
	nnoremap("[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
	nnoremap("]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
	nnoremap("[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
	nnoremap("]h", diagnostic_goto(true, "HINT"), { desc = "Next Hint" })
	nnoremap("[h", diagnostic_goto(false, "HINT"), { desc = "Prev Hint" })

	nnoremap("<leader>b", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	end, { desc = "Toggle Inlay Hints" })

	nnoremap("gi", vim.lsp.buf.implementation, options)
	nnoremap("<leader>ca", vim.lsp.buf.code_action, options)
	nnoremap("<leader>rn", vim.lsp.buf.rename, options)
	nnoremap("<space>e", vim.diagnostic.open_float, options)
	nnoremap("<space>q", vim.diagnostic.setqflist, options)
end)

lsp_zero.set_preferences({
	file_ignore_patterns = { "*.d.ts" },
	suggest_lsp_servers = true,
	sign_icons = {
		error = icons.diagnostics.Error,
		warn = icons.diagnostics.Warning,
		hint = icons.diagnostics.Hint,
		info = icons.diagnostics.Info,
	},
})

-- add vscode like snippets support
require("luasnip.loaders.from_vscode").lazy_load()

-- add .tsx snippets support for .ts files
require("luasnip").filetype_extend("typescript", { "typescriptreact" })

luasnip.config.setup({})

cmp.setup({
	sources = {
		{ name = "path" },
		{ name = "luasnip" }, -- For luasnip users.
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "buffer" },
	},
	window = {
		documentation = cmp.config.window.bordered(),
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	formatting = {
		-- changing the order of fields so the icon is the first
		fields = { "menu", "abbr", "kind" },
		snippet = {
			-- REQUIRED - you must specify a snippet engine
			expand = function(args)
				require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
			end,
		},

		-- here is where the change happens
		format = function(entry, item)
			local menu_icon = {
				nvim_lsp = "λ",
				luasnip = "⋗",
				buffer = "Ω",
				path = "🖫",
				nvim_lua = "Π",
			}

			item.menu = menu_icon[entry.source.name]
			return item
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end,
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		-- Disable Tab key to navigate completion menu for AI completions
		["<Tab>"] = cmp.config.disable,
		["<S-Tab>"] = cmp_action.luasnip_supertab(),

		-- Ctrl+Space to trigger completion menu
		["<C-Space>"] = cmp.mapping.complete(),

		-- Navigate between snippet placeholder
		["<C-f>"] = cmp_action.luasnip_jump_forward(),
		["<C-b>"] = cmp_action.luasnip_jump_backward(),

		-- Scroll up and down in the completion documentation
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
	}),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

vim.diagnostic.config({
	virtual_text = false,
})
