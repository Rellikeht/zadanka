### A Pluto.jl notebook ###
# v0.19.40

#> [frontmatter]
#> title = "Sprawozdanie 2"
#> date = "2024-12-03"
#> 
#>     [[frontmatter.author]]
#>     name = "Michał Hemperek"

using Markdown
using InteractiveUtils

# ╔═╡ 1172ed90-d054-4a2a-8017-8e4f816ba9bb
md"""
###### Michał Hemperek, 19.03.2024
"""

# ╔═╡ 8e884038-7dfa-4089-bb7b-cd16545d4413
md"""
# Sprawozdanie 2
"""

# ╔═╡ 0635a200-e15a-11ee-22c8-cb3ef0262d26
md"""
Zadanie 1.
"""

# ╔═╡ 23f6da86-caf8-406d-bea7-f03ac9990d58
md"""
a)
"""

# ╔═╡ 9d67202e-c5b9-4764-ba6e-a9f8ebb700a9
ε = 10^-15

# ╔═╡ 35d3a5b3-4e41-43d2-b723-a037b0da4683
function myE(x) :: Float64
	# Zaczynam od 1 + x
    result = 1 + x

	# Następny wyraz
    term = x^2/2
	i = 2
	
    # Kryterium jest tutaj:
    # Jeśli wyrazy są mniejsze od przyjętego wcześniej ε kończymy liczenie
    while abs(term) > ε
		# Dodaję wyraz do sumy
        result += term

		# Obliczam następny wyraz
        term *= x
        i += 1
        term /= i
    end

	# Zwracam wynik
    return result
end

# ╔═╡ 67fb00b4-b34d-463f-81c4-6b6599b3b452


# ╔═╡ 2b08bd93-4bac-4506-a98c-7354a9c7a2c6


# ╔═╡ 44a4732b-05e4-4641-88bc-6427254af3eb


# ╔═╡ a53a13ab-790f-4ebe-a2b2-79fd17b397e5


# ╔═╡ 38218076-1798-49a0-bcbd-1fdd4d38d119


# ╔═╡ a08c6ee1-8802-4bfb-a3c2-67decccca48c


# ╔═╡ 6fc619e9-e2f3-46c0-bcd0-834307dd7663
md"""
b)
"""

# ╔═╡ 0c02af42-401b-4d00-a6da-dfc75e5480b0
@time md"""
|x|myE(x)|exp(x)|
|:-:|:-:|:-:|
|1|$(myE(1))|$(exp(1))|
|-1|$(myE(-1))|$(exp(-1))|
|5|$(myE(5))|$(exp(5))|
|-5|$(myE(-5))|$(exp(-5))|
|10|$(myE(10))|$(exp(10))|
|-10|$(myE(-10))|$(exp(-10))|
|50|$(myE(50))|$(exp(50))|
|-50|$(myE(-50))|$(exp(-50))|
|100|$(myE(100))|$(exp(100))|
|-100|$(myE(-100))|$(exp(-100))|
"""

# ╔═╡ 2108fcce-642b-41de-a82c-d976700a61de
md"""
Jak widać dla liczb dużo poniżej 0 funkcja zaczyna dawać całkowicie błędne wyniki, jest to spowodowane dodawaniem na przemian dużych liczb dodatnich i ujemnych do wyniku, który i tak jest bliski $0$
"""

# ╔═╡ 5ccdc5fb-17c7-40c7-bece-d0f0021dac03


# ╔═╡ 02825e28-0d37-4aae-82f2-8181d3b9e500
md"""
c)

Jak widać po wynikach uzyskanych przeze mnie dokładność spada wraz z oddalaniem się
od $0$, więc nie jest to dobra metoda daleko od niego 
"""

# ╔═╡ f9194776-2f8f-4040-b079-40ac5122edaa


# ╔═╡ 77fe890d-afbc-4f0b-9c98-8e7e865eea71
md"""
d)

Można użyć wzoru $e^{-x} = \frac{1}{e^x}$
"""

# ╔═╡ c8431a9f-0db1-4de5-bcab-e6867a64d30e
function myEE(x)
    if x < 0
		# Dla x < 0 zwracam 1/e^x używając poprzednio zdefiniowanej funkcji
        return 1/myE(-x)
    end
	# Dla pozostałych zwracam wynik poprzedmio zdefiniowanej funkcji
    return myE(x)
end

