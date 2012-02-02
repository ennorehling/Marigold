local SDL = require('daisy')
local print = print
module('moon')
local screen

local function video(w, h, options)
    SDL.Init()
    screen = SDL.SetVideoMode(w, h, 32, options)
    SDL.Flip(screen)
    return screen
end

local shouldExit = false
local hooks = {}
hook = {
    add = function(name, hookfunc)
        hooks[name] = hookfunc
    end,
    remove = function(name)
        hookfunc = hooks[name]
        hooks[name] = nil
        return hookfunc
    end,
    get = function(name)
        return hooks[name]
    end
}

local function pump(time)
    local event, args = SDL.PollEvent()
    print(SDL.GetTicks())
    if event==12 then shouldExit = true end
    if event==2 or event==3 then print(args.sym, args.mod) end
end

local x = 0
local y = 0
local function run()
    local gameInit = hook.get('gameInit')
    local frameRender = hook.get('frameRender')
    local frameUpdate = hook.get('frameUpdate')
    if gameInit~=nil then gameInit() end
    while not shouldExit do
        pump(0.1)
        if frameUpdate~=nil then frameUpdate(0.1) end
        if frameRender~=nil then frameRender() end
        SDL.FillRect(screen, x*40, 40*y, 39, 39, 0xFF00FF)
        SDL.Flip(screen)
        x=x+1
        if x >= 16 then
            x = 0
            y = y + 1
        end
    end
end

function init(x, y, options)
    return {
        video = video(x, y, 32, options),
        run = run,
        exitGame = function() shouldExit = true end,
        setWindowTitle = function(title) SDL.WM_SetCaption(title, title) end
    }
end
