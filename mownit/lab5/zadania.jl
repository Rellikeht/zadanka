### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ 42b9be8a-f679-11ee-39a2-11193876cb5f
begin
    using Pkg
    Pkg.activate("..", io=devnull)
    using HypertextLiteral
    using BenchmarkTools
    using Dates
    using CairoMakie
    CairoMakie.activate!(type="svg")

    tday = string(day(today()), pad=2)
    tmonth = string(month(today()), pad=2)
    tyear = string(year(today()), pad=4)
    md"""
    ###### Michał Hemperek, $(tday*"."*tmonth*"."*tyear)
    """
end

# ╔═╡ 80ae333e-6f67-4a13-accb-5681198de0fa
begin
    const c1 = "#00ff00"
    const c2 = "#0040eedd"
    const c3 = "#ff0000"
    const lw = 4
    const ms = 24
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
    </style>
    """
end

# ╔═╡ 8218993e-b216-4868-8d8b-b32ffb9771ae
md"""
## Zadanie 1
Obliczyć $I = \int^1_0 \frac{1}{1+x} dx$ wg wzoru prostokątów, trapezów i wzoru Simpsona (zwykłego i złożonego $n=3, 5$). Porównać wyniki i błędy.
"""

# ╔═╡ 6541ef5c-d6ac-417c-97b7-44f76fbbdab6
md"""
##### Kod:
"""

# ╔═╡ c61772cd-e7be-4eaf-a7a2-f63b37708161
begin
	# Domyślne wartości h i n
    const defaultH = 0.001
    const defaultN = 1000

    # Wzór prostokątów
    function rectangle(
        f::Function,
        a::Union{Int,Float64},
        b::Union{Int,Float64},
        h::Float64=defaultH
    )::Float64
        result::Float64 = 0
        @simd for i in (a+h/2):h:(b-h/2)
            result += f(i)
        end
        return result * h
    end
    function rectangle(
        f::Function,
        a::Union{Int,Float64},
        b::Union{Int,Float64},
        n::Int=defaultN
    )::Float64
        rectangle(f, a, b, (b - a) / n)
    end

    # Wzór trapezów
    function trapezoidal(
        f::Function,
        a::Union{Int,Float64},
        b::Union{Int,Float64},
        h::Float64=defaultH
    )::Float64
        result::Float64 = 0
        @simd for i in (a+h):h:(b-h)
            result += f(i)
        end
        return h * (result + (f(Float64(a)) + f(Float64(b))) / 2)
    end
    function trapezoidal(
        f::Function,
        a::Union{Int,Float64},
        b::Union{Int,Float64},
        n::Int=defaultN
    )::Float64
        trapezoidal(f, a, b, (b - a) / n)
    end

    # Wzór simpsona (prosty)
    function simpsonSimple(
        f::Function,
        a::Union{Int,Float64},
        b::Union{Int,Float64}
    )::Float64
        return (f(Float64(a)) + f(Float64(b)) + 4 * f((a + b) / 2)) / 6
    end

    # Wzór simpsona (złożony)
    function simpson(
        f::Function,
        a::Union{Int,Float64},
        b::Union{Int,Float64},
        h::Float64=defaultH
    )::Float64
        result::Float64 = 0
        @simd for i in (a+h):2*h:(b-h)
            result += f(i)
        end
        return 2 * (trapezoidal(f, a, b, h) + result * h) / 3
    end
    function simpson(
        f::Function,
        a::Union{Int,Float64},
        b::Union{Int,Float64},
        n::Int=defaultN
    )::Float64
        if n % 2 == 1
            n = n - 1
        end
        simpson(f, a, b, (b - a) / n)
    end

    # Lekkie obliczeniowo wywołania wymuszające prekompilację funkcji
    const precompH = 0.05
    const precompN = 20
    const precompF = x -> x^2
    const precompA = 1.0
    const precompB = 2.0
    begin
        for f in [rectangle, trapezoidal, simpson]
            _ = f(precompF, precompA, precompB, precompH)
            _ = f(precompF, precompA, precompB, precompN)
        end
        _ = simpsonSimple(precompF, precompA, precompB)
        md"""
        """
    end
end

# ╔═╡ 147fb8a8-e0dc-4267-9083-445de5e13bf6
md"""
 $n$ oznacza ilość przedziałów, w przypadku metody simpsona musi to być liczba parzysta, więc tam gdzie nie jest przyjmuję n-1

