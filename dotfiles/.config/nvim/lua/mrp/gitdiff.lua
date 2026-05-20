-- mrp.gitdiff: a tiny workflow on top of fugitive for diffing the working
-- tree against a configurable base (vim.g.mrp_diff_base, default "HEAD").
--
-- <leader>gd  Populate the quickfix list with files changed vs the base.
-- <CR> in qf  Close qf and open the entry as a side-by-side vertical diff
--             (Gvdiffsplit) against the same base, replacing any prior diff
--             in the main window area.
-- <leader>q   Reopen the quickfix window full-width across the bottom
--             (botright). If a working-copy file from the qf list is
--             currently visible in the tabpage, position the cursor on its
--             entry.

local M = {}

local qf_title_prefix = "git diff --name-only "
local active_diff_base = nil

local function open_under_cursor()
  local qfinfo = vim.fn.getqflist({ title = 0, items = 0 })
  if not active_diff_base or qfinfo.title ~= (qf_title_prefix .. active_diff_base) then
    vim.cmd(".cc")
    return
  end
  local item = qfinfo.items[vim.fn.line('.')]
  if not item then return end
  local filename = (item.filename and item.filename ~= "")
    and item.filename
    or vim.fn.bufname(item.bufnr)
  if not filename or filename == "" then return end

  -- Close the quickfix window before opening the side-by-side diff so it
  -- doesn't eat horizontal space. <leader>q reopens it.
  vim.cmd("cclose")

  local main_winid
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local bt = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), 'buftype')
    if bt ~= 'quickfix' then
      main_winid = win
      break
    end
  end
  if not main_winid then
    vim.cmd("aboveleft new")
    main_winid = vim.api.nvim_get_current_win()
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if win ~= main_winid then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end

  vim.api.nvim_set_current_win(main_winid)
  pcall(vim.cmd, "diffoff")
  vim.cmd("edit " .. vim.fn.fnameescape(filename))
  vim.cmd("Gvdiffsplit " .. active_diff_base)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_get_option_value('diff', { win = win }) then
      vim.api.nvim_set_option_value('wrap', true, { win = win })
    end
  end
end

local function populate_qf()
  local base = vim.g.mrp_diff_base or "HEAD"
  local files = vim.fn.systemlist({ "git", "diff", "--name-only", base })
  if vim.v.shell_error ~= 0 then
    vim.notify(table.concat(files, "\n"), vim.log.levels.ERROR)
    return
  end
  local items = {}
  for _, f in ipairs(files) do
    if f ~= "" then
      table.insert(items, { filename = f, lnum = 1, col = 1, text = f })
    end
  end
  if #items == 0 then
    vim.notify("No changes vs " .. base, vim.log.levels.INFO)
    return
  end
  active_diff_base = base
  vim.fn.setqflist({}, ' ', { title = qf_title_prefix .. base, items = items })
  -- botright ensures the qf window spans the full screen width (under both
  -- sides of any side-by-side diff), not just the current column.
  vim.cmd("botright copen")
  vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', '', {
    noremap = true, silent = true, callback = open_under_cursor,
  })
end

local function reopen_qf()
  -- Build a set of candidate absolute paths from non-quickfix windows in the
  -- current tabpage. We check all windows (not just the focused one) because
  -- <leader>gd's Gvdiffsplit puts a fugitive scratch buffer (fugitive://...)
  -- in the left window and the working-copy file in the right window; we
  -- want to match against the working-copy file regardless of which side is
  -- focused when <leader>q is pressed.
  local candidates = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bt = vim.api.nvim_buf_get_option(buf, 'buftype')
    if bt == "" then -- skip quickfix, terminal, fugitive (acwrite), etc.
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" then
        candidates[vim.fn.fnamemodify(name, ":p")] = true
      end
    end
  end

  vim.cmd("botright copen")

  if next(candidates) == nil then return end
  local items = vim.fn.getqflist()
  for idx, item in ipairs(items) do
    local item_path
    if item.bufnr and item.bufnr ~= 0 then
      local name = vim.fn.bufname(item.bufnr)
      if name ~= "" then
        item_path = vim.fn.fnamemodify(name, ":p")
      end
    end
    if item_path and candidates[item_path] then
      -- We're now in the quickfix window; position the cursor on the match.
      vim.api.nvim_win_set_cursor(0, { idx, 0 })
      return
    end
  end
end

function M.setup()
  if vim.g.mrp_diff_base == nil then
    vim.g.mrp_diff_base = "HEAD"
  end

  vim.keymap.set('n', '<leader>gd', populate_qf,
    { silent = true, desc = "Git diff vs base -> quickfix" })

  vim.keymap.set('n', '<leader>q', reopen_qf,
    { silent = true, desc = "Reopen quickfix window" })
end

return M
