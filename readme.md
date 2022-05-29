# A dodge game with partial-observable obstacles

In this game, you dodge obstacles which is not always observable as usual game. You should control your radar to get noisy observation at some time and work with result of [Kalman Filter](https://en.wikipedia.org/wiki/Kalman_filter) at most of time. Since exact dodging become impossible, collision would not end game or decrease HP, but just increase a hit count and give you a immunity time period. Your goal is to find a solid policy to minimize your expected collision count.

## Run the game

```shell
julia Game.jl
```

## Illustrations

Red points are noisy observations location, 8 points are used to portray the contour of the 1σ area of the Kalman Filter. So it's possible the target is outside of the area due to properties of Kalman Filter (probability or "failure" to handle big scale maneuver).

* Blue: The player.
* White: One sigma uncertainty region for a obstacle.
* Red: Noisy observation for a obstacle.
* Green: (Enable manually) Exact location for a obstacle.

## Tactics

* If you must choose a uncertainty region to pass, a boarder region is safer, since the obstacle is "distributed" more sparsely and your path have a lower probability to collide with it.
* The obstacles are always generated from border and point to the center. So if you are near the border, you will take the risk of a surprise of obstacle generated. While in center region, the prior expected density is higher, but the risk can be avoid by agile control to some extend.

## Formulations

The state of a obstacle is denoted by a 6-vector $X = (p_x, v_x, a_x, p_y, v_y, a_v)$ (position, velocity and acceleration of $x$ and $y$). The movement are driven by a random initial speed and a random "force" (the the acceleration follow a Wiener process).

State transition model (matrix):

$$
F_1 = \begin{bmatrix}
1 & \Delta t & \Delta t^2/2 \\
0 & 1 & \Delta t \\
0 & 0 & 1
\end{bmatrix}
$$

$$
F = \begin{bmatrix}
F_1 & 0 \\ 
0 & F_1
\end{bmatrix}
$$

Process noise:
$$
Q_1 =
\begin{bmatrix}
\Delta t^3 / 6 & \Delta t^2 / 2 & \Delta t
\end{bmatrix}'
$$

$$
Q = \begin{bmatrix}
Q_1 Q_1' & 0 \\
0 & Q_1 Q_1'
\end{bmatrix}
$$

Observation model:

$$
H = \begin{bmatrix}
1 & 0 & 0 & 0 & 0 & 0 \\
0 & 0 & 0 & 1 & 0 & 0
\end{bmatrix}
$$

Observation noise:

$$
R = \begin{bmatrix}
\sigma^2_{px} & 0 \\
0 & \sigma^2_{py}
\end{bmatrix}
$$

The calculation call [KalmanFilter.jl](https://github.com/JuliaGNSS/KalmanFilters.jl) to do the work.

## Notes

The game is based on [Starlight.jl](https://github.com/jhigginbotham64/Starlight.jl) engine and committed to a Julia game jam in the [Julia Discord's game-dev channel](https://discord.com/channels/762167454973296644/775962287461629952).

