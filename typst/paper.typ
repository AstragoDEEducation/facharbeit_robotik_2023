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

Der 3R-Roboterarm besteht aus drei Gelenken, welche jeweils über ein Armglied mit fester Länge miteinander verbunden sind. Am Ende des drittem Armgliedes befindet sich ein Endeffektor (hier: ein Greifer), welcher die Aufgabe hat, einen Stift führen. Das Weltsystem $S$ befindet sich am 1. Gelenk des Roboterarmes ($"R"_"1"$), das Toolsystem $T$ am 3. Gelenk ($"R"_"3"$). @fig-3r_arm zeigt den Aufbau des Roboterarmes. Die Länge der einzelnen Armglieder $l_"1"$, $l_"2"$ und $l_"3"$ ist bekannt.

Der Manipulator greift einen Stift mit dem bekannten Radius $rho$, in dessen Zentrum sich die Spitze _P_ befindet (siehe: @fig-3r_arm_ts).

= Trajektorienplanung

In der Trajektorienplanung wird der Weg, welcher vom Roboterarm zurückgelegt wird, geplant.
Hierbei wird die Strecke zwischen den gegebenen Punkten $"[A]"_"S"$ und $"[B]"_"S"$ unter Zuhilfenahme von Vektoren parametrisiert.
Die Verwendung von Vektoren anstelle von linearen Funktionen hat den Vorteil, dass auch vertikale Strecken gezeichnet werden können. 

Außerdem wird überprüft, ob die Strecke in einem vom Roboter erreichbaren Bereich liegt.

== Erreichbarkeit von Koordinaten

#text("ABBILDUNGEN FEHLEN", fill: red, style: "italic", size: 1.1em)

Um einen Pfad für die Bewegung des Roboters zu planen, ist zuvor eine Überprüfung der Erreichbarkeit der Koordinaten nötig.
Durch den Aufbau eines Roboterarms kann es passieren, dass gewisse Punkte aufgrund der Längen der einzelnen Armglieder für den Roboter nicht erreichbar sind, und somit das Zeichnen der Strecke nicht möglich ist.

Aus Gründen, welche im Verlauf der Arbeit erläutert werden, entspricht der Winkel des Toolsystems $T$ ($[theta_3]_S$) zur x-Achse des Weltsystems $S$ dem Winkel zwischen den Punkten $"[A]"_"S"$ und $"[B]"_"S"$.

Für die Laage der Stiftspitze _P_ im Bezug auf das Toolsystem $T$ gilt:
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

Durch Anwendung des direkten kinematischen Problems kann der Punkt $"[P]"_"S"$ bestimmt werden.

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

Der Roboterarm soll sich zum Zeitpunkt $t$ mit der Spitze des Stiftes am Punkt $X(s)$ der Strecke $accent("AB", -)$ befinden. Hierzu müssen die Gelenkwinkel $theta_1$, $theta_2$ und $theta_3$ berechnet werden. Die Bewegung des Roboters soll am Zeitpunkt $t = 0$ beginnen; der Roboter befindet sich zu diesem Zeitpunkt am Punkt $"[A]"_"S"$, und am Zeitpunkt $t = t_1$ beendet sein; der Roboter befindet sich zu diesem Zeitpunkt am Punkt $"[B]"_"S"$.
Gesucht ist also eine Funktion $s(t)$, welche den Fortschritt der Bewegung des Roboters in Abhängigkeit von der Zeit $t$ beschreibt.

Für die Funktion $s(t)$ gibt es einige Anforderungen, welche erfüllt werden müssen:
#enum(
  enum.item(1)[
    Zum Zeitpunkt $t = 0$ muss sich der Roboterarm in seiner Ausgangsposition, also am Punkt $"[A]"_"S"$ befinden.

    $s(t) = 0$ #h(4em) für $t = 0$
    // $ s(t) = 0 space.quad space.quad "für" t = 0 $
  ],
  enum.item(2)[
    Zum Zeitpunkt $t = t_1$ muss sich der Roboterarm in seiner Endposition, also am Punkt $"[B]"_"S"$ befinden.
    
    $s(t) = 1$ #h(4em) für $t = t_1$
  ],
  enum.item(3)[
    Die Funktion $s(t)$ muss auf dem Intervall $[0, t_1]$ streng monoton wachsend sein ($=> accent("s", .)(t) >= 0$), sie darf sich also nicht verringern.
  ],
)

