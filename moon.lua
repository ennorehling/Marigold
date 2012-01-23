local daisy = require('daisy')
local print = print
module('moon')

local function video()
    return nil
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
end

local function run()
    local gameInit = hook.get('gameInit')
    local frameRender = hook.get('frameRender')
    local frameUpdate = hook.get('frameUpdate')
    if gameInit~=nil then gameInit() end
    while not shouldExit do
        pump(0.1)
        if frameUpdate~=nil then frameUpdate(0.1) end
        if frameRender~=nil then frameRender() end
    end
end

function init(x, y, options)
    local screen = daisy.init(x, y, 32, options)
    print(screen)
    return {
        video = video(x, y, 32, options),
        run = run,
        exitGame = function() shouldExit = true end,
        setWindowTitle = function(title) daisy.setWindowTitle(title) end
    }
end
