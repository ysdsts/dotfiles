-- bm.yazi
-- ファイルベースのブックマークプラグイン（DDS 非依存）
-- actions: save / jump / list / delete / delete_all

local BM_FILE = (os.getenv("HOME") or "") .. "/.config/yazi/bookmarks.tsv"

-- 0-9, A-Z, a-z の全候補キー一覧
local ALL_KEYS = {}
do
	for i = 0, 9 do
		table.insert(ALL_KEYS, tostring(i))
	end
	for i = string.byte("A"), string.byte("Z") do
		table.insert(ALL_KEYS, string.char(i))
	end
	for i = string.byte("a"), string.byte("z") do
		table.insert(ALL_KEYS, string.char(i))
	end
end

local function sort_bookmarks(t)
	table.sort(t, function(a, b)
		local ka, kb = a.on, b.on
		if ka:match("%d") and not kb:match("%d") then return true end
		if kb:match("%d") and not ka:match("%d") then return false end
		if ka:match("%u") and kb:match("%l") then return true end
		if kb:match("%u") and ka:match("%l") then return false end
		return ka < kb
	end)
end

local function read_bookmarks()
	local bms = {}
	local f = io.open(BM_FILE, "r")
	if not f then return bms end
	for line in f:lines() do
		local key, path = line:match("^([^\t]+)\t(.+)$")
		if key and path then
			table.insert(bms, { on = key, path = path, desc = path })
		end
	end
	f:close()
	sort_bookmarks(bms)
	return bms
end

local function write_bookmarks(bms)
	local f = io.open(BM_FILE, "w")
	if not f then return false end
	for _, bm in ipairs(bms) do
		f:write(bm.on .. "\t" .. bm.path .. "\n")
	end
	f:close()
	return true
end

-- 登録済みパスを desc に反映した全キー候補を返す（save 用）
local function key_cands(bms)
	local map = {}
	for _, bm in ipairs(bms) do
		map[bm.on] = bm.path
	end
	local cands = {}
	for _, k in ipairs(ALL_KEYS) do
		local short = map[k]
		if short then
			-- パスが長い場合に末尾 40 文字だけ表示
			if #short > 40 then short = "…" .. short:sub(-40) end
		end
		table.insert(cands, { on = k, desc = short or "Free" })
	end
	return cands
end

-- カレントディレクトリを同期コンテキストで取得
local get_cwd = ya.sync(function(_)
	return tostring(cx.active.current.cwd)
end)

-- fzf を使ったインタラクティブ選択。選択されたパスを返す（なければ nil）
local function fzf_select(bms)
	-- 一時ファイルにブックマーク一覧を書き出す
	local tmpfile = os.tmpname()
	local f = io.open(tmpfile, "w")
	if not f then return nil end
	for _, bm in ipairs(bms) do
		f:write(string.format("%-5s %s\n", bm.on, bm.path))
	end
	f:close()

	-- ya.hide() と ui.hide() を両方試みてどちらかを使用
	local permit
	local ok = pcall(function()
		permit = ya.hide()
	end)
	if not ok or not permit then
		pcall(function()
			permit = ui.hide()
		end)
	end

	local handle = io.popen(
		'fzf --prompt="Bookmark> " --layout=reverse --border=rounded'
			.. " --height=~40% --info=inline --no-sort"
			.. ' < "' .. tmpfile .. '"'
	)
	local result = ""
	if handle then
		result = handle:read("*all") or ""
		handle:close()
	end

	if permit then permit:drop() end
	os.remove(tmpfile)

	result = result:gsub("[\n\r]+$", "")
	if result == "" then return nil end

	-- 先頭の KEY 部分を取り出してブックマークを逆引き
	local key = result:match("^(%S+)")
	if not key then return nil end
	for _, bm in ipairs(bms) do
		if bm.on == key then return bm end
	end
	return nil
end

return {
	setup = function(_, _) end,

	entry = function(_, job)
		local action = job.args[1]
		if not action then return end

		local bms = read_bookmarks()

		-- ---- save ----
		if action == "save" then
			local cands = key_cands(bms)
			local idx = ya.which({ cands = cands })
			if not idx then return end
			local key = ALL_KEYS[idx]
			local path = get_cwd()

			-- 同じキーが既にあれば上書き
			local new_bms = {}
			for _, bm in ipairs(bms) do
				if bm.on ~= key then
					table.insert(new_bms, bm)
				end
			end
			table.insert(new_bms, { on = key, path = path, desc = path })
			sort_bookmarks(new_bms)
			write_bookmarks(new_bms)
			ya.notify({ title = "Bookmark saved", content = key .. "  →  " .. path, timeout = 2 })

		-- ---- jump ----
		elseif action == "jump" then
			if #bms == 0 then
				ya.notify({ title = "Bookmarks", content = "No bookmarks saved", timeout = 2 })
				return
			end
			local idx = ya.which({ cands = bms })
			if not idx then return end
			ya.mgr_emit("cd", { bms[idx].path })

		-- ---- list (fzf) ----
		elseif action == "list" then
			if #bms == 0 then
				ya.notify({ title = "Bookmarks", content = "No bookmarks saved", timeout = 2 })
				return
			end
			local bm = fzf_select(bms)
			if bm then
				ya.mgr_emit("cd", { bm.path })
			end

		-- ---- delete ----
		elseif action == "delete" then
			if #bms == 0 then
				ya.notify({ title = "Bookmarks", content = "No bookmarks to delete", timeout = 2 })
				return
			end
			local idx = ya.which({ cands = bms })
			if not idx then return end
			local key = bms[idx].on
			local new_bms = {}
			for _, bm in ipairs(bms) do
				if bm.on ~= key then
					table.insert(new_bms, bm)
				end
			end
			write_bookmarks(new_bms)
			ya.notify({ title = "Bookmark deleted", content = key, timeout = 1 })

		-- ---- delete_all ----
		elseif action == "delete_all" then
			local f = io.open(BM_FILE, "w")
			if f then f:close() end
			ya.notify({ title = "Bookmarks", content = "All bookmarks deleted", timeout = 2 })
		end
	end,
}
