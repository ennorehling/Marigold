#include "SDLX.h"
#include <SDL.h>
#include <stdlib.h>
#include <string.h>

struct SDLX {
    struct SDL_Surface * screen;
    struct SDL_Semaphore * sem_fps;
};

int SDLX_Hello(void)
{
    return 42;
}

SDLX * SDLX_Init()
{
    SDLX * sdl = (SDLX *)malloc(sizeof(SDLX));
    memset(sdl, 0, sizeof(SDLX));
    return sdl;
}

int SDLX_SetVideoMode(struct SDLX * sdl, int w, int h, int bpp, int flags)
{
    sdl->screen = SDL_SetVideoMode(w, h, bpp, flags);
    return sdl->screen?0:-1; // TODO: error handling
}

int SDLX_Flip(struct SDLX * sdl)
{
    return SDL_Flip(sdl->screen);
}
