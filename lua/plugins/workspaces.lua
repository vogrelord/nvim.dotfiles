return {
  "natecraddock/workspaces.nvim",
  cmd = { "WorkspacesList", "WorkspacesAdd", "WorkspacesOpen", "WorkspacesRemove" },
  config = function()
    require("workspaces").setup({
      hooks = {
        open_pre = { "Neotree close" },
        open = function(_, path)
          require("neo-tree.command").execute({ action = "show", dir = path })
          vim.cmd("cd " .. path)
        end,
      },
    })
  end,
}
