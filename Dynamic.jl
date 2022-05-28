function F_for(Δt)
    [1 Δt Δt^2/2; 
    0 1 Δt; 
    0 0 1]
end

function F2_for(Δt)
    F = F_for(Δt)
    [F zero(F); zero(F) F]
end

function QV_for(Δt, σ_acc_noise)
    [Δt^3/6; Δt^2/2; Δt] * σ_acc_noise
end

# x_init = [750.0, -160.0, 0.0, 400.0, 0, 0]
