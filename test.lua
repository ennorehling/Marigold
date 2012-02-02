local SDL = require('daisy')

local timeout = 1000
local function cb(interval, sem)
    print("hello")
    SDL.SemPost(sem)
    return 0
end

SDL.Init()
sem = SDL.CreateSemaphore(0)
SDL.AddTimer(timeout, cb, sem)
a, b = SDL.WaitEvent()
print("start")
SDL.SemWait(sem)
print("done")
SDL.DestroySemaphore(sem)
