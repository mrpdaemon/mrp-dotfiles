-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

vim.opt.guicursor = ""                -- turn off skinny gui cursor
vim.opt.mouse = ""                    -- no mouse support

vim.opt.scrolloff = 5                 -- Keep 5 lines above/below when scrolling
vim.opt.number = true                 -- Show numbers
vim.opt.cursorline = true             -- Highlight the cursor line
vim.opt.colorcolumn = "80"            -- Color the 80th column

-- Formatting options
vim.opt.autoindent = true             -- automatically indent
vim.opt.wrap = false                  -- wrap long lines
vim.opt.expandtab = true              -- use spaces not TABs
vim.opt.shiftwidth = 3                -- 3 spaces per indent
vim.opt.tabstop = 3                   -- indent every 3 columns
vim.opt.softtabstop = 3               -- let backspace delete indents
vim.opt.smarttab = true               -- Let TAB/BSpace insert/delete spaces
vim.opt.list = true                   -- show tab / trail chars
vim.opt.listchars = {
  tab = '   ',
  trail = '·',
  extends = '»',
  nbsp = '␣',
}

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "vim-scripts/xoria256.vim",
      lazy = false,
      priority = 1000, -- make sure to load this before all the other start plugins
      config = function()
        vim.cmd([[colorscheme xoria256]])
      end,
    },
    { "myusuf3/numbers.vim",
      config = function()
      end,
    },
    { "easymotion/vim-easymotion",
      config = function()
      end,
    },
    { "vim-airline/vim-airline",
      dependencies = {
        "vim-airline/vim-airline-themes",
      },
      init = function()
        vim.g.airline_extensions_whitespace_enabled = 0 -- Disable whitespace warnings
        vim.g.airline_extensions_tagbar_enabled = 0     -- Disable tagbar integration
        vim.g.airline_section_y = ""                    -- Don't want encoding info
        vim.g.airline_theme = "base16"                  -- Theme selection
      end,
    },
    { "bling/vim-bufferline",
      dependencies = {
        "vim-airline/vim-airline",
      },
      init = function()
        vim.g.bufferline_echo = 0         -- Don't echo buffer name to command bar
        vim.g.bufferline_rotate = 1       -- Rotate buffers
        vim.g.bufferline_fixed_index = -1 -- Fix current buffer to last position
      end,
    },
    { "scrooloose/nerdtree",
       keys = {
         { "<leader>nt", "<cmd>NERDTreeToggle<cr>", desc = "NERDTree" },
         { "<leader>nf", "<cmd>NERDTreeFind<cr>", desc = "NERDTree Find" },
       },
      init = function()
        vim.g.NERDTreeQuitOnOpen = 1       -- quit when opening stuff
        vim.g.NERDTreeKeepTreeInNewTab = 1 -- keep tree in a new tab
        vim.g.NERDTreeShowHidden = 1       -- show hidden files
        vim.g.NERDTreeIgnore = { '\\~$', '\\.swp$', '\\.git' }
        vim.g.NERDTreeWinSize = 60 -- Larger window size
      end,
    },
    { "tpope/vim-fugitive",
       lazy = false,
       keys = {
         { "<leader>gv",
           function()
              vim.cmd("Gvdiffsplit " .. (vim.g.mrp_diff_base or "HEAD"))
           end,
           desc = "Git vertical split vs diff base" },
       },
      config = function()
      end,
    },
    { "airblade/vim-gitgutter",
       lazy = false,
       keys = {
         { "<leader>gb",
           function()
              local current = vim.g.mrp_diff_base or "HEAD"
              local base = vim.fn.input("Diff base: ", current)
              if base == "" then return end
              vim.g.mrp_diff_base = base
              vim.g.gitgutter_diff_base = base
              vim.cmd("GitGutterAll")
           end,
           desc = "Set git diff base" },
         { "<leader>gc",
           function()
              vim.g.mrp_diff_base = "HEAD"
              vim.g.gitgutter_diff_base = ""
              vim.cmd("GitGutterAll")
           end,
           desc = "Reset diff base to HEAD" },
       },
      config = function()
      end,
    },
    { "ctrlpvim/ctrlp.vim",
       keys = {
         { "<leader>p", "<cmd>CtrlPBuffer<cr>", desc = "CtrlP" },
         { "<leader>o", "<cmd>CtrlP<cr>", desc = "CtrlP" },
       },
      init = function()
        vim.g.ctrlp_max_files = 0          -- no limit on max files
        vim.g.ctrlp_max_depth = 40         -- large projects hit the depth limit
        vim.g.ctrlp_lazy_update = 1        -- slow to search on every key press
        vim.g.ctrlp_by_filename = 1        -- only search file names
      end,
    },
    { "junegunn/fzf",
       keys = {
         { "<leader>f", "<cmd>FZF<cr>", desc = "FZF" },
       },
      config = function()
      end,
    },
    { "rking/ag.vim",
       keys = {
         { "<leader>a", "<cmd>Ag<cr>", desc = "Silver searcher" },
       },
      config = function()
      end,
    },
    { "majutsushi/tagbar",
       keys = {
         { "<leader>t", "<cmd>TagbarToggle<cr>", desc = "Tagbar" },
       },
      init = function()
        vim.g.tagbar_autoclose = 1         -- close when tag is selected
        vim.g.tagbar_autofocus = 1         -- focus when tagbar is opened
        vim.g.tagbar_width = 60            -- larger tagbar
      end,
    },
    { "rhysd/vim-clang-format",
      ft = { "c", "cpp", "objc" },
      init = function()
        vim.g.clang_format_detect_style_file = 1  -- detect .clang-format files
      end,
    },
    { "google/vim-jsonnet",
      ft = { "jsonnet" },
      init = function()
        vim.g.jsonnet_format_on_save = 0
      end,
    },
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

