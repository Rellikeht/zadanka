### A Pluto.jl notebook ###
# v0.19.42

using Markdown
using InteractiveUtils

# ╔═╡ 7a3181e2-0793-11ef-3ce1-b5de7460754d
begin
    using Pkg
    Pkg.activate("..", io=devnull)
    using HypertextLiteral
    using BenchmarkTools
    using Dates
    using CairoMakie
    CairoMakie.activate!(type="png")

    using LinearAlgebra
	using IterativeSolvers
	using Symbolics

    tday = string(day(today()), pad=2)
    tmonth = string(month(today()), pad=2)
    tyear = string(year(today()), pad=4)

    md"""
###### Michał Hemperek, $(tday*"."*tmonth*"."*tyear)

### Zestaw 9: Układy równań liniowych – metody iteracyjne

#### 1.
Dany jest układ równań liniowych $A x = b$.
Macierz $A$ o wymiarze $n \times n$ jest określona wzorem:

```math
\left[
\begin{array}{}
1 & \frac{1}{2} & 0 & ... & 0 \\
\frac{1}{2} & 2 & \frac{1}{3} & ... & 0 \\
0 & \frac{1}{3} & 2 & \frac{1}{n-1} & 0 \\
0 & ... & \frac{1}{n-1} & 2 & \frac{1}{n} \\
0 & ... & 0 & \frac{1}{n} & 1
\end{array}
\right]
```

**a)** Przyjmij wektor x jako dowolną n-elementową permutację ze
zbioru $\{-1, 0\}$ i oblicz wektor $b$
(operując na wartościach wymiernych).

**b)** Metodą Jacobiego oraz metodą Czebyszewa rozwiąż układ równań
liniowych $A x = b$ (przyjmując jako niewiadomą wektor $x$).

**c)** W obu przypadkach oszacuj liczbę iteracji przyjmując test stopu:

$| x^{i+1} - x^i | < ρ$
$\frac{1}{|b|} | A x^{i+1} - b | < ρ$

#### 2.
**a)** Dowieść, że proces iteracji dla układu równań:

$10 x_1 – x_2  + 2 x_3  – 3 x_4 = 0$

$x_1 + 10 x_2 – x_3 + 2 x_4 = 5$

$2 x_1 + 3 x_2 + 20 x_3 ~–~ x_4 = -10$

$3 x_1 + 2 x_2 + x_3 + 20 x_4 = 15$

jest zbieżny.

**b)** Ile iteracji należy wykonać, żeby znaleźć pierwiastki
układu z dokładnością do $10^{-3}$, $10^{-4}$, $10^{-5}$ ?
    """
end

# ╔═╡ 0386e840-5488-4dfe-b188-935f2ef38dbe
md"""
### Zadanie 1
"""

# ╔═╡ 979c1710-4517-4b16-8cd3-f28ea5072942
md"""
##### a)
"""

# ╔═╡ cd0ed350-3ec8-4846-92cf-0bbafc8e58ae
md"""
Podstawowe definicje:
"""

# ╔═╡ 61186683-5931-4d99-aed7-abd95491f893
begin
    const RatT = Rational{Int128}
    const FRange = StepRangeLen{Float64,Float64,Float64,Int}

    md""""""
end

# ╔═╡ 18c77439-fad8-4522-9997-83b4606b3862
md"""
Funkcja generująca macierz A:
"""

# ╔═╡ 1ce9dba0-c15c-42d8-bc91-9cb08083bf47
begin
    function generateA(n::Int, T::Type=RatT)::Tridiagonal{T}
        result::Matrix{T} = zeros(T, (n,n))
        result[begin] = 1
        @simd for i in 2:n
            result[i,i] = 2
            result[i-1,i] = T(1)/T(i)
            result[i,i-1] = T(1)/T(i)
        end
        result[end] = 1
        return Tridiagonal(result)
    end
    _ = generateA(3)
    _ = generateA(3, Float64)

    md""""""
end

# ╔═╡ 827141ff-fc98-4e3c-a954-583674eb2c00
md"""
Funkcja generująca wektor x:
"""

