local vim = vim
local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

local function ex_opts(desc)
	return vim.tbl_extend("force", opts, { desc = desc })
end

keymap("n", "<ESC>", ":noh<cr>", ex_opts("Rest Highlight Search"))

-- Window navigation (tmux smart navigation と連携: C-h/j/k/l を tmux 側でも使用)
keymap("n", "<C-h>", "<C-w>h", ex_opts("Window Left"))
keymap("n", "<C-j>", "<C-w>j", ex_opts("Window Down"))
keymap("n", "<C-k>", "<C-w>k", ex_opts("Window Up"))
keymap("n", "<C-l>", "<C-w>l", ex_opts("Window Right"))

----------------------------------------------------
-- Can use any plugin, so the interface is fixed.
----------------------------------------------------
------------------------
-- [Map Layer]
-- Visually grasp the project's hierarchical structure, layer structure, and component placement.
-- Candidates: Neotree / Oil / Snacks.explorer
------------------------
--keymap("n", "<leader>e", ":Neotree toggle left<cr>", ex_opts("Neotree Toggle"))
keymap("n", "<leader>e", function() Snacks.explorer() end, ex_opts("File Explorer (project root)"))
keymap("n", "<leader>E", function() Snacks.explorer({ cwd = vim.loop.cwd() }) end, ex_opts("File Explorer (cwd)"))

------------------------
-- [Locator Layer]
-- Assign “Files,” “Symbols,” and “Text” without being constrained by structure.
-- Candidates: Telescope / Snacks.picker
------------------------
-- Top pickers
keymap("n", "<leader><space>", function() Snacks.picker.smart() end, ex_opts("Smart Find Files (buffers/recent/files)"))
keymap("n", "<leader>,", function() Snacks.picker.buffers() end, ex_opts("Buffers"))
keymap("n", "<leader>/", function() Snacks.picker.grep() end, ex_opts("Grep"))
keymap("n", "<leader>:", function() Snacks.picker.command_history() end, ex_opts("Command History"))

