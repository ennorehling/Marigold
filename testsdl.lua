require('LSDL')
SDL_Init(SDL_INIT_EVERYTHING)
screen = SDL_SetVideoMode(800, 480, 32, 0)
SDL_WM_SetCaption("My First Game", "An Icon Title")
print(SDL_GetTicks())
event = createEvent()
for x = 1,20 do
    SDL_Flip(screen)
    SDL_WaitEvent(event)
    print(event.type)
end
print(SDL_GetTicks())
