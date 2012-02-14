

SDL_Event* SDL_CreateEvent() 
{
  SDL_Event* r = (SDL_Event *)malloc(sizeof(SDL_Event));
  return r;
}


