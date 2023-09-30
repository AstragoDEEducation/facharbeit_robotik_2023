// ========== Document settings ==========

// Template setup
#import "template.typ": *

#show: project.with(
  title: "Interpolation zwischen Punkten in der Ebene mittels eines Roboterarmes (3R, Gerade)" ,
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

Das Ziel dieser Arbeit ist die mathematische Beschreibung der linearen Interpolation zwischen zwei Punkten $"[A]"_"S"$ und $"[B]"_"S"$ mittels eines 3R-Roboterarmes. 

Dazu wird die Aufgabe der Interpolation in mehrere Teilbereiche aufgeteilt, welche im Folgenden erläutert werden.
Zuerst wird die Gültigkeit von Koordinaten überprüft, indem bestimmt wird, ob die gesamte Strecke zwischen den Punkten $"[A]"_"S"$ und $"[B]"_"S"$ in einem vom Roboter erreichbaren Bereich liegt.
Im Anschluss wird die Strecke mit Hilfe von Vektoren parametrisiert und ein Zeitverlauf für die Bewegung des Roboters bestimmt, sodass dieser die Strecke in einer vorgegebenen Zeit zurücklegt, ohne dabei die maximalen Geschwindigkeiten oder Beschleunigungen zu überschreiten.

= Aufbau des 3R-Roboterarmes

Der 3R-Roboterarm besteht aus drei Gelenken, welche jeweils über einen Schaft mit fester Länge miteinander verbunden sind. Am Ende des drittem Schaftes befindet sich ein Manipulator (hier: ein Greifarm), welcher die Aufgabe hat, einen Stift führen. Das Weltsystem _S_ befindet sich am 1. Gelenk des Roboterarmes ($"R"_"1"$), das Toolsystem _T_ am Manipulator. @fig-3r_arm zeigt den Aufbau des Roboterarmes.

Der Manipulator greift einen Stift mit dem Radius $rho$, in dessen Zentrum sich die Spitze $P$ befindet (siehe: @fig-3r_arm_ts).  

= Trajektorienplanung

- Kreise

== Gültigkeit von Koordinaten

Um einen Pfad für die Bewegung des Roboters zu planen, ist zuvor, insbesondere in praktischen Anwendungen, eine Überprüfung der Erreichbarkeit von Koordinaten nötig.
Durch den Aufbau eines Roboterarms kann es passieren, dass gewisse Punkte aufgrund der Armlängen für den Roboter nicht erreichbar sind.


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

// === Eigener Ansatz

// Um eine Bewegung des Robortearmes aufzuführen zu können, muss sich die gesamte Strecke zwischen $A$ und $B$ in einem vom Roboter erreichbaren Bereich befinden.

// Da der hier referenzierte Roboter eine feste Basis am Koordinatenursprung des Weltsystems $O_U$ hat, ergeben sich die folgenden Einschränkungen:

// $
// l_"Gesamt" <= l_"1" + l_"2" + l_"3"
// $

// $
// l_"Gesamt" >= abs(l_"1" - l_"2" - l_"3")
// $