// ========== Document settings ==========

// Template setup
#import "template.typ": *

#show: project.with(
  title: "Interpolation zwischen Punkten mittels eines 3R-Roboterarmes in der Ebene" ,
  authors: (
    "Justus John Michael Seeck",
  ),
  date: datetime.today().display(),
  logo: "./assets/pgwv_logo.svg",
)

// Underline links
#show link: underline

// ========== Content ==========

= Einführung

== Ziel dieser Arbeit

Das Ziel der Arbeit ist die mathematische Beschreibung der Interpolation zwischen zwei Punkten mittels eines 3R-Roboterarmes. Dazu wird zunächst die Kinematik des Roboters beschrieben und mittels Analogien zum Menschlichen Körper erläutert. Anschließend wird die Interpolation zwischen zwei Punkten mittels der Inversen Kinematik beschrieben. Im Anschluss werden Beispiele für die anwendung von geradliniger Interpolation in der Industrie gegeben.

== Mögliche Herangehensweisen
#lorem(50)

= Playground

Here, we can simplify:
$
(a dot b dot cancel(x)) / (cancel(x)) = a dot b 
$

== Die #link("https://www.youtube.com/watch?v=tRblwTsX6hQ")[PQ-Formel]
\
$
x eq minus frac(p, 2) plus.minus root(2, (frac(p,2))^2 - q)
$

== Limes mag Limetten

$
op("custom",
     limits: #true)_(n->oo) n 
$

== Vektoren

$
vec(a, b, c) dot vec(1, 2, 3) = a + 2b + 3c
$

== LOL

$
f(x, y) := cases(
  1 "if" (x dot y)/2 <= 0,
  2 "if" x "is even",
  3 "if" x in NN,
  4 "else",
)
$

== Matrizen

$
mat(
  1, 2, ..., 10;
  2, 2, ..., 10;
  dots.v, dots.v, dots.down, dots.v;
  10, 10, ..., 10;
)
$

== Summen

// With syntax.
$
sum_(i=0)^n a_i = 2^(1+i)
$

// With function call.
$
attach(
  Pi, t: alpha, b: beta,
  tl: 1, tr: 2+3, bl: 4+5, br: 6,
)
$

== Irgendeine Quellen

Terminator 2 @terminator-2 ist ein Toller film, @interior Rind-?fleisch-?e-?ti-?kett-?

== Irgendein Text

#text("LOL", font: "Bebas Neue", fill: rgb("#FF80ff"))
