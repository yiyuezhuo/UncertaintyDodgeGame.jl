using LinearAlgebra

mutable struct Planet <: Starlight.Renderable
    function Planet(w, h; kw...)
        instantiate!(new(); w=w, h=h, color=colorant"green", kw...)
    end
end

Starlight.draw(p::Planet) = defaultDrawRect(p) # Don't show Planet's exact location.

function Starlight.awake!(p::Planet)
    hw = p.w / 2
    hh = p.h / 2
    @show hw hh
    addTriggerBox!(p, hw, hh, 1, p.pos.x + hw, p.pos.y + hh, 0, 0, 0, 0)
end  

function Starlight.shutdown!(p::Planet)
  removePhysicsObject!(p)
  
  for s in p.satellites
    destroy!(s)
  end
  
end

const c45 = cos(π/4)
const satellites_mat = [
    1  c45  0    -c45  -1  -c45  0   c45
    0  c45  1     c45   0  -c45  -1  -c45
]

function sync_std_to_satellites!(p::Planet)
    mat = satellites_mat .* [p.std_x, p.std_y]
    for i in 1:size(satellites_mat, 2)
        p.satellites[i].offset_x = mat[1, i]
        p.satellites[i].offset_y = mat[2, i]
    end
end

function create_satellites!(p::Planet)
    mat = satellites_mat .* [p.std_x, p.std_y]
    for i in 1:size(satellites_mat, 2)
        pos = XYZ(p.pos.x + mat[1, i], p.pos.y + mat[2, i])
        s = Satellite(5, 5; pos=pos, planet=p, offset_x=mat[1, i], offset_y=mat[2, i])
        push!(p.satellites, s)
    end
end

const σ_acc_noise_x = 180
const σ_acc_noise_y = 600
const obs_noise_x = 10
const obs_noise_y = 10

function newball()
    posx = 750.
    posy = 700. * rand() + 50
    vel = normalize([400 - posx, 400 - posy]) * 160

    p = let x_init=[posx, vel[1], 0., posy, vel[2], 0.]
        measurement = H2 * x_init + [randn() * obs_noise_x, randn() * obs_noise_y]
        mu = measurement_update(x_init, P_init, measurement, H2, R2_for(obs_noise_x, obs_noise_y))
        c = get_covariance(mu)
        Planet(30, 30; pos=XYZ(round(Int, posx), round(Int, posy)), x=x_init, satellites=Any[], 
            std_x=sqrt(c[1,1]), std_y=sqrt(c[4,4]), 
            # last_obs_t=0.0, 
            mu=mu
        )    
    end

    println("newball middle")

    create_satellites!(p)
    # sync_std_to_satellites!(p)
    @show p.id
    TS_BtSetLinearVelocity(p.id, -160, 0, 0)
    return p
end

function Starlight.update!(p::Planet, Δ::AbstractFloat)
    p.x, p.mu = let x=p.x, Δt=Δ, mu=p.mu
        bx = QV_for(Δt, σ_acc_noise_x) .* randn()
        by = QV_for(Δt, σ_acc_noise_y) .* randn()
        # @show bx by
        x = F2_for(Δt) * x + [bx; by]
        # @show x
        
        # filter related
        # p.last_obs_t += Δt
        Q2 = Q2_for(Δt, σ_acc_noise_x, σ_acc_noise_y)
        mu = time_update(get_state(mu), get_covariance(mu), F2_for(Δt), Q2)

        if rand() < Δt
            measurement = [p.pos.x + randn() * obs_noise_x, p.pos.y + randn() * obs_noise_y]
            R2 = R2_for(obs_noise_x, obs_noise_y)
            mu = measurement_update(get_state(mu), get_covariance(mu), measurement, H2, R2)

            ObsLabel(5, 5; pos=XYZ(measurement[1], measurement[2]), acc_t=0)
        end

        x, mu
    end

    c = get_covariance(p.mu)
    p.std_x = sqrt(c[1,1])
    p.std_y = sqrt(c[4,4])
    sync_std_to_satellites!(p)

    TS_BtSetLinearVelocity(p.id, p.x[2], p.x[5], 0)
end


function Starlight.handleMessage!(p::Planet, col::TS_CollisionEvent)
    otherId = other(p, col)
    # other = getEntityById(otherId)
    println("TS_CollisionEvent: p.id=$(p.id) otherId=$otherId")
    # other = getEntityById(otherId)
    # println("other=$other typeof(other)=$(typeof(other))")
    # if other.
    if otherId ∈ destory_set # TODO: refactor this inversed global dependency
        destroy!(p)
        # oneshot!(clk(), wait_and_start_new_round)
    end
end