W powyższych funkcjach korzystam z faktu, że h jest stałe,
więc mnożenie przez nie można wyciągnąć przed całkę i wykonać je raz
jednocześnie zmniejszając ilość mnożeń i błędów z nimi związanych

W metodzie Simpsona:
$S = \frac{h}{3}[f(x_1)+4f(x_2)+2f(x_3)+4f(x_4)+...+2f(x_{n−2})+4f(x_{n−1})+f(x_n)]$ \
korzystam z obserwacji, że wzór ten to $\frac{2}{3} h$ razy wynik metody trapezów + $\frac{2}{3} h$ razy suma parzystych punktów
"""

# ╔═╡ 3d1946ab-3555-49e8-b601-5ee351e9b3c8
begin
    const f1(x) = 1 / (1 + x)
    const true_value_1 = log(2)
    const n = 10^7

    md"""
    """
end

# ╔═╡ f9c522c6-b50d-4b76-9cde-165bc1c9e1f3
md"""
##### Wartości całek i błędy:
Rzeczywista wartość całki: $~~ln(2) \approx$ **$(true_value_1)**

###### Dla $n=3$:
|metoda|wartość wyliczona|błąd|
|:-:|:-:|:-:|
|prostokąty|$(rectangle(f1,0,1,3))|$(abs(rectangle(f1,0,1,3)-true_value_1))|
|trapezy|$(trapezoidal(f1,0,1,3))|$(abs(trapezoidal(f1,0,1,3)-true_value_1))|
|simpson prosty|$(simpsonSimple(f1,0,1))|$(abs(simpsonSimple(f1,0,1)-true_value_1))|
|simpson złożony|$(simpson(f1,0,1,3))|$(abs(simpson(f1,0,1,3)-true_value_1))|

###### Dla $n=5$:
||||
|:-:|:-:|:-:|
|prostokąty|$(rectangle(f1,0,1,5))|$(abs(rectangle(f1,0,1,5)-true_value_1))|
|trapezy|$(trapezoidal(f1,0,1,5))|$(abs(trapezoidal(f1,0,1,5)-true_value_1))|
|simpson prosty|$(simpsonSimple(f1,0,1))|$(abs(simpsonSimple(f1,0,1)-true_value_1))|
|simpson złożony|$(simpson(f1,0,1,5))|$(abs(simpson(f1,0,1,5)-true_value_1))|

###### Dla $n=10$:
||||
|:-:|:-:|:-:|
|prostokąty|$(rectangle(f1,0,1,10))|$(abs(rectangle(f1,0,1,10)-true_value_1))|
|trapezy|$(trapezoidal(f1,0,1,10))|$(abs(trapezoidal(f1,0,1,10)-true_value_1))|
|simpson złożony|$(simpson(f1,0,1,10))|$(abs(simpson(f1,0,1,10)-true_value_1))|

###### Dla $n=50$:
||||
|:-:|:-:|:-:|
|prostokąty|$(rectangle(f1,0,1,50))|$(abs(rectangle(f1,0,1,50)-true_value_1))|
|trapezy|$(trapezoidal(f1,0,1,50))|$(abs(trapezoidal(f1,0,1,50)-true_value_1))|
|simpson złożony|$(simpson(f1,0,1,50))|$(abs(simpson(f1,0,1,50)-true_value_1))|

###### Dla $n=100$:
||||
|:-:|:-:|:-:|
|prostokąty|$(rectangle(f1,0,1,100))|$(abs(rectangle(f1,0,1,100)-true_value_1))|
|trapezy|$(trapezoidal(f1,0,1,100))|$(abs(trapezoidal(f1,0,1,100)-true_value_1))|
|simpson złożony|$(simpson(f1,0,1,100))|$(abs(simpson(f1,0,1,100)-true_value_1))|

