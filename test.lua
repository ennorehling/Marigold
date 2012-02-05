require('LuaSDL')

sdl = SDL.Init()
SDL.WM_SetCaption("My First Game", "An Icon Title")
print(sdl)
local w = 640
local h = 480

sdl:SetVideoMode(w, h, 32, 0)
sdl:Flip()
--[[
sdl:SetFrameDelay(20) -- 5 fps
]]-- broken

print(SDL.GetTicks())
local exit = false
for x = 1,10 do
    if exit then break end
    for y = 1,10 do
        local event
--[[
        repeat
            local args
            event, args = SDL.PollEvent()
            if event==12 then
                exit=true
            end
        until exit or event==nil
]]--
        if exit then break end
        sdl:FillRect(x*40, 40*y, 39, 39, 0xFF00FF)
        sdl:Flip()
        print(SDL.GetTicks())
    end
end
