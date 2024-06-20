#set page("a4", margin: (x: 2cm, y: 2cm))
#set math.mat(delim: "[")
#let ph = 32%
#let ps = 2.5em
#let hs = 1.3em

#set align(right)
*Michał Hemperek, #datetime.today().display("[day].[month].[year]")*

#set align(center)
#v(0.5em)
#text(hs)[= Zadanie 1]
#v(0.6em)
#set align(left)

$ f(x) = 1 + x^3 $
$ Q(x) = a x + b $
$f(x)$ - funkcja aproksymowana\
$Q(x)$ - wielomian aproksymujący\
$w(x) = 1$ - funkcja wagowa\
Szukamy takich $a$ i $b$, żeby zminimalizować całkę
$
  integral_0^1 w(x) [Q(x) - f(x)]^2 d x =
  integral_0^1 [a x + b + 1 + x^3]^2 d x \
$

Układ normalny:
#let a00 = $integral_0^1 1 dot 1 d x$
#let a01 = $integral_0^1 1 dot x d x$
#let a10 = $integral_0^1 x dot 1 d x$
#let a11 = $integral_0^1 x dot x d x$
#let y0 = $integral_0^1 1+x^3 d x$
#let y1 = $integral_0^1 x(1+x^3) d x$
$
  mat(a00, a01;a10, a11) mat(a;b) = mat(y0;y1) \
  \
  mat(1, 1/2;1/2, 1/3) mat(a;b) = mat(5/4;7/10) \
  #let a = $9/10$
  #let b = $4/5$
  a = #a " ", " " b = #b \
  Q(x) = #a x + #b
$

#v(ps)
#set align(center)
#image("wykres1.svg", height: ph)

#pagebreak()
#text(hs)[= Zadanie 2]
#v(0.8em)
#set align(left)

$
  P_0(x) = 1 \
  P_1(x) = x \
  P_2(x) = (3x^2-1)/2 \
  Q(x) = a P_0(x) + b P_1(x) + c P_2(x)
$
#v(0.5em)

Wielomiany te nie są ortogonalne na tym przedziale, więc
trzeba będzie policzyć układ równań analogiczny jak w
zadaniu 1:
#v(0.5em)

#let p2 = $(3x^2-1)/2$
#let a00 = $integral_0^1 1 dot 1 d x$
#let a01 = $integral_0^1 1 dot x d x$
#let a02 = $integral_0^1 1 dot #p2 d x$
#let a10 = $integral_0^1 x dot 1 d x$
#let a11 = $integral_0^1 x dot x d x$
#let a12 = $integral_0^1 x dot #p2 d x$
#let a20 = $integral_0^1 #p2 dot 1 d x$
#let a21 = $integral_0^1 #p2 dot x d x$
#let a22 = $integral_0^1 #p2 dot #p2 d x$
#let y0 = $integral_0^1 1+x^3 d x$
#let y1 = $integral_0^1 x dot (1+x^3) d x$
#let y2 = $integral_0^1 #p2 dot (1+x^3) d x$
$
  mat(a00, a01, a02;a10, a11, a12;a20, a21, a22) mat(a;b;c) = mat(y0;y1;y2) \
  \
  mat(1, 1/2, 0;1/2, 1/3, 1/8;0, 1/8, 1/5) mat(a;b;c) = mat(5/4;7/10;1/8) \
  #let a = $31/20$
  #let b = $-3/5$
  #let c = $1$
  a = #a " ", " " b = #b " ", " " c = #c \ \
  Q(x) = #a P_0(x) #b P_1(x) + #c P_2(x) \ \
  Q(x) = 3/2 x^2 - 3/5 x + 21/20
$

#v(ps)
#set align(center)
#image("wykres2.svg", height: ph)
#set align(left)
