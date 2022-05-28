mutable struct ObsLabel <: Starlight.Renderable
    function ObsLabel(w, h; kw...)
        instantiate!(new(); w=w, h=h, color=colorant"red", kw...)
    end
end

Starlight.draw(p::ObsLabel) = defaultDrawRect(p)

function Starlight.update!(p::ObsLabel, Δ::AbstractFloat)
    p.acc_t += Δ

    if p.acc_t > 1
        destroy!(p)
    end
end

# obs_label = ObsLabel(50, 50; pos=XYZ(400, 400), acc_t=0)
