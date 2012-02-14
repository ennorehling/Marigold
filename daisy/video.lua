module('video', package.seeall)

local screenWidth = 1024
local screenHeight = 768
local fullscreen = false
local screen = nil

function init(w, h, f)
    SDL_FPS_SetDelay(1000/60)
    screenWidth = w or screenWidth
    screenHeight = h or screenHeight
    if f~=nil then fullscreen = f end
end

function getScreenSize()
    return screenWidth, screenHeight
end

local rect = SDL_CreateRect()
function renderRectangle(x, y, w, h, a, r, g, b)
    rect.x = x
    rect.y = y
    rect.w = w
    rect.h = h
    SDL_FillRect(screen, rect, SDL_MapRGBA(screen.format, r, g, b, a))
end

function renderText(str, x, y, alignment, font, a, r, g, b)
   print(str)
end

function _flip()
    SDL_FPS_Wait()
    SDL_Flip(screen)
end

function _open()
    SDL_Init(SDL_INIT_EVERYTHING)
    local flags = 0
    if fullscreen then flags = flags + SDL_FULLSCREEN end
    screen = SDL_SetVideoMode(screenWidth, screenHeight, 32, flags)
end

