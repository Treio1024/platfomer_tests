function love.conf(t)
    t.graphics.setDefaultFilter("nearest", "nearest")
    
    t.version = "11.3"
    t.window.width = 1280
    t.window.height = 768
    t.title = string.format('test %.2f', love.getVersion())

    t.console = true
    t.window.vsync = 0
end