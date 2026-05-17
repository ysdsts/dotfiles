local vim = vim

-- vim.cmd('language en_US')
vim.opt.helplang = "ja"

-- ファイル
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hidden = true -- バッファを切り替える際にファイル保存不要
vim.opt.confirm = true -- バッファ終了前に確認

--vim.opt.ambiwidth = "double"
vim.opt.clipboard:append({ "unnamedplus" }) -- レジスタとクリップボードを共有

vim.opt.title = true

vim.opt.undofile = true -- undo履歴をファイルに保存する(undodir)

vim.opt.wildmenu = true -- コマンドラインで補完
vim.opt.cmdheight = 1 -- コマンドラインの表示行数
vim.opt.laststatus = 3 -- 下部にステータスラインを表示 3:画面を縦分割してもステータスバーを分割しない
vim.opt.showcmd = true -- コマンドラインに入力されたコマンドを表示

vim.opt.hlsearch = true -- ハイライト検索を有効
vim.opt.incsearch = true -- インクリメンタルサーチを有効
vim.opt.matchtime = 1 -- 入力文字列がマッチするまでにかかる時間
vim.opt.inccommand = "split" -- 置換をインタラクティブ変更する

vim.opt.termguicolors = true -- 24ビットカラーを使用
vim.opt.winblend = 20 -- ウィンドウ不透明度
vim.opt.pumblend = 20 -- ポップアップメニューの不透明度
vim.opt.background = "dark" -- ダークカラー

vim.opt.shiftwidth = 4 -- シフト幅(自動インデントの幅)
vim.opt.tabstop = 4 -- タブ幅
vim.opt.softtabstop = 0 -- shiftwidthに追随
vim.opt.expandtab = true -- タブをスペースに変換
vim.opt.autoindent = true -- 自動インデント
vim.opt.smartindent = true -- スマートインデント
vim.opt.smarttab = true -- スマートタブ

vim.opt.number = true -- 行番号
vim.opt.numberwidth = 6 -- 行番号のカラム最小幅
vim.opt.relativenumber = true -- 相対行番号
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10
vim.opt.foldcolumn = "1" -- snacks.nvim statuscolumnのfoldを優先
vim.opt.statuscolumn = "" -- snacks.nvim statuscolumnの優先

vim.opt.wrap = true -- 自動折り返し
vim.opt.breakindent = true -- 折り返し行を同じインデントで表示する
vim.opt.showtabline = 2 -- タブライン表示
vim.opt.visualbell = true
vim.opt.showmatch = true -- 対応する括弧をハイライト表示

vim.opt.splitbelow = true -- 画面分割時、新しいバッファを下に開く
vim.opt.splitright = true -- 画面分割時、新しいバッファを右に開く

vim.opt.signcolumn = "yes" -- サインカラム表示
vim.opt.list = true -- タブ文字と行末文字を表示
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

--vim.opt.cursorline = true
--vim.api.nvim_set_hl(0, "LineNr", { fg = "#ffffff" })        -- 行番号の色
--vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffffff" })  -- カーソル行の行番号
vim.opt.completeopt = {
	"fuzzy",
	"popup",
	"menuone", -- show menu even if only one candidate
	"noinsert",
}
vim.opt.wildmode = "longest:full,full"

-- カラースキームの影響回避（ColorScheme 再適用後も維持するため autocmd + 即時適用）
local function apply_highlights()
    vim.api.nvim_set_hl(0, "LineNr",       { fg = "#5f87af" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffaf00" })
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#8aadf4" })
end
vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("CustomHighlights", { clear = true }),
    callback = apply_highlights,
})
apply_highlights()
