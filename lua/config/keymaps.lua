-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
--
vim.keymap.set("n", "<Leader>.", ":w<CR>")
vim.keymap.set("n", "<Leader>Wo", ":WorkspacesOpen<CR>", { desc = "Open workspace" })
vim.keymap.set("n", "<Leader>Wa", ":WorkspacesAdd<CR>", { desc = "Add workspace" })
vim.keymap.set("n", "<Tab>", ":Neotree reveal<CR>", { desc = "toggle Neotree" })

local function open_gitlab_build()
  local gomodtext = vim.fn.system("go mod edit -json")
  local mod_json = vim.json.decode(gomodtext)
  module = mod_json.Module.Path
  local url = "https://" .. module .. "/-/pipelines"
  vim.ui.open(url)
end

vim.keymap.set("n", "<Leader>gob", open_gitlab_build, { desc = "Open gitlab builds" })

local function open_jira_issue()
  local revision = vim.fn.system("git rev-parse --abbrev-ref HEAD")
  revision = revision.gsub(revision, "\n\t", "")
  local match = string.match(revision, "release/(.+)")
  vim.ui.open("https://jit.o3.ru/browse/" .. match)
end

vim.keymap.set("n", "<Leader>goj", open_jira_issue, { desc = "Open jit ticket" })
vim.keymap.set("n", "<Leader>jl", function()
  vim.cmd.FloatermNew(
    'jira issue list --columns KEY,SUMMARY,STATUS,PRIORITY  --assignee=vlagrishin -q "sprint in openSprints()"'
  )
end, { desc = "issues" })

vim.keymap.set("n", "<Leader>jb", function()
  --local handle = io.popen(
  --  'jira issue list --columns KEY,SUMMARY,STATUS,PRIORITY --plain --no-headers --assignee=vlagrishin -q "sprint in openSprints()" --order-by status'
  -- )
  --local result = handle:read("*a")
  --handle:close()
  local cmd =
    'jira issue list --columns KEY,SUMMARY,STATUS,PRIORITY --plain --no-headers --assignee=vlagrishin -q "sprint in openSprints()" --order-by status'

  local result = vim.fn.system(cmd)
  require("fzf-lua").fzf_exec({ result }, {
    -- @param selected: the selected entry or entries
    -- @param opts: fzf-lua caller/provider options
    -- @param line: originating buffer completed line
    -- @param col: originating cursor column location
    -- @return newline: will replace the current buffer line
    -- @return newcol?: optional, sets the new cursor column
    complete = function(selected, opts, line, col)
      local key = string.match(selected[1], "%S+")
      local existing_branches = vim.fn.system("git branch  --list 'release/" .. key .. "'")
      local res
      print(string.match(existing_branches, "fatal:"))
      if #existing_branches > 0 then
        res = vim.fn.system("git switch release/" .. key)
      else
        res = vim.fn.system("git switch -c release/" .. key)
      end
    end,
  })
end, { desc = "load jira ticket" })

vim.keymap.set("n", "<Leader>ml", ":make lint<CR>")
vim.keymap.set("n", "<Leader>M", function()
  local result = vim.fn.system("make help")
  require("fzf-lua").fzf_exec({ result }, {
    -- @param selected: the selected entry or entries
    -- @param opts: fzf-lua caller/provider options
    -- @param line: originating buffer completed line
    -- @param col: originating cursor column location
    -- @return newline: will replace the current buffer line
    -- @return newcol?: optional, sets the new cursor column
    complete = function(selected, opts, line, col)
      local cmd = string.match(selected[1], "%S+")
      vim.cmd.FloatermNew("--autoclose=0 make " .. cmd)
    end,
  })
end, { desc = "make command" })

local gitlab = require("gitlab")
local gitlab_server = require("gitlab.server")
vim.keymap.set("n", "<Leader>glb", gitlab.choose_merge_request, { desc = "choose merge request" })
vim.keymap.set("n", "<Leader>glr", gitlab.review, { desc = "gitlab review" })
vim.keymap.set("n", "<Leader>gls", gitlab.summary, { desc = "gitlab summary" })
vim.keymap.set("n", "<Leader>glA", gitlab.approve, { desc = "gitlab.approve" })
vim.keymap.set("n", "<Leader>glR", gitlab.revoke, { desc = "gitlab.revoke" })
vim.keymap.set("n", "<Leader>glc", gitlab.create_comment, { desc = "gitlab.create_comment" })
vim.keymap.set("v", "<Leader>glc", gitlab.create_multiline_comment, { desc = "gitlab.create_multiline_comment" })
vim.keymap.set("v", "<Leader>glC", gitlab.create_comment_suggestion, { desc = "gitlab.create_comment_suggestion" })
vim.keymap.set("n", "<Leader>glO", gitlab.create_mr, { desc = "gitlab.create_mr" })
vim.keymap.set(
  "n",
  "<Leader>glm",
  gitlab.move_to_discussion_tree_from_diagnostic,
  { desc = "gitlab.move_to_discussion_tree_from_diagnostic" }
)
vim.keymap.set("n", "<Leader>gln", gitlab.create_note, { desc = "gitlab.create_note" })
vim.keymap.set("n", "<Leader>gld", gitlab.toggle_discussions, { desc = "toggle_discussions" })
vim.keymap.set("n", "<Leader>glaa", gitlab.add_assignee, { desc = "gitlab.add_assignee" })
vim.keymap.set("n", "<Leader>glad", gitlab.delete_assignee, { desc = "gitlab.delete_assignee" })
vim.keymap.set("n", "<Leader>glla", gitlab.add_label, { desc = "gitlab.add_label" })
vim.keymap.set("n", "<Leader>glld", gitlab.delete_label, { desc = "gitlab.delete_label" })
vim.keymap.set("n", "<Leader>glra", gitlab.add_reviewer, { desc = "gitlab.add_reviewer" })
vim.keymap.set("n", "<Leader>glrd", gitlab.delete_reviewer, { desc = "gitlab.delete_reviewer" })
vim.keymap.set("n", "<Leader>glp", gitlab.pipeline, { desc = "gitlab.pipeline" })
vim.keymap.set("n", "<Leader>glo", gitlab.open_in_browser, { desc = "gitlab.open_in_browser" })
vim.keymap.set("n", "<Leader>glM", gitlab.merge, { desc = "gitlab.merge" })
vim.keymap.set("n", "<Leader>glu", gitlab.copy_mr_url, { desc = "gitlab.copy_mr_url" })
vim.keymap.set("n", "<Leader>glP", gitlab.publish_all_drafts, { desc = "gitlab.publish_all_drafts" })
vim.keymap.set("n", "<Leader>glD", gitlab.toggle_draft_mode, { desc = "gitlab.toggle_draft_mode" })

