return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        animate = { enabled = true },
        bigfile = { enabled = true },
        bufdelete = { enabled = true },
        dashboard = {
            enabled = true,
            preset = {
                keys = {
                    { icon = " ", key = "f", desc = "Find File",    action = ":lua Snacks.picker.files()" },
                    { icon = " ", key = "g", desc = "Find Text",    action = ":lua Snacks.picker.grep()" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
                    { icon = " ", key = "c", desc = "Config",       action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
                    { icon = "󰒲 ", key = "l", desc = "Lazy",        action = ":Lazy" },
                    { icon = " ", key = "q", desc = "Quit",         action = ":qa" },
                },
            },
            sections = {
                { section = "header" },
                { section = "keys",         gap = 1, padding = 1 },
                { section = "recent_files", indent = 2, padding = 1 },
                { section = "projects",     indent = 2, padding = 1 },
                { section = "startup" },
            },
        },
        dim = { enabled = true },
        explorer = { enabled = true },
        image = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        lazygit = { enabled = true },
        notifier = {
            enabled = true,
            timeout = 3000,
        },
        picker = {
            enabled = true,
            sources = {
                explorer = {
                    -- snacks explorer は picker として動作するため auto_close を有効化
                    auto_close = true,
                },
            },
        },
        profiler = { enabled = true },
        quickfile = { enabled = true },
        rename = { enabled = true },
        scope = { enabled = true },
        scratch = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        terminal = {
            enabled = true,
            win = { style = "terminal" },
        },
        words = { enabled = true },
        zen = {
            enabled = true,
            toggles = {
                dim = true,
                git_signs = false,
                mini_diff_signs = false,
                diagnostics = false,
                inlay_hints = false,
            },
        },
        styles = {
            notification = {
                -- wo = { wrap = true } -- 通知テキストを折り返す場合は有効化
            },
        },
    },

    keys = {
        {
            "<leader>N",
            function()
                Snacks.win({
                    file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
                    width = 0.6,
                    height = 0.6,
                    wo = {
                        spell = false,
                        wrap = false,
                        signcolumn = "yes",
                        statuscolumn = " ",
                        conceallevel = 3,
                    },
                })
            end,
            desc = "Neovim News",
        },
    },

    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- デバッグユーティリティをグローバルに公開
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- `:=` コマンドを snacks 経由にする

                -- UI トグル
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                Snacks.toggle.diagnostics():map("<leader>ud")
                Snacks.toggle.line_number():map("<leader>ul")
                Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
                Snacks.toggle.treesitter():map("<leader>uT")
                Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
                Snacks.toggle.inlay_hints():map("<leader>uh")
                Snacks.toggle.indent():map("<leader>ug")
                Snacks.toggle.dim():map("<leader>uD")
                Snacks.toggle.animate():map("<leader>uA")
                Snacks.toggle.scroll():map("<leader>uS")
                -- プロファイラー
                Snacks.toggle.profiler():map("<leader>pp")
                Snacks.toggle.profiler_highlights():map("<leader>ph")
                -- 透明背景
                Snacks.toggle({
                    name = "Transparency",
                    get = function() return vim.o.winblend > 0 end,
                    set = function(enabled)
                        if enabled then
                            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
                            vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
                            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
                            vim.o.winblend = 20
                            vim.o.pumblend = 20
                        else
                            require("catppuccin").setup({ flavour = "macchiato", transparent_background = false })
                            vim.cmd.colorscheme("catppuccin")
                            vim.o.winblend = 0
                            vim.o.pumblend = 0
                        end
                    end,
                }):map("<leader>ut")
            end,
        })
    end,
}
