mutable struct Controller <: Starlight.Entity
    function Controller() 
      instantiate!(new(); reveal_exact=false, auto_generating=true, generating_coef = 1.0, uncertainty_area=true, acc_t=0.0, acc_hit=0)
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
        elseif code == SDL_SCANCODE_2 # toggle auto generating
            p.auto_generating = !p.auto_generating
        elseif code == SDL_SCANCODE_3 # decrease auto generating frequency
            p.generating_coef *= 2 / 3
        elseif code == SDL_SCANCODE_4 # increase auto generating frequency
            p.generating_coef *= 3 / 2
        elseif code == SDL_SCANCODE_5 # toggle uncertainty_area
            p.uncertainty_area = !p.uncertainty_area
        end
    end 
end

function Starlight.update!(p::Controller, Δ::AbstractFloat)
    p.acc_t += Δ

    # @show p.acc_t

    time_text.str = string(Int(p.acc_t ÷ 1))
    ranking_text.str = round((p.acc_t + 5) / (p.acc_hit + 5); digits=2) |> string

    if p.auto_generating
        if rand() < Δ * p.generating_coef
            newball()
        end
    end
end

function count_hit!(p::Controller)
    p.acc_hit += 1
    hit_text.str = string(p.acc_hit)
end


# controller = Controller()