###### Dla $n=1000$:
||||
|:-:|:-:|:-:|
|prostokąty|$(rectangle(f1,0,1,1000))|$(abs(rectangle(f1,0,1,1000)-true_value_1))|
|trapezy|$(trapezoidal(f1,0,1,1000))|$(abs(trapezoidal(f1,0,1,1000)-true_value_1))|
|simpson złożony|$(simpson(f1,0,1,1000))|$(abs(simpson(f1,0,1,1000)-true_value_1))|
"""

# ╔═╡ 5c74f413-9003-429d-91eb-4fe41fccbe30
md"""
# Zadanie 2
Obliczyć całkę $I = \int_{-1}^1 \frac{1}{1+x^2} dx$ korzystając z wielomianów ortogonalnych (np. Czebyszewa) dla $n=8$.
"""

# ╔═╡ 998509e3-c2ff-471e-936e-26080f99e528
md"""
##### Kod:
"""

# ╔═╡ a2ccf7c0-f140-44b5-962c-18bdb8a6f32d
begin
	# Funkcja dana w zadaniu
	const f2(x) = 1/(1+x^2)
	# Rzeczywista wartość całki
    const true_value_2 = atan(1) - atan(-1)
	# Punkty i Współczynniki do kwadratury
    const lpoints = [
        (0.3626837833783620, -0.1834346424956498),
        (0.3626837833783620, 0.1834346424956498),
        (0.3137066458778873, -0.5255324099163290),
        (0.3137066458778873, 0.5255324099163290),
        (0.2223810344533745, -0.7966664774136267),
        (0.2223810344533745, 0.7966664774136267),
        (0.1012285362903763, -0.9602898564975363),
        (0.1012285362903763, 0.9602898564975363),
    ]
	const N = 8

	# Czebyszew
    int2c::Float64 = 0
	for i in 0:N
		xk = cos((2*i+1)*π/(2*N+2))
		global int2c += f2(xk)*π/(N+1)*sqrt(1-xk^2)
	end
	# Legendre
	int2l::Float64 = 0
    for (A, x) in lpoints
        global int2l += A*f2(x)
    end
    md"""
    """
end

# ╔═╡ 4afc6822-fe53-4878-ae89-507ea56053fe
md"""
W tym zadaniu uzyję wielomianów Czebyszewa, ale ze względu na błąd z nimi związany
dla porównania dodam też Legendre'a:
\
Całka ta jest równa $tg^{-1}(1) - tg^{-1}(-1) \approx$ **$(true_value_2)**

##### Wyniki:

Wartość przybliżona przez wielomiany Czebyszewa: **$(int2c)**
\
Jej błąd: **$(abs(int2c-true_value_2))**
\
Wartość przybliżona przez wielomiany Legendre'a: **$(int2l)**
\
Jej błąd: **$(abs(int2l-true_value_2))**
"""

# ╔═╡ 3f67e1c5-a958-4050-b8e3-06ea5f972278
md"""
# Zadanie Domowe 1
Obliczyć całkę $\int_0^1 \frac{1}{1+x^2} dx$ korzystając ze wzoru prostokątów dla $h=0.1$ oraz metody całkowania adaptacyjnego.
"""

# ╔═╡ b690792a-b4fc-475e-b754-b3ec1a58753e
md"""
##### Kod:
"""

# ╔═╡ 8976231a-9abd-4805-922f-3969ee1a7c09
begin
	# Funkcja dana w poleceniu
    const f3(x::Union{Int,Float64})::Float64 = 1 / (1 + x^2)
	_ = f3(3)
	# Rzeczywista wartość całki
    const true_value_3 = atan(1) - atan(0)
	# Domyślna wartość tolerancji
	const defaultTol = 10^-3
	# Minimalna wielość przedziału przy całkowaniu adaptacyjnym
	const defaultMinH = 10^-5

	# Funkcja do całkowania adaptacyjnego opartego o metodę prostokątów
	function adaptiveRect(
		f::Function,
		a::Union{Int, Float64},
		b::Union{Int, Float64},
		tol::Union{Int, Float64}=defaultTol,
		minH::Float64=defaultMinH
	)::Float64
		H = b-a
		function helper(
			p::Union{Float64, Int},
			q::Union{Float64,Int},
			tol::Union{Float64, Int}=tol
		)::Float64
			h::Float64 = q-p
			mid = (q+p)/2
			S::Float64 = f(mid)*h
			if h < minH
				return S
			end
			S1::Float64 = f(mid/2)*h/2
			S2::Float64 = f(3*mid/2)*h/2
			if abs(S-S1-S2) < tol*h/H
				return S1+S2
			else
				return helper(p,mid,tol/2)+helper(mid,q,tol/2)
			end
		end
		return helper(a, b)
	end
	# Wywołania rozgrzewkowe wymuszające wstępną kompilację funkcji
	_ = adaptiveRect(f3, 0, 2, 1)
	_ = adaptiveRect(f3, -1, 1, 0.01)

	err3(v::Float64)::Float64 = abs(v-true_value_3)
    md"""
    """
end

# ╔═╡ bd30f014-f3c4-4a4d-910d-6ed64627c693
md"""
##### Wyniki:
Całka ta jest równa $tg^{-1}(1) - tg^{-1}(0) \approx$ **$(true_value_3)**

