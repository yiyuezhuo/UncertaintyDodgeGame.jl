mutable struct BoundaryWall <: Starlight.Entity
    function BoundaryWall(w, h; kw...)
        instantiate!(new(); w=w, h=h, kw...)
    end
end

function Starlight.awake!(bw::BoundaryWall)
    hw = bw.w / 2
    @show hw
    hh = bw.h / 2
    @show hh
    addTriggerBox!(bw, hw, hh, 1, bw.pos.x + hw, bw.pos.y + hh, 0, 0, 0, 0)
end
