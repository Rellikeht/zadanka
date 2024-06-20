#set page ("a4", margin: 2.2cm)

#align(center, text(22pt)[*Sprawozdanie 1*])

#linebreak()
= Zadanie 1

Maszynowy epsilon musi mieć taki sam wykładnik jak 1 i jak najmniejszą mantysę.

Jest wyliczany ze wzoru $ epsilon = beta^(1-p) $ podanego w prezentacji.

W 64-bitowej wersji IEEE 754 to 2.220446049250313e-16.

#linebreak()
= Zadanie 2

- błąd bezwzględny przy ewaluacji $sin(x)$: $Delta sin(x) = | sin(x)(1+epsilon) - sin(x) |$

- błąd względny przy ewaluacji $sin(x)$:
$
(Delta sin(x))/(sin(x)) =
(|sin(x)(1+epsilon) - sin(x)|)/(sin(x))
$

- uwarunkowanie dla tego problemu
$
italic("cond")(sin(x)) =
| (x sin '(x))/sin(x) | = | x cot(x) |
$

*Wnioski:*

Problem jest czuły w miejscach, gdzie funkcja $cot x$
zmierza do nieskończoności, czyli dla $x = k π$, gdzie $k ∈ Z$, poza $k = 0$.

Najlepiej uwarunkowany natomiast będzie problem w miejscach, gdzie funkcja $cos x$ zeruje
się, a więc dla $x = k π + π/2$, gdzie $k ∈ Z$

#linebreak()
= Zadanie 3
#h(0.5em)

a) $hat(y) = x$ , $hat(x) = arcsin(hat(y))$

Błąd progresywny: $|y − hat(y)| = |sin(x) − x|$

Błąd wsteczny: $|hat(x) − x| = | arcsin(hat(y)) − x| = | arcsin(x) − x|$

#let xhat1(y) = calc.asin(y).rad()
#let perr1(x) = calc.abs(calc.sin(x) - x)
#let berr1(x) = calc.abs(calc.asin(x).rad() - x)

#table(
  columns: (auto, auto, auto, auto, auto),
  inset: 1.0em,
  align: center,
  [$x$],
  [$hat(y)$],
  [$hat(x)$],
  [błąd progresywny],
  [błąd wsteczny],
  ..(0.1, 0.5, 1.0).map(x => ([#x], [#x], [#xhat1(x)], [#perr1(x)], [#berr1(x)])).flatten(),
)

#pagebreak()
b) $hat(y) = x − x^3/6$ , $hat(x) = arcsin(x − x^3/6)$

Błąd progresywny: $|y − hat(y)| = |sin(x) − (x − x^3/6)| = |sin(x) - x + x^3/6|$

Błąd wsteczny: $|hat(x) − x| = |arcsin(hat(y)) − x| = |arcsin(x − x^3/6) − x|$

#let xhat2(y) = calc.asin(y - calc.pow(y, 3) / 6).rad()
#let perr2(x) = calc.abs(calc.sin(x) - x + calc.pow(x, 3) / 6)
#let berr2(x) = calc.abs(calc.asin(x - calc.pow(x, 3) / 6).rad() - x)

#table(
  columns: (auto, auto, auto, auto, auto),
  inset: 1.0em,
  align: center,
  [$x$],
  [$hat(y)$],
  [$hat(x)$],
  [błąd progresywny],
  [błąd wsteczny],
  ..(0.1, 0.5, 1.0).map(x => ([#x], [#x], [#xhat2(x)], [#perr2(x)], [#berr2(x)])).flatten(),
)

// #table(
//   columns: (auto, auto, auto),
//   inset: 1.0em,
//   align: center,
//   [$x$], [ błąd progresywny ], [ błąd wsteczny ],
//   [$x$], [$|sin(x) - x + x^3/6|$], [$|arcsin(x - x^3/6) - x|$],
//   [0.1], [#perr2(0.1)], [#berr2(0.1)],
//   [0.5], [#perr2(0.5)], [#berr2(0.5)],
//   [1.0], [#perr2(1.0)], [#berr2(1.0)],
// )

*Wnioski:*

Oczywistym wnioskiem jest, że przybliżenia są bardziej dokładne (błędy są
mniejsze) dla większej ilości wyrazów z szeregu.

#linebreak()
= Zadanie 4

a) $ "UFL" = beta ^ L = 10^(-98)$

b) $x − y = 0.06 · 10−97 = 6 · 10−99 < "UFL"$ , co zostanie zinterpretowane jako
0

*Wnioski:*

UFL mówi nam jaka jest najmniejsza możliwa wartość, którą można trzymać w danej
reprezentacji zmiennoprzecinkowej i kiedy wyniki operacji zostaną
zinterpretowane jako 0.
