using GLMakie, Makie
GLMakie.activate!()

function circle!(
    scene::Scene,
    x::Union{Int,Float64},
    y::Union{Int,Float64},
    r::Union{Int,Float64};
    pts::Int=Int(round(10 * 2 * π * r)),
    color::String="#ffffff",
    psize::Union{Int,Float64}=5
)
    scatter!(
        scene,
        [x + r * cos(2 * pi * t / pts) for t in 1:pts],
        [y + r * sin(2 * pi * t / pts) for t in 1:pts],
        color=color,
        markersize=psize
    )
end

function main()::Scene
    scene::Scene = Scene(backgroundcolor=:white)
    scx::Int, scy::Int = size(scene)
    campixel!(scene)

    # image!(scene, [(i+j)/(scx+scy) for i in 1:scx,j in 1:scy])
    # image!(scene, [i/scx for i in 1:scx,j in 1:scy])
    image!(scene, [RGBf(i / scx, j / scy, 0) for i in 1:scx, j in 1:scy])
    circle!(scene, 800, 500, 200)
    circle!(scene, 1000, 400, 300, color="#0000ff")

    scene
end
main()
