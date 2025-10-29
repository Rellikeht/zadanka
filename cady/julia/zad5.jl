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
    GRAY = Matrix{R}(undef, prec)
    result = Matrix{R}(undef, prec) # Z
    temp = Matrix{R}(undef, prec)
    ts = Vector{R}.(undef, precision)
    ts = adjust_ts!.(ts, precision, knot_vector)

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

    RRx, GGx, BBx = solve_direction(A, FR, FG, FB)
    RRy, GGy, BBy = solve_direction(
        A,
        transpose(FR),
        transpose(FG),
        transpose(FB),
    )

    # % reconstruction of image
    # % set zero to reconstructed image matrices
    # R1 = zeros(ix,iy);
    # G1 = zeros(ix,iy);
    # B1 = zeros(ix,iy);


    # funx_tab = zeros(nx,ix);
    # funy_tab = zeros(ny,iy);

    # % precache basis functions values
    # % loop over basis functions
    # for bi = 1:nx
    #   % loop over nonzero pixels over given function
    #   for i=xx(knot_vectorx(bi)):xx(knot_vectorx(bi+px+1))
    #     % scale coordinates [1-width] -> [0-1]
    #     ii = (i-1)/(ix-1);
    #     % B^x_i(x)
    #     funx_tab(bi,i) = compute_spline(knot_vectorx,px,bi,ii);
    #   end
    # end

    # % loop over basis functions
    # for bj = 1:ny
    #   % loop over nonzero pixels over given function
    #   for j=yy(knot_vectory(bj)):yy(knot_vectory(bj+py+1))  
    #     % scale coordinates [1-height] -> [0-1]
    #     jj = (j-1)/(iy-1);
    #     % B^y_j(y)
    #     funy_tab(bj,j) = compute_spline(knot_vectory,py,bj,jj);
    #   end
    # end

    # %RR is 1:nx, GRAY is 1:precision
    # GRAY=zeros(precision+1,precision+1);
    # if nx==precision
    #   for i=1:precision
    #     for j=1:precision
    #       GRAY(i,j)=255.0-(0.3*RR(i,j)+0.59*GG(i,j)+0.11*BB(i,j));
    #     end
    #   end
    # else
    #   for i=1:precision
    #     for j=1:precision
    #       i1 = floor((i-1)/(floor(precision/nx)))+1;
    #       if(i1>nx)
    #         i1=nx;
    #       end
    #       j1 = floor((j-1)/(floor(precision/ny)))+1;
    #       if(j1>ny)
    #         j1=ny;
    #       end
    #       GRAY(i,j)=255.0-(0.3*RR(i1,j1)+0.59*GG(i1,j1)+0.11*BB(i1,j1));
    #     end
    #   end
    # end

    if ns == prec
    end
    GRAY[prec[1]+1, :] = GRAY[prec[1], :]
    GRAY[:, prec[2]+1] = GRAY[:, prec[2]]

    # hold on
    # Z=zeros(precision+1,precision+1);
    # for i=1:nx
    #   %compute values of 
    #   vx=compute_spline(knot_vectorx,px,i,X);
    #   for j=1:ny
    #     vy=compute_spline(knot_vectory,py,j,Y);
    #     %vx has all the values of B^x_{i,p} over entire domain
    #     %vy has all the values of B^x_{j,p} over entire domain
    #     Z=Z+vx.*vy.*GRAY;
    #   end
    # end

    # Should suffice
    update_plane!(
        result,
        coeffs,
        [], # TODO xspline
        [], # TODO ysplines
        temp,
        ts,
        knot_vector,
        degree,
    )

    return result
end

# % Subroutine to solve one direction as 1D problem with multiple RHS
# function [RR,GG,BB]=solve_direction(A,FR,FG,FB)
#   % compute LU factorization of A  matrix
#   [L,U,P,Q] = lu(A);
#   Q1=Q';
#   RR = zeros(size(FR,1),size(FR,2));
#   GG = zeros(size(FG,1),size(FG,2));
#   BB = zeros(size(FB,1),size(FB,2));
#   % loop over multiple RHS and color components
#   for i=1:size(FR,2)
#     RR(:,i)=solveRHS(L,U,P,Q1,FR(:,i));  
#     GG(:,i)=solveRHS(L,U,P,Q1,FG(:,i));  
#     BB(:,i)=solveRHS(L,U,P,Q1,FB(:,i));  
#   end
# end

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

# xx, yy
function res(
    img_size::Integer,
    coord::Real,
)
    return floor((img_size - 1) * coord + 1)
end

# TODO
# % Helper subroutine for integration over bitmap
# function val=bitmp(M,x,y)
#   val = zeros(size(x));
#   for i=1:size(x,1)
#     for j=1:size(x,1)
#       val(i,j)=M(xx(x(1,i)),yy(y(1,j)));
#     end
#   end
# end

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
