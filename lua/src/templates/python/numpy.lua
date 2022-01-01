
-- https://numpydoc.readthedocs.io/en/latest/format.html

return function (function_name, parameters, return_type)

    local content = {
        '"""',
        "[ Summary ]",
        "",
        "[ Description ]",
    }

    if #parameters ~= 0 then
        table.insert(content, "")
        table.insert(content, "Parameters")
        table.insert(content, "----------")

        for _, param in ipairs(parameters) do
            local iden = param.identifier
            if param.type ~= nil then
                iden = iden .. " | " .. param.type
            end

            if param.default ~= nil then
                iden = iden .. ", default = " .. param.default
            end
            table.insert(content, iden)
            table.insert(content, "    [ Desc ]")
        end
    end

    if return_type ~= nil then
        table.insert(content, "")
        table.insert(content, "Returns")
        table.insert(content, "-------")
        table.insert(content, return_type)
        table.insert(content, "    [ Desc ]")
    end

    table.insert(content, '"""')

    return content
end
