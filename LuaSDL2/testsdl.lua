require('LuaSDL2')
require('SDL_compat')

function SDL_FlipEx(screen)
    SDL_FPS_Wait()
    return SDL_Flip(screen)
end

SDL_Init(SDL_INIT_EVERYTHING)
SDL_WM_SetCaption("My First Game", "An Icon Title")
local w = 640
local h = 480
local rect = SDL_CreateRect()
rect.x = 0
rect.y = 0
rect.w = w
rect.h = h
local fullscreen = 0x80000000
local screen = SDL_SetVideoMode(w, h, 32, 0)
surface = SDL_DisplayFormat(screen)
SDL_FPS_SetDelay(100) -- 100ms = 10 FPS
SDL_FillRect(screen, nil, 0xFF0070)
SDL_FlipEx(screen)
print(SDL_GetTicks())
local exit = false
local stamp = SDL_CreateRect()
stamp.w = 39
stamp.h = 39
local target = SDL_CreateRect()
target.w = 39
target.h = 39
local event = SDL_CreateEvent()

for y = 0,11 do
    for x = 0,15 do
        repeat
            if SDL_PollEvent(event)==0 then
                break
            end
            if event.type==12 then
                exit=true
            end
        until exit
        if exit then break end

        color = x * 256 * 16 + y*16
        stamp.x = x*40
        stamp.y = 40*y
        SDL_FillRect(surface, stamp, color)
        target.x = x*40+20
        target.y = 40*y+20
        SDL_FillRect(surface, target, SDL_MapRGB(surface.format, 255, 0, 0))
    end
    if exit then break end

    SDL_BlitSurface(surface, nil, screen, nil)
    SDL_FlipEx(screen)
    print(SDL_GetTicks())
end

local font = SDL_LoadBMP("daisymoon/04b08.bmp")
SDL_BlitSurface(font, nil, screen, nil)
SDL_Flip(screen)

repeat
    SDL_WaitEvent(event)
    SDL_FlipEx(screen)
    if event.type==12 then
        exit=true
    end
until exit
