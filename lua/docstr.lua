local treesitter = require"src.treesitter"
local utils = require"src.utils"

local M = {}

local config = {
    indent_key = '>',
    down_key = 'j',
    visual_mode = "v",
    templates = {
        python = {
            default = "numpy",
            numpy = {
                place_above = false,
                indent = 1,
                ignore_params = {
                    "self"
                },
                content = require("src.templates.python.numpy")
            }
        }
    }
}

M.setup = function(opts)
    config = vim.tbl_deep_extend('force', opts, config)
end

M.docstr = function(template)
    local function_data = treesitter.get_function_data()

    utils.place_docs(config, function_data, template)
end


return M
