include("zad3.jl")

function ReversedPlane(
    coeffs::Union{AbstractMatrix{<:Real},Observable{AbstractMatrix{<:Real}}};
    accuracy::NTuple{2,Integer}=DEFAULT_PLANE_ACCURACY,
    degree::NTuple{2,Integer}=DEFAULT_PLANE_DEGREE,
)
    return SplinePlane(
        [coeffs; zeros(1, size(coeffs)[2]); (-reverse(coeffs;dims=2))];
        accuracy,
        degree,
    )
end
