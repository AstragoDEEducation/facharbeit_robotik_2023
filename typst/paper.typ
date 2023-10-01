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
#text("ABBILDUNGEN UNVOLLSTÄNDIG (O_S UND O_T FEHLEN)", fill: red, style: "italic", size: 1.1em)

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

Die Erreichbarkeitsbegrenzung des Roboterarms ist konzentrisch kreisförmig um den Ursprung des Weltsystems, verschoben um einen Vektor $accent(v, ->)$.

Um den Vektor $accent(v, ->)$ zu erhalten, wird $"[P]"_"t"$ mit der bereits aus dem direkten kinematischen Problem bekannten Rotationsmatrix $"Rot"_theta$ multipliziert.

$
accent(v, ->) = vec(v_1, v_2) &= "[P]"_"t" dot "Rot"_theta \
&= mat("l"_"3" + rho; 0) dot mat("cos"(theta), "-sin"(theta); "sin"(theta), "cos"(theta)) \
&= mat("l"_"3" + rho) dot mat("cos"(theta); "sin"(theta)) \
$

Der Mittelpunkt der Kreise $M$, welche die Erreichbarkeit des Roboters begrenzen, liegt dann bei $M = "[O]"_"S" + accent(v, ->)$.

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

Gegeben sind die Punkte $"[A]"_"S" = mat(a_1; b_1)$ und $"[B]"_"S" = mat(b_1; b_2)$. Auf der Strecke zwischen den Punkten befindet sich der Punkt $X$, welcher mit dem Vektor $accent("x", ->)$ ausgehend vom Punkt $"[A]"_"S"$ in Richtung von Punkt $"[B]"_"S"$ verschoben werden kann.

$X &= A + accent("AX", ->) = A + accent("x", ->)$ #h(4em) mit $accent("x", ->) = accent("AX", ->)$

$accent("AX", ->)$ und $accent("AB", ->)$ sind parallel zueinander. Somit gilt:

$accent("AX", ->) || accent("AB", ->) => accent("AX", ->) = s dot accent("AB", ->)$ #h(4em) mit $0 <= s <= 1$

Die Funktion $X(s) = A + s dot accent("AB", ->)$ beschreibt dann alle Punkte auf der Strecke $accent("AB", -)$ im Bezug auf den Parameter $s$. 

Diese Funktion lässt sich ebenfalls in Koordinaten darstellen.

Mit
$
[accent("AB", ->)]_S = [B]_S - [A]_S = b - a
$

lässt sich die Funktion $X(s)$ wie folgt darstellen:

#text("Großes X benötigt?", fill: red, style: "italic", size: 1.1em)

$
X(s) = [X(s)]_S &= [A]_S + s dot [accent("AB", ->)]_S \
&= a + s dot (b - a) \
&= (1 - s) dot a + s dot b
$

Auch andere Interpolationen zwischen Punkten, zum Beispiel Bezierkurven, können parametrisiert werden, sodass der Roboterarm diese abfahren kann.

== Beschreibung der Bewegung des Roboters

#text("ABBILDUNGEN FEHLEN", fill: red, style: "italic", size: 1.1em)

Der Roboterarm soll sich zum Zeitpunkt $t$ mit der Spitze des stiftes am Punkt $X(s)$ der Strecke $accent("AB", -)$ befinden. Hierzu müssen die Gelenkwinkel $theta_1$, $theta_2$ und $theta_3$ berechnet werden. Die Bewegung des Roboters soll am Zeitpunkt $t = 0$ beginnen; der Roboter befindet sich zu diesem Zeitpunkt am Punkt $"[A]"_"S"$, und am Zeitpunkt $t = t_1$ beendet sein; der Roboter befindet sich zu diesem Zeitpunkt am Punkt $"[B]"_"S"$.
Gesucht ist also eine Funktion $s(t)$, welche den Fortschritt der Bewegung des Roboters in Abhängigkeit von der Zeit $t$ beschreibt.

