require('bit')
local SDL_VideoWindow = nil
local SDL_PublicSurface = nil
local wm_title = nil

local desktop_mode = nil

SDL_FULLSCREEN = 0x00800000
SDL_OPENGL = 0x04000000
SDL_RESIZABLE = 0x01000000
SDL_NOFRAME = 0x02000000
function SDL_UpdateRect(screen, x, y, w, h)
    if screen~=nil then
        -- TODO: implement me
    end
end

function SDL_Flip(screen)
    SDL_UpdateRect(screen, 0, 0, 0, 0)
    return 0
end

local function ClearVideoSurface()
    if SDL_ShadowSurface~=nil then
        SDL_FillRect(SDL_ShadowSurface, nil, SDL_MapRGB(SDL_ShadowSurface.format, 0, 0, 0))
    end
    SDL_FillRect(SDL_WindowSurface, nil, 0)
    SDL_UpdateWindowSurface(SDL_VideoWindow)
end

local function SetupScreenSaver()
    -- TODO: implement me
end

local function GetEnvironmentWindowPosition(w, h)
    -- TODO: getenv magic
    return 0, 0
end

local function GetVideoDisplay()
    -- TODO: implement me
    return 0
end

function SDL_SetVideoMode(width, height, bpp, flags)
    local display = GetVideoDisplay()
    desktop_mode = desktop_mode or SDL_CreateDisplayMode()
    SDL_GetDesktopDisplayMode(display, desktop_mode)
    if (width == 0) then
        width = desktop_mode.w;
    end
    if height == 0 then
        height = desktop_mode.h;
    end
    if bpp == 0 then
        bpp = SDL_BITSPERPIXEL(desktop_mode.format)
    end

--[[
    /* See if we can simply resize the existing window and surface */
    if (SDL_ResizeVideoMode(width, height, bpp, flags) == 0) {
        return SDL_PublicSurface;
    } ]]

--[[
    /* Destroy existing window */
    SDL_PublicSurface = NULL;
    if (SDL_ShadowSurface) {
        SDL_ShadowSurface->flags &= ~SDL_DONTFREE;
        SDL_FreeSurface(SDL_ShadowSurface);
        SDL_ShadowSurface = NULL;
    }
    if (SDL_VideoSurface) {
        SDL_VideoSurface->flags &= ~SDL_DONTFREE;
        SDL_FreeSurface(SDL_VideoSurface);
        SDL_VideoSurface = NULL;
    }
    if (SDL_VideoContext) {
        /* SDL_GL_MakeCurrent(0, NULL); *//* Doesn't do anything */
        SDL_GL_DeleteContext(SDL_VideoContext);
        SDL_VideoContext = NULL;
    }
    if (SDL_VideoWindow) {
        SDL_GetWindowPosition(SDL_VideoWindow, &window_x, &window_y);
        SDL_DestroyWindow(SDL_VideoWindow);
    }
]]

--[[
    /* Set up the event filter */
    if (!SDL_GetEventFilter(NULL, NULL)) {
        SDL_SetEventFilter(SDL_CompatEventFilter, NULL);
    }
]]
    
    window_flags = SDL_WINDOW_SHOWN
    if bit.band(flags, SDL_FULLSCREEN) then
        window_flags = window_flags + SDL_WINDOW_FULLSCREEN
    end
    if bit.band(flags, SDL_OPENGL) then
        window_flags = window_flags + SDL_WINDOW_OPENGL
    end
    if bit.band(flags, SDL_RESIZABLE) then
        window_flags = window_flags + SDL_WINDOW_RESIZABLE
    end
    if bit.band(flags, SDL_NOFRAME) then
        window_flags = window_flags + SDL_WINDOW_BORDERLESS
    end
    window_x, window_y = GetEnvironmentWindowPosition(width, height)
    SDL_VideoWindow =
        SDL_CreateWindow(wm_title, window_x, window_y, width, height,
                         window_flags);
    if not SDL_VideoWindow then
        return nil
    end
    SDL_SetWindowIcon(SDL_VideoWindow, SDL_VideoIcon)

    SetupScreenSaver(flags)

    window_flags = SDL_GetWindowFlags(SDL_VideoWindow)
    surface_flags = 0
    if bit.band(window_flags, SDL_WINDOW_FULLSCREEN) then
        surface_flags = surface_flags + SDL_FULLSCREEN
    end
    if bit.band(window_flags, SDL_WINDOW_OPENGL) and bit.band(flags, SDL_OPENGL) then
        surface_flags = surface_flags + SDL_OPENGL;
    end
    if bit.band(window_flags, SDL_WINDOW_RESIZABLE) then
        surface_flags = surface_flags + SDL_RESIZABLE;
    end
    if bit.band(window_flags, SDL_WINDOW_BORDERLESS) then
        surface_flags = surface_flags + SDL_NOFRAME;
    end

    SDL_VideoFlags = flags
