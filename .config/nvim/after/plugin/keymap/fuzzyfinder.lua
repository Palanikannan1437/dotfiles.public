local nnoremap = require("palani.keymap").nnoremap

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

nnoremap("<leader>gi", function()
	require("fzf-lua").grep({
		fzf_opts = { ["--layout"] = "reverse-list" },
		raw_cmd = [[git status -su | rg "^\s*M" | cut -d ' ' -f3 | xargs rg --hidden --column --line-number --no-heading --color=always --smart-case --with-filename --max-columns=4096 -e '']],
	})
end, { silent = true })

nnoremap(
	"<leader>go",
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
	"<cmd>lua require('fzf-lua').lsp_workspace_diagnostics({ fzf_opts = {['--layout'] = 'reverse-list'} })<CR>",
	{ silent = true }
)

local live_grep_cwd = function()
	require("fzf-lua").fzf_exec("fd --type d -H --exclude=.git", {
		actions = {
			["default"] = function(sel, opts)
				require("fzf-lua").live_grep({ cwd = sel[1], fzf_opts = { ["--layout"] = "reverse-list" } })
			end,
		},
	})
end

nnoremap("<leader>g", live_grep_cwd, { silent = true })
nnoremap("<leader>u", "<cmd>lua require('fzf-lua').resume()<CR>", { silent = true })
