return {
  "nvim-neo-tree/neo-tree.nvim",
  init = function()
    print("init neotree")
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
      desc = "Start Neo-tree with directory",
      once = true,
      callback = function()
        if package.loaded["neo-tree"] then
          return
        else
          local stats = vim.uv.fs_stat(vim.fn.argv(0))
          if stats == nil or stats.type == "directory" then
            require("neo-tree")
            vim.fn.system(":Neotree show<CR>")
            vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = "#333333" })
          end
        end
      end,
    })
  end,
  opts = {
    follow_current_file = {
      enabled = true, -- This will find and focus the file in the active buffer every time
      --               -- the current file is changed while the tree is open.
      leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    },
    filesystem = {
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = {
          -- '.git',
          -- '.DS_Store',
          -- 'thumbs.db',
        },
        never_show = {},
      },
      window = {
        mappings = {
          ["v"] = "visidata",
          ["V"] = "visidata_semicolon",
          ["<Tab>"] = "open",
        },
      },
    },
    commands = {
      visidata = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        require("FTerm").scratch({ cmd = { "csvlens", "-d", "auto", path }, close_on_kill = true })
      end,
      visidata_semicolon = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        vim.cmd('e term://csvlens -d auto "' .. path .. '"')
      end,
    },
  },
}
