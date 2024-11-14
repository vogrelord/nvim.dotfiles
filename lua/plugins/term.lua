return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    keys = {
      {
        ":!",
        "<cmd>ToggleTerm<CR>",
        desc = "Open a horizontal terminal at the Desktop directory",
      },
    },
  },
  {
    "https://github.com/tzvetkoff/vim-numbertoggle.git",
  },
}
