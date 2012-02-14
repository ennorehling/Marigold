require('LuaSDL')
require('daisy.hook')
require('daisy.video')

local hook = hook
module('daisy')

function main()
    local gameInit = hook.get("gameInit")
    local frameRender = hook.get("frameRender")
    local frameUpdate = hook.get("frameUpdate")
    if gameInit~=nil then gameInit() end
    local endGame = false
    repeat
        endGame = true
        if frameRender~=nil then frameRender() end
        if frameUpdate~=nil then frameUpdate(0) end
    until endGame
end

function getMousePosition()
    return 0, 0
end

function isMouseButtonPressed(index)
    return false
end