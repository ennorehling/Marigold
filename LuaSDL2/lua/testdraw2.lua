-- testdraw2.lua
package.path = 'lua/?.lua;' .. package.path
require('LuaSDL2')
require('common')

local num_objects = 100
local rect = SDL_CreateRect()
local viewport = SDL_CreateRect()
local current_alpha = 255
local current_color = 0
local cycle_direction = 1

local bmp_pave = SDL_LoadBMP("assets/pave.bmp")
local tex_pave = nil
local frames = 0
local src = SDL_CreateRect()
local dst = SDL_CreateRect()
function DrawSprites(renderer)
    if not tex_pave then
        tex_pave = SDL_CreateTextureFromSurface(renderer, bmp_pave)
        src.x = 40
        src.y = 41
        src.w = 40
        src.h = 40
        dst.w = 40
        dst.h = 40
    end
    for x = 1, 10 do
        dst.x = 40*x
        for y = 1, 10 do
            src.x = 40 + 80 * (math.mod(x+y, 5))
            src.y = 41 + 80 * (math.mod(x+y, 4))
            dst.y = 40*y
            SDL_RenderCopy(renderer, tex_pave, src, dst)
        end
    end
end

function DrawRects(renderer)
    SDL_RenderGetViewport(renderer, viewport)
    for i = 1, num_objects do
        current_color = current_color + cycle_direction
        if current_color < 0 then
            current_color = 0
            cycle_direction = -cycle_direction
        end
        if current_color > 255 then
            current_color = 255
            cycle_direction = -cycle_direction
        end
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
    
    start = SDL_GetTicks()
    done = false
    local event = SDL_CreateEvent()
    while not done do
        frames = frames + 1
        while SDL_PollEvent(event)~=0 do
            function onDone() done = true end
            common.Event(state, event, onDone)
            w = event.window
        end
        for i = 1, state.num_windows do
            renderer = state.renderers[i]
            SDL_SetRenderDrawColor(renderer, 0xA0, 0xA0, 0xA0, 0xFF)
            SDL_RenderClear(renderer)
    
            DrawRects(renderer)
            DrawSprites(renderer)
            -- DrawLines(renderer)
            -- DrawPoints(renderer)
    
            SDL_RenderPresent(renderer)
        end
    end
    SDL_Delay(500)
    SDL_Quit()
end

main()
