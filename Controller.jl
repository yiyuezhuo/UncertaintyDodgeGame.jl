mutable struct Controller <: Starlight.Entity
    function Controller() 
      instantiate!(new(); reveal_exact=false)
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
    pressed =  key.state == SDL_PRESSED
    code = key.keysym.scancode
    if pressed
        if code == SDL_SCANCODE_SPACE && key.state == SDL_PRESSED
            # p.ball = newball()
            newball()
        elseif code == SDL_SCANCODE_1 # toggle hidden exact location visibility
            p.reveal_exact = !p.reveal_exact
        end
    end 
end

function Starlight.update!(p::Controller, Δ::AbstractFloat)
    if rand() < Δ
        newball()
    end
end

# controller = Controller()