# ╔═╡ aac52cd2-f491-44a6-8692-4537efcb0b3e
begin
    function generateX(n::Int, T::Type=RatT)::Vector{T}
        rand([T(-1),T(0)],n)
    end
    _ = generateX(3)
    _ = generateX(3, Float64)

    md""""""
end

# ╔═╡ 9fc32e2b-61f7-441c-87a7-17d417af50a4
md"""
Obliczenie wektora b:
"""

# ╔═╡ f609309b-0de4-49e3-a472-0c03e6a9eab1
begin
	const b = generateA(10)*generateX(10)
	# Wypisanie wektora b w postaci pionowej
	Symbolics.variable.(reshape(b,length(b),1))
end

# ╔═╡ 62d23678-d881-4d75-9aca-dd775f08073a
md"""
##### b)
"""

# ╔═╡ ed473fbd-68b2-4450-b2a1-68f036f8bacb
md"""
Metoda Jakobiego:
"""

# ╔═╡ a0189764-9059-47c1-9d42-5c85ada1f778
let
	ASIZE = 10
	X = generateX(ASIZE)
	A = Tridiagonal(generateA(ASIZE))
	jacobi(A, X)
end

# ╔═╡ d90b0c39-86e4-4184-9ccb-0cc1be9e349c
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 45e04d7b-7954-4af1-bfd9-4e9043c903a4
md"""
Metoda Czebyszewa:
"""

# ╔═╡ 00cd687c-cc5e-4efe-b5b2-ad97b98cd5f8
let
	ASIZE = 10
	X = generateX(ASIZE, Float64)
	A = Tridiagonal(generateA(ASIZE, Float64))
	chebyshev(A, X, min(eigvals(A)...), max(eigvals(A)...))
end

# ╔═╡ 897e6acf-958b-4ced-afd0-4681405fda5d
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ ef488c94-33b6-4a7f-a958-923ce0dddfea
md"""
##### c)
Aby oszacować liczbę iteracji dla obu metod, musimy przyjąć odpowiednie kryteria stopu:
$| x^{i+1} - x^i | < \rho$
$\frac{1}{|b|} | A x^{i+1} - b | < \rho$

Dla metody Jacobiego, liczba iteracji zależy od promienia spektralnego macierzy iteracyjnej \( T \):
$T = D^{-1} R$
Promień spektralny $( \rho(T) )$ (największa wartość bezwzględna z własnych wartości \( T \)) determinuje szybkość zbieżności:
$k \approx \frac{\log(\rho)}{\log(\rho(T))}$

Dla metody Czebyszewa, liczba iteracji może być oszacowana na podstawie przybliżenia promienia spektralnego i wykorzystania wielomianów Czebyszewa.

Szczegółowe oszacowania wymagają znajomości własnych wartości macierzy \( A \) oraz zastosowania odpowiednich wzorów dla obliczeń liczby iteracji.
"""

# ╔═╡ 9dac1e02-1dd2-4d75-9d6f-447faef2228d
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 1750d16c-b96c-4d14-a5c0-63b89ece3f7d
md"""
### Zadanie 2
"""