Für die Funktion $s(t)$ gibt es einige Anforderungen, welche erfüllt werden müssen:
#enum(
  enum.item(1)[
    Zum Zeitpunkt $t = 0$ muss sich der Roboterarm in seiner Ausgangsposition, also am Punkt $"[A]"_"S"$ befinden.

    $s(t) = 0$ #h(4em) für $t = 0$
  ],
  enum.item(2)[
    Zum Zeitpunkt $t = t_1$ muss sich der Roboterarm in seiner Endposition, also am Punkt $"[B]"_"S"$ befinden.
    
    $s(t) = 1$ #h(4em) für $t = t_1$
  ],
  enum.item(3)[
    Die Funktion $s(t)$ muss stetig auf dem Intervall $[0, t_1]$ streng monoton wachsend sein ($=> accent("s", .)(t) >= 0$), sie darf also keine Sprünge enthalten oder sich verringern.
  ],
)

Der wohl einfachste Lösungsansatz wäre es, die Bewegung des Roboters linear zu beschreiben, also $s(t) = t / t_1$ auf dem Intervall $[0, t_1]$. Dies würde in der Anwendung jedoch problematisch sein, da die Geschwindigkeit des Roboters nicht konstant wäre. Der Roboter müsste also innerhalb von $Delta t = 0$ von $accent("s", dot)(t) = 0$ auf $accent("s", dot)(t) = 1$ beschleunigen, was nicht möglich ist.  

Gesucht ist also eine Funktion $s(t)$, welche die obrigen Anforderungen erfüllt, sowie die Geschwindigkeit ($accent("s", dot)(t)$) und die Beschleunigung ($accent("s", dot.double)(t)$) des Roboters stetig hält.

Für die Funktion $s(t)$ bietet sich eine Polynomfunktion an, da diese stetig differenzierbar ist. Diese Polynomfunktion muss dann so angepasst werden, dass die obrigen Anforderungen erfüllt werden.

Die Anforderungen an die Polynomfunktion $s(t)$ lauten fortlaufend:

#enum(
  enum.item(4)[
    Die Geschwindigkeit des Roboters ist am Zeitpunkt $t = 0$ und am Zeitpunkt $t = t_1$ gleich 0.
    $
    accent("s", dot)(0) = accent("s", dot)(t_1) = 0
    $
  ],
  enum.item(5)[
    Die Beschleunigung des Roboters ist am Zeitpunkt $t = 0$ und am Zeitpunkt $t = t_1$ gleich 0.
    $
    accent("s", dot.double)(0) = accent("s", dot.double)(t_1) = 0
    $
  ],
  enum.item(6)[
    $accent("s", dot)(t)$ und $accent("s", dot.double)(t)$ sind beschränkt. Die maximale Geschwindigkeit $accent("s", dot)(t)$ und die maximale Beschleunigung $accent("s", dot.double)(t)$ dürfen nicht überschritten werden.
    $accent("s", dot)(t)$ und $accent("s", dot.double)(t)$ hängen vom Roboter ab.

    Sollten die maximalen Geschwindigkeiten und Beschleunigungen des Roboters überschritten werden, muss $Delta t$ erhöht werden, indem $t_1$ vergrößert wird.
  ],
)

Um das Polynom $s(t) = c_0 + c_1 dot t + c_2 dot t^2 + c_3 dot t^3 + ... + c_n dot t^n$ auf $[0, t_1]$ zu binden, wird $t_1 = 1$ gesetzt. Sollten Geschwindigkeiten oder Beschleunigungen des Roboters überschritten werden, wird $t_1$ erhöht, bis die Geschwindigkeiten und Beschleunigungen des Roboters nicht mehr überschritten werden.
Alternativ könnte auch eine andere Methode zur Vergrößerung von $Delta t$ verwendet werden, welche jedoch nicht ineffizientern Gesamtablauf der Bewegung des Roboters zur Folge hätte. Diese Methode wird im Verlauf der Arbeit kurz dargestellt.