--[[
    /* If we're in OpenGL mode, just create a stub surface and we're done! */
    if (flags & SDL_OPENGL) {
        SDL_VideoContext = SDL_GL_CreateContext(SDL_VideoWindow);
        if (!SDL_VideoContext) {
            return NULL;
        }
        if (SDL_GL_MakeCurrent(SDL_VideoWindow, SDL_VideoContext) < 0) {
            return NULL;
        }
        SDL_VideoSurface =
            SDL_CreateRGBSurfaceFrom(NULL, width, height, bpp, 0, 0, 0, 0, 0);
        if (!SDL_VideoSurface) {
            return NULL;
        }
        SDL_VideoSurface->flags |= surface_flags;
        SDL_PublicSurface = SDL_VideoSurface;
        return SDL_PublicSurface;
    }
]]
    -- Create the screen surface
    SDL_WindowSurface = SDL_GetWindowSurface(SDL_VideoWindow)
    if not SDL_WindowSurface then
        return nil
    end

    -- Center the public surface in the window surface
    window_w, window_h = SDL_GetWindowSize(SDL_VideoWindow)
    SDL_VideoViewport.x = (window_w - width)/2
    SDL_VideoViewport.y = (window_h - height)/2
    SDL_VideoViewport.w = width
    SDL_VideoViewport.h = height
--[[
    SDL_VideoSurface = SDL_CreateRGBSurfaceFrom(nil, 0, 0, 32, 0, 0, 0, 0, 0)
    SDL_VideoSurface->flags |= surface_flags;
    SDL_VideoSurface->flags |= SDL_DONTFREE;
    SDL_FreeFormat(SDL_VideoSurface->format);
    SDL_VideoSurface->format = SDL_WindowSurface->format;
    SDL_VideoSurface->format->refcount++;
    SDL_VideoSurface->w = width;
    SDL_VideoSurface->h = height;
    SDL_VideoSurface->pitch = SDL_WindowSurface->pitch;
    SDL_VideoSurface->pixels = (void *)((Uint8 *)SDL_WindowSurface->pixels +
        SDL_VideoViewport.y * SDL_VideoSurface->pitch +
        SDL_VideoViewport.x  * SDL_VideoSurface->format->BytesPerPixel);
    SDL_SetClipRect(SDL_VideoSurface, nil)

    /* Create a shadow surface if necessary */
    if ((bpp != SDL_VideoSurface->format->BitsPerPixel) and !(flags & SDL_ANYFORMAT)) then
        SDL_ShadowSurface =
            SDL_CreateRGBSurface(0, width, height, bpp, 0, 0, 0, 0);
        if (!SDL_ShadowSurface) {
            return NULL;
        }
        SDL_ShadowSurface->flags |= surface_flags;
        SDL_ShadowSurface->flags |= SDL_DONTFREE;

        /* 8-bit SDL_ShadowSurface surfaces report that they have exclusive palette */
        if (SDL_ShadowSurface->format->palette) {
            SDL_ShadowSurface->flags |= SDL_HWPALETTE;
            SDL_DitherColors(SDL_ShadowSurface->format->palette->colors,
                             SDL_ShadowSurface->format->BitsPerPixel);
        }
        SDL_FillRect(SDL_ShadowSurface, NULL,
            SDL_MapRGB(SDL_ShadowSurface->format, 0, 0, 0));
    end
]]
    SDL_PublicSurface = SDL_ShadowSurface or SDL_VideoSurface
    ClearVideoSurface()

    return SDL_PublicSurface;
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
