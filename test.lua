require('LuaSDL')

SDL.Init()
SDL.WM_SetCaption("My First Game", "An Icon Title")
local w = 640
local h = 480

local screen = SDL.SetVideoMode(w, h, 32, 0)
blerg = screen:DisplayFormat()
SDL.SetFrameDelay(10)
screen:Flip()
local rect = SDL.CreateRect(0, 0, w, h)
print(SDL.GetTicks())
local exit = false
for x = 0,15 do
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
        color = x * 256 * 256 * 16 + y*16
        blerg:FillRect({x*40, 40*y, 39, 39}, color)
        -- blerg:FillRect(SDL.CreateRect(x*40, 40*y, 39, 39), color)
        -- blerg:FillRect(x*40, 40*y, 39, 39, color)
        blerg:BlitSurface(rect, screen, rect)
        screen:Flip()
        print(SDL.GetTicks())
    end
end
