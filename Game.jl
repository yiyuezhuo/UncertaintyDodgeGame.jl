using Starlight

include("Dynamic.jl")
include("Kalman.jl")

include("ObsLabel.jl")
include("BoundaryWall.jl")
include("Satellite.jl")
include("Planet.jl")
include("Controller.jl")

app = App(; wdth=800, hght=800)

controller = Controller()

wall_left = BoundaryWall(10, 800, pos=XYZ(-10, 0))
wall_right = BoundaryWall(10, 800, pos=XYZ(800, 0))
wall_top = BoundaryWall(800, 10, pos=XYZ(0, -10))
wall_bottom = BoundaryWall(800, 10, pos=XYZ(0, 800))

# TODO: refactor those inversed dependencies
destory_set = Set{Int}()
for wall in [wall_left, wall_right, wall_top, wall_bottom]
    push!(destory_set, wall.id)
end

run!(app)
