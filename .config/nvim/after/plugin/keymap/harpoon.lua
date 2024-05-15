local nnoremap = require("palani.keymap").nnoremap

local harpoon = require("harpoon")

harpoon:setup({
	settings = {
		save_on_toggle = true,
		sync_on_ui_close = true,
	},
})

nnoremap("<leader>a", function()
	harpoon:list():add()
end)
nnoremap("<C-e>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)
nnoremap("<C-b>", function()
	harpoon:list():select(1)
end)
nnoremap("<C-i>", function()
	harpoon:list():select(2)
end)
nnoremap("<C-g>", function()
	harpoon:list():select(3)
end)
nnoremap("<C-s>", function()
	harpoon:list():select(4)
end)

harpoon:extend({
	UI_CREATE = function(cx)
		vim.keymap.set("n", "<C-v>", function()
			harpoon.ui:select_menu_item({ vsplit = true })
		end, { buffer = cx.bufnr })

		vim.keymap.set("n", "<C-x>", function()
			harpoon.ui:select_menu_item({ split = true })
		end, { buffer = cx.bufnr })
	end,
})
