-- requires
local scm = require("./scm")
---@class turtleController
local t = scm:load("turtleController")

t.canBreakBlocks = true;

-- definitions
local args = { ... }
if #args ~= 3 then
    print("Usage: clearArea <height> <length> <width>")
    print("Starts at the bottom right corner of the area")
    return
end
local height = tonumber(args[1])
local length = tonumber(args[2])
local width = tonumber(args[3])
local skipLoop = 0

local turnDir = {
    [1] = "tL",
    [2] = "tR"
}


-- functions
local function dig(i, height)
    if height - i > 0 then
        t:tryAction("digU")
    end
    if i > 1 then
        t:tryAction("digD")
    end
end

local function clearArea()
    local turnOrder = 1;
    for i = 1, height, 1 do
        if skipLoop > 0 then
            skipLoop = skipLoop - 1
        else
            for j = 1, width do
                for k = 1, length do
                    dig(i, height)
                    if k > 1 then
                        t:tryMove("f")
                    end
                end
                if width - j > 0 then
                    t:tryMove(turnDir[turnOrder])
                    dig(i, height)
                    t:tryMove("f")
                    t:tryMove(turnDir[turnOrder])
                    turnOrder = turnOrder % 2 + 1
                end
            end
            dig(i, height)
            if i + 2 < height then
                t:compactMove("u3")
                skipLoop = 2
            else
                if i + 1 < height then
                    t:compactMove("u2")
                    skipLoop = 1
                else
                    skipLoop = 1
                end
            end
            t:compactMove("tR,tR")
        end
    end
end

clearArea()
