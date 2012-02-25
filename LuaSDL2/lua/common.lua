require('LuaSDL2')
require('bit')

module('common', package.seeall)

local DEFAULT_WINDOW_WIDTH = 640
local DEFAULT_WINDOW_HEIGHT = 480

local VERBOSE_VIDEO  = 0x00000001
local VERBOSE_MODES  = 0x00000002
local VERBOSE_RENDER = 0x00000004
local VERBOSE_EVENT  = 0x00000008
local VERBOSE_AUDIO  = 0x00000010

function CreateState(flags)
    local state = {}
    state.flags = flags

    state.videodriver = nil
    state.depth = 32
    state.window_title = "Lua SDL Application"
    state.render_flags = SDL_RENDERER_PRESENTVSYNC

    state.window_flags = 0
    state.window_x = SDL_WINDOWPOS_UNDEFINED
    state.window_y = SDL_WINDOWPOS_UNDEFINED
    state.window_w = DEFAULT_WINDOW_WIDTH
    state.window_h = DEFAULT_WINDOW_HEIGHT
    state.num_windows = 1

    state.verbose = VERBOSE_VIDEO + VERBOSE_RENDER

    return state
end

local fullscreen_mode = nil

function Init(state)
    if bit.band(state.flags, SDL_INIT_VIDEO) then
        if bit.band(state.verbose, VERBOSE_VIDEO) then
            n = SDL_GetNumVideoDrivers();
            if n == 0 then
                print("No built-in video drivers");
            else
                local drivers = ""
                for i = 0, n-1 do
                    if i > 0 then drivers = drivers .. "," end
                    drivers = drivers .. " " .. SDL_GetVideoDriver(i)
                end
                print("Built-in video drivers:" .. drivers)
            end
        end
        if SDL_VideoInit(state.videodriver) < 0 then
            print("Couldn't initialize video driver: " .. SDL_GetError())
            return false
        end
        if bit.band(state.verbose, VERBOSE_VIDEO) then
            print("Video driver: " .. SDL_GetCurrentVideoDriver())
        end
        
        fullscreen_mode = fullscreen_mode or SDL_CreateDisplayMode()
        fullscreen_mode.format = SDL_PIXELFORMAT_RGB888
        fullscreen_mode.refresh_rate = 0
        state.windows = {}
        state.renderers = {}
        for i = 0, state.num_windows-1 do
            local title = state.window_title
            if state.num_windows > 1 then title = title .. " " .. i end
            local window = SDL_CreateWindow(title, state.window_x, state.window_y,
                                 state.window_w, state.window_h,
                                 state.window_flags)
            if not window then
                print("Couldn't create window: " .. SDL_GetError())
                return false
            end
            if SDL_SetWindowDisplayMode(window, fullscreen_mode) < 0 then
                print("Can't set up fullscreen display mode: " .. SDL_GetError())
                return false
            end
            SDL_ShowWindow(window)
            local renderer = SDL_CreateRenderer(window, -1, state.render_flags)
            if not renderer then
                print("Couldn't create renderer: " .. SDL_GetError())
                return false
            end

            table.insert(state.windows, window)
            table.insert(state.renderers, renderer)
        end
    end
    return true
end

function Event(state, event, onQuit)
    print(event.type)
    if event.type==SDL_QUIT then onQuit() end
end