Der wohl einfachste Lösungsansatz wäre es, die Bewegung des Roboters linear zu beschreiben, also $s(t) = t / t_1$ auf dem Intervall $[0, t_1]$. Dies würde in der Anwendung jedoch problematisch sein, da die Geschwindigkeit des Roboters nicht konstant wäre. Der Roboter müsste also innerhalb von $Delta t = 0$ von $accent("s", dot)(t) = 0$ auf $accent("s", dot)(t) = 1$ beschleunigen, was nicht möglich ist.  

Gesucht ist also eine Funktion $s(t)$, welche die oben genannten Anforderungen erfüllt, sowie die Geschwindigkeit ($accent("s", dot)(t)$) und die Beschleunigung ($accent("s", dot.double)(t)$) des Roboters stetig hält.

Für die Funktion $s(t)$ bietet sich eine Polynomfunktion an, da diese stetig differenzierbar ist. Diese Polynomfunktion muss dann so angepasst werden, dass die oben genannten Anforderungen erfüllt werden.

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
Alternativ könnte auch eine andere Methode zur Vergrößerung von $Delta t$ verwendet werden, welche jedoch einen weniger effizienteren Gesamtablauf der Bewegung des Roboters zur Folge hätte. Diese Methode wird im Verlauf der Arbeit kurz dargestellt und mit einer Neuberechnung des Polynoms für ein neuen Wert $t_1$ verglichen.

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

