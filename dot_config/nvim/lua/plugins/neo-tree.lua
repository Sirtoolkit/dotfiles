return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  keys = {
    {
      "<leader>fe",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
      end,
      desc = "Explorer NeoTree (Root Dir)",
    },
    {
      "<leader>fE",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
    { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
    { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
    {
      "<leader>ge",
      function()
        require("neo-tree.command").execute({ source = "git_status", toggle = true })
      end,
      desc = "Git Explorer",
    },
    {
      "<leader>be",
      function()
        require("neo-tree.command").execute({ source = "buffers", toggle = true })
      end,
      desc = "Buffer Explorer",
    },
  },
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  init = function()
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
      desc = "Start Neo-tree with directory",
      once = true,
      callback = function()
        if package.loaded["neo-tree"] then
          return
        else
          local stats = vim.uv.fs_stat(vim.fn.argv(0))
          if stats and stats.type == "directory" then
            require("neo-tree")
          end
        end
      end,
    })
  end,
  opts = function()
    local git_available = vim.fn.executable("git") == 1

    local icons = {
      FolderClosed = "",
      FolderOpen = "",
      FolderEmpty = "",
      DefaultFile = "",
      Diagnostic = "󰒡",
      Git = "󰊢",
      GitAdd = "",
      GitDelete = "",
      GitChange = "",
      GitRenamed = "➜",
      GitUntracked = "★",
      GitIgnored = "◌",
      GitUnstaged = "✗",
      GitStaged = "✓",
      GitConflict = "",
    }

    local sources = {
      { source = "filesystem", display_name = icons.FolderClosed .. " File" },
      { source = "buffers", display_name = icons.DefaultFile .. " Bufs" },
      { source = "diagnostics", display_name = icons.Diagnostic .. " Diagnostic" },
    }

    if git_available then
      table.insert(sources, 3, { source = "git_status", display_name = icons.Git .. " Git" })
    end

    return {
      enable_git_status = git_available,
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = sources,
      },
      default_component_configs = {
        indent = {
          padding = 0,
          expander_collapsed = "",
          expander_expanded = "",
        },
        icon = {
          folder_closed = icons.FolderClosed,
          folder_open = icons.FolderOpen,
          folder_empty = icons.FolderEmpty,
          folder_empty_open = icons.FolderEmpty,
          default = icons.DefaultFile,
        },
        modified = { symbol = "●" },
        git_status = {
          symbols = {
            added = icons.GitAdd,
            deleted = icons.GitDelete,
            modified = icons.GitChange,
            renamed = icons.GitRenamed,
            untracked = icons.GitUntracked,
            ignored = icons.GitIgnored,
            unstaged = icons.GitUnstaged,
            staged = icons.GitStaged,
            conflict = icons.GitConflict,
          },
        },
      },
      commands = {
        system_open = function(state)
          vim.ui.open(state.tree:get_node():get_id())
        end,
        reveal_in_finder = function(state)
          local node = state.tree:get_node()
          local file_path = node:get_id()
          if not file_path or file_path == "" then
            vim.notify("No hay archivo seleccionado", vim.log.levels.WARN)
            return
          end

          local os = vim.loop.os_uname().sysname
          if os == "Darwin" then
            vim.fn.system({ "open", "-R", file_path })
          elseif os == "Linux" then
            local dir_path = node.type == "directory" and file_path or vim.fn.fnamemodify(file_path, ":h")
            vim.fn.system({ "xdg-open", dir_path })
          elseif os == "Windows" or os == "Windows_NT" then
            vim.fn.system({ "explorer", "/select,", file_path })
          else
            vim.notify("Sistema operativo no soportado", vim.log.levels.ERROR)
          end
        end,
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if node:has_children() and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        child_or_open = function(state)
          local node = state.tree:get_node()
          if node:has_children() then
            if not node:is_expanded() then
              state.commands.toggle_node(state)
            else
              if node.type == "file" then
                state.commands.open(state)
              else
                require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
              end
            end
          else
            state.commands.open(state)
          end
        end,
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local vals = {
            ["BASENAME"] = modify(filename, ":r"),
            ["EXTENSION"] = modify(filename, ":e"),
            ["FILENAME"] = filename,
            ["PATH (CWD)"] = modify(filepath, ":."),
            ["PATH (HOME)"] = modify(filepath, ":~"),
            ["PATH"] = filepath,
            ["URI"] = vim.uri_from_fname(filepath),
          }

          local options = vim.tbl_filter(function(val)
            return vals[val] ~= ""
          end, vim.tbl_keys(vals))
          if vim.tbl_isempty(options) then
            vim.notify("No values to copy", vim.log.levels.WARN)
            return
          end
          table.sort(options)
          vim.ui.select(options, {
            prompt = "Choose to copy to clipboard:",
            format_item = function(item)
              return ("%s: %s"):format(item, vals[item])
            end,
          }, function(choice)
            local result = vals[choice]
            if result then
              vim.notify(("Copied: `%s`"):format(result))
              vim.fn.setreg("+", result)
            end
          end)
        end,
      },
      window = {
        width = 30,
        mappings = {
          ["<S-CR>"] = "system_open",
          ["<Space>"] = false,

          O = "system_open",
          Y = "copy_selector",
          h = "parent_or_close",
          l = "child_or_open",
          ["<leader>of"] = "reveal_in_finder",
        },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        filtered_items = { hide_gitignored = git_available },
        hijack_netrw_behavior = "disabled",
        use_libuv_file_watcher = vim.fn.has("win32") ~= 1,
      },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function(_)
            vim.opt_local.signcolumn = "auto"
            vim.opt_local.foldcolumn = "0"
          end,
        },
      },
    }
  end,
  config = function(_, opts)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("neo-tree").setup(opts)

    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*lazygit*",
      desc = "Refresh Neo-Tree sources when closing lazygit",
      callback = function()
        local manager_avail, manager = pcall(require, "neo-tree.sources.manager")
        if manager_avail then
          for _, source in ipairs({ "filesystem", "git_status", "document_symbols" }) do
            local module = "neo-tree.sources." .. source
            if package.loaded[module] then
              manager.refresh(require(module).name)
            end
          end
        end
      end,
    })
  end,
}
