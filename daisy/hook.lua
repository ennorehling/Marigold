module('hook')

local hooks = {}

function add(name, func)
    hooks[name] = func
end

function get(name)
    return hooks[name]
end