Die nun erhaltene Funktion $s(t)$ muss nun auf dem Intervall $[0, 1]$ auf die Erfüllung der oben genannten Anforderungen (1. - 6.) geprüft werden:

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
    Die Funktion $s(t)$ ist auf dem Intervall $[0, 1]$ streng monoton wachsend.
    Hierzu wird überprüft, ob die Ableitung $accent("s", dot)(t)$ auf dem Intervall $[0, 1]$ streng positiv ist, also $accent("s", .)(t) >= 0$ für $0 < t < 0$.

    $
    accent("s", dot)(t) &= 30t^2 - 60t^3 + 30t^4
    &= 30t^2 (t-1)^2
    $

    #sym.checkmark $accent("s", .)(t) >= 0$ auf dem Intervall $[0, 1]$. Damit ist diese Bedingung erfüllt.
  ],

  enum.item(4)[
    Die Geschwindigkeit des Roboters ist am Zeitpunkt $t = 0$ und am Zeitpunkt $t = t_1 = 1$ gleich 0.
    
    Einsetzen von $t = 0$ und $t = 1$ in die Funktion $accent("s", dot)(t)$ ergibt:

    $
    accent("s", dot)(0) &= 30 dot 0^2 - 60 dot 0^3 + 30 dot 0^4 \
    &= 0
    $

    $
    accent("s", dot)(1) &= 30 dot 1^2 - 60 dot 1^3 + 30 dot 1^4 \
    &= 0
    $
  ],

  enum.item(5)[
    Die Beschleunigung des Roboters ist am Zeitpunkt $t = 0$ und am Zeitpunkt $t = t_1 = 1$ gleich 0.

    Einsetzen von $t = 0$ und $t = 1$ in die Funktion $accent("s", dot.double)(t)$ ergibt:

    $
    accent("s", dot.double)(0) &= 60 dot 0 - 180 dot 0^2 + 120 dot 0^3 \
    &= 0
    $

    $
    accent("s", dot.double)(1) &= 60 dot 1 - 180 dot 1^2 + 120 dot 1^3 \
    &= 0
    $
  ],

  enum.item(6)[
    Die maximalen Geschwindigkeiten und Beschleunigungen des Roboters dürfen nicht überschritten werden.
    Zur Überprüfung wird die Funktion $accent("s", dot)(t)$ und $accent("s", dot.double)(t)$ mithilfe der _PQ-Formel_ auf lokale Maxima (und Minima) untersucht.
    Dafür wird die Funktion $accent("s", dot)(t)$ und $accent("s", dot.double)(t)$ abgeleitet und gleich 0 gesetzt.

    Die _PQ-Formel_ lautet mit $f(x) = x^2 + p x + q$:  
    $
    x = - p/2 plus.minus sqrt((p/2)^2 - q)
    $

    #enum(
      enum.item(1)[
        Für die maximale Geschwindigkeit $accent("s", dot)(t)$ ergibt sich auf dem Intervall $(0, 1)$ (hier wird ein offenes Intervall verwendet, da die Geschwindigkeit am Anfang und am Ende der Bewegung des Roboters bereits bekannt $= 0$ ist):

        $
        accent("s", dot.double)(t) &= 60 t - 180 t^2 + 120 t^3 \
        &= 60 t (1 - 3 t + 2 t^2) \
        $

        #text("Ist gekürzt der richtige Ausdruck?", fill: red, style: "italic", size: 1.1em)

        Da im Intervall $t > 0$ ist, können die $60 t$ gekürzt werden und im Anschluss durch $2$ dividiert werden. Es ergibt sich:

        $
        accent("s", dot.double)(t) = 0 &= 1 - 3 t + 2 t^2 \
        &= t^2 - 3/2 t + 1/2 \
        $

        Durch Einsetzen in die _PQ-Formel_ ergibt sich:

        $
        t &= 3/4 plus.minus sqrt(9/16 - 1/2) \
        // &= 3/4 plus.minus 1/4 \
        &= 1/2, 1 \
        $

        Die hier relevante Maximalgeschwindigkeit liegt bei $t = 1/2$. Durch einsetzen in die Funktion $accent("s", dot)(t)$ ergibt sich:

        $
        accent("s", dot)(1/2) &= 30 dot (1/2)^2 dot (1/2 - 1)^2 \
        &= 15/8 = 1.875 \
        $ 

        Die maximale Geschwindigkeit des Roboters liegt in diesem Fall bei $1.875$, was mangels einer roboterspezifischen Angabe nicht auf Über- oder Unterschreitung eines Grenzwertes überprüft werden kann.

        #sym.checkmark Daher wird diese Bedingung als erfüllt angesehen.
      ],

      enum.item(2)[
        Zur Bestimmung der maximalen Beschleunigung $accent("s", dot.double)(t)$ wird analog zur Bestimmung der maximalen Geschwindigkeit vorgegangen. Es ergeben sich die folgenden Werte:

        $
        accent("s", dot.triple)(t) = 0 &= 60 - 360 t + 360 t^2 \
        &= t^2 - 2 t + 1/3 \
        $

        $
        t &= 1 plus.minus sqrt(1 - 1/3) \
        $

        $
        accent("s", dot.double)(1-sqrt(2/3)) &= 60 dot (1-sqrt(2/3)) - 180 dot (1-sqrt(2/3))^2 + 120 dot (1-sqrt(2/3))^3 \
        & approx 5.6905 \
        $

        Die maximale Beschleunigung des Roboters liegt in diesem Fall bei $5.6905$. Auch hier kann mangels einer roboterspezifischen Angabe nicht auf Über- oder Unterschreitung eines Grenzwertes überprüft werden. 

        #sym.checkmark Daher wird diese Bedingung als erfüllt angesehen.
      ],
    )

    #text("Abbildungen fehlen!", fill: red, style: "italic", size: 1.1em)

    Sollten die maximalen Geschwindigkeiten und Beschleunigungen des Roboters überschritten werden, besteht die Möglichkeit, die Funktion $s(t)$ durch das Verändern von $t$ so anzupassen, dass die Geschwindigkeiten und Beschleunigungen des Roboters nicht mehr überschritten werden. Ein einfacher Ansatz hierfür wäre die Bildung der folgenden Funktion:

    $
    s_"neu" (t) = s(t/t_1)
    $

    Diese Funktion wird im Folgenden kurz dargestellt und mit einer Neuberechnung des Polynoms für ein neuen Wert $t_1$ verglichen.

    Wie in #text("ABBILDUNG HIER EINFÜGEN", fill: red) sichtbar, ist die Funktion $s_"neu" (t)$ im graphischen Vergleich zu der Funktion $s_"neu"_"poly" (t)$ keine Punktspiegelung am Punkt $mat(1/2 t_1; 1/2)$ auf dem Intervall $[0, t_1]$, sondern vielmehr eine im letzten drittel _langgezogene_ Version der Funktion $s (t)$.
    Dies führt dazu, dass die Funktion $s_"neu" (t)$ zwar eine geringere Geschwindigkeit aufweist (durch die Kettenregel ergibt sich für die Geschwindigkeit $accent("s", dot)_"neu" (t) = 1/t_1 dot accent("s", dot) (t/t_1)$), diese Reduktion jedoch keine hohe Effizienz aufweist. Ähnliches gilt für die Beschleunigung $accent("s", dot.double)_"neu" (t)$.
  ],
)

