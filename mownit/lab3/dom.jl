# Zadanie 1
using Plots

rnd(x) = round(x, digits=14)
runge(x) = 1 / (1 + 25x^2)
minx1 = -1
maxx1 = 1
r = minx1:0.001:maxx1

function coeffs(n)
    if n < 1
        error("Za mało punktów")
    end
    d = (maxx1 - minx1) / n
    xs = rnd.((x -> minx1 + d * x).(0:n))
    ys = rnd.(runge.(xs))
    xpows(x) = transpose(rnd.((y -> x^y).(n:-1:0))[:, :])
    A = reduce(vcat, xpows.(xs))
    return rnd.(A \ ys)
end

function poly(coeffs)
    n = length(coeffs) - 1
    return (x -> sum((y -> coeffs[y+1] * x^(n - y)).(n:-1:0)))
end

function add(n)
    plot!(r,
        poly(coeffs(n)),
        # label="Wielomian $(n) stopnia",
        label="$(n+1) punktów",
        legendfont=5
    )
end

plot(r, runge, label="Funkcja rungego")
add(5)
add(7)
savefig("zad1.svg")

# add(3)
# add(4)

# add(9)
# add(11)

# add(4)
# add(6)
# add(8)
# add(10)

# add(20)
# add(41)
# add(40)

# Zadanie 2
# c)

# @time _ = [
#     3//8 -15//4 35//8;
#     -35//5 0 63//8;
#     -5//16 105//16 -315//16
# ] \ [5 // 6; 6 // 7; 8 // 9]

# @time begin
#     s = 0//1
#     for i in 1:20
#         s += i//(i+1)
#     end
# end

@time ps = (transpose([
    1 0 0 0 0 0 0;
    0 1 0 0 0 0 0;
    -1//2 0 3//2 0 0 0 0;
    0 -3//2 0 5//2 0 0 0;
    3//8 0 -15//4 0 35//8 0 0;
    0 15//8 0 -35//5 0 63//8 0;
    -5//16 0 105//16 0 -315//16 0 231//16
]))

@time _ = [4//5 5//6; 6//7 8//9] \ [1 // 2, 2 // 3]
@time function getPs(i=6)
    t = (i -> map(j -> Int(i == j), (0:6))).(0:i)
    return (x -> (ps \ x)).(t)
end

@time getPs(0)
@time sols = getPs()

# Dupa
# sols = Vector{Vector{Rational{Int}}}(undef,length(t))
# @time sols[1] = (ps \ t[1])
# @time for i in 2:length(t)
#     sols[i] = ps \ t[i]
# end

# Wolniej :(
# using Ratios
# function simple_ratio(ratio)
#     return SimpleRatio(numerator(ratio), denominator(ratio))
# end
# function ratio(simpleRatio)
#     return simpleRatio.num // simpleRatio.den
# end
# t = (i -> map(j -> BigInt(i == j), (0:6))).(0:6)
# @time ps = simple_ratio.(transpose([
# 1    0    0    0    0    0    0;
# 0    1    0    0    0    0    0;
# -1//2 0    3//2  0    0    0    0;
# 0   -3//2  0   5//2   0    0    0;
# 3//8  0  -15//4  0  35//8   0    0;
# 0  15//8   0 -35//5   0  63//8   0;
# -5//16 0 105//16 0 -315//16 0 231//16;
# ]))
# @time sols = (x -> Rational{Int64}.(ratio.(ps \ x))).(t)

# Zadanie 3
using Maxima

@time s = mcall(
    m"solve([
            a_1 * x_0^3 + b_1 * x_0^2 + c_1 * x_0 + d_1 = y_0,
            a_1 * (x_0+h)^3 + b_1 * (x_0+h)^2 + c_1 * (x_0+h) + d_1 = y_1,
            a_1 * (x_0+2*h)^3 + b_1 * (x_0+2*h)^2 + c_1 * (x_0+2*h) + d_1 = y_2,
            a_2 * (x_0+2*h)^3 + b_2 * (x_0+2*h)^2 + c_2 * (x_0+2*h) + d_2 = y_2,
            3*a_1 * (x_0+h)^2 + 2*b_1 * (x_0+h) + c_1 =
            3*a_2 * (x_0+h)^2 + 2*b_2 * (x_0+h) + c_2,
            6*a_1 * (x_0+h) + 2*b_1 = 6*a_2 * (x_0+h) + 2*b_2
            3*a_1 * (x_0)^2 + 2*b_1 * (x_0) + c_1 = (y_1-y_0)/h,
            3*a_2 * (x_0+2*h)^2 + 2*b_2 * (x_0+2*h) + c_2 = (y_2-y_1)/h
        ],
        [a_1, b_1, c_1, d_1, a_2, b_2, c_2, d_2])
        ")

using TypstGenerator
st = math(s.str[1])
tp = typst(st)
open("zad3.typ", "w") do file
    write(file, tp)
end

# @time using Symbolics
# @time @variables x0 x1 x2 y0 y1 y2 h
# @time @variables a1 b1 c1 d1 a2 b2 c2 d2
# dif = Symbolics.derivative
# dif2(e, v) = dif(dif(e, v), v)

# @time sol = Symbolics.solve_for([
#         a1 * x0^3 + b1 * x0^2 + c1 * x0 + d1 ~ y0,
#         a1 * x1^3 + b1 * x1^2 + c1 * x1 + d1 ~ y1,
#         a1 * x2^3 + b1 * x2^2 + c1 * x2 + d1 ~ y2,
#         a2 * x2^3 + b2 * x2^2 + c2 * x2 + d2 ~ y2,
#         dif(a1 * x1^3 + b1 * x1^2 + c1 * x1 + d1, x1) ~
#             dif(a2 * x1^3 + b2 * x1^2 + c2 * x1 + d2, x1),
#         dif(a1 * x2^3 + b1 * x2^2 + c1 * x2 + d1, x2) ~
#             dif(a2 * x2^3 + b2 * x2^2 + c2 * x2 + d2, x2),
#         dif2(a1 * x1^3 + b1 * x1^2 + c1 * x1 + d1, x1) ~
#             dif2(a1 * x2^3 + b1 * x2^2 + c1 * x2 + d1, x2),
#         dif2(a2 * x1^3 + b2 * x1^2 + c2 * x1 + d2, x1) ~
#             dif2(a2 * x2^3 + b2 * x2^2 + c2 * x2 + d2, x2),
#     ],
#     [a1, b1, c1, d1, a2, b2, c2, d2])
#     # [a1, b1, c1, d1, a2, b2, c2, d2], simplify=true)

# # @time simp = (x -> Symbolics.simplify(x, threaded=true)).(sol)
# @time sol = expand.(sol)

# using Base.Threads
# simp = Vector(0:7)
# @time @threads for i = 1:8
#     simp[i] = Symbolics.simplify(sol[i])
# end

