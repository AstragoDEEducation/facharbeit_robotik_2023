#import "template.typ": *

#show: project.with(
  title: "Interpolation zwischen Punkten mittels eines 3R-Roboterarmes" ,
  authors: (
    "Justus John Michael Seeck",
  ),
  date: datetime.today().display(),
)

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

== Die PQ-Formel

\
$
minus frac(p, 2) plus.minus root(2, (frac(p,2))^2 -q) approx x
$


// Quellen

#pagebreak()

#bibliography("bibliography.yml")