#pragma once

#include <SDL_video.h>

SDL_Rect* SDL_CreateRect();
SDL_DisplayMode* SDL_CreateDisplayMode();
int SDL_FPS_SetDelay(int interval);
int SDL_FPS_Wait(void);
