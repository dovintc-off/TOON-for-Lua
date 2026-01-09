--[[
DVTOONL.lua (Dovintc module TOON for Lua)
Create by Dovintc
Date 10.01.26 0:51 - Russia|Moscow

MIT License

Copyright (c) 2026 Dovintc

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

local DVTOONL = {}


local function value_to_string(v)
    if v == nil then
        return "null"
    elseif type(v) == "boolean" then
        return tostring(v)
    elseif type(v) == "number" then
        return tostring(v)
    elseif type(v) == "string" then
        return v
    else
        error("Unsupported value type: " .. type(v))
    end
end

local function is_uniform_array(tbl)
    local n = #tbl
    if n == 0 then return false end

    for i = 1, n do
        if type(tbl[i]) ~= "table" then
            return false
        end
    end

    local first = tbl[1]
    local keys = {}
    local key_order = {}
    for k in pairs(first) do
        table.insert(key_order, k)
        keys[k] = true
    end

    for i = 2, n do
        local item = tbl[i]
        local count = 0
        for k, v in pairs(item) do
            if not keys[k] then return false end
            if type(v) == "table" then return false end
            count = count + 1
        end
        if count ~= #key_order then return false end
    end

    table.sort(key_order, function(a, b)
        return tostring(a) < tostring(b)
    end)

    return true, key_order
end

local function serialize_table(tbl, indent_level)
    local indent = string.rep("  ", indent_level)
    local lines = {}

    for key, value in pairs(tbl) do
        if type(value) == "table" then
            local is_uniform, fields = is_uniform_array(value)
            if is_uniform then
                local header = indent .. tostring(key) .. "[" .. #value .. "]{" .. table.concat(fields, ",") .. "}:"
                table.insert(lines, header)
                for _, item in ipairs(value) do
                    local row_values = {}
                    for _, f in ipairs(fields) do
                        table.insert(row_values, value_to_string(item[f]))
                    end
                    local row = indent .. "  " .. table.concat(row_values, ",")
                    table.insert(lines, row)
                end
            else
                table.insert(lines, indent .. tostring(key) .. ":")
                local nested = serialize_table(value, indent_level + 1)
                if nested ~= "" then
                    table.insert(lines, nested)
                end
            end
        else
            local str_val = value_to_string(value)
            table.insert(lines, indent .. tostring(key) .. ": " .. str_val)
        end
    end

    return table.concat(lines, "\n")
end

function DVTOONL.serialization(tbl)
    if type(tbl) ~= "table" then
        error("Input must be a table")
    end
    return serialize_table(tbl, 0)
end


local function parse_value(str)
    if str == "true" then return true
    elseif str == "false" then return false
    elseif str == "null" then return nil
    else
        local num = tonumber(str)
        if num then return num end
        return str
    end
end

local function trim(s)
    return s:match("^%s*(.-)%s*$")
end

function DVTOONL.deserialization(str)
    if type(str) ~= "string" then
        error("Input must be a string")
    end

    local lines = {}
    for line in str:gmatch("[^\r\n]+") do
        local trimmed = trim(line)
        if trimmed ~= "" then
            table.insert(lines, line)
        end
    end

    if #lines == 0 then
        return {}
    end

    local root = {}
    local stack = { { obj = root, indent = -1 } }
    local i = 1

    while i <= #lines do
        local line = lines[i]
        local indent_str = line:match("^( *)") or ""
        local indent = #indent_str
        local content = line:sub(#indent_str + 1)
        while #stack > 1 and stack[#stack].indent >= indent do
            table.remove(stack)
        end
        local current_obj = stack[#stack].obj

        local arr_key, arr_count, arr_fields = content:match("^([%w_]+)%[(%d+)%]%{(.+)%}:$")
        if arr_key and arr_count and arr_fields then
            local count = tonumber(arr_count)
            local fields = {}
            for field in arr_fields:gmatch("[^,%s]+") do
                table.insert(fields, trim(field))
            end

            local arr = {}
            current_obj[arr_key] = arr

            i = i + 1
            for r = 1, count do
                if i > #lines then break end

                local data_line = lines[i]
                local data_indent_str = data_line:match("^( *)") or ""
                local data_indent = #data_indent_str

                if data_indent <= indent then
                    i = i - 1
                    break
                end

                local values_str = data_line:sub(#data_indent_str + 1)
                local values = {}

                local pos = 1
                while pos <= #values_str do
                    if values_str:sub(pos, pos) == '"' then
                        local s, e = values_str:find('"([^"]*)"', pos)
                        if s then
                            table.insert(values, values_str:sub(s+1, e-1))
                            pos = e + 2
                        else
                            break
                        end
                    else
                        local next_comma = values_str:find(",", pos)
                        local seg
                        if next_comma then
                            seg = trim(values_str:sub(pos, next_comma - 1))
                            pos = next_comma + 1
                        else
                            seg = trim(values_str:sub(pos))
                            pos = #values_str + 1
                        end
                        table.insert(values, seg)
                    end
                end

                local item = {}
                for j = 1, math.min(#fields, #values) do
                    item[fields[j]] = parse_value(values[j])
                end
                table.insert(arr, item)
                i = i + 1
            end
            i = i - 1
        elseif content:match(":$") and not content:match("%[%d+%]") then
            local key = content:sub(1, -2)
            local new_obj = {}
            current_obj[key] = new_obj
            table.insert(stack, { obj = new_obj, indent = indent })
        else
            local key, val_str = content:match("^([%w_]+):%s*(.*)$")
            if key then
                current_obj[key] = parse_value(val_str or "")
            end
        end

        i = i + 1
    end

    return root
end

function DVTOONL.save_to_file(table, file_path)
    local data = DVTOONL.serialization(table)
    local file = io.open(file_path, "w")
    if file then
        file:write(data)
        file:close()
        return true
    end
    return false
end

function DVTOONL.load_from_file(file_path)
    local file = io.open(file_path, "r")
    if file then
        local content = file:read("*a")
        file:close()
        return DVTOONL.deserialization(content)
    end
    return nil
end

return DVTOONL