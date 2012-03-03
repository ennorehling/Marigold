SDL_Init(SDL_INIT_EVERYTHING)
local window = SDL_CreateWindow("SDL 2.0 Demo", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 640, 480, 0)
local renderer = SDL_CreateRenderer(window, -1, 0)
color = 0
while true do
    color = color + 1
    SDL_SetRenderDrawColor(renderer, 0xA0, 0xA0, 0xA0, 0xFF)
    SDL_RenderClear(renderer)
    SDL_RenderPresent(renderer)
    SDL_SetRenderDrawColor(renderer, color, 0, 0, 0xFF)
    SDL_RenderClear(renderer)
    SDL_RenderPresent(renderer)
end
SDL_Delay(2000)
SDL_Quit()
