require('LuaSDL2')

SDL_Init(SDL_INIT_EVERYTHING)
local w = 640
local h = 480
local rect = SDL_CreateRect()
rect.x = 0
rect.y = 0
rect.w = w
rect.h = h
local fullscreen = 0x80000000

--[[ 1.2 only
SDL_WM_SetCaption("My First Game", "An Icon Title")
local screen = SDL_SetVideoMode(w, h, 32, 0)
local surface = SDL_DisplayFormat(screen)
]]
local window = SDL_CreateWindow("SDL 2.0 Demo", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, w, h, SDL_WINDOW_SHOWN)
local screen = SDL_GetWindowSurface(window)
local surface = SDL_ConvertSurface(screen, screen.format, SDL_RLEACCEL)
local renderer = SDL_CreateRenderer(window, -1, 0)
SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255)
SDL_RenderClear(renderer)

function SDL_FlipEx(screen)
    SDL_FPS_Wait()
    --[[ SDL 1.2 ]]-- return SDL_Flip(screen)
    SDL_RenderPresent(renderer)
end

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
SDL_FlipEx(screen)

repeat
    SDL_WaitEvent(event)
    SDL_FlipEx(screen)
    if event.type==12 then
        exit=true
    end
until exit
