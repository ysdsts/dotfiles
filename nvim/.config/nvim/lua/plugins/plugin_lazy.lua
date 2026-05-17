return {
	{
		"vim-jp/vimdoc-ja",
		build = function(plugin)
			-- doc/tags-ja は CI 生成ファイルだが :helptags に上書きされるため
			-- git が dirty と判定し次回更新が失敗する。変更追跡をスキップする。
			vim.fn.system({ "git", "-C", plugin.dir, "update-index", "--skip-worktree", "doc/tags-ja" })
		end,
	},

	{
		"keaising/im-select.nvim",
		config = function()
			require("im_select").setup({
				default_im_select = "com.justsystems.inputmethod.atok34.Roman",
				default_command = "macism",
				set_default_events = { "VimEnter", "InsertEnter", "InsertLeave" },
				set_previous_events = {},
			})
		end,
	},

	-- colorscheme (lazy-loaded、:colorscheme や picker で切り替え可能)
	{ "jonathanfilip/vim-lucius" },
	{ "folke/tokyonight.nvim" },
	{ "sainnhe/everforest" },

	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {},
		version = "^1.0.0",
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {},
		event = "VeryLazy",
	},

	{
		"kdheepak/tabline.nvim",
		opts = {},
		event = "BufWinEnter",
	},

	{
		"numToStr/Comment.nvim",
		opts = {},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufRead", "BufNewFile", "InsertEnter" },
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				ensure_installed = {
					"awk",
					"bash",
					"comment",
					"c",
					"css",
					"csv",
					"diff",
					"gpg",
					"html",
					"htmldjango",
					"java",
					"javascript",
					"json",
					"lua",
					"markdown",
					"python",
					"rust",
					"sql",
					"ssh_config",
					"tmux",
					"toml",
					"vim",
					"xml",
					"yaml",
					"regex",
					"vimdoc",
				},
				sync_install = false,
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		opts = {
			-- vim.notify は snacks.notifier に委譲する
			notify = { enabled = false },
			routes = {
				{
					filter = { event = "msg_show", find = "E486: Pattern not found: .*" },
					opts = { skip = true },
				},
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
				},
			},
		},
	},

	{
		"lewis6991/gitsigns.nvim",
		config = true,
		event = { "BufReadPre", "BufNewFile" },
	},
}
