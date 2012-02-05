#pragma once
#ifndef SDL_HELPER_H
#define SDL_HELPER_H

struct SDL_Surface;
struct SDL_Semaphore;

#ifdef __cplusplus
extern "C" {
#endif

typedef struct SDLX SDLX;
int SDLX_Hello(void);
SDLX * SDLX_Init(void);
int SDLX_Flip(SDLX * sdl);
int SDLX_SetVideoMode(struct SDLX * sdl, int w, int h, int bpp, int flags);

#ifdef __cplusplus
}
#endif
#endif
