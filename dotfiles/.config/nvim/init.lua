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
    {
      "nvim-tree/nvim-web-devicons",
      opts = {
      }
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
         { "<leader>gm",
           function()
              local base = vim.env.MRP_MAIN_BRANCH_NAME
              if base == nil or base == "" then base = "master" end
              vim.g.mrp_diff_base = base
              vim.g.gitgutter_diff_base = base
              vim.cmd("GitGutterAll")
           end,
           desc = "Set diff base to main branch" },
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
    {
      "nvim-telescope/telescope.nvim",
      version = "*",
      keys = {
         { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Telescope find files" },
         { "<leader>p", "<cmd>Telescope buffers sort_mru=true ignore_current_buffer=true<cr>", desc = "Telescope buffers" },
         { "<leader>gr", "<cmd>Telescope live_grep<cr>", desc = "Telescope live grep" },
         { "<leader>b", "<cmd>Telescope file_browser<cr>", function() require("telescope").load_extension "file_browser" end, desc = "Telescope file browser" },
         { "<leader>bf", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", function() require("telescope").load_extension "file_browser" end, desc = "Telescope file browser" },
      },
      dependencies = {
        "nvim-lua/plenary.nvim",
        {
           "nvim-telescope/telescope-fzf-native.nvim",
           build = "make"
        },
        "nvim-telescope/telescope-file-browser.nvim",
      },
      config = function()
        local telescope = require("telescope")
        telescope.setup({
            defaults = {
                layout_config = {
                    horizontal = { preview_cutoff = 130 },
                },
            },
            pickers = {
                live_grep = {
                    file_ignore_patterns = { 'node_modules', '.git', '.venv' },
                    additional_args = function(_)
                        return { "--hidden" }
                    end
                },
                find_files = {
                    file_ignore_patterns = { 'node_modules', '.git', '.venv' },
                    hidden = true
                }

            },
            extensions = {
                file_browser = {
                    layout_config = {
                        horizontal = { preview_cutoff = 130 },
                    },
                },
            },
        })
    end,
    },
    {
      "nvim-telescope/telescope-file-browser.nvim",
      lazy = true,
    },
    {
       "neovim/nvim-lspconfig",
    },
    {
       "nvim-treesitter/nvim-treesitter",
       branch = 'master',
       lazy = false,
       build = ":TSUpdate",
       config = function()
          local configs = require("nvim-treesitter.configs")
          configs.setup({
              ensure_installed = { "bash", "c", "cpp", "dockerfile",
                  "git_config", "git_rebase", "gitcommit", "gitignore", "go",
                  "javascript", "json", "jsonnet", "lua", "make",
                  "markdown", "markdown_inline", "proto", "rust", "starlark",
                  "tmux", "typescript", "vim", "vimdoc"},
              auto_install = true,
              indent = {
                enable = true,
              },
              highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
                disable = { "markdown", "markdown_inline" },
              },
          })
          -- nvim-treesitter's markdown injections.scm uses a custom
          -- #set-lang-from-info-string! directive that's incompatible with
          -- nvim 0.10+'s iter_matches API (passes a TSNode[] where a TSNode
          -- is expected), which throws "attempt to call method 'range' (a
          -- nil value)" on fenced code blocks. Replace it with a plain
          -- @injection.language capture.
          vim.treesitter.query.set("markdown", "injections", [[
(fenced_code_block
  (info_string (language) @injection.language)
  (code_fence_content) @injection.content)

((html_block) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined)
  (#set! injection.include-children))

((minus_metadata) @injection.content
  (#set! injection.language "yaml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

((plus_metadata) @injection.content
  (#set! injection.language "toml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

([(inline) (pipe_table_cell)] @injection.content
  (#set! injection.language "markdown_inline"))
]])
       end
    },
    {
       "MeanderingProgrammer/render-markdown.nvim",
       ft = { "markdown" },
       dependencies = {
         "nvim-treesitter/nvim-treesitter",
         "nvim-tree/nvim-web-devicons",
       },
       keys = {
         { "<leader>rm", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle render-markdown" },
       },
       opts = {
         enabled = false,
       },
    },
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

vim.keymap.set('n', '<leader>l', '<cmd>Lazy<CR>', { silent = true })
vim.keymap.set('n', '<leader>tw', '<cmd>set tw=80<CR>', { silent = true, desc = "Set textwidth=80" })

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

    -- Enable LSP via clangd
    vim.lsp.enable('clangd')
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.wrap = true
  end,
})

-- Diagnostics
vim.diagnostic.config({ virtual_text = true })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = "Show diagnostics in float" })

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
vim.cmd([[highlight LineNr ctermfg=238 guifg=#444444]])

-- Easy window movements with CTRL+hjkl
vim.keymap.set('n', '<C-J>', '<C-W>j', { silent = true })
vim.keymap.set('n', '<C-K>', '<C-W>k', { silent = true })
vim.keymap.set('n', '<C-L>', '<C-W>l', { silent = true })
vim.keymap.set('n', '<C-H>', '<C-W>h', { silent = true })

-- Git diff workflow on top of fugitive: <leader>gd, <CR> in qf, <leader>q.
-- Implementation lives in lua/mrp/gitdiff.lua.
require("mrp.gitdiff").setup()