Dla całkowania adaptacyjnego został przyjęty minimalny rozmiar przedziału
równy **$(defaultMinH)**

metoda|tolerancja/wielkość przedziału|wartość|błąd
:-:|:-:|:-:|:-:
|||
|||
prostokątów|0.1|$(rectangle(f3, 0, 1, 0.1))|$(err3(rectangle(f3, 0, 1, 0.1)))
adaptacyjna prostokątów|0.1|$(adaptiveRect(f3, 0, 1, 0.1))|$(err3(adaptiveRect(f3, 0, 1, 0.1)))
|||
|||
|||
prostokątów|0.01|$(rectangle(f3, 0, 1, 0.01))|$(err3(rectangle(f3, 0, 1, 0.01)))
adaptacyjna prostokątów|0.01|$(adaptiveRect(f3, 0, 1, 0.01))|$(err3(adaptiveRect(f3, 0, 1, 0.01)))
|||
|||
|||
prostokątów|0.001|$(rectangle(f3, 0, 1, 0.001))|$(err3(rectangle(f3, 0, 1, 0.001)))
adaptacyjna prostokątów|0.001|$(adaptiveRect(f3, 0, 1, 0.001, 5*10^-7))|$(err3(adaptiveRect(f3, 0, 1, 0.001, 5*10^-7)))
|||
|||
|||
prostokątów|0.0001|$(rectangle(f3, 0, 1, 0.0001))|$(err3(rectangle(f3, 0, 1, 0.0001)))
adaptacyjna prostokątów|0.0001|$(adaptiveRect(f3, 0, 1, 0.0001, 5*10^-7))|$(err3(adaptiveRect(f3, 0, 1, 0.0001, 5*10^-7)))
|||
|||
|||
adaptacyjna prostokątów|0.00001|$(adaptiveRect(f3, 0, 1, 0.00001, 5*10^-7))|$(err3(adaptiveRect(f3, 0, 1, 0.00001, 5*10^-7)))
adaptacyjna prostokątów|0.000001|$(adaptiveRect(f3, 0, 1, 0.000001, 5*10^-7))|$(err3(adaptiveRect(f3, 0, 1, 0.000001, 5*10^-7)))

\

W ramach eksperymentu przyjmę też różne minimalne wielkości przedziału:

