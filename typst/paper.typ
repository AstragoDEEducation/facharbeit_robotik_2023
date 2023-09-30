// ========== Document settings ==========

// Template setup
#import "template.typ": *

#show: project.with(
  title: "Lineare Interpolation zwischen Punkten mittels eines 3R-Roboterarmes in der Ebene" ,
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

Das Ziel dieser Arbeit ist die mathematische Beschreibung der linearen Interpolation zwischen zwei gegebenen Punkten $"[A]"_"S"$ und $"[B]"_"S"$ mittels eines 3R-Roboterarmes. 

Dazu wird die Aufgabe der Interpolation in mehrere Teilbereiche aufgeteilt, welche im Folgenden  erläutert werden.
Zuerst wird die Gültigkeit von Koordinaten überprüft, indem bestimmt wird, ob die gesamte Strecke zwischen den Punkten $"[A]"_"S"$ mit den Koordinaten $mat("a"_"1"; "a"_"2")$ und $"[B]"_"S"$ mit den Koordinaten $mat("b"_"1"; "b"_"2")$ in einem vom Roboter erreichbaren Bereich liegt.
Im Anschluss wird die Strecke mit Hilfe von Vektoren parametrisiert und ein Zeitverlauf für die Bewegung des Roboters bestimmt, sodass dieser die Strecke in einer vorgegebenen Zeit zurücklegt, ohne dabei die maximalen Geschwindigkeiten oder Beschleunigungen zu überschreiten.

= Aufbau des 3R-Roboterarmes

Der 3R-Roboterarm besteht aus drei Gelenken, welche jeweils über einen Schaft mit fester Länge miteinander verbunden sind. Am Ende des drittem Schaftes befindet sich ein Manipulator (hier: ein Greifarm), welcher die Aufgabe hat, einen Stift führen. Das Weltsystem _S_ befindet sich am 1. Gelenk des Roboterarmes ($"R"_"1"$), das Toolsystem _T_ am 3. Gelenk ($"R"_"3"$). @fig-3r_arm zeigt den Aufbau des Roboterarmes. Die Länge der einzelnen Schäfte $l_"1"$, $l_"2"$ und $l_"3"$ ist bekannt.

Der Manipulator greift einen Stift mit dem bekannten Radius $rho$, in dessen Zentrum sich die Spitze _P_ befindet (siehe: @fig-3r_arm_ts).

= Trajektorienplanung

In der Trajektorienplanung wird der Weg, welcher vom Roboterarm zurückgelegt wird, geplant.
Hierbei wird die Strecke zwischen den gegebenen Punkten $"[A]"_"S"$ und $"[B]"_"S"$ unter Zurhilfenahme von Vektoren parametrisiert.
Die Verwendung von Vektoren anstelle von linearen Funktionen hat den Vorteil, dass auch vertikale Strecken gezeichnet werden können. 

Außerdem wird überprüft, ob die Strecke in einem vom Roboter erreichbaren Bereich liegt.

== Erreichbarkeit von Koordinaten

Um einen Pfad für die Bewegung des Roboters zu planen, ist zuvor eine Überprüfung der Erreichbarkeit der Koordinaten nötig.
Durch den Aufbau eines Roboterarms kann es passieren, dass gewisse Punkte aufgrund der Armlängen für den Roboter nicht erreichbar sind, und somit das Zeichnen der Strecke nicht möglich ist.

Aus Gründen, welche im Verlauf der Arbeit erläutert werden, entspricht der Winkel des Toolsystems _T_ ($[theta_3]_S$) zur x-Achse des Weltsystems _S_ dem Winkel zwischen den Punkten $"[A]"_"S"$ und $"[B]"_"S"$.

Für die Laage der Stiftspitze _P_ im Bezug auf das Toolsystem _T_ gilt:
$
"[P]"_"t" = mat("l"_"3" + rho; 0)
$

Für den Winkel $theta$ zwischen den Punkten $"[A]"_"S"$ und $"[B]"_"S"$ gilt:
$
theta = "atan2"("b"_"2" - "a"_"2", "b"_"1" - "a"_"1")
$

Die Erreichbarkeitsbegrenzung des Roboterarms ist konzentrisch kreisförmig um den Ursprung des Weltsystems, verschoben um den Vektor $accent(v, arrow)$.

Für $accent(v, arrow)$ gilt:
$
accent(v, arrow) &= "[P]"_"t" * "Rot"_theta \
&= mat("l"_"3" + rho; 0) * mat("cos"(theta), "-sin"(theta); "sin"(theta), "cos"(theta)) \
&= mat("l"_"3" + rho) * mat("cos"(theta); "sin"(theta)) \
$

// ===== Abbildungen

#pagebreak()

= Abbildungen

#figure(
  image("./assets/3r_arm.png", width: 60%),
  caption: [
    Ein 3R-Roboterarm mit dem Weltsystem _S_ und dem Toolsystem _T_.
  ],
) <fig-3r_arm>

#figure(
  image("./assets/3r_arm_ts.png", width: 60%),
  caption: [
    Manipulator des Roboters mit dem #text("Stift (rot)", fill: red) und dem Stiftradius $rho$.
  ],
) <fig-3r_arm_ts>

// ===== Bibliographie
  
#pagebreak()

#bibliography("bibliography.yml")
