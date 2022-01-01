local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

-- TODO remove later
M.dump = function (o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. M.dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


---Grabs text from node
---@param node any
local get_text = function (node)
    local buf = vim.api.nvim_get_current_buf()
    return ts_utils.get_node_text(node, buf)[1]
end

---Function will search upwards for a function parent node returning it
-- otherwise returning nil
---@param start_node any The node module object if nil will just do default
---@return any The function parent node or nil if not found
local get_function_parent = function (start_node)
    local node = start_node or ts_utils.get_node_at_cursor()
    -- TODO make it more versitile for different function types
    while (node ~= nil and node:type() ~= "function_definition") do
        node = node:parent()
    end

    return node
end

---Uses the function node to find the name of the function if there is one
---@param function_node any The function node
---@return string the identifier of the function
local get_function_name = function (function_node)
    return get_text(function_node:field("name")[1])
end

---Uses the function node to find the parameters of the function
---@param function_node any The function node
---@return table A list of tables with information about each param
local get_parameters = function (function_node)

    local params = {}

    for node, _ in function_node:field("parameters")[1]:iter_children() do

        if not node:named() then
            goto continue
        end

        local param = {
            identifier = nil,
            type = nil,
            default = nil
        }

        if node:child_count() > 0 then
            for p_node, field in node:iter_children() do
                if field == "name" or p_node:type() == "identifier" then
                    param.identifier = get_text(p_node)
                elseif field == "type" then
                    param.type = get_text(p_node)
                elseif field == "value" then
                    param.default = get_text(p_node)
                end
            end
        else
            param.identifier = get_text(node)
        end

        table.insert(params, param)
        ::continue::
    end

    return params

end

---Uses the function node to find the return type of the function
---@param function_node any The function node
---@return string The string representation of the return type or nil if not found
local get_return_type = function (function_node)
    return get_text(function_node:field("return_type")[1])
end


---Uses the function node to find the final function declaration node (just
--before the body).
---@param function_node any The function node
---@return any The final node that is used or nil if no body found
local get_final_function_node = function(function_node)

    local prev_node = nil

    for node, field in function_node:iter_children() do
        if field == 'body' then
            return prev_node
        end
        prev_node = node
    end

    return nil
end


M.get_function_data = function ()
    local function_node = get_function_parent()

    if function_node == nil then
        vim.notify("Couldn't locate function")
        return nil
    end

    local s1, s2 = function_node:start()

    local e1, e2 = get_final_function_node(function_node):end_()

    local results = {
        start_location = {s1, s2},
        end_location = {e1, e2},
        identifier = get_function_name(function_node),
        parameters = get_parameters(function_node),
        return_type = get_return_type(function_node)
    }

    return results
end


return M
