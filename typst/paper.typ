// ========== Document settings ==========

// Template setup
#import "template.typ": *

#show: project.with(
  title: "Interpolation zwischen Punkten mittels eines 3R-Roboterarmes" ,
  authors: (
    "Justus John Michael Seeck",
  ),
  date: datetime.today().display(),
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
x eq minus frac(p, 2) plus.minus root(2, (frac(p,2))^2 - q) < 7
$

== Limes mag Limetten

$
op("custom",
     limits: #true)_(n->oo) n 
$


// Quellen

#pagebreak()

#bibliography("bibliography.yml")