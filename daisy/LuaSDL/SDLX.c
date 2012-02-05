#include "SDLX.h"
#include <SDL.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

static SDL_sem * fps_sem = 0;
static SDL_TimerID fps_timer = 0;

int SDLX_Init(void) {
    return SDL_Init(SDL_INIT_EVERYTHING);
}

int SDLX_Hello(void)
{
    return 42;
}

int SDLX_Flip(SDL_Surface * screen)
{
    if (fps_timer) {
        SDL_SemWait(fps_sem);
    }
    return SDL_Flip(screen);
}

static Uint32 fps_timer_cb(Uint32 interval, void *param)
{
    SDL_sem * sem = (SDL_sem *)param;
    SDL_SemPost(sem);
    return interval;
}

int SDLX_SetFrameDelay(int interval)
{
    if (!interval) {
        if (SDL_RemoveTimer(fps_timer)) {
            fps_timer = 0;
            return 0;
        }
        return -1;
    }

    fps_sem = SDL_CreateSemaphore(0);
    fps_timer = SDL_AddTimer(interval, fps_timer_cb, fps_sem);
    return fps_timer?0:-1;
}

int SDLX_FillRectA(struct SDL_Surface * screen, int r[4], int color) {
    return SDLX_FillRect(screen, r[0], r[1], r[2], r[3], color);
}

int SDLX_FillRect(struct SDL_Surface * screen, int x, int y, int w, int h, int color)
{
    SDL_Rect rect = { x, y, w, h };
    Uint32 rgb = SDL_MapRGB(screen->format, (color>>16)&0xFF, (color>>8)&0xFF, color&0xFF);
    return SDL_FillRect(screen, &rect, rgb);
}

SDL_Rect * SDLX_CreateRect(int x, int y, int w, int h)
{
    SDL_Rect * rect = (SDL_Rect *)malloc(sizeof(SDL_Rect));
    rect->x = x;
    rect->y = y;
    rect->w = w;
    rect->h = h;
    return rect;
}