== Berechnung der Gelenkwinkel

=== Bestimmung des Winkels $theta_3$

Durch die in der Trajektorienplanung erhaltenen Funktionen $X(s)$ und $s(t)$ können nun die Zielkoordinaten $"[X]"_"S"$ in Abhängigkeit von der Zeit $t$ mit $X(s(t))$ bestimmt werden. 
Ziel ist es nun, die Stiftspitze $P$ in den Punkt mit den Koordinaten $mat(x(t);y(t)) = (1-s(t)) dot mat(a_1; a_2) + s(t) dot mat(b_1; b_2)$ zu bewegen. Hierzu müssen die Gelenkwinkel $theta_1$, $theta_2$ und $theta_3$ bestimmt werden.

#text("Normdarstellung richtig verwendet??? + Abbildung fehlt", fill: red, style: "italic", size: 1.1em)

Mit der Ausnahme von Punkten, welche $norm(l_1 + l_2 + l_3)$ von dem Koordinatenursprung $O_S$ entfernt sind, gibt es unendlich viele Möglichkeiten, die Gelenkwinkel $theta_1$, $theta_2$ und $theta_3$ einzustellen um den Punkt $[P]_S$ zu erreichen, solange sich das Gelenk $R_3$ auf dem Kreis mit dem Radius $l_3$ um den Punkt $[X]_S$ befindet und so eingestellt ist, dass der Punkt $[P]_S$ auf dem Punkt $[X]_S$ liegt.
Dies ist für die Bestimmung der Gelenkwinkel problematisch, da es keine eindeutigen Lösungen für die Gelenkwinkel gibt.

Um diesem Problem aus dem Weg zu gehen, wird die Rotation der x-Achse des Toolsystems $T$, und damit die Rotation des Gelenkes $R_3$ im Bezug auf die x-Achse des Weltkoordinatensystem $S$ auf den gleichen Winkel des Richtungsvektors $accent("AB", ->)$ eingestellt.
Dies sorgt dafür, dass es nur noch eine Lösung für die Gelenkwinkel gibt.
Eine solche Herangehensweise kann potentiell auch zur Reduktion von mechanischem Stress auf die Greifvorrichtung führen, da der Stift so nicht rotiert, während er auf dem Papier aufliegt.

Der Winkel $theta$ zwischen der x-Ache von $T$ und der x-Achse von $S$ entspricht der Summe der Gelenkwinkel $theta_1$, $theta_2$ und $theta_3$ und soll im Verlauf der gesamten Bewegung des Roboterarmes konstant dem Winkel des Richtungsvektors $accent("AB", ->)$ entsprechen.

