local SDL = require('daisy')

sdl = SDL.Init()
print(sdl)
local w = 640
local h = 480
SDL.SetVideoMode(sdl, w, h, 32, options)
SDL.SetFrameDelay(sdl, 20) -- 5 fps
print(SDL.GetTicks())
local exit = false
for x = 1,10 do
    if exit then break end
    for y = 1,10 do
        local event
        repeat
            local args
            event, args = SDL.PollEvent()
            if event==12 then
                exit=true
            end
        until exit or event==nil
        if exit then break end
        SDL.FillRect(sdl, x*40, 40*y, 39, 39, 0xFF00FF)
        SDL.Flip(sdl)
        print(SDL.GetTicks())
    end
end
