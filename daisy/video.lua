module('video', package.seeall)

local screenWidth = 1024
local screenHeight = 768
local fullscreen = false
local screen = nil
local buffer = nil

function init(w, h, f, fps)
    if fps~=nil then
        SDL_FPS_SetDelay(1000/fps)
    end
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

    if a<255 then
        SDL_FillRect(buffer, rect, SDL_MapRGBA(screen.format, r, g, b, a))
        SDL_SetAlpha(buffer, SDL_SRCALPHA, a)
        SDL_UpperBlit(buffer, rect, screen, rect)
    else
        SDL_FillRect(screen, rect, SDL_MapRGB(screen.format, r, g, b))
    end
end

function renderText(str, x, y, alignment, font, a, r, g, b)
    -- TODO: this is a fake
    local xx = x
    alignment = alignment or 0
    a = a or 128
    r = r or 255
    g = g or 255
    b = b or 255
    if alignment==1 then
        xx = xx - string.len(str) * 4
    end
    for i = 1, string.len(str) do
        renderRectangle(xx, y, 7, 7, a, r, g, b)
        if alignment==2 then
            xx = xx - 8
        else
            xx = xx + 8
        end
    end
    -- print('renderText', str)
end

function getTextSize(str, font)
    -- TODO: this is a fake
    return 8*string.len(str), 8
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
    buffer = SDL_DisplayFormat(screen)
end