$
theta = theta_1 + theta_2 + theta_3 = "atan2"(b_2 - a_2, b_1 - a_1)
$

Um die übrigen Gelenkwinkel $theta_1$ und $theta_2$ zu bestimmen, wird zuerst der Punkt $[O:T]_S$ bestimmt. Da die Zielkoordinaten $[P]_S = mat(x(t); y(t))$ bekannt sind, kann der Punkt $[O:T]_S$ bestimmt werden, indem $l_3 + rho$ in Richtung der x-Achse von $T$ subtrahiert wird.
Die Richtung der x-Achse von $T$ lässt sich darstellen als:

$
frac(1,sqrt((b_1 - a_1)^2 + (b_2 - a_2)^))) dot mat(b_1 - a_1; b_2 - a_2)
$

Daraus folgt für den Punkt $[O_T]_S$:

$
[O_T]_S = mat(x(t); y(t)) - frac((l_3 + rho), sqrt((b_1 - a_1)^2 + (b_2 - a_2)^2)) dot mat(b_1 - a_1; b_2 - a_2)
$

Der Winkel $theta_3$ in Abhängigkeit von der Zeit $t$ lässt sich nun wie folgt beschreiben:

$
theta_3 (t) = "atan2"(b_2 - a_2, b_1 - a_1) - theta_1 (t) - theta_2 (t)
$

Die Winkel $theta_1$ und $theta_2$ lassen sich nun mit Hilfe der Lösung des indirekten kinematischen Problems bestimmen.

=== Bestimmung der Winkel $theta_1$ und $theta_2$ mit Hilfe des inversen kinematischen Problems

Um die Winkel $theta_1$ und $theta_2$ zu bestimmen, wird die Distanz zwischen den Punkten $"[O]"_"S"$ und $[O_T]_"S"$ benötigt. Hierzu wird ein Vektor $accent("v", ->)$ gebildet, welcher von $"[O]"_"S"$ in Richtung von $[O_T]_"S"$ zeigt.

$
accent("v", ->) = [O_T]_S - [O]_S = mat(x(t); y(t)) - frac((l_3 + rho), sqrt((b_1 - a_1)^2 + (b_2 - a_2)^2)) dot mat(b_1 - a_1; b_2 - a_2) - mat(0; 0)
$

Die Länge des Vektors $accent("v", ->)$ ist:

$
norm(accent("v", ->)) = d = sqrt((x(t) - frac((l_3 + rho), sqrt((b_1 - a_1)^2 + (b_2 - a_2)^2)) dot (b_1 - a_1))^2 + (y(t) - frac((l_3 + rho), sqrt((b_1 - a_1)^2 + (b_2 - a_2)^2)) dot (b_2 - a_2))^2)
$

Da die Längen der einzelnen Armglieder bekannt sind, kann die bereits aus der Lösung des inversen kinematischen Problems bekannte Formel zur Berechnung des Winkels $theta_2$ verwendet werden:  

$
theta_2 = plus.minus "arccos" frac(d^2 - l_1^2 - l_2^2, 2 l_1 l_2)
$

Schließlich kann der Winkel $theta_1$ bestimmt werden:

// ===== Abbildungen

#pagebreak()

= Abbildungen

#figure(
  image("./assets/3r_arm.png", width: 60%),
  caption: [
    Ein 3R-Roboterarm mit dem Weltsystem $S$ und dem Toolsystem $T$.
  ],
) <fig-3r_arm>

#figure(
  image("./assets/3r_arm_ts.png", width: 60%),
  caption: [
    Endeffektor des Roboters mit dem Stift (rot) und dem Stiftradius $rho$.
  ],
) <fig-3r_arm_ts>

// ===== Bibliographie
  
#pagebreak()

#bibliography("bibliography.yml")


