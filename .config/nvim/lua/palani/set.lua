vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.errorbells = false

vim.opt.ttimeoutlen = 0
vim.opt.cursorline = true

-- decent crisp seperator
vim.cmd("highlight WinSeparator guibg=#2e3440")

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.splitright = true
vim.opt.splitbelow = true

-- scroll starts while the cursor is at the middle itself instead of starting
-- when the cursor hits the top
-- vim.opt.scrolloff = 999

-- virtual edit for ctrl+v i.e. visual block mode
vim.opt.virtualedit = "block"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.textwidth = 80

vim.opt.showmode = false

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.signcolumn = "yes"

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.o.completeopt = "menuone,noselect"

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.opt.clipboard = "unnamedplus"

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- common status lines across buffer
vim.opt.laststatus = 3
