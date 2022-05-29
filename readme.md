# A dodge game with partial-observable obstacles

In this game, you dodge obstacles that are not directly observable as usual game. Your radar will collect noisy observations at random times and present the results of the [Kalman Filter](https://en.wikipedia.org/wiki/Kalman_filter). Since exact dodging becomes impossible, the collision would not end the game or decrease HP, but just increase a hit count, your score will be evaluated by the ratio of playing time to hit count with smoothing. Your goal is to find a solid policy to minimize your expected collision count.

## Run the game

```shell
julia Game.jl
```

Due to Julia's JIT, the game will freeze a few seconds at the beginning, and lag when some functions are called the first time.

### Control

* Arrow keys: Move the player.
* Space: Generate an obstacle manually.
* 1: Toggle visibility of obstacle (default: false). It is used to learn the mechanism and debug. It should not be enabled in a normal play.
* 2: Toggle auto-generating (default: true). You may want to disable auto-generating, press space to generate obstacles, and enable visibility to learn the mechanism.
* 3: Decrease auto-generating frequency.
* 4: Increase auto-generating frequency.
* 5: Toggle visibility of uncertainty area (default: true).

### Hints

* If you must choose an uncertainty region to pass, a boarder region is safer, since the "density" of obstacle is lower thus your path have a lower probability to collide with it.
* The obstacles are always generated from the border and point to the center. So if you are near the border, you will take the risk of a surprise of obstacle generated. While in the center region, the prior expected density is higher, but the risk can be avoid by agile control to some extent.

## Illustrations

![Screenshot 2022-05-29 162655](https://user-images.githubusercontent.com/12798270/170859327-11ae8c44-5b87-420c-b9e3-63a85e461125.png)

* Blue: The player.
* White: A ellipse is portrayed by 8 points. Kalman Filter gives the ellipse, or "uncertainty region", which is 1 sigma area of a posterior location distribution, which is normal distributed. 
* Red: Noisy observation for an obstacle.
* Green: (Require enabling manually) Exact location for an obstacle. The exact location may be outside of the uncertainty region, due to probability itself (the region is just a 1 sigma region) or lack of observation. 

## Formulations

The state of an obstacle is denoted by a 6-vector $X = (p_x, v_x, a_x, p_y, v_y, a_v)$ (position, velocity and acceleration of $x$ and $y$). The movement is driven by a random initial speed and a random "force" (the acceleration follows a Wiener process).

Parameters for [Kalman Filter](https://en.wikipedia.org/wiki/Kalman_filter):

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

The calculation calls [KalmanFilter.jl](https://github.com/JuliaGNSS/KalmanFilters.jl) to do the work.

See the [notebook gist](https://gist.github.com/yiyuezhuo/6f3d444cb507ad64e18c806033cce28c) for pure (non-game) simulation:

![Screenshot 2022-05-29 162238](https://user-images.githubusercontent.com/12798270/170859066-95afc7bd-db63-4e82-95ce-1453e12a192a.png)

## Notes

The game is based on [Starlight.jl](https://github.com/jhigginbotham64/Starlight.jl) engine and committed to a Julia game jam in the [Julia Discord's game-dev channel](https://discord.com/channels/762167454973296644/775962287461629952).

## TODO List

- [ ] More random moving pattern.
- [ ] More scan strategies. (Passive scan still are executed automatically, but the player can choose timing of "aggressive" scan.)
- [ ] Better game graphics.