Es ergeben sich die folgenden Polynomfunktionen für $s(t)$, $accent("s", dot)(t)$ und $accent("s", dot.double)(t)$:

$
s(t) &= c_0 + c_1t + c_2t^2 + c_3t^3 + ... + c_n t^n \
accent("s", dot)(t) &= c_1 + 2c_2t + 3c_3t^2 + ... + n c_n t^(n - 1) \
accent("s", dot.double)(t) &= 2c_2 + 6c_3t + ... + n(n - 1) c_n t^(n - 2)
$

Für die Erfüllung folgender Anforderungen am Zeitpunkt $t = 0$ ergibt sich:
$
s(0) = 0 &=> c_0 = 0 \
accent("s", dot)(0) = 0 &=> c_1 = 0 \
accent("s", dot.double)(0) = 0 &=> c_2 = 0 \
$

Für die Erfüllung der Anforderungen am Zeitpunkt $t = t_1$ werden $n = 5$ Koeffizienten benötigt. Da $c_0$ bis $c_2$ $= 0$ sind fallen diese nun weg. Es ergibt sich:

$
s(t) &= c_3 t^3 + c_4 t^4 + c_5 t^5 \
accent("s", dot)(t) &= 3c_3 t^2 + 4c_4 t^3 + 5c_5 t^4 \
accent("s", dot.double)(t) &= 6c_3 t + 12c_4 t^2 + 20c_5 t^3 \
$

$s(t)$ muss an der Stelle $t = 1$ den Wert $1$ annehmen, die Geschwindigkeit $accent("s", dot)$ und die Beschleunigung $accent("s", dot.double)$ den Wert $0$. Es ergibt sich das folgende lineare Gleichungssystem:

$
c_3 + c_4 + c_5 &= 1 \
3c_3 + 4c_4 + 5c_5 &= 0 \
6c_3 + 12c_4 + 20c_5 &= 0 \
$

Bei der Lösung des Gleichungssystems ergeben sich die Koeffizienten:

$
c_3 &= 10 \
c_4 &= -15 \
c_5 &= 6 \
$

Durch Einsetzen der Koeffizienten in die Gleichung ergibt sich die Funktion $s(t)$:

$
s(t) = 10t^3 - 15t^4 + 6t^5
$

#text("Abbildung generieren!", fill: red, style: "italic", size: 1.1em)

Die nun erhaltene Funktion $s(t)$ muss nun auf dem Intervall $[0, 1]$ auf die Erfüllung der obrigen Anforderungen (1. - 6.) geprüft werden:

#enum(
  enum.item(1)[
    Der Roboterarm befindet sich zum Zeitpunkt $t = 0$ am Punkt $"[A]"_"S"$.

    $
    s(0) &= 10 dot 0^3 - 15 dot 0^4 + 6 dot 0^5 \
    &= 0
    $

    $s(0)$ in die Funktion $X(s)$ eingesetzt ergibt:

    $
    X(s(0)) &= (1 - s(0)) dot a + s(0) dot b \
    X(0) &= (1 - 0) dot a + 0 dot b \
    &= a
    $

    #sym.checkmark Diese Bedingung ist erfüllt.
  ],

  enum.item(2)[
    Der Roboterarm befindet sich zum Zeitpunkt $t = t_1 = 1$ am Punkt $"[B]"_"S"$.

    $
    s(1) &= 10 dot 1^3 - 15 dot 1^4 + 6 dot 1^5 \
    &= 1
    $

    $s(1)$ in die Funktion $X(s)$ eingesetzt ergibt:

    $
    X(s(1)) &= (1 - s(1)) dot a + s(1) dot b \
    X(1) &= (1 - 1) dot a + 1 dot b \
    &= b
    $

    #sym.checkmark Diese Bedingung ist erfüllt.
  ],

  enum.item(3)[
    
  ],

  enum.item(4)[
    
  ],

  enum.item(5)[
    
  ],

  enum.item(6)[
    
  ],
)

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
