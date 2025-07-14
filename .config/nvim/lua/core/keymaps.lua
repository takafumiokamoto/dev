-- clipboard
vim.keymap.set("v", "<C-c>", [["+y]], { desc = "Copy to Clipboard" })
vim.keymap.set("v", "<C-x>", [["+d]], { desc = "Cut to Clipboard" })
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select All" })

-- multiline edit
vim.keymap.set("v", "<S-i>", "<C-v>^<S-i>", { desc = "Multiline edit from top of line" })
vim.keymap.set("v", "<S-a>", "<C-v>$<S-a>", { desc = "Multiline edit from end of line" })

-- lsp
vim.keymap.set("n", "gd", "<cmd>:lua vim.lsp.buf.definition()<CR>")

-- tab
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- split
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

--buffer
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Go to next buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Go to previous buffer" })
vim.keymap.set("n", "<C-w>", "<cmd>bd<CR>", { desc = "Remove file from buffer" })

-- telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
-- vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
-- vim.keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Fuzzy find buffer" })
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope luasnip<cr>", { desc = "Fuzzy find buffer" })
vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

-- no neck pain
vim.keymap.set({ "i", "n", "v" }, "<leader>nn", "<cmd>NoNeckPain<cr>", { desc = "Toggle NoNeckPain" })

-- misc
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
vim.keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })
vim.keymap.set("v", "<", "<gv", { desc = "Outdent lines" }) -- < outdents, gv re-selects
vim.keymap.set("v", ">", ">gv", { desc = "Indent lines" }) -- > indents, gv re-selects

-- nvim-tree
vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer

-- Move lines down in visual mode
-- :'<,'>m '>+1<CR> moves the selected lines (from start of selection ' to end of selection ')
-- to one line after the end of the selection ('>+1).
-- gv re-selects the moved block.
vim.keymap.set("v", "J", ":'<,'>m '>+1<CR>gv", { desc = "Move lines down" })
-- Move lines up in visual mode
-- :'<,'>m '<-2<CR> moves the selected lines
-- to two lines before the start of the selection ('<-2). This effectively moves it up by one line.
-- gv re-selects the moved block.
vim.keymap.set("v", "K", ":'<,'>m '<-2<CR>gv", { desc = "Move lines up" })
