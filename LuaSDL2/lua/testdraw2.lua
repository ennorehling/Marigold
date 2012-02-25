-- testdraw2.lua
package.path = 'lua/?.lua;' .. package.path
require('LuaSDL2')
require('common')

local num_objects = 100
local rect = SDL_CreateRect()
local viewport = SDL_CreateRect()
local current_alpha = 255
local current_color = 255

function DrawRects(renderer)
    SDL_RenderGetViewport(renderer, viewport)
    for i = 1, num_objects do
        rect.w = math.random() * (viewport.h / 2);
        rect.h = math.random() * (viewport.h / 2);
        rect.x = (math.random() * (viewport.w*2) - viewport.w) - (rect.w / 2);
        rect.y = (math.random() * (viewport.h*2) - viewport.h) - (rect.h / 2);
        SDL_SetRenderDrawColor(renderer, 255, current_color, current_color, current_alpha)
        SDL_RenderFillRect(renderer, rect)
    end
end

function main()
    state = common.CreateState(SDL_INIT_VIDEO)
    common.Init(state)
    
    for i = 1, state.num_windows do
        renderer = state.renderers[i]
        -- SDL_SetRenderDrawBlendMode(renderer, blendMode)
        SDL_SetRenderDrawColor(renderer, 0xA0, 0xA0, 0xA0, 0xFF)
        SDL_RenderClear(renderer)
    end
    
    frames = 0
    start = SDL_GetTicks()
    done = false
    event = SDL_CreateEvent()
    while not done do
        frames = frames + 1
        while SDL_PollEvent(event)~=0 do
            function onDone() done = true end
            common.Event(state, event, onDone)
        end
        for i = 1, state.num_windows do
            renderer = state.renderers[i]
            SDL_SetRenderDrawColor(renderer, 0xA0, 0xA0, 0xA0, 0xFF)
            SDL_RenderClear(renderer)
    
            DrawRects(renderer)
            -- DrawLines(renderer)
            -- DrawPoints(renderer)
    
            SDL_RenderPresent(renderer)
        end
    end
    SDL_Delay(500)
    SDL_Quit()
end

main()
