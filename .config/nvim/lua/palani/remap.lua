local nnoremap = require("palani.keymap").nnoremap
local vnoremap = require("palani.keymap").vnoremap

--moving around selected text in visual mode
vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")

-- apped lines below with cursor staying in the same position
nnoremap("J", "mzJ`z")
nnoremap("Q", "<nop>")

-- tmux navigator
nnoremap("<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- search and replace
nnoremap("<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- disable up, down, left and right arrow keys
nnoremap("<up>", "<nop>")
nnoremap("<down>", "<nop>")
nnoremap("<left>", "<nop>")
nnoremap("<right>", "<nop>")

-- quickfix list
vim.keymap.set("n", "<C-n>", "<cmd>:cnext<CR>")
vim.keymap.set("n", "<C-p>", "<cmd>:cprev<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>:copen<CR>")
vim.keymap.set("n", "<leader>c", "<cmd>:cclose<CR>")

-- switching between alternate files made easier
nnoremap("<leader><leader>", "<C-^>")

--window size management
nnoremap("<C-Left>", ":vertical resize -3<CR>")
nnoremap("<C-Right>", ":vertical resize +3<CR>")
nnoremap("<C-Up>", ":resize -3<CR>")
nnoremap("<C-Down>", ":resize +3<CR>")

--jumping around vim vertically
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")

-- pasting on new line
nnoremap("<leader>P", "<cmd>pu<CR>")

-- copying the entire file
nnoremap("<leader>y", "ggyG")

-- selecting the entire file
nnoremap("<leader>v", "ggVG")

-- add a new line without entering insert mode
nnoremap("<leader>o", "mOo<Esc>`O")
nnoremap("<leader>O", "moO<Esc>`o")

--navigating while searching
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")

-- move to next and previous buffers
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", {
	desc = "Prev buffer",
})
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", {
	desc = "Next buffer",
})

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- surround selection with backticks
local function get_visual_selection()
	local _, ls, cs, _ = unpack(vim.fn.getpos("v"))
	local _, le, ce, _ = unpack(vim.fn.getpos("."))

	-- Swap if the selection is made from bottom to top
	if ls > le or (ls == le and cs > ce) then
		ls, le = le, ls
		cs, ce = ce, cs
	end

	return vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
end

local function surround_selection_with_backticks()
	-- Get the visual selection
	local lines = get_visual_selection()

	-- Ensure lines are not nil
	if not lines or #lines == 0 then
		print("No lines selected")
		return
	end

	-- Surround the text with triple dots
	table.insert(lines, 1, "```")
	table.insert(lines, "```")

	-- Join the lines into a single string
	local text = table.concat(lines, "\n")

	-- Copy the text to the system clipboard
	vim.fn.setreg("+", text)
	print("Copied to clipboard with surrounding backticks")
end

vim.keymap.set("v", "<leader>c", surround_selection_with_backticks, { desc = "Surround selection with backticks" })
