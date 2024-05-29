local Remap = require("palani.keymap")

local nnoremap = Remap.nnoremap
local xnoremap = Remap.xnoremap

nnoremap("<esc><esc>", ":noh<CR>")

-- greatest remap ever
xnoremap("<leader>p", '"_dP')
