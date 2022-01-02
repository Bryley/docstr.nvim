
local M = {}

local array_contains = function (array, value)
    for val in array do
        if val == value then
            return true
        end
    end

    return false
end

M.place_docs = function (config, function_data, given_template)
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
    local parameters = {}

    for param in function_data["parameters"] do
        if array_contains(template.ignore_params, param.identifier) then
            table.insert(parameters, param)
        end
    end

    local text = template.content(function_data["identifier"],
                                  parameters,
                                  function_data["return_type"])

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

return M
