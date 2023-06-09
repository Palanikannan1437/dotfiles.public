local Remap = require("palani.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local nmap = Remap.nmap

nnoremap("<esc><esc>", ":noh<CR>")

-- greatest remap ever
xnoremap("<leader>p", "\"_dP")
