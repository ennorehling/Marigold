local SDL = require('daisy')

local timeout = 1000
local function cb(sem)
    print("hello")
    SDL.SemPost(sem)
    return timeout
end

sem = SDL.CreateSemaphore(0)
SDL.AddTimer(timeout, cb, sem)
a, b = SDL.WaitEvent()
print("start")
SDL.SemWait(sem)
print(sem)
SDL.DestroySemaphore(sem)
