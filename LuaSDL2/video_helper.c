#include <SDL.h>
#include "video_helper.h"

static SDL_sem * fps_sem = 0;
static SDL_TimerID fps_timer = 0;

/* creators */

SDL_Rect* SDL_CreateRect() 
{
  return (SDL_Rect*)calloc(1, sizeof(SDL_Rect));
}

SDL_DisplayMode* SDL_CreateDisplayMode()
{
    return (SDL_DisplayMode*)calloc(1, sizeof(SDL_DisplayMode));
}

static Uint32 fps_timer_cb(Uint32 interval, void *param)
{
    SDL_sem * sem = (SDL_sem *)param;
    SDL_SemPost(sem);
    return interval;
}

int SDL_FPS_SetDelay(int interval)
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

int SDL_FPS_Wait(void)
{
    if (fps_timer) {
        return SDL_SemWait(fps_sem);
    }
	return -1;
}
