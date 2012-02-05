#include "SDLX.h"
#include <SDL.h>
#include <stdlib.h>
#include <string.h>

struct SDLX {
    SDL_Surface * screen;
    SDL_sem * sem_fps;
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
    if (sdl->sem_fps) {
        SDL_SemWait(sdl->sem_fps);
    }
    return SDL_Flip(sdl->screen);
}

static Uint32 fps_timer(Uint32 interval, void *param)
{
    SDL_sem * sem = (SDL_sem *)param;
    SDL_SemPost(sem);
    return interval;
}

int SDLX_SetFrameDelay(struct SDLX * sdl, int interval)
{
    SDL_TimerID result;
    SDL_NewTimerCallback callback = fps_timer;
    sdl->sem_fps = SDL_CreateSemaphore(0);
    result = SDL_AddTimer(interval, callback, sdl->sem_fps);
    return result!=0;
}

int SDLX_FillRect(struct SDLX * sdl, int x, int y, int w, int h, int color)
{
    SDL_Rect rect = { x, y, w, h };
    Uint32 rgb = SDL_MapRGB(sdl->screen->format, (color>>16)&0xFF, (color>>8)&0xFF, color&0xFF);
    return SDL_FillRect(sdl->screen, &rect, rgb);
}
