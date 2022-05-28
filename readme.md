# A dodge game with partial-observable obstacles

In this game, you dodge obstacles which is not always observable as usual game. You should control your radar to get noisy observation at some time and work with result of [Kalman Filter](https://en.wikipedia.org/wiki/Kalman_filter) at most of time. Since exact dodging become impossible, collision would not end game or decrease HP, but just increase a hit count and give you a immunity time period. Your goal is to find a solid policy to minimize your expected collision count.

## Run the game

```shell
julia Game.jl
```

## Illustration

Red points are noisy observations location, 8 points are used to portray the contour of the 1σ area of the Kalman Filter. So it's possible the target is outside of the area due to properties of Kalman Filter (probability or "failure" to handle big scale maneuver)

## Notes

The game is based on [Starlight.jl](https://github.com/jhigginbotham64/Starlight.jl) engine and committed to a Julia game jam in the Julia Discord.

