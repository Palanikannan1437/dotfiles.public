local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop
local nnoremap = require("palani.keymap").nnoremap

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

require("lazy").setup({
	-- dependencies
	"nvim-lua/plenary.nvim",

	-- icons
	"nvim-tree/nvim-web-devicons",

	-- fuzzy finder
	"ibhagwan/fzf-lua",

	-- window navigation
	{ "christoomey/vim-tmux-navigator", event = "VeryLazy" },

	-- GIT STUFF --
	-- git signs
	{
		"lewis6991/gitsigns.nvim",
		-- ft = filetypes,
		event = { "BufReadPre", "BufNewFile" },
		config = true,
		opts = function()
			local icons = require("palani.icons")
			local C = {
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end
					-- Navigation
					map({ "n", "v" }, "]g", function()
						if vim.wo.diff then
							return "]g"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Jump to next hunk" })

					map({ "n", "v" }, "[g", function()
						if vim.wo.diff then
							return "[g"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Jump to previous hunk" })

					-- Actions
					-- visual mode
					map("v", "<leader>gs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "stage git hunk" })
					map("v", "<leader>gr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "reset git hunk" })
					-- normal mode
					map("n", "<leader>gs", gs.stage_hunk, { desc = "git stage hunk" })
					map("n", "<leader>gr", gs.reset_hunk, { desc = "git reset hunk" })
					map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "undo stage hunk" })

					-- Toggles
					map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "toggle git blame line" })

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select git hunk" })
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
				"ghh",
				mode = { "n" },
				"<cmd>:normal gcc<CR>",
				desc = "Comment",
			},
			{
				"gh",
				mode = { "v" },
				"<cmd>:normal gcc<CR>",

				desc = "Comment",
			},
		},
	},

	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		keys = {
			{
				"ghh",
				mode = { "n" },
				"<cmd>:normal gcc<CR>",
				desc = "Comment",
			},
			{
				"gh",
				mode = { "v" },
				"<cmd>:normal gcc<CR>",

				desc = "Comment",
			},
		},
	},

	{ "ThePrimeagen/vim-apm" },

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
			vim.cmd.colorscheme("catppuccin-mocha")
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
				mode = { "n", "v", "x" },
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

	-- treesitter syntax highlighting
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
				auto_install = true,
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
						set_jumps = true,
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
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",

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
						selection_modes = {
							["@function.outer"] = "V",
							["@class.outer"] = "V",
							["@call.outer"] = "v",
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

	-- nvim fncolors
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
				desc = "Print a variable",
			},
			{
				"<leader>rc",
				mode = { "n" },
				function()
					require("refactoring").debug.cleanup({})
				end,
				desc = "Cleanup print statements",
			},
		},
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	},

	-- harpooooon for quick file switching
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		requires = { { "nvim-lua/plenary.nvim" } },
		event = "VeryLazy",
	},

	-- better ts tools
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},

	-- lsp progress
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		config = true,
	},

	-- lsp
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		lazy = true,
		config = false,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
		dependencies = {
			-- Mason Support for installing and managing LSP Servers
			{
				"williamboman/mason.nvim",
				lazy = false,
				config = true,
			},
			"williamboman/mason-lspconfig.nvim",

			-- LSP Support
			{
				"neovim/nvim-lspconfig",
				cmd = "LspInfo",
				event = { "BufReadPre", "BufNewFile" },
				dependencies = {
					-- Autocompletion
					"saadparwaiz1/cmp_luasnip",
					"rafamadriz/friendly-snippets",
					{
						"hrsh7th/nvim-cmp",
						event = "InsertEnter",
						dependencies = {
							{
								"L3MON4D3/LuaSnip",
								dependencies = { "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" },
							},
						},
					},
					{
						"L3MON4D3/LuaSnip",
						dependencies = { "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" },
					},
					"hrsh7th/cmp-nvim-lsp",
					"hrsh7th/cmp-nvim-lua",
					"hrsh7th/cmp-buffer",
					"hrsh7th/cmp-path",
				},
			},
		},
	},
	-- for better quick fix list
	-- {
	-- 	"kevinhwang91/nvim-bqf",
	-- 	event = "VeryLazy",
	-- },

	{ "stefandtw/quickfix-reflector.vim", event = "VeryLazy" },

	-- for live diagnostics population in quickfix list
	{
		"onsails/diaglist.nvim",
		keys = {
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

	{
		"gen740/SmoothCursor.nvim",
		config = true,
		opts = {
			cursor = "👉",
		},
		cmd = { "SmoothCursorStart", "SmoothCursorToggle" },
	},
	{
		"folke/zen-mode.nvim",
		config = function()
			vim.keymap.set("n", "<leader>z", function()
				require("zen-mode").setup({
					window = {
						width = 90,
						options = {},
					},
				})
				require("zen-mode").toggle()
				vim.wo.wrap = false
				vim.wo.number = true
				vim.wo.rnu = true
			end)

			vim.keymap.set("n", "<leader>Z", function()
				require("zen-mode").setup({
					window = {
						width = 80,
						options = {},
					},
				})
				require("zen-mode").toggle()
				vim.wo.wrap = false
				vim.wo.number = false
				vim.wo.rnu = false
				vim.opt.colorcolumn = "0"
			end)
		end,
	},
})