vim.keymap.set('n', '<leader>l', '<cmd>Lazy<CR>', { silent = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    -- Buffer-local normal mode mapping: <Leader>cf triggers :ClangFormat
    vim.api.nvim_buf_set_keymap(0, "n", "<Leader>cf", ":<C-u>ClangFormat<CR>",
                                { noremap = true, silent = true })
    -- Buffer-local visual mode mapping: <Leader>cf triggers :ClangFormat
    vim.api.nvim_buf_set_keymap(0, "v", "<Leader>cf", ":ClangFormat<CR>",
                                { noremap = true, silent = true })
    -- Enable auto-formatting on save
    vim.cmd("ClangFormatAutoEnable")
  end,
})

-- Colorscheme tweaks
vim.cmd([[highlight String ctermfg=229 guifg=#ffffaf]])
vim.cmd([[highlight ColorColumn cterm=NONE gui=NONE ctermbg=236 guibg=#303030]])
vim.cmd([[highlight Type cterm=bold gui=bold]])
vim.cmd([[highlight Function ctermfg=NONE guifg=NONE cterm=NONE gui=NONE]])
vim.cmd([[highlight ModeMsg ctermfg=NONE guifg=NONE cterm=NONE gui=NONE]])
vim.cmd([[highlight Conditional cterm=bold gui=bold]])
vim.cmd([[highlight Statement cterm=bold gui=bold]])
vim.cmd([[highlight Include cterm=bold gui=bold]])
vim.cmd([[highlight Boolean cterm=bold gui=bold]])
vim.cmd([[highlight Identifier cterm=bold gui=bold]])
vim.cmd([[highlight Macro cterm=bold gui=bold]])
vim.cmd([[highlight PreProc cterm=bold gui=bold]])

-- Easy window movements with CTRL+hjkl
vim.keymap.set('n', '<C-J>', '<C-W>j', { silent = true })
vim.keymap.set('n', '<C-K>', '<C-W>k', { silent = true })
vim.keymap.set('n', '<C-L>', '<C-W>l', { silent = true })
vim.keymap.set('n', '<C-H>', '<C-W>h', { silent = true })

-- Git diff vs the configured diff base (vim.g.mrp_diff_base): populate
-- quickfix with changed files; <CR> in the quickfix opens the file as a
-- vertical diff against the same base, replacing any prior diff in the
-- main window area.
vim.g.mrp_diff_base = "HEAD"

local gd_qf_title_prefix = "git diff --name-only "
local gd_diff_base = nil

local function gd_open_under_cursor()
  local qfinfo = vim.fn.getqflist({ title = 0, items = 0 })
  if not gd_diff_base or qfinfo.title ~= (gd_qf_title_prefix .. gd_diff_base) then
    vim.cmd(".cc")
    return
  end
  local item = qfinfo.items[vim.fn.line('.')]
  if not item then return end
  local filename = (item.filename and item.filename ~= "")
    and item.filename
    or vim.fn.bufname(item.bufnr)
  if not filename or filename == "" then return end

  local qf_winid = vim.api.nvim_get_current_win()
  local main_winid
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if win ~= qf_winid then
      local bt = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), 'buftype')
      if bt ~= 'quickfix' then
        main_winid = win
        break
      end
    end
  end
  if not main_winid then
    vim.cmd("aboveleft new")
    main_winid = vim.api.nvim_get_current_win()
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if win ~= qf_winid and win ~= main_winid then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end

  vim.api.nvim_set_current_win(main_winid)
  pcall(vim.cmd, "diffoff")
  vim.cmd("edit " .. vim.fn.fnameescape(filename))
  vim.cmd("Gvdiffsplit " .. gd_diff_base)
end

local function gd_populate_qf()
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
  gd_diff_base = base
  vim.fn.setqflist({}, ' ', { title = gd_qf_title_prefix .. base, items = items })
  vim.cmd("copen")
  vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', '', {
    noremap = true, silent = true, callback = gd_open_under_cursor,
  })
end

vim.keymap.set('n', '<leader>gd', gd_populate_qf,
  { silent = true, desc = "Git diff vs base -> quickfix" })
