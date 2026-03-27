-- ~/.config/conky/visualizer.lua
local fifo_path = "/tmp/cava.raw"
local MAX_BARS = 64
local last_output = ""
local buffer = {}

-- Open FIFO once and keep it open
local f = io.open(fifo_path, "r")
if not f then
    print("Failed to open FIFO")
end

function conky_visualizer()
    if not f then
        return "waiting for CAVA..."
    end

    -- Try to read one line
    local line = f:read("*l")
    if not line or line == "" then
        return last_output
    end

    -- Parse semicolon-separated values
    buffer = {}
    local i = 1
    for val in string.gmatch(line, "([^;]+)") do
        if i <= MAX_BARS then
            local v = tonumber(val) or 0
            buffer[i] = v
            i = i + 1
        end
    end

    if #buffer == 0 then
        return last_output
    end

    -- Build visual bars
    local output = ""
    for i = 1, #buffer do
        local height = math.floor(buffer[i] / 25)
        if height > 15 then height = 15 end
        for j = 1, height do
            output = output .. "▇"
        end
        output = output .. " "
    end

    last_output = output
    return output
end