# ╔═╡ a9e5e1f5-1139-4f49-a5a0-a08f99671451
@time md"""
|x|myEE(x)|exp(x)|
|:-:|:-:|:-:|
|1|$(myEE(1))|$(exp(1))|
|-1|$(myEE(-1))|$(exp(-1))|
|5|$(myEE(5))|$(exp(5))|
|-5|$(myEE(-5))|$(exp(-5))|
|10|$(myEE(10))|$(exp(10))|
|-10|$(myEE(-10))|$(exp(-10))|
|50|$(myEE(50))|$(exp(50))|
|-5|0$(myEE(-50))|$(exp(-50))|
|100|$(myEE(100))|$(exp(100))|
|-100|$(myEE(-100))|$(exp(-100))|
"""

# ╔═╡ 0efc3c8e-8761-4ca6-84a7-2cd6e7c8ef5c
md"""
Zadanie 2.

Lepsze będzie $(x+y)(x-y)$

Mnożenie jest o wiele bardziej niedokładne na liczbach zmiennoprzecinkowych niż
dodawanie, w $x^2 - y^2$ występuje ono dwa razy, a w $(x+y)(x-y)$ tylko raz.

Może zdarzyć się, że
$x^2$ czy $y^2$ będą zbyt duże by móc reprezentować ich wartość,
podczas gdy $x+y$ i $x−y$ będą mieścić się w arytmetyce.
W takim wypadku różnica w wynikach będzie ogromna.
"""

# ╔═╡ d9d1c6ff-77f2-4d29-99a8-9ffa6f09225e


# ╔═╡ 94898fcf-1494-4cc7-9e2b-7f78dca8c675
md"""
Zadanie 3.
"""

# ╔═╡ 543c07a0-30f7-463b-be96-d25124027ab4
md"""
a)

 $fl(b · b) = fl(3.34 · 3.34) = fl(11.1556) = 11.2$
 $fl(4 · a · c) = fl(fl(4 · a) · c) = fl(fl(4 · 1.22) · 2.28) =$
 $fl(fl(4.88) · 2.28) = fl(4.88 · 2.28) = fl(11.1264) = 11.1$

Wartość wyrażenia to: $fl(11.2 − 11.1) = 0.1$
"""

# ╔═╡ d16d926b-cee2-4220-ac52-63210a79b9fd
md"""
b)
$b^2 − 4ac = 11.1556 − 11.1264 = 0.0292$
"""

# ╔═╡ 930fba9c-6e39-4274-8ccf-0b103ceefe3f
md"""
c)
$\frac{0.1 − 0.0292}{0.0292} = 0.0708 0.0292 ≈ 2.42466$
"""

# ╔═╡ Cell order:
# ╟─1172ed90-d054-4a2a-8017-8e4f816ba9bb
# ╠═8e884038-7dfa-4089-bb7b-cd16545d4413
# ╟─0635a200-e15a-11ee-22c8-cb3ef0262d26
# ╟─23f6da86-caf8-406d-bea7-f03ac9990d58
# ╠═9d67202e-c5b9-4764-ba6e-a9f8ebb700a9
# ╠═35d3a5b3-4e41-43d2-b723-a037b0da4683
# ╟─67fb00b4-b34d-463f-81c4-6b6599b3b452
# ╟─2b08bd93-4bac-4506-a98c-7354a9c7a2c6
# ╟─44a4732b-05e4-4641-88bc-6427254af3eb
# ╟─a53a13ab-790f-4ebe-a2b2-79fd17b397e5
# ╟─38218076-1798-49a0-bcbd-1fdd4d38d119
# ╟─a08c6ee1-8802-4bfb-a3c2-67decccca48c
# ╟─6fc619e9-e2f3-46c0-bcd0-834307dd7663
# ╟─0c02af42-401b-4d00-a6da-dfc75e5480b0
# ╟─2108fcce-642b-41de-a82c-d976700a61de
# ╟─5ccdc5fb-17c7-40c7-bece-d0f0021dac03
# ╟─02825e28-0d37-4aae-82f2-8181d3b9e500
# ╟─f9194776-2f8f-4040-b079-40ac5122edaa
# ╟─77fe890d-afbc-4f0b-9c98-8e7e865eea71
# ╠═c8431a9f-0db1-4de5-bcab-e6867a64d30e
# ╟─a9e5e1f5-1139-4f49-a5a0-a08f99671451
# ╟─0efc3c8e-8761-4ca6-84a7-2cd6e7c8ef5c
# ╟─d9d1c6ff-77f2-4d29-99a8-9ffa6f09225e
# ╟─94898fcf-1494-4cc7-9e2b-7f78dca8c675
# ╟─543c07a0-30f7-463b-be96-d25124027ab4
# ╟─d16d926b-cee2-4220-ac52-63210a79b9fd
# ╟─930fba9c-6e39-4274-8ccf-0b103ceefe3f
