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

	-- preview markdown in neovim
	{
		"henriklovhaug/Preview.nvim",
		cmd = { "Preview" },
		config = function()
			require("preview").setup()
		end,
	},

	-- obsidian
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "personal",
					path = "/Users/palanikannan/Documents/work/notes",
				},
			},

			-- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
			completion = {
				-- Set to false to disable completion.
				nvim_cmp = true,
				-- Trigger completion at 2 chars.
				min_chars = 2,
			},

			mappings = {
				-- Toggle check-boxes.
				["<leader>ch"] = {
					action = function()
						return require("obsidian").util.toggle_checkbox()
					end,
					opts = { buffer = true },
				},
			},
			ui = {
				enable = true, -- set to false to disable all additional syntax features
				update_debounce = 200, -- update delay after a text change (in milliseconds)
				-- Define how various check-boxes are displayed
				checkboxes = {
					-- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
					[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
					["x"] = { char = "", hl_group = "ObsidianDone" },
					[">"] = { char = "", hl_group = "ObsidianRightArrow" },
					["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
					-- Replace the above with this if you don't have a patched font:
					-- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
					-- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

					-- You can also add more custom ones...
				},
				-- Use bullet marks for non-checkbox lists.
				bullets = { char = "•", hl_group = "ObsidianBullet" },
				external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
				-- Replace the above with this if you don't have a patched font:
				-- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
				reference_text = { hl_group = "ObsidianRefText" },
				highlight_text = { hl_group = "ObsidianHighlightText" },
				tags = { hl_group = "ObsidianTag" },
				block_ids = { hl_group = "ObsidianBlockID" },
				hl_groups = {
					-- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
					ObsidianTodo = { bold = true, fg = "#f78c6c" },
					ObsidianDone = { bold = true, fg = "#89ddff" },
					ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
					ObsidianTilde = { bold = true, fg = "#ff5370" },
					ObsidianBullet = { bold = true, fg = "#89ddff" },
					ObsidianRefText = { underline = true, fg = "#c792ea" },
					ObsidianExtLinkIcon = { fg = "#c792ea" },
					ObsidianTag = { italic = true, fg = "#89ddff" },
					ObsidianBlockID = { italic = true, fg = "#89ddff" },
					ObsidianHighlightText = { bg = "#75662e" },
				},
			},

			-- Specify how to handle attachments.
			attachments = {
				-- The default folder to place images in via `:ObsidianPasteImg`.
				-- If this is a relative path it will be interpreted as relative to the vault root.
				-- You can always override this per image by passing a full path to the command instead of just a filename.
				img_folder = "assets/imgs", -- This is the default
				-- A function that determines the text to insert in the note when pasting an image.
				-- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
				-- This is the default implementation.
				---@param client obsidian.Client
				---@param path obsidian.Path the absolute path to the image file
				---@return string
				img_text_func = function(client, path)
					path = client:vault_relative_path(path) or path
					return string.format("![%s](%s)", path.name, path)
				end,
			},

			-- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
			open_app_foreground = true,
			picker = {
				-- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
				name = "fzf-lua",
				-- Optional, configure key mappings for the picker. These are the defaults.
				-- Not all pickers support all mappings.
				mappings = {
					-- Create a new note from your query.
					new = "<C-x>",
					-- Insert a link to the selected note.
					insert_link = "<C-l>",
				},
			},
		},
	},
	-- Use your favorite package manager to install, for example in lazy.nvim
	--  Optionally, you can also install nvim-telescope/telescope.nvim to use some search functionality.
	{
		{
			"sourcegraph/sg.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope.nvim",
			},
			config = true,
			-- If you have a recent version of lazy.nvim, you don't need to add this!
			build = "nvim -l build/init.lua",
		},
	},

	-- fuzzyfinder
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	},

	-- something for after v10 neovim
	-- tailwind-tools.lua
	{
		"luckasRanarison/tailwind-tools.nvim",
		opts = {}, -- your configuration
	},

	-- { "chrisgrieser/nvim-dr-lsp" },
	-- status and window line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local utils = require("lualine.utils.utils")
			local highlight = require("lualine.highlight")

			local diagnostics_message = require("lualine.component"):extend()

			diagnostics_message.default = {
				colors = {
					error = utils.extract_color_from_hllist(
						{ "fg", "sp" },
						{ "DiagnosticError", "LspDiagnosticsDefaultError", "DiffDelete" },
						"#e32636"
					),
					warning = utils.extract_color_from_hllist(
						{ "fg", "sp" },
						{ "DiagnosticWarn", "LspDiagnosticsDefaultWarning", "DiffText" },
						"#ffa500"
					),
					info = utils.extract_color_from_hllist(
						{ "fg", "sp" },
						{ "DiagnosticInfo", "LspDiagnosticsDefaultInformation", "DiffChange" },
						"#ffffff"
					),
					hint = utils.extract_color_from_hllist(
						{ "fg", "sp" },
						{ "DiagnosticHint", "LspDiagnosticsDefaultHint", "DiffAdd" },
						"#273faf"
					),
				},
			}
			function diagnostics_message:init(options)
				diagnostics_message.super:init(options)
				self.options.colors =
					vim.tbl_extend("force", diagnostics_message.default.colors, self.options.colors or {})
				self.highlights = { error = "", warn = "", info = "", hint = "" }
				self.highlights.error = highlight.create_component_highlight_group(
					{ fg = self.options.colors.error },
					"diagnostics_message_error",
					self.options
				)
				self.highlights.warn = highlight.create_component_highlight_group(
					{ fg = self.options.colors.warn },
					"diagnostics_message_warn",
					self.options
				)
				self.highlights.info = highlight.create_component_highlight_group(
					{ fg = self.options.colors.info },
					"diagnostics_message_info",
					self.options
				)
				self.highlights.hint = highlight.create_component_highlight_group(
					{ fg = self.options.colors.hint },
					"diagnostics_message_hint",
					self.options
				)
			end

			function diagnostics_message:update_status(is_focused)
				local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
				local diagnostics = vim.diagnostic.get(0, { lnum = r - 1 })
				if #diagnostics > 0 then
					local top = diagnostics[1]
					for _, d in ipairs(diagnostics) do
						if d.severity < top.severity then
							top = d
						end
					end
					local icons = { " ", " ", " ", " " }
					local hl = {
						self.highlights.error,
						self.highlights.warn,
						self.highlights.info,
						self.highlights.hint,
					}
					local length_max = 90
					local message = top.message

					if #message > length_max then
						message = string.sub(top.message, 1, length_max) .. " [...]"
					end

					return highlight.component_format_highlight(hl[top.severity])
						.. icons[top.severity]
						.. " "
						.. utils.stl_escape(message)
				else
					return ""
				end
			end

			local cyberdream = require("lualine.themes.cyberdream")
			require("lualine").setup({
				options = {
					-- theme = "catppuccin",
					theme = cyberdream,
					globalstatus = true,
					separator = " ",
				},
				sections = {
					lualine_c = {

						{
							diagnostics_message,
							colors = {
								error = "#BF616A",
								warn = "#EBCB8B",
								info = "#A3BE8C",
								hint = "#88C0D0",
							},
						},
					},

					lualine_a = {},
					lualine_z = {
						{
							"harpoon2",
							indicators = { "b", "i", "g", "s" },
							active_indicators = { "B", "I", "G", "S" },
							separator = " ",
						},
					},
					lualine_x = {},
					lualine_y = {},
					lualine_b = {
						-- { require("dr-lsp").lspCount },
					},
				},
				winbar = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {
						{
							"filename",
							path = 1,
						},
					},
					lualine_y = { "diagnostics" },
					lualine_z = {},
				},
				inactive_winbar = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {
						{
							"filename",
							path = 1,
						},
					},
					lualine_y = { "diagnostics" },
					lualine_z = {},
				},
				extensions = {},
			})
		end,
	},

	{
		"letieu/harpoon-lualine",
		dependencies = {
			{
				"ThePrimeagen/harpoon",
				branch = "harpoon2",
			},
		},
	},
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
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({})
		end,
	},

	-- call tracing
	{
		"ldelossa/litee.nvim",
		event = "VeryLazy",
		opts = {
			notify = { enabled = false },
			panel = {
				orientation = "bottom",
				panel_size = 10,
			},
		},
		config = function(_, opts)
			require("litee.lib").setup(opts)
		end,
	},

	{
		"ldelossa/litee-calltree.nvim",
		dependencies = "ldelossa/litee.nvim",
		event = "VeryLazy",
		opts = {
			on_open = "panel",
			map_resize_keys = false,
		},
		config = function(_, opts)
			require("litee.calltree").setup(opts)
		end,
	},

	-- theme
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("cyberdream").setup({
				-- Recommended - see "Configuring" below for more config options
				transparent = true,
				italic_comments = true,
				hide_fillchars = true,
				borderless_telescope = true,
				terminal_colors = true,
			})
			vim.cmd("colorscheme cyberdream") -- set the colorscheme
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
				ensure_installed = {
					"c",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"markdown",
					"markdown_inline",
					"tsx",
					"typescript",
					"rust",
					"python",
					"go",
				},
				sync_install = true,
				auto_install = true,
				ignore_install = { "" },
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
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

					lsp_interop = {
						enable = true,
						border = "rounded",
						floating_preview_opts = {},
						peek_definition_code = {
							["<leader>k"] = "@function.outer",
							["<leader>i"] = "@class.outer",
						},
					},

					select = {
						enable = true,

						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,
						keymaps = {
							["aa"] = "@conditional.outer",
							["ia"] = "@conditional.inner",

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
		dependencies = "nvim-treesitter/nvim-treesitter",
		-- lazy = true,
		config = function()
			require("nvim-treesitter.configs").setup({})
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

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
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
