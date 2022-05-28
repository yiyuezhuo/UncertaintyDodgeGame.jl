using KalmanFilters

function Q_for(Δt, σ_acc_noise)
    qv = QV_for(Δt, σ_acc_noise)
    return qv * qv'
end

function Q2_for(Δt, σ_acc_noise_x, σ_acc_noise_y)
    Qx = Q_for(Δt, σ_acc_noise_x)
    Qy = Q_for(Δt, σ_acc_noise_y)
    [Qx zero(Qx); zero(Qy) Qy]
end

R2_for(obs_noise_x, obs_noise_y) = [obs_noise_x^2 0; 0 obs_noise_y^2]

P_init_x = [
    2.5 0.25 0.1; 
    0.25 2.5 0.2; 
    0.1 0.2 2.5
]
P_init_y = [
    2.5 0.25 0.1; 
    0.25 2.5 0.2; 
    0.1 0.2 2.5
]
P_init = [
    P_init_x zero(P_init_x); 
    zero(P_init_y) P_init_y
]

H2 = [
    1 0 0 0 0 0;
    0 0 0 1 0 0
]

