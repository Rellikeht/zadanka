include("zad3.jl")

using GLMakie
using FileIO
using Observables
using Colors

using SparseArrays # this is in base already
using LinearAlgebra

const DEFAULT_BITMAP_ELEMENTS = (50, 50)
const DEFAULT_BITMAP_DEGREE = (2, 2)
const X = 2, Y = 1

GLMakie.activate!(framerate=60)

function bitmap_terrain(
    bitmap::String;
    elements::NTuple{2,Integer}=DEFAULT_BITMAP_ELEMENTS,
    degree::NTuple{2,Integer}=DEFAULT_BITMAP_DEGREE,
)
    bitmap_terrain(abs(load(bitmap)); elements, degree)
end

function bitmap_terrain(
    bitmap::AbstractMatrix{<:AbstractRGB};
    elements::NTuple{2,Integer}=DEFAULT_BITMAP_ELEMENTS,
    degree::NTuple{2,Integer}=DEFAULT_BITMAP_DEGREE,
)
    # TODO
end

function bitmap_terrain(
    bitmap::AbstractMatrix{<:Real};
    elements::NTuple{2,Integer}=DEFAULT_BITMAP_ELEMENTS,
    degree::NTuple{2,Integer}=DEFAULT_BITMAP_DEGREE,
)
    R = typeof(bitmap).parameters[1]
    prec = @. 2 * (elements + degree) + 1

    knot_vector = Vector{R}(undef, 0), Vector{R}(undef, 0)
    get_knots!.(knot_vector, elements, degree)
    ns = ((ks, d) -> length(ks) - d - 1).(knot_vector, degree)
    A = (s -> sparse(R, I, s, s)).(elements)
    FR = Matrix{R}(undef, elements)
    FG = deepcopy(FR)
    FB = deepcopy(FR)
    # splines = Array{R}.(undef, elements, elements, degree .+ 1)

    splines = Array{R}.(undef, degree .+ 1, elements, elements)
    coeffs = Matrix{R}(undef, elements)
    # all below had .+1 to precision
    GRAY = Matrix{R}(undef, prec)
    result = Matrix{R}(undef, prec) # Z
    temp = Matrix{R}(undef, prec)
    ts = Vector{R}.(undef, prec)
    ts = adjust_ts!.(ts, prec, knot_vector)
    xspline = Vector{R}(undef, prec[X]),
    ysplines = Matrix{R}(undef, prec)

    for D in [Y, X]
        for e in 1:elements[D]
            low, high = dofs_on_element(knot_vector[D], degree[D], e)
            bounds = element_boundary(knot_vector[D], degree[D], e)
            qp = quad_points(bounds..., degree[D] + 1)
            # qw = quad_weights(bounds..., degree[D] + 1)
            for bi in low:high
                splines[D][:, bi, e] = calc_point.(
                    (knot_vector[D],),
                    (degree[D],),
                    (bi,),
                    qp,
                )
            end
        end
    end

    # % integral B^x_i(x) B^y_j(y) B^x_k(x) B^y_l(y)
    # % (i,k=1,...,Nx; j,l=1,...,Ny)px
    # % loop over elements over x axis
    # for ex = 1:elementsx;
    #   % range of nonzero functions over element
    #   [xl,xh] = dofs_on_element(knot_vectorx,px,ex);
    #   % range of element (left and right edge over x axis)
    #   [ex_bound_l,ex_bound_h] = element_boundary(knot_vectorx,px,ex);
    #   % Jacobian = size of element
    #   J = ex_bound_h - ex_bound_l;
    #   % quadrature points over element (over x axis)
    #   qpx = quad_points(ex_bound_l,ex_bound_h,px+1);
    #   % quadrature weights over element (over x axis)
    #   qwx = quad_weights(ex_bound_l,ex_bound_h,px+1);
    #   % loop over nonzero functions over element
    #   for bi = xl:xh
    #     for bk = xl:xh
    #       % loop over quadrature points
    #       for iqx = 1:size(qpx,2)
    #         % B^x_k(x)
    #         funk = splinex(ex,bk,iqx);
    #         % B^x_i(x)
    #         funi = splinex(ex,bi,iqx);
    #         % B^x_i(x) B^y_j(y) B^x_k(x) B^y_l(y)
    #         fun = funi*funk;

    #         % integral z B^x_i(x) B^y_j(y) B^x_k(x) B^y_l(y)
    #         % (i,k=1,...,Nx; j,l=1,...,Ny)
    #         int = fun*qwx(iqx)*J;
    #         if (int~=0)
    #           Ax(bi,bk) = Ax(bi,bk) + int;
    #         end
    #       end
    #     end
    #   end
    # end


    # % integral B^x_i(x) B^y_j(y) B^x_k(x) B^y_l(y)
    # % (i,k=1,...,Nx; j,l=1,...,Ny)
    # % loop over elements on y axis
    # for ey = 1:elementsy
    #   % range of nonzero functions over element
    #   [yl,yh] = dofs_on_element(knot_vectory,py,ey);
    #   % range of element (left and right edge over y axis)
    #   [ey_bound_l,ey_bound_h] = element_boundary(knot_vectory,py,ey);
    #   % Jacobian = size of element
    #   J = ey_bound_h - ey_bound_l;
    #   % quadrature points over element (over y axis)
    #   qpy = quad_points(ey_bound_l,ey_bound_h,py+1);
    #   % quadrature weights over element (over y axis)
    #   qwy = quad_weights(ey_bound_l,ey_bound_h,py+1);
    #   % loop over nonzero functions over element
    #   for bj = yl:yh
    #     for bl = yl:yh
    #       % loop over quadrature points      
    #       for iqy = 1:size(qpy,2)
    #         % B^y_l(y)
    #         funl = spliney(ey,bl,iqy);
    #         % B^y_j(y)
    #         funj = spliney(ey,bj,iqy);
    #         % B^x_i(x) B^y_j(y) B^x_k(x) B^y_l(y)
    #         fun = funj*funl;

    #         % integral z B^x_i(x) B^y_j(y) B^x_k(x) B^y_l(y)
    #         % (i,k=1,...,Nx; j,l=1,...,Ny)
    #         int = fun*qwy(iqy)*J;
    #         if (int~=0)
    #           Ay(bj,bl) = Ay(bj,bl) + int;
    #         end
    #       end
    #     end
    #   end
    # end



    # TODO WTF
    # % Helper subroutine for integration over bitmap
    # function val=bitmp(M,x,y)
    #   val = zeros(size(x));
    #   for i=1:size(x,1)
    #     for j=1:size(x,1)
    #       val(i,j)=M(xx(x(1,i)),yy(y(1,j)));
    #     end
    #   end
    # end
    # this boils down to single number
    # bitmp(M,x,y) = M[(
    #     res.(size(bitmap), (a -> a[begin]).((x, y)))
    # )...]

    # % Integral BITMAP(x,y) B^x_k(x) B^y_l(y)
    # % loop over elements on x axis
    # for ex = 1:elementsx;
    #   % range of nonzero functions over element
    #   [xl,xh] = dofs_on_element(knot_vectorx,px,ex);
    #   % range of element (left and right edge over x axis)
    #   [ex_bound_l,ex_bound_h] = element_boundary(knot_vectorx,px,ex);
    #   % loop over elements on y axis
    #   for ey = 1:elementsy
    #     % range of nonzero functions over element
    #     [yl,yh] = dofs_on_element(knot_vectory,py,ey);
    #     % range of element (left and right edge over y axis)
    #     [ey_bound_l,ey_bound_h] = element_boundary(knot_vectory,py,ey);
    #     % Jacobian = size of element
    #     Jx = ex_bound_h - ex_bound_l;
    #     Jy = ey_bound_h - ey_bound_l;
    #     J = Jx * Jy;
    #     % quadrature points over element (over x axis)
    #     qpx = quad_points(ex_bound_l,ex_bound_h,px+1);
    #     % quadrature points over element (over y axis)
    #     qpy = quad_points(ey_bound_l,ey_bound_h,py+1);
    #     % quadrature weights over element (over x axis)
    #     qwx = quad_weights(ex_bound_l,ex_bound_h,px+1);
    #     % quadrature weights over element (over y axis)
    #     qwy = quad_weights(ey_bound_l,ey_bound_h,py+1);
    #     % loop over nonzero functions over element
    #     for bk = xl:xh
    #       for bl = yl:yh  
    #         % loop over quadrature points      
    #         for iqx = 1:size(qpx,2)
    #           for iqy = 1:size(qpy,2)
    #             % B^x_k(x)
    #             funk = splinex(ex,bk,iqx);
    #             % B^y_l(y)
    #             funl = spliney(ey,bl,iqy);
    #             % integral BITMAP(x,y) B^x_k(x) B^y_l(y) over RGB components
    #             intR = funk*funl*qwx(iqx)*qwy(iqy)*J*bitmp(R,qpx(iqx),qpy(iqy));
    #             intG = funk*funl*qwx(iqx)*qwy(iqy)*J*bitmp(G,qpx(iqx),qpy(iqy));
    #             intB = funk*funl*qwx(iqx)*qwy(iqy)*J*bitmp(B,qpx(iqx),qpy(iqy));
    #             FRx(bk,bl) = FRx(bk,bl) + intR;
    #             FGx(bk,bl) = FGx(bk,bl) + intG;
    #             FBx(bk,bl) = FBx(bk,bl) + intB;
    #           end
    #         end
    #       end
    #     end
    #   end
    # end

    RR, GG, BB = solve_direction(A[X], FR, FG, FB)
    RR, GG, BB = solve_direction(
        A[Y],
        transpose(RR),
        transpose(GG),
        transpose(BB),
    )
    RR, BB, GG = transpose.((RR, GG, BB))

    if ns == prec
        GRAY .= gray.(RR, GG, BB)
    else
        for i in 1:size(GRAY)[X]
            for j in 1:size(GRAY)[Y]
                i1 = @. floor(((j, i) - 1) / floor(precision / ns)) + 1
                GRAY[j, i] = gray((a -> a[i1...]).(RR, GG, BB)...)
            end
        end
    end
    # GRAY[prec[Y]+1, :] = GRAY[prec[Y], :]
    # GRAY[:, prec[X]+1] = GRAY[:, prec[X]]

    # Should suffice
    update_plane!(
        result,
        coeffs,
        xspline,
        ysplines,
        temp,
        ts,
        knot_vector,
        degree,
    )
    return result
