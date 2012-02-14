#pragma once
#ifndef SDL_HELPER_H
#define SDL_HELPER_H

#ifdef __cplusplus
extern "C" {
#endif

struct SDL_Surface;
struct SDL_Rect;

int SDLX_Hello(void);
int SDLX_Init(void);
int SDLX_Flip(struct SDL_Surface * screen);
struct SDL_Surface * SDLX_SetVideoMode(int w, int h, int bpp, int flags);
int SDLX_SetFrameDelay(int interval);

struct SDL_Rect * SDLX_CreateRect(int x, int y, int w, int h);
int SDLX_FillRect(struct SDL_Surface *, int r[4], int color);

#ifdef __cplusplus
}
#endif
#endif
