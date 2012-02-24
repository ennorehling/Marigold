local SDL_VideoWindow = nil
local SDL_PublicSurface = nil
local dm = nil
local wm_title = nil

function SDL_UpdateRect(screen, x, y, w, h)
    if screen~=nil then
        -- TODO: implement me
    end
end

function SDL_Flip(screen)
    SDL_UpdateRect(screen, 0, 0, 0, 0)
    return 0
end

function SDL_SetVideoMode(width, height, bpp, flags)
    local mode = dm or SDL_CreateDisplayMode()
    SDL_GetDesktopDisplayMode(0, dm)
end

function SDL_WM_SetCaption(title, icon)
    wm_title = title
    if SDL_VideoWindow~=nil then
        SDL_SetWindowTitle(SDL_VideoWindow, wm_title)
    end
end

function SDL_WM_GetCaption()
    title = wm_title or ""
    return title, ""
end

function SDL_DisplayFormat(surface)
    local format

    if not SDL_PublicSurface then
        -- TODO: error handling in LuaSDL
        -- SDL_SetError("No video mode has been set")
        return nil
    end
    format = SDL_PublicSurface.format
    return SDL_ConvertSurface(surface, format, SDL_RLEACCEL)
end
