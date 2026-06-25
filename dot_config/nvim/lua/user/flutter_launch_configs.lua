local M = {}

local function strip_jsonc_comments(input)
  local output = {}
  local i = 1
  local len = #input
  local in_string = false
  local escaped = false

  while i <= len do
    local char = input:sub(i, i)
    local next_char = input:sub(i + 1, i + 1)

    if in_string then
      table.insert(output, char)

      if escaped then
        escaped = false
      elseif char == "\\" then
        escaped = true
      elseif char == '"' then
        in_string = false
      end

      i = i + 1
    elseif char == '"' then
      in_string = true
      table.insert(output, char)
      i = i + 1
    elseif char == "/" and next_char == "/" then
      i = i + 2
      while i <= len and input:sub(i, i) ~= "\n" do
        i = i + 1
      end
      if input:sub(i, i) == "\n" then
        table.insert(output, "\n")
        i = i + 1
      end
    elseif char == "/" and next_char == "*" then
      i = i + 2
      while i <= len do
        char = input:sub(i, i)
        next_char = input:sub(i + 1, i + 1)
        if char == "\n" then
          table.insert(output, "\n")
        end
        if char == "*" and next_char == "/" then
          i = i + 2
          break
        end
        i = i + 1
      end
    else
      table.insert(output, char)
      i = i + 1
    end
  end

  return table.concat(output)
end

local function strip_trailing_commas(input)
  local output = {}
  local i = 1
  local len = #input
  local in_string = false
  local escaped = false

  while i <= len do
    local char = input:sub(i, i)

    if in_string then
      table.insert(output, char)

      if escaped then
        escaped = false
      elseif char == "\\" then
        escaped = true
      elseif char == '"' then
        in_string = false
      end

      i = i + 1
    elseif char == '"' then
      in_string = true
      table.insert(output, char)
      i = i + 1
    elseif char == "," then
      local j = i + 1
      while j <= len and input:sub(j, j):match("%s") do
        j = j + 1
      end

      local next_char = input:sub(j, j)
      if next_char == "}" or next_char == "]" then
        i = i + 1
      else
        table.insert(output, char)
        i = i + 1
      end
    else
      table.insert(output, char)
      i = i + 1
    end
  end

  return table.concat(output)
end

local function decode_jsonc(input)
  local json = strip_trailing_commas(strip_jsonc_comments(input))
  local ok, decoded = pcall(vim.json.decode, json, { luanil = { object = true, array = true } })
  if not ok then
    return nil, decoded
  end
  return decoded
end

local function find_launch_json(cwd)
  local dir = vim.fn.fnamemodify(cwd or vim.fn.getcwd(), ":p")
  if dir:sub(-1) == "/" then
    dir = dir:sub(1, -2)
  end

  while dir and dir ~= "" do
    local candidate = dir .. "/.vscode/launch.json"
    if vim.fn.filereadable(candidate) == 1 then
      return candidate
    end

    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then
      break
    end
    dir = parent
  end
end

local function normalize_args(args)
  if args == nil then
    return nil
  end
  if type(args) == "table" then
    return args
  end
  return { tostring(args) }
end

local function to_dap_configuration(config, paths)
  local dap_config = vim.deepcopy(config)

  dap_config.type = "dart"
  dap_config.request = "launch"
  dap_config.name = dap_config.name or "Dart launch"
  dap_config.program = dap_config.program or "lib/main.dart"
  dap_config.cwd = dap_config.cwd or "${workspaceFolder}"
  dap_config.args = normalize_args(dap_config.args)
  dap_config.dartSdkPath = paths.dart_sdk or paths.dart_bin
  dap_config.flutterSdkPath = paths.flutter_sdk or paths.flutter_bin

  return dap_config
end

function M.default_configurations(paths)
  return {
    {
      type = "dart",
      request = "launch",
      name = "PROD",
      dartSdkPath = paths.dart_sdk or paths.dart_bin,
      flutterSdkPath = paths.flutter_sdk or paths.flutter_bin,
      program = "${workspaceFolder}/lib/main.dart",
      cwd = "${workspaceFolder}",
    },
    {
      type = "dart",
      request = "launch",
      name = "DEV",
      flutterMode = "profile",
      dartSdkPath = paths.dart_sdk or paths.dart_bin,
      flutterSdkPath = paths.flutter_sdk or paths.flutter_bin,
      program = "${workspaceFolder}/lib/main_dev.dart",
      cwd = "${workspaceFolder}",
    },
  }
end

function M.vscode_configurations(paths, opts)
  local launch_path = find_launch_json(opts and opts.cwd)
  if not launch_path then
    return {}
  end

  local content = table.concat(vim.fn.readfile(launch_path), "\n")
  local decoded, err = decode_jsonc(content)
  if not decoded then
    vim.notify(("Could not parse %s: %s"):format(launch_path, err), vim.log.levels.WARN)
    return {}
  end

  local configurations = decoded.configurations
  if type(configurations) ~= "table" then
    return {}
  end

  local dap_configurations = {}
  for _, config in ipairs(configurations) do
    if config.type == "dart" and config.request == "launch" then
      table.insert(dap_configurations, to_dap_configuration(config, paths))
    end
  end

  return dap_configurations
end

function M.configurations(paths, opts)
  local vscode_configurations = M.vscode_configurations(paths, opts)
  if #vscode_configurations > 0 then
    return vscode_configurations
  end
  return M.default_configurations(paths)
end

function M.register(paths)
  require("dap").configurations.dart = M.configurations(paths)
end

return M
