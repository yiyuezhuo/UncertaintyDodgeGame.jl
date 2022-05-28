# mutable struct BoundaryWall <: Starlight.Entity
mutable struct BoundaryWall <: Starlight.Renderable
    function BoundaryWall(w, h; kw...)
        instantiate!(new(); w=w, h=h, color=colorant"purple", kw...)
    end
end

Starlight.draw(p::BoundaryWall) = defaultDrawRect(p)

function Starlight.awake!(p::BoundaryWall)
    hw = p.w / 2
    # @show hw
    hh = p.h / 2
    # @show hh
    println("BoundaryWall: hx=$hw hy=$hh px=$(p.pos.x + hw) py=$(p.pos.y + hh)")
    addTriggerBox!(p, hw, hh, 1, p.pos.x + hw, p.pos.y + hh, 0, 0, 0, 0)
end

function Starlight.update!(p::BoundaryWall, Δ::AbstractFloat)
    TS_BtSetLinearVelocity(p.id, 0, 0, 0) # disable gravity
end
