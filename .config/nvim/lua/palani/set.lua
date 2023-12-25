vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.errorbells = false

vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.textwidth = 80

vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
vim.opt.synmaxcol = 200

vim.opt.showmode = false

vim.opt.smartindent = true

vim.opt.cursorline = true

-- decent crisp seperator
vim.cmd("highlight WinSeparator guibg=None")

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- vim.opt.undofile = true
-- vim.opt.undodir = os.getenv("HOME") .. "/.undodir"

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appear/become resolved.
vim.opt.signcolumn = "yes"

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.splitright = true

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50
vim.opt.clipboard = "unnamedplus"
vim.g.mapleader = " "