vim.keymap.set("n", "<Leader>S", function()
  vim.cmd.FloatermNew("serpl")
end, { desc = "Search And Replace" })

function dump(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. dump(v) .. ","
    end
    return s .. "} "
  else
    return tostring(o)
  end
end

function jira_list()
  local token = ""
  local curl = require("plenary.curl")
  local query = {
    maxResults = 100,
    jql = "assignee=currentuser() AND sprint in openSprints()",
  }
  local headers = {
    Authorization = "Bearer " .. token,
  }
  local resp = curl.get("https://jit.o3.ru/rest/api/2/search", {
    query = query,
    headers = headers,
  })
  local b = vim.json.decode(resp.body)
  local issues = b.issues

  local iss_desc = {}
  for _, iss in ipairs(issues) do
    table.insert(iss_desc, iss.key .. " " .. iss.fields.summary .. " [" .. iss.fields.status.name .. "]")
  end
  require("fzf-lua").fzf_exec(iss_desc, {
    actions = {
      -- Use fzf-lua builtin actions or your own handler
      ["default"] = function(selected, opts)
        print(selected)
      end,
      ["ctrl-b"] = jira_branch,
      ["ctrl-t"] = function(selected)
        local key = string.match(selected[1], "%S+")
        jira_transition(key)
      end,
    },
  })
end

function jira_transition(key)
  local token = ""
  local curl = require("plenary.curl")
  local headers = {
    Authorization = "Bearer " .. token,
  }
  local resp = curl.get("https://jit.o3.ru/rest/api/2/issue/" .. key .. "/transitions", {
    headers = headers,
  })
  local b = vim.json.decode(resp.body)
  local transitions = b.transitions

  local Menu = require("nui.menu")
  local event = require("nui.utils.autocmd").event

  local lines = {}

  for _, t in ipairs(transitions) do
    table.insert(lines, Menu.item(t.name))
  end

  local menu = Menu({
    position = "50%",
    size = {
      width = 50,
      height = 10,
    },
    border = {
      style = "single",
      text = {
        top = "[Select new status for issue" .. key .. "]",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
  }, {
    lines = lines,
    max_width = 20,
    keymap = {
      focus_next = { "j", "<Down>", "<Tab>" },
      focus_prev = { "k", "<Up>", "<S-Tab>" },
      close = { "<Esc>", "<C-c>" },
      submit = { "<CR>", "<Space>" },
    },
    on_close = function()
      print("Menu Closed!")
    end,

    on_submit = function(item)
      for _, t in ipairs(transitions) do
        print(t.name .. " " .. item.text)
        local headers = {
          Accept = "application/json",
          ["Content-Type"] = "application/json",
          Authorization = "Bearer " .. token,
        }
        if t.name == item.text then
          local resp = curl.post("https://jit.o3.ru/rest/api/2/issue/" .. key .. "/transitions", {
            headers = headers,
            body = vim.json.encode({
              transition = {
                id = t.id,
              },
            }),
          })
          print(dump(resp))
          break
        end
      end
      print("Menu Submitted: ", item.text)
    end,
  })
  menu:mount()
end

local function all_trim(s)
  return s:match("^%s*(.*)"):match("(.-)%s*$")
end

function jira_branch(selected)
  local key = string.match(selected[1], "%S+")
  local existing_branches = vim.fn.system("git branch  --list 'release/" .. key .. "'")
  local res
  print(string.match(existing_branches, "fatal:"))
  if #existing_branches > 0 then
    res = vim.fn.system("git switch release/" .. key)
  else
    res = vim.fn.system("git switch -c release/" .. key)
  end
end

vim.keymap.set("n", "<Leader>J", jira_list, { desc = "jira" })

vim.keymap.set("n", "<Leader>Gm", function()
  local relative_filepath = vim.fn.expand("%:.")
  local module_path = all_trim(vim.fn.system("go list -m"))
  local p = module_path .. "/" .. relative_filepath
  print(p)
  vim.fn.setreg("+", p)
end)

vim.keymap.set("n", "<Enter>", "o<ESC>")
vim.keymap.set("n", "<S-Enter>", "O<ESC>")