tolerancja|minimalna wielkość przedziału|wartość|błąd
:-:|:-:|:-:|:-:
|||
|||
0.01|0.5|$(adaptiveRect(f3, 0, 1, 0.01, 0.5))|$(err3(adaptiveRect(f3, 0, 1, 0.01, 0.5)))
0.001|0.5|$(adaptiveRect(f3, 0, 1, 0.001, 0.5))|$(err3(adaptiveRect(f3, 0, 1, 0.001, 0.5)))
0.0001|0.5|$(adaptiveRect(f3, 0, 1, 0.0001, 0.5))|$(err3(adaptiveRect(f3, 0, 1, 0.0001, 0.5)))
|||
0.01|0.1|$(adaptiveRect(f3, 0, 1, 0.01, 0.1))|$(err3(adaptiveRect(f3, 0, 1, 0.01, 0.1)))
0.001|0.1|$(adaptiveRect(f3, 0, 1, 0.001, 0.1))|$(err3(adaptiveRect(f3, 0, 1, 0.001, 0.1)))
0.0001|0.1|$(adaptiveRect(f3, 0, 1, 0.0001, 0.1))|$(err3(adaptiveRect(f3, 0, 1, 0.0001, 0.1)))
|||
0.01|0.01|$(adaptiveRect(f3, 0, 1, 0.01, 0.01))|$(err3(adaptiveRect(f3, 0, 1, 0.01, 0.01)))
0.001|0.01|$(adaptiveRect(f3, 0, 1, 0.001, 0.01))|$(err3(adaptiveRect(f3, 0, 1, 0.001, 0.01)))
0.0001|0.01|$(adaptiveRect(f3, 0, 1, 0.0001, 0.01))|$(err3(adaptiveRect(f3, 0, 1, 0.0001, 0.01)))
|||
0.01|0.001|$(adaptiveRect(f3, 0, 1, 0.01, 0.001))|$(err3(adaptiveRect(f3, 0, 1, 0.01, 0.001)))
0.001|0.001|$(adaptiveRect(f3, 0, 1, 0.001, 0.001))|$(err3(adaptiveRect(f3, 0, 1, 0.001, 0.001)))
0.0001|0.001|$(adaptiveRect(f3, 0, 1, 0.0001, 0.001))|$(err3(adaptiveRect(f3, 0, 1, 0.0001, 0.001)))
|||
0.01|0.0001|$(adaptiveRect(f3, 0, 1, 0.01, 0.0001))|$(err3(adaptiveRect(f3, 0, 1, 0.01, 0.0001)))
0.001|0.0001|$(adaptiveRect(f3, 0, 1, 0.001, 0.0001))|$(err3(adaptiveRect(f3, 0, 1, 0.001, 0.0001)))
0.0001|0.0001|$(adaptiveRect(f3, 0, 1, 0.0001, 0.0001))|$(err3(adaptiveRect(f3, 0, 1, 0.0001, 0.0001)))
"""

# ╔═╡ 0a9ee599-89f7-4aef-8807-66aec6e1552b
md"""
# Zadanie Domowe 2
Metodą Gaussa obliczyć następującą całkę $\int^1_0 \frac{1}{x+3} dx$ dla $n=4$. Oszacować resztę kwadratury.
"""

# ╔═╡ 8c6de3a3-c766-4347-a2e2-76b770566775
md"""
##### Kod:
"""

# ╔═╡ 72e74f32-9a86-4f14-aac3-684b9a770158
begin
	#Funkcja dana w zadaniu
    const f4(x) = 1 / (x + 3)
	# Rzeczywista wartość całki
    const true_value_4 = log(4) - log(3)
	# Współczynniki do kwadratury
    const Ak = [
        [1, 1],
        [5 / 9, 8 / 9, 5 / 9],
        [0.347855, 0.652145, 0.652145, 0.347855],
        [0.236927, 0.478629, 0.568889, 0.478629, 0.236927]
    ]
	# Punkty do kwadratury
    const xk = [
        [-0.5773501, 0.5773501],
        [-0.774597, 0, 0.774597],
        [-0.861136, -0.339981, 0.339981, 0.861136],
        [-0.906180, -0.538469, 0, 0.538469, 0.906180]
    ]

    int4::Float64 = 0
	# Wyliczam ze wzoru
    for i in eachindex(Ak[4])
        tk = xk[4][i] / 2 + 1 / 2
        global int4 += Ak[4][i] * f4(tk) / 2
    end

	# Potrzebne do policzenia reszty kwadratury
	const ξ = 0.5
    md"""
    """
end

# ╔═╡ 603ad49c-d7ec-461a-b200-b4beb4b4f704
md"""
Ze względu na uniwersalność i dokładność skorzystam z kwadratry Gaussa-Legendre'a
##### Wyniki, wzory:
Rzeczywista wartość całki $ln(4) - ln(3) \approx$ **$(true_value_4)**
\
Wzór przybliżenia:

$\int_a^b f(t) dt \approx \frac{b-a}{2} \sum_{k=0}^n A_k f(t_k)
~,~~
t_k = \frac{a+b}{2} + \frac{b-a}{2}x_k$

W moim wypadku $a=0$, $b=1$, $n=4$, korzystając z wartości z tablic
(podanych w materiałach pomocniczych) otrzymuję:

 $\int^1_0 \frac{1}{x+3} dx \approx$ **$(int4)**,

