mutable struct Satellite <: Starlight.Renderable
    function Satellite(w, h; kw...)
        instantiate!(new(); w=w, h=h, color=colorant"white", kw...)
    end
end

Starlight.draw(p::Satellite) = defaultDrawRect(p)

function Starlight.update!(p::Satellite, Δ::AbstractFloat)
    #=
    p.pos.x = p.planet.pos.x + p.offset_x
    p.pos.y = p.planet.pos.y + p.offset_y
    =#
    s = get_state(p.planet.mu)
    p.pos.x = s[1] + p.offset_x
    p.pos.y = s[4] + p.offset_y
end