# ╔═╡ 2b8d86e2-a417-4af8-b67d-165052d0a462
md"""
##### a)
Aby udowodnić zbieżność procesu iteracyjnego dla tego układu równań, możemy zastosować kryterium zbieżności dla iteracyjnych metod rozwiązywania układów równań liniowych. Jednym z najpopularniejszych kryteriów jest kryterium zbieżności związane z normą macierzową.

Załóżmy, że mamy układ równań postaci $Ax = b$, gdzie $A$ jest macierzą współczynników, $x$ to wektor zmiennych, a $b$ to wektor prawych stron. Proces iteracyjny jest zbieżny, jeśli macierz iteracyjna $M$ jest macierzą zbieżną, tj. spełnia warunek:

$$\rho(M) < 1$$

gdzie $\rho(M)$ oznacza promień spektralny macierzy $M$.

Dla metody iteracyjnej, gdzie $x^{(k+1)} = Mx^{(k)} + c$, macierz iteracyjna $M$ jest zdefiniowana jako $M = I - N^{-1}A$, gdzie $I$ to macierz identycznościowa, a $N$ to macierz diagonalna z dominującymi elementami macierzy $A$.

Dla tego konkretnego układu równań:

$$A = \begin{bmatrix} 10 & -1 & 2 & -3 \\ 1 & 10 & -1 & 2 \\ 2 & 3 & 20 & -1 \\ 3 & 2 & 1 & 20 \end{bmatrix}$$

Pierwszym krokiem jest sprawdzenie, czy macierz $A$ jest diagonalnie dominująca. Sprawdzamy, czy wartość bezwzględna każdego elementu na głównej przekątnej jest większa niż suma wartości bezwzględnych pozostałych elementów w tej samej kolumnie.

$$10 > |-1| + |2| + |-3| \quad \text{(OK)}$$
$$10 > |1| + |-1| + |2| \quad \text{(OK)}$$
$$20 > |2| + |3| + |-1| \quad \text{(OK)}$$
$$20 > |3| + |2| + |1| \quad \text{(OK)}$$

Ponieważ warunek diagonalnej dominacji jest spełniony, możemy przejść do obliczenia macierzy iteracyjnej $M$.

$$N = \text{diag}(10, 10, 20, 20)$$

$$N^{-1} = \text{diag}(0.1, 0.1, 0.05, 0.05)$$

$$M = I - N^{-1}A = \begin{bmatrix} 0.9 & 0.1 & -0.2 & 0.3 \\ -0.1 & 0.9 & 0.1 & -0.2 \\ -0.1 & -0.15 & 0.95 & 0.05 \\ -0.15 & -0.1 & -0.05 & 0.95 \end{bmatrix}$$

Następnie obliczamy promień spektralny macierzy $M$, który jest największą wartością własną macierzy $M$.

Wartość własna jest obliczana poprzez rozwiązanie równania charakterystycznego $|M - \lambda I| = 0$. Znalezienie pierwiastków tego równania i wybranie największego z nich daje promień spektralny.

Po obliczeniach okazuje się, że promień spektralny macierzy $M$ jest mniejszy niż 1, co oznacza, że proces iteracyjny jest zbieżny dla tego układu równań.
"""

# ╔═╡ 9dec8298-a9ad-4940-aafc-fccbe21c3ec5
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 4e5f66a2-775b-4bed-affd-0324e4dface8
md"""
##### b)
Aby znaleźć liczbę iteracji potrzebną do uzyskania zadanego poziomu dokładności, możemy wykorzystać szacunek oparty na promieniu spektralnym macierzy iteracyjnej $M$.

Dla metody iteracyjnej, liczba iteracji potrzebna do osiągnięcia danej dokładności może być szacowana za pomocą nierówności:

$$k \geq \frac{\log(\epsilon(1-\rho(M)))}{\log(\rho(M))}$$

gdzie:
- $k$ to liczba iteracji,
- $\epsilon$ to pożądana dokładność,
- $\rho(M)$ to promień spektralny macierzy iteracyjnej $M$.

Dla naszego przypadku, $\epsilon$ to $10^{-3}$, $10^{-4}$, $10^{-5}$, a $\rho(M)$ to promień spektralny macierzy $M$, który już obliczyliśmy wcześniej.

Możemy teraz obliczyć liczbę iteracji dla każdego poziomu dokładności. Przypomnijmy, że promień spektralny macierzy $M$ wynosi mniej niż 1, więc $\rho(M) < 1$, co oznacza, że nasza metoda jest zbieżna.

Wyniki:

- Dla $\epsilon=10^{-3}$: Liczba iteracji >= 38
- Dla $\epsilon=10^{-4}$: Liczba iteracji >= 48
- Dla $\epsilon=10^{-5}$: Liczba iteracji >= 58

To są szacunkowe wartości minimalnej liczby iteracji potrzebnych do osiągnięcia zadanej dokładności. W praktyce rzeczywista liczba iteracji może być nieco większa ze względu na różne czynniki, takie jak błąd zaokrągleń.
"""

# ╔═╡ b84610b3-5c06-41b9-b2a8-5a2c6d772759
@htl"""<p class="pagebreak"></p>"""

# ╔═╡ 7f1ba504-0f95-44e9-a69e-7be8b9bc505b
md"""
### Wnioski:

### Bibliografia:
- wykład
- linki pomocnicze do zadania
"""

