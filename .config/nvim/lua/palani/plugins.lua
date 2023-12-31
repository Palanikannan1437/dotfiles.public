local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local nnoremap = require("palani.keymap").nnoremap
local uv = vim.uv or vim.loop

-- Auto-install lazy.nvim if not present
if not uv.fs_stat(lazypath) then
	print("Installing lazy.nvim....")
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
	print("Done.")
end

vim.opt.rtp:prepend(lazypath)
vim.opt.fillchars:append({ diff = "╱" })

require("lazy").setup({
	-- dependencies
	"nvim-lua/plenary.nvim",

	-- icons
	"nvim-tree/nvim-web-devicons",

	-- fuzzy finder
	{
		"ibhagwan/fzf-lua",
		event = "VeryLazy",
		config = function()
			require("fzf-lua").setup({
				"telescope",
				winopts = { preview = { default = "bat" } },
				grep = {
					rg_opts = "--column --hidden --line-number --no-heading --color=always --smart-case --max-columns=4096 -g '!.git'",
				},
			})

			nnoremap(
				"<leader>h",
				"<cmd>lua require('fzf-lua').live_grep_native({ fzf_opts = {['--layout'] = 'reverse-list'} })<CR>",
				{ silent = true }
			)

			nnoremap(
				"<leader>rh",
				"<cmd>lua require('fzf-lua').live_grep_native({ fzf_opts = {['--layout'] = 'reverse-list'} , resume = true })<CR>",
				{ silent = true }
			)

			nnoremap(
				"<leader>cw",
				"<cmd>lua require('fzf-lua').grep_cword({ fzf_opts = {['--layout'] = 'reverse-list'} })<CR>",
				{ silent = true }
			)

			nnoremap(
				"<leader>j",
				"<cmd>lua require('fzf-lua').lsp_references({ fzf_opts = {['--layout'] = 'reverse-list'} })<CR>",
				{ silent = true }
			)

			nnoremap(
				"<leader>f",
				"<cmd>lua require('fzf-lua').files({ fzf_opts = {['--layout'] = 'reverse-list'} })<CR>",
				{ silent = true }
			)
			nnoremap(
				"<leader>rf",
				"<cmd>lua require('fzf-lua').files({ fzf_opts = {['--layout'] = 'reverse-list'}, resume= true})<CR>",
				{ silent = true }
			)

			nnoremap(
				"<leader>wd",
				"<cmd>lua require('fzf-lua').lsp_document_diagnostics({ fzf_opts = {['--layout'] = 'reverse-list'} })<CR>",
				{ silent = true }
			)

			nnoremap(
				"<leader>ww",
				"<cmd>lua require('fzf-lua').lsp_workspace_diagnostics({ fzf_opts = {['--layout'] = 'reverse-list'} })<CR>",
				{ silent = true }
			)

			nnoremap("<leader>g", ":lua _G.live_grep_cwd()<CR>", { silent = true })
			nnoremap("<leader>u", "<cmd>lua require('fzf-lua').resume()<CR>", { silent = true })

			_G.live_grep_cwd = function()
				require("fzf-lua").fzf_exec("fd --type d -H --exclude=.git", {
					actions = {
						["default"] = function(sel, opts)
							require("fzf-lua").live_grep({ cwd = sel[1], fzf_opts = { ["--layout"] = "reverse-list" } })
						end,
					},
				})
			end
		end,
	},

	-- window navigation
	{ "christoomey/vim-tmux-navigator", event = "VeryLazy" },

	-- for better quick fix list
	{
		"kevinhwang91/nvim-bqf",
		event = "VeryLazy",
	},

	-- for live diagnostics population in quickfix list
	{
		"onsails/diaglist.nvim",
		keys = {
			{
				"<leader>d0",
				mode = { "n" },
				function()
					require("diaglist").open_buffer_diagnostics()
				end,
				desc = "Open buffer diagnostic list",
			},
			{
				"<leader>dw",
				mode = { "n" },
				function()
					require("diaglist").open_all_diagnostics()
				end,
				desc = "Open all diagnostic list",
			},
		},
		config = function()
			require("diaglist").init({
				debug = false,
				debounce_ms = 150,
			})
		end,
	},

	-- GIT STUFF --
	-- git signs
	{
		"lewis6991/gitsigns.nvim",
		-- ft = filetypes,
		event = { "BufReadPre", "BufNewFile" },
		config = true,
		opts = function()
			local C = {
				on_attach = function(buffer)
					local gs = package.loaded.gitsigns
					local function map(mode, l, r, desc)
						vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
					end
					map("n", "]g", gs.next_hunk, "Next Hunk")
					map("n", "[g", gs.prev_hunk, "Prev Hunk")
				end,
			}
			return C
		end,
	},

	-- git links on the fly
	{
		"linrongbin16/gitlinker.nvim",
		cmd = { "GitLink" },
		config = function()
			require("gitlinker").setup()
		end,
	},

	-- diff view for git
	{ "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" } },

	-- git blame
	{
		"FabijanZulj/blame.nvim",
		cmd = "ToggleBlame",
	},

	-- comments in nvim
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})

			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})

			vim.g.skip_ts_context_commentstring_module = true
		end,
		keys = {
			{
				"gcc",
				mode = { "n" },
				function()
					require("Comment").toggle()
				end,
				desc = "Comment",
			},
			{
				"gc",
				mode = { "v" },
				function()
					require("Comment").toggle()
				end,
				desc = "Comment",
			},
		},
	},

	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		keys = {
			{
				"gcc",
				mode = { "n" },
				function()
					require("Comment").toggle()
				end,
				desc = "Comment",
			},
			{
				"gc",
				mode = { "v" },
				function()
					require("Comment").toggle()
				end,
				desc = "Comment",
			},
		},
	},

	-- AI Autocompletion
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<Tab>",
						accept_word = false,
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
			})
		end,
	},

	-- color theme
	{
		"catppuccin/nvim",
		priority = 1000,
		name = "catppuccin",
		lazy = false,
		config = function()
			require("catppuccin").setup({
				highlight_overrides = {
					mocha = function(mocha)
						return {
							LineNr = { fg = mocha.overlay1 },
						}
					end,
				},
			})
		end,
	},

	-- formatter
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				-- Customize or remove this keymap to your liking
				"<leader>i",
				function()
					require("conform").format({
						lsp_fallback = true,
						async = false,
						timeout_ms = 10000,
					})
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				go = { "gofumpt", "goimports", "golines" },
				rust = { "rustfmt" },
				css = { "prettierd" },
				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				lua = { "stylua" },
				sh = { "shfmt" },
				zsh = { "shfmt" },
			},
			timeout_ms = 10000,
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 10000,
			},
		},
	},

	-- linter
	{
		"mfussenegger/nvim-lint",
		-- ft = filetypes,
		event = { "BufReadPre", "BufWritePre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				css = { "eslint_d" },
				javascript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescript = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				markdown = { "markdownlint" },
			}

			vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile", "BufWritePost" }, {
				callback = function()
					lint.try_lint()
				end,
			})

			nnoremap("<leader>l", function()
				lint.try_lint()
			end, { silent = true, desc = "Trigger linting for current buffer" })
		end,
	},

	-- treesitter syntax highlighting (lazy loaded)nvim-treesitter/nvim-treesitter-textobjects
	{
		"nvim-treesitter/nvim-treesitter",
		-- event = { "BufNewFile" },
		event = { "BufReadPre", "BufNewFile" },
		-- ft = filetypes,
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects", "chrisgrieser/nvim-various-textobjs" },
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
		config = function()
			require("nvim-treesitter.configs").setup({
				sync_install = true,
				auto_install = false,
				ignore_install = { "" },
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
			})
		end,
	},

	{
		"chrisgrieser/nvim-various-textobjs",
		lazy = true,
		config = function()
			require("various-textobjs").setup({
				-- lines to seek forwards for "small" textobjs (mostly characterwise textobjs)
				-- set to 0 to only look in the current line
				lookForwardSmall = 5,

				-- lines to seek forwards for "big" textobjs (mostly linewise textobjs)
				lookForwardBig = 15,

				-- use suggested keymaps (see overview table in README)
				useDefaultKeymaps = false,

				-- disable only some default keymaps, e.g. { "ai", "ii" }
				disabledKeymaps = {},
			})
			local keymap = vim.keymap.set
			keymap({ "o", "x" }, "mc", "<cmd>lua require('various-textobjs').multiCommentedLines()<CR>")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		lazy = true,
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					move = {
						enable = true,
						goto_next_start = {
							["]f"] = "@function.outer",
							["]c"] = "@call.outer",
							["]s"] = "@class.outer",
						},
						goto_next_end = {
							["]F"] = "@function.outer",
							["]C"] = "@call.outer",
							["]S"] = "@class.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[c"] = "@call.outer",
							["[s"] = "@class.outer",
						},
						goto_previous_end = {
							["[F"] = "@function.outer",
							["[C"] = "@call.outer",
							["[S"] = "@class.outer",
						},
					},

					select = {
						enable = true,

						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,
						keymaps = {
							["ac"] = {
								query = "@call.outer",
								desc = "Select outer part of a function call",
							},
							["ic"] = {
								query = "@call.inner",
								desc = "Select inner part of a function call",
							},

							["af"] = {
								query = "@function.outer",
								desc = "Select outer part of a method/function definition",
							},
							["if"] = {
								query = "@function.inner",
								desc = "Select inner part of a method/function definition",
							},

							["as"] = {
								query = "@class.outer",
								desc = "Select outer part of a class/struct",
							},
							["is"] = {
								query = "@class.inner",
								desc = "Select inner part of a class/struct",
							},
						},
					},
				},
			})
		end,
	},

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({})
		end,
		keys = { "cs", "ds", "ys" },
	},

	-- nvim colors
	{ "norcalli/nvim-colorizer.lua", ft = { "css", "javascriptreact", "typescriptreact", "html" } },

	-- file explorer
	{
		"stevearc/oil.nvim",
		opts = {},
		keys = {
			{
				"-",
				mode = { "n" },
				function()
					require("oil").open()
				end,
				desc = "Open parent directory",
			},
		},
		config = function()
			require("oil").setup({
				use_default_keymaps = false,
				keymaps = {
					["<CR>"] = "actions.select",
				},
				view_options = {
					show_hidden = true,
					is_hidden_file = function(name, bufnr)
						return vim.startswith(name, ".")
					end,
					is_always_hidden = function(name, bufnr)
						return false
					end,
				},
				-- Configuration for the floating window in oil.open_float
				float = {
					-- Padding around the floating window
					padding = 2,
					max_width = 0,
					max_height = 0,
					border = "rounded",
					win_options = {
						winblend = 10,
					},
				},
			})

			nnoremap("-", require("oil").open, { desc = "Open parent directory" })
		end,
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- refactoring code
	{
		"ThePrimeagen/refactoring.nvim",
		keys = {
			{
				"<leader>rv",
				mode = { "n" },
				function()
					require("refactoring").debug.print_var({ normal = true })
				end,
				desc = "Comment",
			},
		},
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	},

	-- { "ThePrimeagen/vim-apm", branch = "v2" },

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		requires = { "nvim-lua/plenary.nvim" },
		keys = {
			{
				"<leader>a",
				mode = { "n" },
				function()
					local harpoon = require("harpoon")
					harpoon:setup({
						settings = {
							save_on_toggle = true,
							sync_on_ui_close = true,
						},
					})
					harpoon:list():append()
				end,
				desc = "Add file to harpoon",
			},
			{
				"<C-e>",
				mode = { "n" },
				function()
					local harpoon = require("harpoon")
					harpoon:setup()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "Toggle harpoon menu",
			},
			{
				"<C-b>",
				mode = { "n" },
				function()
					local harpoon = require("harpoon")
					harpoon:setup()
					harpoon:list():select(1)
				end,
				desc = "Select harpoon item 1",
			},
			{
				"<C-i>",
				mode = { "n" },
				function()
					local harpoon = require("harpoon")
					harpoon:list():select(2)
				end,
				desc = "Select harpoon item 2",
			},
			{
				"<C-g>",
				mode = { "n" },
				function()
					local harpoon = require("harpoon")
					harpoon:setup()
					harpoon:list():select(3)
				end,
				desc = "Select harpoon item 3",
			},
			{
				"<C-s>",
				mode = { "n" },
				function()
					local harpoon = require("harpoon")
					harpoon:setup()
					harpoon:list():select(4)
				end,
				desc = "Select harpoon item 4",
			},
		},
		config = function()
			local harpoon = require("harpoon")

			harpoon:setup()
		end,
	},

	-- lsp
	{
		"VonHeikemen/lsp-zero.nvim",
		-- ft = filetypes,
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim" },
		},
		branch = "v3.x",
		lazy = true,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
		config = function()
			-- This is where all the LSP shenanigans will live
			local lsp_zero = require("lsp-zero")

			lsp_zero.on_attach(function(client, bufnr)
				lsp_zero.default_keymaps({ buffer = bufnr })
				local options = { buffer = bufnr, remap = false }

				if vim.bo.filetype == "typescript" or vim.bo.filetype == "typescriptreact" then
					nnoremap("gD", "<cmd>vsplit | TSToolsGoToSourceDefinition<CR>", options)
					nnoremap("gd", "<cmd>TSToolsGoToSourceDefinition<CR>", options)

					-- for typescript types go to definition works best with the lsp and
					-- function overloads
					nnoremap("gt", vim.lsp.buf.definition, options)
					nnoremap("gT", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", options)
					nnoremap("tgt", vim.lsp.buf.type_definition, options)
					nnoremap("tgT", "<cmd>vsplit | lua vim.lsp.buf.type_definition()<CR>", options)

					nnoremap("tami", "<cmd>TSToolsAddMissingImports<CR>", options)
					nnoremap("toi", "<cmd>TSToolsOrganizeImports<CR>", options)
					nnoremap("tsi", "<cmd>TSToolsSortImports<CR>", options)
					nnoremap("tru", "<cmd>TSToolsRemoveUnusedImports<CR>", options)
					nnoremap("tfa", "<cmd>TSToolsFixAll<CR>", options)
					nnoremap("trnf", "<cmd>TSToolsRenameFile<CR>", options)
				else
					nnoremap("gt", vim.lsp.buf.type_definition, options)
					nnoremap("gT", "<cmd>vsplit | lua vim.lsp.buf.type_definition()<CR>", options)
					nnoremap("gd", vim.lsp.buf.definition, options)
					nnoremap("gD", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", options)
				end

				nnoremap("K", vim.lsp.buf.hover, options)

				local diagnostic_goto = function(next, severity)
					local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
					severity = severity and vim.diagnostic.severity[severity] or nil
					return function()
						go({ severity = severity })
					end
				end
				nnoremap("]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
				nnoremap("[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
				nnoremap("]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
				nnoremap("[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
				nnoremap("]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
				nnoremap("[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

				nnoremap("gi", vim.lsp.buf.implementation, options)
				nnoremap("<leader>ca", vim.lsp.buf.code_action, options)
				nnoremap("<leader>rn", vim.lsp.buf.rename, options)
				nnoremap("<space>e", vim.diagnostic.open_float, options)
				nnoremap("<space>q", vim.diagnostic.setloclist, options)
			end)

			lsp_zero.extend_cmp()

			lsp_zero.set_preferences({
				file_ignore_patterns = { "*.d.ts" },
				suggest_lsp_servers = true,
				sign_icons = {
					error = "E",
					warn = "W",
					hint = "H",
					info = "I",
				},
			})

			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"html",
					"cssls",
					"bashls",
					"rust_analyzer",
					"gopls",
					"tailwindcss",
				},
				handlers = {
					lsp_zero.default_setup,
					-- rust_analyzer = function()
					-- 	local rust_tools = require("rust-tools")
					-- 	rust_tools.setup({})
					-- 	rust_tools.inlay_hints.enable()
					-- end,
					lua_ls = function()
						-- (Optional) Configure lua language server for neovim
						local lua_opts = lsp_zero.nvim_lua_ls()
						require("lspconfig").lua_ls.setup(lua_opts)
					end,
				},
			})
		end,
	},

	{
		"williamboman/mason.nvim",
		cmd = { "Mason" },
		config = true,
	},

	-- lsp progress
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		config = true,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "L3MON4D3/LuaSnip" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "rafamadriz/friendly-snippets" },
		},
		config = function()
			-- Here is where you configure the autocompletion settings.
			-- And you can configure cmp even more, if you want to.
			-- add vscode like snippets support
			local lsp_zero = require("lsp-zero")

			require("luasnip.loaders.from_vscode").lazy_load()

			-- add .tsx snippets support for .ts files
			require("luasnip").filetype_extend("typescript", { "typescriptreact" })

			local cmp = require("cmp")
			local cmp_action = lsp_zero.cmp_action()
			local luasnip = require("luasnip")
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
			cmp.setup.cmdline({ "/" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
		end,
	},

	-- typescript stuff
	{
		"pmizio/typescript-tools.nvim",
		ft = { "typescript", "typescriptreact" },
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require("typescript-tools").setup({
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false

					if vim.lsp.inlay_hint then
						vim.lsp.inlay_hint(bufnr, true)
					end
				end,
				settings = {
					tsserver_file_preferences = {
						-- Inlay Hints
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayVariableTypeHintsWhenTypeMatchesName = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
			})
		end,
	},

	-- rust stuff
	{
		"simrat39/rust-tools.nvim",
		ft = "rust",
		requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		config = function()
			local rust_tools = require("rust-tools")

			rust_tools.setup({
				tools = {
					hover_actions = {
						auto_focus = true,
					},
				},

				server = {
					on_attach = function(client, bufnr)
						vim.keymap.set("n", "<leader>cha", rust_tools.hover_actions.hover_actions, { buffer = bufnr })
						vim.keymap.set("n", "<leader>cr", rust_tools.runnables.runnables, { buffer = bufnr })
						vim.keymap.set(
							"n",
							"<leader>cc",
							rust_tools.open_cargo_toml.open_cargo_toml,
							{ buffer = bufnr }
						)
					end,
				},
			})
		end,
	},

	-- smooth cursor
	{
		"gen740/SmoothCursor.nvim",
		config = true,
		opts = {
			cursor = "👉",
		},
		cmd = { "SmoothCursorStart", "SmoothCursorToggle" },
	},
})
