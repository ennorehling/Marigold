require('LuaSDL')

SDL.Init()
SDL.WM_SetCaption("My First Game", "An Icon Title")
local w = 640
local h = 480
local fullscreen = 0x80000000
local screen = SDL.SetVideoMode(w, h, 32, 0)
surface = screen:DisplayFormat()
SDL.SetFrameDelay(100)
screen:Flip()
local rect = SDL.CreateRect(0, 0, w, h)
print(SDL.GetTicks())
local exit = false
for y = 0,11 do
    if exit then break end
    for x = 0,15 do
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
        surface:FillRect({x*40, 40*y, 39, 39}, color)
        surface:FillRect(SDL.CreateRect(x*40+20, 40*y+20, 39, 39), color*256)
    end
    surface:BlitSurface(rect, screen, rect)
    screen:Flip()
    print(SDL.GetTicks())
end
