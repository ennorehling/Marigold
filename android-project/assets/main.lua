SDL_Init(SDL_INIT_EVERYTHING)
local w = 640
local h = 480
local rect = SDL_CreateRect()
rect.x = 0
rect.y = 0
rect.w = w
rect.h = h
local fullscreen = 0x80000000
local window = SDL_CreateWindow("SDL 2.0 Demo", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, w, h, SDL_WINDOW_SHOWN)
local screen = SDL_GetWindowSurface(window)
local surface = SDL_ConvertSurface(screen, screen.format, SDL_RLEACCEL)
local renderer = SDL_CreateRenderer(window, -1, 0)
SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255)
SDL_RenderClear(renderer)
SDL_Delay(1000)
SDL_Quit()
