require('LSDL')

SDL_BlitSurface = SDL_UpperBlit
SDL_Init(SDL_INIT_EVERYTHING)
SDL_WM_SetCaption("My First Game", "An Icon Title")
local w = 640
local h = 480
local rect = createRect()
rect.x = 0
rect.y = 0
rect.w = w
rect.h = h
local fullscreen = 0x80000000
local screen = SDL_SetVideoMode(w, h, 32, 0)
surface = SDL_DisplayFormat(screen)
-- SDL_SetFrameDelay(100)
SDL_FillRect(screen, nil, 0xFF0070)
SDL_Flip(screen)
print(SDL_GetTicks())
local exit = false
local stamp = createRect()
stamp.w = 39
stamp.h = 39
local target = createRect()
target.w = 39
target.h = 39
local event = createEvent()

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
        SDL_FillRect(surface, target, color*256)
    end
    if exit then break end

    SDL_BlitSurface(surface, nil, screen, nil)
    SDL_Flip(screen)
    print(SDL_GetTicks())
end

repeat
    SDL_WaitEvent(event)
    SDL_Flip(screen)
    if event.type==12 then
        exit=true
    end
until exit
