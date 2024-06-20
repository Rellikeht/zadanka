# 1. Znaleźć "maszynowe epsilon", czyli najmniejszą liczbę a, taką że a+1>1

# 2. Rozważamy problem ewaluacji funkcji sin(x), m.in. propagację błędu danych wejściowych, tj. błąd wartości funkcji ze względu na zakłócenie h w argumencie x:
# Ocenić błąd bezwzględny przy ewaluacji sin(x)
# Ocenić błąd względny przy ewaluacji sin(x)
# Ocenić uwarunkowanie dla tego problemu
# Dla jakich wartości argumentu x problem jest bardzo czuły ?

# 3. Funkcja sinus zadana jest nieskończonym ciągiem
# sin(x) = x – x^3/3! + x^5/5! – x^7/7! + …
# Jakie są błędy progresywny i wsteczny jeśli przybliżamy funkcję sinus biorąc tylko pierwszy człon rozwinięcią, tj.sin(x) ≈ x, dla x = 0.1, 0.5 i 1.0 ?
# Jakie są błędy progresywny i wsteczny jeśli przybliżamy funkcję sinus biorąc pierwsze dwa człony rozwinięcią, tj.sin(x) ≈ x - x^3/6, dla x = 0.1, 0.5 i 1.0 ?

# 4. Zakładamy że mamy znormalizowany system zmiennoprzecinkowy z β = 10, p = 3, L = -98
# Jaka jest wartość poziomu UFL (underflow) dla takiego systemu ?
# Jeśli x = 6.87 x 10^(-97) i y = 6.81 x 10^(-97), jaki jest wynik operacji x – y ?

# 1
pos_eps = [1, 3, 5, 0.2, 1/3]
# ε = 1
for e in pos_eps:
    next_eps = e
    while 1+next_eps > 1:
        next_eps /= 2
