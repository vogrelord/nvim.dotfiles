return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "gbprod/none-ls-luacheck.nvim",
    },
    config = function()
      local none_ls = require("null-ls")

      local function with_root_file(builtin, file)
        return builtin.with({
          condition = function(utils)
            return utils.root_has_file(file)
          end,
        })
      end

      none_ls.register(with_root_file(require("none-ls-luacheck.diagnostics.luacheck"), ".luacheckrc"))

      none_ls.setup({
        debounce = 150,
        debug = true,
        save_after_format = false,
        sources = {
          -- NOTE: wanna try working without them for now.
          none_ls.builtins.formatting.gofumpt,
          none_ls.builtins.formatting.goimports.with({
            extra_args = {
              -- "-format-only=true",
            },
          }),
          none_ls.builtins.diagnostics.golangci_lint.with({
            extra_args = {
              "--config=.golangci.pipeline.yaml",
              "--new-from-rev=origin/master",
            },
            timeout = 60 * 1000,
          }),
        },
      })
      print("setup done")
    end,
  },
}
