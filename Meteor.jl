
mutable struct Meteor <: Starlight.Renderable # aka player
    function Meteor(w, h; kw...)
        instantiate!(new(); w=w, h=h, color=colorant"blue",
            up=false, down=false, left=false, right=false,
            kw...)
    end
end

Starlight.draw(p::Meteor) = defaultDrawRect(p) # Don't show Planet's exact location.

function Starlight.awake!(p::Meteor)
    hw = p.w / 2
    hh = p.h / 2
    println("Meteor: hx=$hw hy=$hh px=$(p.pos.x + hw) py=$(p.pos.y + hh)")
    addTriggerBox!(p, hw, hh, 1, p.pos.x + hw, p.pos.y + hh, 0, 0, 0, 0)

    listenFor(p, SDL_KeyboardEvent)
end

function Starlight.shutdown!(p::Meteor)
    removePhysicsObject!(p)

    unlistenFrom(p, SDL_KeyboardEvent)
end  

function Starlight.handleMessage!(c::Meteor, k::SDL_KeyboardEvent)
    
    pressed = k.state == SDL_PRESSED
    code = k.keysym.scancode
    
    if code == SDL_SCANCODE_UP
        c.up = pressed
    elseif code == SDL_SCANCODE_DOWN
        c.down = pressed
    elseif code == SDL_SCANCODE_LEFT
        c.left = pressed
    elseif code == SDL_SCANCODE_RIGHT
        c.right = pressed
    end

    # @show pressed code
end

const meteor_speed = 300

function Starlight.update!(c::Meteor, Δ::AbstractFloat)
    v = [0., 0.]

    if c.up
        v[2] -= 1
    end
    if c.down
        v[2] += 1
    end
    if c.left
        v[1] -= 1
    end
    if c.right
        v[1] += 1
    end

    if v[1] < 0 && c.pos.x <= 0
        v[1] = 0
    end
    if v[1] > 0 && c.pos.x + c.w >= 800
        v[1] = 0
    end
    if v[2] < 0 && c.pos.y <= 0
        v[2] = 0
    end
    if v[2] > 0 && c.pos.y + c.h >= 800
        v[2] = 0
    end

    if !(v[1] == 0 && v[2] == 0)
        v = normalize(v) * meteor_speed
        # @show v
    end
    TS_BtSetLinearVelocity(c.id, v[1], v[2], 0)
end

function Starlight.handleMessage!(p::Meteor, col::TS_CollisionEvent)
    otherId = other(p, col)
    println("(Meteor) TS_CollisionEvent: p.id=$(p.id) otherId=$otherId")
    if otherId ∈ wall_set # TODO: refactor this inversed global dependency
        # destroy!(p)
        # TODO: what should it do? block or decrease score?
    else # planets
        println("Hit planet!")
        count_hit!(controller)
    end
end
