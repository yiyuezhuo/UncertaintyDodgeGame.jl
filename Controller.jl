mutable struct Controller <: Starlight.Entity
    function Controller() 
      instantiate!(new(); ball=nothing, w=false, s=false, up=false, down=false, 
        p1TouchingTopWall=false, p2TouchingTopWall=false, 
        p1TouchingBottomWall=false, p2TouchingBottomWall=false)
    end
end

function Starlight.awake!(p::Controller)
    listenFor(p, SDL_KeyboardEvent)
    listenFor(p, SDL_QuitEvent)
    TS_BtSetGravity(0, 0, 0)
end
  
function Starlight.shutdown!(p::Controller)
    unlistenFrom(p, SDL_KeyboardEvent)
    unlistenFrom(p, SDL_QuitEvent)
end
  
function Starlight.handleMessage!(p::Controller, q::SDL_QuitEvent)
    shutdown!(app)
end

function Starlight.handleMessage!(p::Controller, key::SDL_KeyboardEvent)
    if key.keysym.scancode == SDL_SCANCODE_SPACE && key.state == SDL_PRESSED
      p.ball = newball()
    end
end

# controller = Controller()