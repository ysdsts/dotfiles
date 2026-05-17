-- bookmark-list.yazi
-- bookmarks.yazi の DDS チャネルを購読し、fzf でブックマーク一覧を表示してジャンプする。
-- 注意: ps.sub_remote は ya.sync コンテキスト内から呼ぶ必要がある。

-- DDS 購読を ya.sync でラップ（bookmarks.yazi の _load_state と同じパターン）
local subscribe = ya.sync(function(state)
	ps.sub_remote("@bookmarks", function(body)
		state.bookmarks = {}
		if not body then return end
		for _, v in pairs(body) do
			table.insert(state.bookmarks, v)
		end
		table.sort(state.bookmarks, function(a, b)
			local ka, kb = a.on, b.on
			if ka:match("%d") and not kb:match("%d") then return true end
			if kb:match("%d") and not ka:match("%d") then return false end
			if ka:match("%u") and kb:match("%l") then return true end
			if kb:match("%u") and ka:match("%l") then return false end
			return ka < kb
		end)
	end)
	ps.sub_remote("@bookmarks-last", function(body)
		state.last_dir = body
	end)
end)

local sync_state = ya.sync(function(state)
	return state.bookmarks or {}, state.last_dir
end)

return {
	setup = function(_, _)
		subscribe()
	end,

	entry = function(_, _)
		local bookmarks, last_dir = sync_state()

		local all = {}
		for _, bm in ipairs(bookmarks) do
			table.insert(all, bm)
		end
		if last_dir then
			table.insert(all, {
				on = "''",
				desc = last_dir.desc,
				path = last_dir.path,
				is_parent = last_dir.is_parent,
			})
		end

		if #all == 0 then
			ya.notify({ title = "Bookmarks", content = "No bookmarks saved", timeout = 2 })
			return
		end

		-- fzf 入力: "KEY   DESCRIPTION"
		local lines = {}
		for _, bm in ipairs(all) do
			table.insert(lines, string.format("%-5s %s", bm.on, bm.desc))
		end

		local tmpfile = os.tmpname()
		local f = io.open(tmpfile, "w")
		if not f then
			ya.notify({ title = "Bookmarks", content = "Failed to open temp file", timeout = 2 })
			return
		end
		f:write(table.concat(lines, "\n") .. "\n")
		f:close()

		-- yazi の TUI を一時停止して fzf をインタラクティブ起動
		local permit = ya.hide()
		local handle = io.popen(
			string.format(
				'fzf --prompt="Bookmark> " --layout=reverse --border=rounded'
					.. ' --height=~40%% --info=inline --no-sort < "%s"',
				tmpfile
			)
		)
		local result = ""
		if handle then
			result = handle:read("*all") or ""
			handle:close()
		end
		permit:drop()

		os.remove(tmpfile)

		result = result:gsub("[\n\r]+$", "")
		if result == "" then return end

		local key = result:match("^(%S+)")
		if not key then return end

		if key == "''" then
			if last_dir then
				if last_dir.is_parent then
					ya.mgr_emit("cd", { last_dir.path })
				else
					ya.mgr_emit("reveal", { last_dir.path })
				end
			end
			return
		end

		for _, bm in ipairs(bookmarks) do
			if bm.on == key then
				if bm.is_parent then
					ya.mgr_emit("cd", { bm.path })
				else
					ya.mgr_emit("reveal", { bm.path })
				end
				return
			end
		end
	end,
}
