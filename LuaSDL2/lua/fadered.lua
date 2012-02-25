require('LuaSDL2')

SDL_Init(SDL_INIT_VIDEO)
window = SDL_CreateWindow("SDL_RenderClear",
                        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
                        512, 512,
                        SDL_WINDOW_SHOWN)
renderer = SDL_CreateRenderer(window, -1, 0)
for i = 0, 255 do
    SDL_SetRenderDrawColor(renderer, i, 0, 0, 255)
    SDL_RenderClear(renderer)
    SDL_RenderPresent(renderer)
    -- SDL_Delay(5)
end
SDL_Quit()