end

# TODO does this work
function solve_direction(
    A::AbstractSparseMatrix,
    FR,
    FG,
    FB,
)
    R = typeof(A).parameters[1]
    F = lu(A)
    RR = zeros(R, size(FR))
    GG = zeros(R, size(FG))
    BB = zeros(R, size(FB))
    for i in eachindex(FR)
        RR[:, i] = solveRHS(F, FR[:, i])
        GG[:, i] = solveRHS(F, FG[:, i])
        BB[:, i] = solveRHS(F, FB[:, i])
    end
    return RR, GG, BB
end

function solveRHS(
    input::Factorization,
    b::Real,
)
    return transpose(input.Q) \ (input.U \ (input.L \ (input.P .* b)))
end

function res(
    img_size::Integer,
    coord::Real,
)
    return floor((img_size - 1) * coord + 1)
end

function dofs_on_element(
    knot_vector::AbstractVector{<:Real},
    p::Integer,
    elem_number::Integer,
)
    return (0, p) .+ first_dof_on_element(knot_vector, p, elem_number)
end

function first_dof_on_element(
    knot_vector::AbstractVector{<:Real},
    p::Integer,
    elem_number::Integer,
)
    low, _ = element_boundary(knot_vector, p, elem_number)
    return findfirst(x -> x == low, knot_vector)
