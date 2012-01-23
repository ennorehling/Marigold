require('moon')

local daisy = moon.init(640, 480, moon.WINDOWED)
local hook = moon.hook

local function onKeyPress(key)
    b = b + 1
    if key==27 then -- ESC
        daisy.exitGame()
    end
end
hook.add('keyPress', onKeyPress)

local function mainInit()
    daisy.setWindowTitle("My Awesome Game v1.3.1")
    fps = 0
--    sprite = video.createSpriteState("Moon", "gfx.dat")
end
hook.add('gameInit', mainInit)

function onFrameRender()
    print('render')
end
hook.add("frameRender", onFrameRender)

function onFrameUpdate(time)
    print('update: ' .. time)
end
hook.add("frameUpdate", onFrameUpdate)

daisy.setWindowTitle("My Awesome Game v1.3.1")
daisy.run()
