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

// Text Settings
#set text(spacing: 150%)
#set text(size: 11pt)

// ========== Content ==========

= Einführung

== Ziel dieser Arbeit 

Das Ziel dieser Arbeit ist die mathematische Beschreibung der linearen Interpolation zwischen zwei gegebenen Punkten $"[A]"_"S"$ und $"[B]"_"S"$ mittels eines 3R-Roboterarmes. 

Dazu wird die Aufgabe der Interpolation in mehrere Teilbereiche aufgeteilt, welche im Folgenden  erläutert werden.
Zuerst wird die Gültigkeit von Koordinaten überprüft, indem bestimmt wird, ob die gesamte Strecke zwischen den Punkten $"[A]"_"S"$ mit den Koordinaten $mat("a"_"1"; "a"_"2")$ und $"[B]"_"S"$ mit den Koordinaten $mat("b"_"1"; "b"_"2")$ in einem vom Roboter erreichbaren Bereich liegt.
Im Anschluss wird die Strecke mit Hilfe von Vektoren parametrisiert und ein Zeitverlauf für die Bewegung des Roboters bestimmt, sodass dieser die Strecke in einer vorgegebenen Zeit zurücklegt, ohne dabei die maximalen Geschwindigkeiten oder Beschleunigungen zu überschreiten.

= Aufbau des 3R-Roboterarmes
#text("ABBILDUNGEN Unvollständig (O_S und O_T fehlen)", fill: red, style: "italic", size: 1.1em)

Der 3R-Roboterarm besteht aus drei Gelenken, welche jeweils über ein Armglied mit fester Länge miteinander verbunden sind. Am Ende des drittem Armgliedes befindet sich ein Endeffektor (hier: ein Greifer), welcher die Aufgabe hat, einen Stift führen. Das Weltsystem _S_ befindet sich am 1. Gelenk des Roboterarmes ($"R"_"1"$), das Toolsystem _T_ am 3. Gelenk ($"R"_"3"$). @fig-3r_arm zeigt den Aufbau des Roboterarmes. Die Länge der einzelnen Armglieder $l_"1"$, $l_"2"$ und $l_"3"$ ist bekannt.

Der Manipulator greift einen Stift mit dem bekannten Radius $rho$, in dessen Zentrum sich die Spitze _P_ befindet (siehe: @fig-3r_arm_ts).

= Trajektorienplanung

In der Trajektorienplanung wird der Weg, welcher vom Roboterarm zurückgelegt wird, geplant.
Hierbei wird die Strecke zwischen den gegebenen Punkten $"[A]"_"S"$ und $"[B]"_"S"$ unter Zurhilfenahme von Vektoren parametrisiert.
Die Verwendung von Vektoren anstelle von linearen Funktionen hat den Vorteil, dass auch vertikale Strecken gezeichnet werden können. 

Außerdem wird überprüft, ob die Strecke in einem vom Roboter erreichbaren Bereich liegt.

== Erreichbarkeit von Koordinaten

#text("ABBILDUNGEN FEHLEN", fill: red, style: "italic", size: 1.1em)

Um einen Pfad für die Bewegung des Roboters zu planen, ist zuvor eine Überprüfung der Erreichbarkeit der Koordinaten nötig.
Durch den Aufbau eines Roboterarms kann es passieren, dass gewisse Punkte aufgrund der Längen der einzelnen Armglieder für den Roboter nicht erreichbar sind, und somit das Zeichnen der Strecke nicht möglich ist.

Aus Gründen, welche im Verlauf der Arbeit erläutert werden, entspricht der Winkel des Toolsystems _T_ ($[theta_3]_S$) zur x-Achse des Weltsystems _S_ dem Winkel zwischen den Punkten $"[A]"_"S"$ und $"[B]"_"S"$.

Für die Laage der Stiftspitze _P_ im Bezug auf das Toolsystem _T_ gilt:
$
"[P]"_"t" = mat("l"_"3" + rho; 0)
$

Für den Winkel $theta$ zwischen den Punkten $"[A]"_"S"$ und $"[B]"_"S"$ gilt:
$
theta = "atan2"("b"_"2" - "a"_"2", "b"_"1" - "a"_"1")
$

Die Erreichbarkeitsbegrenzung des Roboterarms ist konzentrisch kreisförmig um den Ursprung des Weltsystems, verschoben um einen Vektor $accent(v, arrow)$.

Um den Vektor $accent(v, arrow)$ zu erhalten, wird $"[P]"_"t"$ mit der bereits aus dem direkten kinematischen Problem bekannten Rotationsmatrix $"Rot"_theta$ multipliziert.

$
accent(v, arrow) = vec(v_1, v_2) &= "[P]"_"t" dot "Rot"_theta \
&= mat("l"_"3" + rho; 0) dot mat("cos"(theta), "-sin"(theta); "sin"(theta), "cos"(theta)) \
&= mat("l"_"3" + rho) dot mat("cos"(theta); "sin"(theta)) \
$

Der Mittelpunkt der Kreise $M$, welche die Erreichbarkeit des Roboters begrenzen, liegt dann bei $M = "[O]"_"S" + accent(v, arrow)$.