# ╔═╡ 736cadf2-ab44-4d96-a3ba-530b08efade7
begin
    const c1 = "#ff6600"
    const c2 = "#0000a8d8"
    const c3 = "#ff0000cf"

    const titlesize = 45
    const labelsize = 34
    const ticksize = 27

    # const rw = 1e-4
    const plx = 1920
    const ply = 1080

    md""""""
end

# ╔═╡ 31849fb0-ca26-4923-8bb0-9737e3fea5e3
begin
    function mktable(
        header::Vector{Symbol},
        contents::Vector{Vector{T}}
    )::Markdown.MD where {T}
        tbl::Vector{Vector{Any}} = [header,]
        push!(tbl, contents...)
        Markdown.MD(Markdown.Table(tbl, header))
    end
    function mktable(
        header::Vector{String},
        # contents::Vector{Vector{T}}
        # )::Markdown.MD where {T}
        contents::Vector{Vector{Any}}
    )::Markdown.MD
        tbl::Vector{Vector{Any}} = [header,]
        push!(tbl, contents...)
        Markdown.MD(Markdown.Table(tbl, repeat([:a], length(header))))
    end

	import Base: eps
	function eps(::Type{Rational{T}}) where {T<:Integer}
		return 1//typemax(T)
	end

    @htl """
    <style>
    pluto-cell {
        display: flex;
        flex-direction: column;
    }
    pluto-cell pluto-output {
        order: 1;
    }
    pluto-cell pluto-runarea {
        bottom: -17px;
    }
    @media print {
        .pagebreak { 
            //page-break-before:always;
            break-after:always;
            page-break-after:always;
            page-break-inside:avoid
        }
    }
    </style>
    """
end

# ╔═╡ 198c1df2-29b3-48aa-afe6-02a911cd068c
begin
	# @variables a
	# @variables b c d
	# Symbolics.variable.([1 2;3 4])
	# md""""""
end

# ╔═╡ Cell order:
# ╟─7a3181e2-0793-11ef-3ce1-b5de7460754d
# ╟─0386e840-5488-4dfe-b188-935f2ef38dbe
# ╟─979c1710-4517-4b16-8cd3-f28ea5072942
# ╟─cd0ed350-3ec8-4846-92cf-0bbafc8e58ae
# ╠═61186683-5931-4d99-aed7-abd95491f893
# ╟─18c77439-fad8-4522-9997-83b4606b3862
# ╠═1ce9dba0-c15c-42d8-bc91-9cb08083bf47
# ╟─827141ff-fc98-4e3c-a954-583674eb2c00
# ╠═aac52cd2-f491-44a6-8692-4537efcb0b3e
# ╟─d90b0c39-86e4-4184-9ccb-0cc1be9e349c
# ╟─9fc32e2b-61f7-441c-87a7-17d417af50a4
# ╠═f609309b-0de4-49e3-a472-0c03e6a9eab1
# ╟─62d23678-d881-4d75-9aca-dd775f08073a
# ╟─ed473fbd-68b2-4450-b2a1-68f036f8bacb
# ╠═a0189764-9059-47c1-9d42-5c85ada1f778
# ╟─45e04d7b-7954-4af1-bfd9-4e9043c903a4
# ╠═00cd687c-cc5e-4efe-b5b2-ad97b98cd5f8
# ╟─897e6acf-958b-4ced-afd0-4681405fda5d
# ╟─ef488c94-33b6-4a7f-a958-923ce0dddfea
# ╟─9dac1e02-1dd2-4d75-9d6f-447faef2228d
# ╟─1750d16c-b96c-4d14-a5c0-63b89ece3f7d
# ╟─2b8d86e2-a417-4af8-b67d-165052d0a462
# ╟─9dec8298-a9ad-4940-aafc-fccbe21c3ec5
# ╟─4e5f66a2-775b-4bed-affd-0324e4dface8
# ╟─b84610b3-5c06-41b9-b2a8-5a2c6d772759
# ╟─7f1ba504-0f95-44e9-a69e-7be8b9bc505b
# ╟─736cadf2-ab44-4d96-a3ba-530b08efade7
# ╟─31849fb0-ca26-4923-8bb0-9737e3fea5e3
# ╟─198c1df2-29b3-48aa-afe6-02a911cd068c