błąd: **$(abs(int4-true_value_4))**
\
Resztę kwadratury można oszacować ze wzoru podanego na wykładzie:

$E_n \approx \frac{(b-a)^{2n+1} ~ (n!)^4}{((2n)!)^3 ~ (2n + 1)}f(ξ)$
gdzie $b$, $a$ i $n$ mamy podane w zadaniu, a $ξ$ przyjmujemy jako środek
przedziału, czyli 0.5,
\
wtedy $~E_n \approx$ **$((factorial(4)^4)/(factorial(2*4)^3*(2*4+1))*f4(ξ))**

"""

# ╔═╡ e60bc9ee-b428-4dd8-8ded-071b902bf268
md"""
## Wnioski i obserwacje
- Metoda trapezów daje około 2 razy większy błąd niż metoda prostokątów
- Wzór prosty simpsona osiąga dokładność porównywalną z metodą prostokątów dla
  5 części przedziału
- Metoda simpsona daje dokładne wyniki dużo szybciej niż metody prostokątów i
  trapezów
- Kwadratury elementarne potrzebują bardzo dużo próbek, aby uzyskać dobrą dokładność
- Kwadratura Gaussa (w szczególności Gaussa-Legendre'a) daje bardzo dobrą dokładność 
  przy bardzo małej ilośći obliczeń i pozwala na zapisanie części
  potrzebnych obliczeń w tablicach dla łatwiejszego dostępu
- Zbieżność kwadratury używającej wielomianów Czebyszewa jest dużo niższa niż
  wielomianów Legendre'a, przynajmniej w niektórych przypadkach
- Przy całkowaniu adaptacyjnym należy zachować ostrożność, łatwo można doprowadzić
  do przepełnienia stosu (za duże zagnieżdżenie rekurencji)
- Dobór odpowiednich warunków końca przy całkowaniu adaptacyjnym też nie jest łatwy,
  łatwo można doprowadzić do wykonania zbyt dużej ilości obliczeń lub zmniejszyć
  dokładność
- W podstawowej implementacji całkowania adaptacyjnego opartego o metodę prostokątów
  minimalna wielkość przedziału potrafi mieć równie duże znaczenie, co tolerancja

## Bibliografia
- wykład
- materiały pomocnicze do zadań
- https://pomax.github.io/bezierinfo/legendre-gauss.html
- http://fluid.itcmp.pwr.wroc.pl/~znmp/dydaktyka/metnum/calkowanie_trapezy.pdf
- http://fluid.itcmp.pwr.wroc.pl/~znmp/dydaktyka/metnum/simpson.pdf
"""

# ╔═╡ Cell order:
# ╟─42b9be8a-f679-11ee-39a2-11193876cb5f
# ╟─80ae333e-6f67-4a13-accb-5681198de0fa
# ╟─8218993e-b216-4868-8d8b-b32ffb9771ae
# ╟─6541ef5c-d6ac-417c-97b7-44f76fbbdab6
# ╠═c61772cd-e7be-4eaf-a7a2-f63b37708161
# ╟─147fb8a8-e0dc-4267-9083-445de5e13bf6
# ╟─3d1946ab-3555-49e8-b601-5ee351e9b3c8
# ╟─f9c522c6-b50d-4b76-9cde-165bc1c9e1f3
# ╟─5c74f413-9003-429d-91eb-4fe41fccbe30
# ╟─998509e3-c2ff-471e-936e-26080f99e528
# ╠═a2ccf7c0-f140-44b5-962c-18bdb8a6f32d
# ╟─4afc6822-fe53-4878-ae89-507ea56053fe
# ╟─3f67e1c5-a958-4050-b8e3-06ea5f972278
# ╟─b690792a-b4fc-475e-b754-b3ec1a58753e
# ╠═8976231a-9abd-4805-922f-3969ee1a7c09
# ╟─bd30f014-f3c4-4a4d-910d-6ed64627c693
# ╟─0a9ee599-89f7-4aef-8807-66aec6e1552b
# ╟─8c6de3a3-c766-4347-a2e2-76b770566775
# ╠═72e74f32-9a86-4f14-aac3-684b9a770158
# ╟─603ad49c-d7ec-461a-b200-b4beb4b4f704
# ╟─e60bc9ee-b428-4dd8-8ded-071b902bf268
