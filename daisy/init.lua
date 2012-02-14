require('LuaSDL')
require('daisy.hook')
require('daisy.video')
require('daisy.audio')

--local SDL_GetTicks = SDL_GetTicks
--local SDL_CreateEvent = SDL_CreateEvent
--local SDL_PollEvent = SDL_PollEvent
local hook = hook
local video = video
local print = print

module('daisy', package.seeall) -- TODO: do not use this

local event = SDL_CreateEvent()
local mouseX = 0
local mouseY = 0
local buttons = { false, false, false }

function main()
    local gameInit = hook.get("gameInit")
    local frameRender = hook.get("frameRender")
    local frameUpdate = hook.get("frameUpdate")

    video._open()
    if gameInit~=nil then gameInit() end
    local endGame = false
    repeat
        while SDL_PollEvent(event)~=0 do
            print(event.type, SDL_QUIT, SDL_MOUSEMOTION)
            if event.type==SDL_MOUSEMOTION then
                mouseX = event.motion.x
                mouseY = event.motion.y
                print(mouseX, mouseY)
            elseif event.type==SDL_MOUSEBUTTONUP then
                buttons[0] = false
                break
            elseif event.type==SDL_MOUSEBUTTONDOWN then
                buttons[0] = true
                break
            elseif event.type==SDL_QUIT then
                endGame = true
                break
            end
        end
        local time = SDL_GetTicks()/1000
        if frameUpdate~=nil then frameUpdate(time) end
        if frameRender~=nil then frameRender() end
        video._flip()
--        endGame = true
    until endGame
    
    local gameClose = hook.get("gameClose")
    if gameClose~=nil then gameClose() end
end

function getMousePosition()
    return mouseX, mouseY
end

function isMouseButtonPressed(index)
    return buttons[index]
end
