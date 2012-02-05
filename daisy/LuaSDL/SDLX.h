#pragma once
#ifndef SDL_HELPER_H
#define SDL_HELPER_H

#ifdef __cplusplus
extern "C" {
#endif

typedef struct SDLX SDLX;
int SDLX_Hello(void);
SDLX * SDLX_Init(void);
int SDLX_Flip(SDLX * sdl);
int SDLX_SetVideoMode(struct SDLX * sdl, int w, int h, int bpp, int flags);
int SDLX_SetFrameDelay(struct SDLX * sdl, int ms);
int SDLX_FillRect(struct SDLX * sdl, int x, int y, int w, int h, int color);
#ifdef __cplusplus
}
#endif
#endif