-- Files / Projects
keymap("n", "<leader>ff", function() Snacks.picker.files() end, ex_opts("Find Files"))
keymap("n", "<leader>fg", function() Snacks.picker.git_files() end, ex_opts("Find Git Files"))
keymap("n", "<leader>fr", function() Snacks.picker.recent() end, ex_opts("Recent Files"))
keymap("n", "<leader>fb", function() Snacks.picker.buffers() end, ex_opts("Buffers"))
keymap("n", "<leader>fp", function() Snacks.picker.projects() end, ex_opts("Projects"))
keymap("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, ex_opts("Find Config File"))

-- Grep / Text
keymap("n", "<leader>sb", function() Snacks.picker.lines() end, ex_opts("Buffer Lines"))
keymap("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, ex_opts("Grep Open Buffers"))
keymap({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, ex_opts("Visual selection or word"))
keymap("n", "<leader>sg", function() Snacks.picker.grep() end, ex_opts("Grep"))

-- Various “Where to Find What” Guides
keymap("n", '<leader>s"', function() Snacks.picker.registers() end, ex_opts("Registers"))
keymap("n", "<leader>s/", function() Snacks.picker.search_history() end, ex_opts("Search History"))
keymap("n", "<leader>sc", function() Snacks.picker.command_history() end, ex_opts("Command History"))
keymap("n", "<leader>sC", function() Snacks.picker.commands() end, ex_opts("Commands"))
keymap("n", "<leader>sp", function() Snacks.picker.lazy() end, ex_opts("Search for Plugin Spec"))
keymap("n", "<leader>sR", function() Snacks.picker.resume() end, ex_opts("Resume Last Picker"))

------------------------
-- [Semantic Layer]
-- Operations for understanding “meaning,” such as LSPs, documents, and editor metadata.
------------------------
-- LSP / Code navigation
keymap("n", "gd", function() Snacks.picker.lsp_definitions() end, ex_opts("Goto Definition"))
keymap("n", "gD", function() Snacks.picker.lsp_declarations() end, ex_opts("Goto Declaration"))
keymap("n", "gr", function() Snacks.picker.lsp_references() end, ex_opts("References"))
keymap("n", "gI", function() Snacks.picker.lsp_implementations() end, ex_opts("Goto Implementation"))
keymap("n", "gy", function() Snacks.picker.lsp_type_definitions() end, ex_opts("Goto Type Definition"))
keymap("n", "gai", function() Snacks.picker.lsp_incoming_calls() end, ex_opts("Incoming Calls"))
keymap("n", "gao", function() Snacks.picker.lsp_outgoing_calls() end, ex_opts("Outgoing Calls"))
keymap("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, ex_opts("LSP Symbols"))
keymap("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, ex_opts("LSP Workspace Symbols"))

-- Editor-internal metadata
keymap("n", "<leader>sh", function() Snacks.picker.help() end, ex_opts("Help Pages"))
keymap("n", "<leader>sH", function() Snacks.picker.highlights() end, ex_opts("Highlights"))
keymap("n", "<leader>si", function() Snacks.picker.icons() end, ex_opts("Icons"))
keymap("n", "<leader>sk", function() Snacks.picker.keymaps() end, ex_opts("Keymaps"))
keymap("n", "<leader>sm", function() Snacks.picker.marks() end, ex_opts("Marks"))
keymap("n", "<leader>sM", function() Snacks.picker.man() end, ex_opts("Man Pages"))
keymap("n", "<leader>uC", function() Snacks.picker.colorschemes() end, ex_opts("Colorschemes"))

------------------------
-- [Diagnostic Layer]
-- Status verification, problem detection, history/difference verification, etc.
------------------------
-- Diagnostics / List
keymap("n", "<leader>sd", function() Snacks.picker.diagnostics() end, ex_opts("Diagnostics"))
keymap("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, ex_opts("Buffer Diagnostics"))
keymap("n", "<leader>sl", function() Snacks.picker.loclist() end, ex_opts("Location List"))
keymap("n", "<leader>sq", function() Snacks.picker.qflist() end, ex_opts("Quickfix List"))
keymap("n", "<leader>su", function() Snacks.picker.undo() end, ex_opts("Undo History"))
keymap("n", "<leader>st", function() Snacks.picker.tags() end, ex_opts("Tags"))
keymap("n", "<leader>sz", function() Snacks.picker.zoxide() end, ex_opts("Zoxide (recent dirs)"))

-- Git
keymap("n", "<leader>gs", function() Snacks.picker.git_status() end, ex_opts("Git Status"))
keymap("n", "<leader>gS", function() Snacks.picker.git_stash() end, ex_opts("Git Stash"))
keymap("n", "<leader>gb", function() Snacks.picker.git_branches() end, ex_opts("Git Branches"))
keymap("n", "<leader>gl", function() Snacks.picker.git_log() end, ex_opts("Git Log"))
keymap("n", "<leader>gL", function() Snacks.picker.git_log_line() end, ex_opts("Git Log Line"))
keymap("n", "<leader>gf", function() Snacks.picker.git_log_file() end, ex_opts("Git Log File"))
keymap("n", "<leader>gd", function() Snacks.picker.git_diff() end, ex_opts("Git Diff (Hunks)"))
-- GitHub
keymap("n", "<leader>gi", function() Snacks.picker.gh_issue() end, ex_opts("GitHub Issues (open)"))
keymap("n", "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, ex_opts("GitHub Issues (all)"))
keymap("n", "<leader>gp", function() Snacks.picker.gh_pr() end, ex_opts("GitHub PRs (open)"))
keymap("n", "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, ex_opts("GitHub PRs (all)"))

-- Profiler
keymap("n", "<leader>ps", function() Snacks.profiler.scratch() end, ex_opts("Profiler Flamegraph"))

-- Notifications
keymap("n", "<leader>n", function() Snacks.notifier.show_history() end, ex_opts("Notification History"))
keymap("n", "<leader>un", function() Snacks.notifier.hide() end, ex_opts("Dismiss All Notifications"))

------------------------
-- [Focus Layer]
------------------------
keymap("n", "<leader>z", function() Snacks.zen() end, ex_opts("Toggle Zen Mode"))
keymap("n", "<leader>Z", function() Snacks.zen.zoom() end, ex_opts("Toggle Zoom"))
keymap("n", "<leader>.", function() Snacks.scratch() end, ex_opts("Toggle Scratch Buffer"))
keymap("n", "<leader>S", function() Snacks.scratch.select() end, ex_opts("Select Scratch Buffer"))
keymap("n", "<leader>bd", function() Snacks.bufdelete() end, ex_opts("Delete Buffer"))
keymap("n", "<leader>cR", function() Snacks.rename.rename_file() end, ex_opts("Rename File"))
keymap({ "n", "v" }, "<leader>gB", function() Snacks.gitbrowse() end, ex_opts("Git Browse"))
keymap("n", "<leader>gg", function() Snacks.lazygit() end, ex_opts("Lazygit"))
keymap({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, ex_opts("Next Reference"))
keymap({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, ex_opts("Prev Reference"))
keymap("n", "<c-/>", function() Snacks.terminal() end, ex_opts("Toggle Terminal"))
keymap("n", "<c-_>", function() Snacks.terminal() end, ex_opts("Toggle Terminal (alias)"))


-- barbar
keymap("n", "<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>", opts)
keymap("n", "<Space>bn", "<Cmd>BufferOrderByName<CR>", opts)
keymap("n", "<Space>bd", "<Cmd>BufferOrderByDirectory<CR>", opts)
keymap("n", "<Space>bl", "<Cmd>BufferOrderByLanguage<CR>", opts)
keymap("n", "<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>", opts)

--vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