end

# % Finds lower and higher boundary of element
# function [low,high]=element_boundary(knot_vector,p,elem_number)
#   initial = knot_vector(1);
#   kvsize = size(knot_vector,2);
#   k = 0;
#   low=0;
#   high=0;
#   for i=1:kvsize
#     if (knot_vector(i) ~= initial)
#       initial = knot_vector(i);
#       k = k+1;
#     end
#     if (k == elem_number)
#       low = knot_vector(i-1);
#       high = knot_vector(i);
#       return;
#     end
#   end
# end

function element_boundary(
    knots::AbstractVector{<:Real},
    degree::Integer,
    number::Integer,
)
    # TODO do this for general case with loops
    # k = degree+1
    # initial = knot_vector[k]
    # for i in k:length(knots)
    #     if knot_vector[i] != initial
    #         k, initial = k+1, knot_vector[i]
    #     end
    # end
    return knots[[number + degree, number + degree + 1]]
end

function quad_points(
    a::R,
    b::R,
    k::Integer,
) where {R<:Real}
    POINTS = [
        R.([0]),
        R.([-1, 1]) ./ R(3),
        [-1, 0, 1] .* sqrt(R(3) / R(5)),
        [-1, -1, 1, 1] .* sqrt.(
            R(3) .* [1, -1, -1, 1] .*
            R(2) .* sqrt(R(6) / R(5))
        ) / R(7),
        [-1, -1, 0, 1, 1] .* sqrt.(
            R(5) .* [1, -1, 0, 1, -1] .* sqrt(R(10) / R(7))
        )
    ]
    if !(k in eachindex(POINTS))
        k = maximum(eachindex(POINTS))
    end
    return @. 0.5 * (a * (1 - POINTS[k]) + b * (POINTS[k] + 1))
end

function quad_weights(
    _::R,
    _::R,
    k::Integer,
) where {R<:Real}
    WEIGHTS = [
        R.([2]),
        R.([1, 1]),
        R.([5, 8, 5]) ./ R(9),
        R(18) .+ [-1, 1, 1, -1] .* sqrt(R(30)) ./ R(36),
        (
            R.([322, 322, 512, 322, 322]) .+
            R(13) .* [-1, 1, 0, 1, -1] .* sqrt(R(70))
        ) ./ R(900)
    ]
    if !(k in eachindex(WEIGHTS))
        k = maximum(eachindex(WEIGHTS))
    end
    return WEIGHTS[k]
end

function orig_gray(color::AbstractRGB)
    return typeof(color)(
        1.0 - 0.3 * color.r - 0.59 * color.g - 0.11 * color.b
    )
end
