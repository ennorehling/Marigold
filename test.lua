require('LuaSDL')

SDL.Init()
SDL.WM_SetCaption("My First Game", "An Icon Title")
local w = 640
local h = 480

local screen = SDL.SetVideoMode(w, h, 32, 0)
SDL.SetFrameDelay(10) -- 5 fps
screen:Flip()

print(SDL.GetTicks())
local exit = false
for x = 0,16 do
    if exit then break end
    for y = 0,11 do
--[[
        local event
        repeat
            local args
            event, args = SDL.PollEvent()
            if event==12 then
                exit=true
            end
        until exit or event==nil
]]--
        if exit then break end
        color = x * 256 * 16 + y*16
        screen:FillRect(x*40, 40*y, 39, 39, color)
        screen:Flip()
        print(SDL.GetTicks())
    end
end
