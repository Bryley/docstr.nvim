local treesitter = require"src.treesitter"

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
                content = require("src.templates.python.numpy")
            }
        }
    }
}


local place_docs = function (function_data, given_template)
    local filetype = vim.bo.filetype

    local templates = config.templates[filetype]

    if templates == nil then
        error("Couldn't find template, consider making one for '" .. filetype .. "'")
        return
    end

    local template = templates[given_template] or templates[templates.default]

    if template == nil then
        error("Error with getting template, check your configs or input")
        return
    end

    -- Get and place text
    local text = template.content(function_data["identifier"],
                                  function_data["parameters"],
                                  function_data["return_type"])

    -- TODO make sure cursor is at the right spot when inserting
    -- TODO use the place_below config option
    -- vim.api.nvim_put(text, "l", true, true)
    -- vim.api.nvim_feedkeys(config.up_key .. config.indent_key .. (#text - 1) .. config.up_key, "n", false)

    local buf = vim.api.nvim_get_current_buf()

    local l1, l2 = unpack(function_data.end_location)

    if template.place_above then
        l1, l2 = unpack(function_data.start_location)
        table.insert(text, "")
    else
        table.insert(text, 1, "")
    end

    vim.api.nvim_buf_set_text(buf, l1, l2, l1, l2, text)

    vim.api.nvim_win_set_cursor(0, { l1 + (template.place_above and 0 or 1), l2 })

    -- Indenting

    if template.indent > 0 then
        -- Select it
        local keys = config.down_key .. config.visual_mode .. (#text - 2) .. config.down_key .. template.indent .. config.indent_key
        vim.api.nvim_feedkeys(keys, 'n', false)
    end
end

M.setup = function(opts)
    -- TODO custom user options
end

M.docstr = function(template)
    local function_data = treesitter.get_function_data()

    print(vim.bo.filetype)

    place_docs(function_data, template)

end



return M
