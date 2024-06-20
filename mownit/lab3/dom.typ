#set page("a4")
*Michał Hemperek, #datetime.today().display("[day].[month].[year]")*

#v(0.3em)
#set align(center)
#set text(size: 1.25em)
= Zadanie domowe

#set text(size: 0.8em)
#set text(size: 1.1em)
#v(0.5em)
#set align(left)

== Zadanie 1.
Z obserwacji wielomiany nieparzystych stopni zachowują się lepiej w tym
problemie.
#image("zad1.svg")
Uważam, że 8 punktów (wielomian stopnia co najwyżej 7) stanowi najlepszy
kompromis.

// #v(0.6em)
#pagebreak()
== Zadanie 2.
#set enum(numbering: "a)")
#let i = 1

#enum.item(
  i = i + 1,
)[
  Jeśli policzymy dla każdej kombinacji $i, j in {0, 1, 2, 3, 4, 5}$,
  $i != j$ następującą całkę: $ integral^1_(−1) p_i (x) p_j (x) d x $
  to zawsze dostaniemy zero. To oznacza, że są one wzajemnie ortogonalne. Ułatwić
  można sobie sprawę zauważając, że każdy wielomian o nieparzystym numerze jest
  nieparzysty, a każdy o parzystym numerze - parzysty. Przez to iloczyn wielomianu
  o parzystym numerze i nieparzystym daje wielomian nieparzysty. Funkcje
  nieparzyste całkowane (sumowane) na symetrycznym obszarze względem 0 zawsze są
  równe 0.
]

#enum.item(
  i,
)[
  Sprawdźmy dla elementu $p_2 = 1/2 (3x^2 − 1)$:
  $
    p_0 = 1 " "
    p_1 = x " "
    n = 1 \
    L = (2n + 1) x dot p_n(x) = 3 x dot x = 3x^2 \
    R = (n + 1) p_(n+1) (x) + n p_(n−1) (x) =
    2 dot 1/2 (3x^2 − 1) + 1 = 3x^2 \
    L = R
  $
  Podobnie można wykazać prawdziwość tej rekurencji dla pozostałych elementów.
]

#enum.item(i = i + 1)[
  $
    1 = p_0 \
    t = p_1 \
    t^2 = 1/3 (2p_2 + p_0) \
    t^3 = 1/5 (2p_3 + 3p_1) \
    t^4 = 1/35 (8p_4 + 20p_2 - 2p_0) \
    t^5 = 1/63 (8p_5 + 28p_3 + 17p_1) \
    t^6 = 16/231 p_6 + 10/21 p_4 + 24/77 p_2 + 1/7 p_0
  $
]

#pagebreak()
// #v(0.6em)
== Zadanie 3.

Przyjmując, że wielomiany mają mieć odpowiednie wartości na końcach dostaję po 2
równania. Przyjmując, że ich 1 pochodne mają być zgodne w punkcie x1 otrzymuję 1
równanie. Przyjmując, że ich 2 pochodne mają być zgodne w punkcie x1 otrzymuję
znowu 1 równanie. Jako warunki brzegowe przyjmuję zgodność ilorazów różnicowych
wyliczonych między $x_0$ i $x_1$ oraz między $x_1$ i $x_2$, co daje kolejne 2
równania. Tyle wystarczy, aby jednoznacznie określić te wielomiany.

#v(0.6em)
Pierwszy wielomian:
#set text(size: 11pt)
$
  a_1=(y_2-2 y_1+y_0)/(4 h^3) \
  b_1=-(x_0 (3 y_2-6 y_1)+h y_2-2 h y_1+(3 x_0+h) y_0)/(4 h^3) \
  c_1=(x_0 (2 h y_2-4 h y_1)+x_0^2 (3 y_2-6 y_1)+4 h^2 y_1+(3 x_0^2+2 h x_0-4 h^2) y_0)/(4 h^3) \
  d_1=-(x_0^2 (h y_2-2 h y_1)+x_0^3 (y_2-2 y_1)+4 h^2 x_0 y_1+(x_0^3+h x_0^2-4 h^2 x_0-4 h^3) y_0)/(4 h^3) \
$
#set text(size: 12pt)

#linebreak()
Drugi wielomian:
#set text(size: 11pt)
$
  a_2=-(y_2-2 y_1+y_0)/(12 h^3) \
  b_2=(x_0 (y_2-2 y_1)+3 h y_2-6 h y_1+(x_0+3 h) y_0)/(4 h^3) \
  c_2=-(x_0 (6 h y_2-12 h y_1)+x_0^2 (y_2-2 y_1)+4 h^2 y_2-12 h^2 y_1+(x_0^2+6 h x_0+8 h^2) y_0)/(4 h^3) \
  d_2=(x_0 (12 h^2 y_2-36 h^2 y_1)+x_0^2 (9 h y_2-18 h y_1)+x_0^3 (y_2-2 y_1)+8 h^3 y_2-16 h^3 y_1+(x_0^3+9 h x_0^2+24 h^2 x_0+20 h^3) y_0)/(12 h^3)
$
#set text(size: 12pt)
