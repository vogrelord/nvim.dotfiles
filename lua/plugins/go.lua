return {
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    -- config = function()
    --  require("go").setup()
    --end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    opts = {
      lsp_inlay_hints = {
        enable = false,
        only_current_line = false,
      },
      lsp_cfg = {
        settings = {
          gopls = {
            gofumpt = true,
            codelenses = {},
            completeUnimported = true,
            usePlaceholders = false,
            staticcheck = true,
            analyses = {
              unusedparams = true,
              unreachable = true,
              unusedwrite = true,
              unusedvariable = true,
              useany = true,
              nilness = true,
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader>Gi",
        "<cmd>GoToggleInlay<CR>",
        desc = "Go: Toggle Inlay",
      },
      {
        "<leader>Gc",
        "<cmd>ConformInfo<CR>",
        desc = "View formatter errors",
      },
      {
        "<leader>Gf",
        "<cmd>GoFillStruct<CR>",
        desc = "fill struct",
      },
      {
        "<leader>GE",
        "<cmd>GoIfErr<CR>",
        desc = "add if err",
      },
      {
        "<leader>Ga",
        "<cmd>GoAlt<CR>",
        desc = "switch to test",
      },
      {
        "<leader>Gl",
        function()
          vim.cmd.GoCodeLenAct()
        end,
        desc = "code lens action",
      },
      {
        "<leader>Gt",
        desc = "Go: test",
      },
      {
        "<leader>Gr",
        "<cmd>GoRename<CR>",
        desc = "Go: rename",
      },
      {
        "<leader>GtF",
        "<cmd>GoTestFile<CR>",
        desc = "Go: test file",
      },
      {
        "<leader>Gtf",
        "<cmd>GoTestFunc<CR>",
        desc = "Go: test func",
      },
      {
        "<leader>Gtp",
        "<cmd>GoTestPkg<CR>",
        desc = "Go: test package",
      },
      {
        "<leader>Gtc",
        "<cmd>GoTermClose<CR>",
        desc = "Go: close floating term",
      },
    },
  },
  {
    "ray-x/guihua.lua",
  },
}