Nun müssen die Radien der beiden Kreise bestimmt werden, welche die Erreichbarkeit des Roboters begrenzen.

Für den Maximalradius $"r"_"max"$ gilt:
$
"r"_"max" = "l"_"1" + "l"_"2"
$

Für den Minimalradius $"r"_"min"$ gilt:
$
"r"_"min" = abs("l"_"1" - "l"_"2")
$

$==>$ Ein Punkt ist dann erreichbar, wenn er innerhalb eines Kreises mit dem Radius $"r"_"max"$ und dem Mittelpunkt $M$ und außerhalb des Kreises mit dem Radius $"r"_"min"$ und dem Mittelpunkt $M$ liegt.

Die Überprüfung, ob ein Punkt innerhalb eines Kreises liegt, könnte beispielsweise mit dem folgenden, hier nicht näher erläuterten Verfahren erfolgen:

+ Prüfen, ob der Startpunkt $"[A]"_"S"$ und der Endpunkt $"[B]"_"S"$ innerhalb des erreichbaren Bereiches liegen. Hierzu kann die Distanz zwischen dem Mittelpunkt $M$ und den Punkten $"[A]"_"S"$ und $"[B]"_"S"$ berechnet werden. Beispielsweise mit dem Satz des Pythagoras. Liegt mindestens einer der Punkte außerhalb des erreichbaren Bereiches, ist die Strecke nicht zeichenbar beziehungsweise nicht vollständig vom Roboter erreichbar.
+ Prüfen, ob die Strecke zwischen den Punkten $"[A]"_"S"$ und $"[B]"_"S"$ den erreichbaren Bereich schneidet. Hierzu kann die Strecke zwischen den Punkten $"[A]"_"S"$ und $"[B]"_"S"$ parametrisiert und mittels eines Vektors dargestellt werden, und mit der Kreisgleichung ein weiterer Vektor erstellt werden, welcher der Kreisgleichung folgt. Schneiden sich die beiden Vektoren, so schneidet die Strecke den Kreis und ist somit nicht zeichenbar beziehungsweise nicht vollständig vom Roboter erreichbar.

== Bestimmung des Punktes $"[P]"_"S"$ (Wird das benötigt?)

// Da die Längen der einzelnen Armglieder bekannt sind und auch die Position der Stiftspitze _P_ im Bezug auf das Toolsystem _T_ bekannt ist, kann die Strecke zwischen den Punkten $"[A]"_"S"$ und $"[B]"_"S"$ parametrisiert werden.

Durch anwendung des direkten kinematischen Problems kann der Punkt $"[P]"_"S"$ bestimmt werden.

$
"[P]"_"S" &= "Rot"(theta_1 + theta_2 + theta_3) dot vec("l"_"3" + rho, 0) + "Rot"(theta_1 + theta_2) dot vec("l"_"2", 0) + "Rot"(theta_1) dot vec("l"_"1", 0) \
&= vec((l_3 + rho) dot "cos"(theta_1 + theta_2 + theta_3) + l_2 "cos"(theta_1 + theta_2) + l_1 "cos"(theta_1), (l_3 + rho) dot "sin"(theta_1 + theta_2 + theta_3) + l_2 "sin"(theta_1 + theta_2) + l_1 "sin"(theta_1)) 
$

== Parametrisierung der Strecke

#text("ABBILDUNGEN FEHLEN", fill: red, style: "italic", size: 1.1em)

Um die Gelenkwinkel des Roboters in Abhängigkeit von der Zeit zu bestimmen, wird die Strecke zwischen den Punkten $"[A]"_"S"$ und $"[B]"_"S"$ parametrisiert, also in einen Vektor umgewandelt, welcher einem Parameter $s$ abhängt.

Ziel ist es, eine Funktion zu finden, welche alle Punkte auf der Strecke zwischen den Punkten $"[A]"_"S"$ und $"[B]"_"S"$ beschreibt.

Gegeben sind die Punkte $"[A]"_"S" = mat(a_1; b_1)$ und $"[B]"_"S" = mat(b_1; b_2)$. Zwischen den Punkten befindet sich die Strecke $x$, sowie der Vektor $accent("x", arrow)$, welcher sich auf der Strecke $x$ befindet, und damit auch parallel zu ihr ist.

$x &= A + accent("Ax", arrow) = A + accent("x", arrow)$ #h(4em) mit $accent("x", arrow) = accent("Ax", arrow)$

$accent("Ax", arrow) || accent("AB", arrow) => accent("Ax", arrow) = s dot accent("AB", arrow)$ #h(4em) mit $0 <= s <= 1$

$s$ beschreibt den Anteil der Strecke $x$, welcher von dem Vektor $accent("Ax", arrow)$ beschrieben wird. $s = 0$ beschreibt den Punkt $"[A]"_"S"$, $s = 1$ beschreibt den Punkt $"[B]"_"S"$.

#text("Video: 12:00 Minuten", fill: red, style: "italic", size: 1.1em)


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
    Manipulator des Roboters mit dem Stift (rot) und dem Stiftradius $rho$.
  ],
) <fig-3r_arm_ts>

// ===== Bibliographie
  
#pagebreak()

#bibliography("bibliography.yml")
