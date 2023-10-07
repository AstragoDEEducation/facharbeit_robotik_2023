// ========== Document settings ==========

// Template setup
#import "template.typ": *

#show: project.with(
  title: "Lineare Interpolation zwischen zwei Punkten mittels eines 3R-Roboterarmes in der Ebene" ,
  authors: (
    "Justus John Michael Seeck",
  ),
  date: datetime.today().display(),
  // Schullogo ohne Kontext unerwünscht
  // logo: "./assets/pgwv_logo.svg",
)

// Underline links
#show link: underline

// Text Settings
#let default_text_size = 12pt

#set text(spacing: 150%)
#set text(size: default_text_size)

// ========== Content ==========

= Einführung

== Ziel dieser Arbeit 

Das Ziel dieser Arbeit ist die mathematische Beschreibung der linearen Interpolation zwischen zwei gegebenen Punkten $[A]_S$ und $[B]_S$ mit einem 3R-Roboterarmes (3R-Roboterarm = Roboterarm mit drei rotationsgelenken).
Diese Arbeit orientiert sich am Video "Robotik Teil 04 [4/5] [Schülerlabor Mathe-Lok der TU Braunschweig]" @src-kin_4_4, erstellt von Herrn Professor Doktor Harald Löwe und veröffentlicht am 2021-05-02.

Die Aufgabe der Interpolation wird in mehrere Teilbereiche aufgeteilt, welche im Folgenden erläutert werden. \
Zuerst wird die Gültigkeit von Koordinaten überprüft, indem bestimmt wird, ob die gesamte Strecke zwischen den Punkten $[A]_S$ mit den Koordinaten $[A]_S = mat(a_1; a_2)$ und $[B]_S$ mit den Koordinaten $[B]_S = mat(b_1; b_2)$ in einem vom Roboter erreichbaren Bereich liegt. \
Im Anschluss wird die Strecke mit Hilfe von Vektoren parametrisiert und ein Zeitverlauf für die Bewegung des Roboters bestimmt, sodass dieser die Strecke in einer vorgegebenen Zeit zurücklegt, ohne dabei die maximalen Geschwindigkeiten oder Beschleunigungen zu überschreiten. \
Zuletzt wird die Bewegung des Roboters in Gelenkwinkel umgerechnet, sodass der Roboter die Strecke zwischen den Punkten $[A]_S$ und $[B]_S$ abfahren kann.

= Aufbau des 3R-Roboterarmes

Der 3R-Roboterarm besteht aus drei Drehgelenken (eng.: revolute joints), welche jeweils über ein Armglied mit fester Länge miteinander verbunden sind.
Am Ende des dritten Armgliedes befindet sich ein Endeffektor @src-endeffektor (hier: ein Greifer), welcher die Aufgabe hat, einen Stift zu führen.
Der Ursprung des Weltsystems $S$ $[O]_S$ befindet sich am 1. Drehgelenk des Roboterarmes ($R_1$), der Ursprung des Toolsystems $T$ $[O]_T$ am 3. Gelenk ($R_3$).
@fig-3r_arm zeigt den Aufbau des Roboterarmes.
Die Länge der einzelnen Armglieder $l_1$, $l_2$ und $l_3$ ist bekannt.

Der Endeffektor greift einen Stift mit dem bekannten Radius $rho$, in dessen Zentrum sich die Spitze _P_ befindet (siehe: @fig-3r_arm_ts).

= Trajektorienplanung

In der Trajektorienplanung wird der Weg, welcher vom Roboterarm zurückgelegt wird, geplant @src-SeyrMartin2006Amrm.
Hierbei wird die Strecke zwischen den gegebenen Punkten $[A]_S$ und $[B]_S$ unter Zuhilfenahme von Vektoren parametrisiert, also in Abhängigkeit von einem Parameter $s$ dargestellt.
Die Verwendung von Vektoren anstelle von linearen Funktionen hat den Vorteil, dass auch vertikale Strecken gezeichnet werden können @src-kin_4_4. 

Zudem wird überprüft, ob die Strecke in einem vom Roboter erreichbaren Bereich liegt.

== Erreichbarkeit von Koordinaten

Um einen Pfad für die Bewegung des Roboters zu planen, ist zuvor eine Überprüfung der Erreichbarkeit der Koordinaten nötig.
Durch den Aufbau eines Roboterarms ist es möglich, dass gewisse Punkte aufgrund der Längen der einzelnen Armglieder für den Roboter nicht erreichbar sind, und somit das Zeichnen der Strecke nicht möglich ist.

Aus Gründen, welche im Verlauf der Arbeit erläutert werden, entspricht der Winkel des Toolsystems $T$ ($[theta_3]_S$) zur x-Achse des Weltsystems $S$ dem Winkel zwischen den Punkten $[A]_S$ und $[B]_S$.

Für die Laage der Stiftspitze $P$ im Bezug auf das Toolsystem $T$ gilt (vergleiche:
@fig-3r_arm_ts):

$
[P]_t = mat(l_3 + rho; 0)
$

Für den Winkel $theta$ zwischen den Punkten $"[A]"_"S"$ und $"[B]"_"S"$ gilt:
$
theta = "atan2"(b_2 - a_2, b_1 - a_1)
$

Die Erreichbarkeitsbegrenzung des Roboterarms ist konzentrisch kreisförmig um den Ursprung des Weltsystems, verschoben um einen Vektor $accent(v, ->)$.

Um den Vektor $accent(v, ->)$ zu erhalten, wird $[P]_t$ mit der bereits aus dem direkten kinematischen Problem bekannten Rotationsmatrix $"Rot"_theta = mat("cos"(theta), - "sin"(theta); "sin"(theta), "cos"(theta))$ multipliziert.

$
accent(v, ->) = vec(v_1, v_2) &= [P]_t dot "Rot"_theta \
&= mat(l_3 + rho; 0) dot mat("cos"(theta), - "sin"(theta); "sin"(theta), "cos"(theta)) \
&= mat(l_3 + rho) dot mat("cos"(theta); "sin"(theta)) \
$

Der Mittelpunkt der Kreise $[M]_S$, welche die Erreichbarkeit des Roboters begrenzen, liegt dann bei $[M]_S = [O]_S + accent(v, ->)$.

Nun müssen die Radien der beiden Kreise bestimmt werden, welche die Erreichbarkeit des Roboters begrenzen.

Für den Maximalradius $r_"max"$ gilt:
$
r_"max" = l_1 + l_2
$

Für den Minimalradius $r_"min"$ gilt:
$
r_"min" = abs(l_1 - l_2)
$

$==>$ Ein Punkt ist dann erreichbar, wenn er innerhalb eines Kreises mit dem Radius $r_"max"$ und dem Mittelpunkt $[M]_S$ und außerhalb des Kreises mit dem Radius $r_"min"$ und dem Mittelpunkt $[M]_S$ liegt. \
@fig-erreichbarkeit zeigt die Erreichbarkeitsbereiche des Roboters.

Die Überprüfung, ob die Punkte $[A]_S$ und $[B]_S$ mit der zugehörigen Strecke $accent("AB", -)$ innerhalb des für den Roboter zu erreichenden Bereiches liegen, kann beispielhaft wie folgt durchgeführt werden:

#enum(
  enum.item(1)[
    Prüfen, ob der Startpunkt $[A]_S$ und der Endpunkt $[B]_S$ innerhalb des erreichbaren Bereiches liegen.
    Hierzu kann die Distanz $d$ zwischen dem Mittelpunkt $[M]_S$ und den Punkten $[A]_S$ und $[B]_S$ berechnet werden.
    Liegt mindestens einer der Punkte außerhalb des erreichbaren Bereiches, ist die Strecke nicht zeichenbar beziehungsweise nicht vollständig vom Roboter erreichbar.

    Zur Berechnung der Distanz $d$ kann der Satz des Pythagoras verwendet werden:

    $
    [M]_s &= mat(m_1; m_2) \
    [A]_s &= mat(a_1; a_2) \
    [B]_s &= mat(b_1; b_2) \
    $

    $
    d_([M]_s, [A]_S) = sqrt((m_1 - a_1)^2 + (m_2 - a_2)^2) \
    d_([M]_s, [B]_S) = sqrt((m_1 - b_1)^2 + (m_2 - b_2)^2) \
    $

    Sind die Bedingungen $r_min < d_([M]_s, [A]_S) < r_max$ beziehungsweise $r_min < d_([M]_s, [B]_S) < r_max$ erfüllt, kann mit der nächsten Überprüfung fortgefahren werden.
    Sind die Bedingungen nicht erfüllt, ist die Strecke nicht zeichenbar.
    Das Programm, welches den Roboter steuert, kann dann vorzeitig beendet werden und eine Fehlermeldung ausgeben.
  ],

  enum.item(2)[
    Prüfen, ob die Strecke zwischen den Punkten $[A]_S$ und $[B]_S$ den erreichbaren Bereich schneidet.
    Hierzu kann die Strecke zwischen den Punkten $[A]_S$ und $[B]_S$ parametrisiert und mittels eines Vektors dargestellt werden (siehe unten), und mit der Kreisgleichung jeweils ein weiterer Vektor erstellt werden, welcher der Kreisgleichung folgt.
    Schneidet sich der Vektor der Strecke mit mindestens einem Vektor welcher einem Kreisbogen folgt, so schneidet die Strecke mindestens einen der Kreise und ist somit nicht zeichenbar beziehungsweise nicht vollständig vom Roboter erreichbar. Auch hier kann das Programm, welches den Roboter steuert, vorzeitig beendet werden und eine Fehlermeldung ausgeben.

    Eine genaue mathematische Beschreibung dieser Überprüfung erfolgt in dieser Arbeit nicht.
  ],
)

// == Bestimmung des Punktes $"[P]"_"S"$ (Wird das benötigt?)

// // Da die Längen der einzelnen Armglieder bekannt sind und auch die Position der Stiftspitze _P_ im Bezug auf das Toolsystem _T_ bekannt ist, kann die Strecke zwischen den Punkten $"[A]"_"S"$ und $"[B]"_"S"$ parametrisiert werden.

// Durch Anwendung des direkten kinematischen Problems kann der Punkt $"[P]"_"S"$ bestimmt werden.

// $
// "[P]"_"S" &= "Rot"(theta_1 + theta_2 + theta_3) dot vec("l"_"3" + rho, 0) + "Rot"(theta_1 + theta_2) dot vec("l"_"2", 0) + "Rot"(theta_1) dot vec("l"_"1", 0) \
// &= vec((l_3 + rho) dot "cos"(theta_1 + theta_2 + theta_3) + l_2 "cos"(theta_1 + theta_2) + l_1 "cos"(theta_1), (l_3 + rho) dot "sin"(theta_1 + theta_2 + theta_3) + l_2 "sin"(theta_1 + theta_2) + l_1 "sin"(theta_1)) 
// $

== Parametrisierung der Strecke @src-kin_4_4

Um die Gelenkwinkel des Roboters in Abhängigkeit von der Zeit zu bestimmen, wird die Strecke zwischen den Punkten $"[A]"_"S"$ und $"[B]"_"S"$ parametrisiert, also in einen Vektor umgewandelt, welcher einem Parameter $s$ abhängt.
Ziel ist es, eine Funktion zu finden, welche alle Punkte auf der Strecke zwischen den Punkten $[A]_S = mat(a_1; b_1)$ und $[B]_S = mat(b_1; b_2)$ beschreibt.

Auf der Strecke zwischen den Punkten befindet sich der Punkt $X$, welcher mit dem Vektor $accent("x", ->)$ ausgehend vom Punkt $"[A]"_"S"$ in Richtung von Punkt $"[B]"_"S"$ verschoben werden kann.

#set align(center)

$X &= A + accent("AX", ->) = A + accent("x", ->)$ #h(4em) mit $accent("x", ->) = accent("AX", ->)$

#set align(start)

$accent("AX", ->)$ und $accent("AB", ->)$ sind parallel zueinander. Somit gilt:

#set align(center)

$accent("AX", ->) || accent("AB", ->) => accent("AX", ->) = s dot accent("AB", ->)$ #h(4em) mit $0 <= s <= 1$

#set align(start)

Die Funktion $X(s) = A + s dot accent("AB", ->)$ beschreibt dann alle Punkte auf der Strecke $accent("AB", -)$ im Bezug auf den Parameter $s$. 

Diese Funktion lässt sich ebenfalls in Koordinaten darstellen.

Mit
$
[accent("AB", ->)]_S = [B]_S - [A]_S = b - a
$

lässt sich die Funktion $X(s)$ wie folgt darstellen:

$
X(s) = [X(s)]_S &= [A]_S + s dot [accent("AB", ->)]_S \
&= a + s dot (b - a) \
&= (1 - s) dot a + s dot b
$

@fig-para zeigt die Parametrisierung anhand eines Beispiels.

Auch andere Interpolationen zwischen Punkten, zum Beispiel Bezierkurven, können parametrisiert werden, sodass der Roboterarm diese abfahren kann.

== Beschreibung der Bewegung des Roboters @src-kin_4_4

#text("ABBILDUNGEN FEHLEN", fill: red, style: "italic", size: 1.1em)

Der Roboterarm soll sich zum Zeitpunkt $t$ mit der Spitze des Stiftes am Punkt $X(s)$ der Strecke $accent("AB", -)$ befinden.
Die Bewegung des Roboters soll am Zeitpunkt $t = 0$ beginnen; der Roboter befindet sich zu diesem Zeitpunkt am Punkt $[A]_S$, und am Zeitpunkt $t = t_1$ beendet sein; der Roboter befindet sich zu diesem Zeitpunkt am Punkt $[B]_S$.
Gesucht ist also eine Funktion $s(t)$, welche den Fortschritt der Bewegung des Roboters in Abhängigkeit von der Zeit $t$ beschreibt.

Für die Funktion $s(t)$ gibt es einige Anforderungen, welche erfüllt werden müssen:
#enum(
  enum.item(1)[
    Zum Zeitpunkt $t = 0$ muss sich der Roboterarm in seiner Ausgangsposition, also am Punkt $[A]_S$ befinden.

    // #set align(center)
    // $s(t) = 0$ #h(4em) für $t = 0$
    // #set align(start)
    
    $
    s(t) = 0 "für" t = 0
    $

  ],

  enum.item(2)[
    Zum Zeitpunkt $t = t_1$ muss sich der Roboterarm in seiner Endposition, also am Punkt $[B]_"S"$ befinden.
    
    // #set align(center)
    // $s(t) = 1$ #h(4em) für $t = t_1$
    // #set align(start)

    $
    s(t) = 1 "für" t = t_1
    $

  ],

  enum.item(3)[
    Die Funktion $s(t)$ muss auf dem Intervall $[0, t_1]$ streng monoton wachsend sein ($=> accent("s", .)(t) >= 0$), sie darf sich also nicht verringern.
  ],
)

Der wohl einfachste Lösungsansatz wäre es, die Bewegung des Roboters linear zu beschreiben, also $s(t) = t / t_1$ auf dem Intervall $[0, t_1]$.
Dies wäre in der Anwendung jedoch problematisch, da die Geschwindigkeit des Roboters nicht konstant wäre. Der Roboter müsste also innerhalb von $Delta t = 0$ von $accent("s", dot)(t) = 0$ auf $accent("s", dot)(t) = 1$ beschleunigen, was nicht möglich ist.

Gesucht ist also eine Funktion $s(t)$, welche die oben genannten Anforderungen erfüllt, sowie die Geschwindigkeit ($accent("s", dot)(t)$) und die Beschleunigung ($accent("s", dot.double)(t)$) des Roboters stetig hält.

Für die Funktion $s(t)$ bietet sich eine Polynomfunktion an, da diese stetig differenzierbar ist. Diese Polynomfunktion muss dann so angepasst werden, dass die oben genannten Anforderungen erfüllt werden.

Die Anforderungen an die Polynomfunktion $s(t)$ lauten zudem fortlaufend:

#enum(
  enum.item(4)[
    Die Geschwindigkeit des Roboters ist am Zeitpunkt $t = 0$ und am Zeitpunkt $t = t_1$ gleich $0$.

    $
    accent("s", dot)(0) = accent("s", dot)(t_1) = 0
    $
  ],

  enum.item(5)[
    Die Beschleunigung des Roboters ist am Zeitpunkt $t = 0$ und am Zeitpunkt $t = t_1$ gleich $0$.

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

Um das Polynom $s(t) = c_0 + c_1 dot t + c_2 dot t^2 + c_3 dot t^3 + ... + c_n dot t^n$ auf $[0, t_1]$ mit konkreter Lösung zu binden, wird $t_1 = 1$ gesetzt.
Sollten Geschwindigkeiten oder Beschleunigungen des Roboters überschritten werden, wird $t_1$ erhöht, bis die Geschwindigkeiten und Beschleunigungen des Roboters nicht mehr überschritten werden.
Eine Methode um $Delta t$ mittels der Verschiebung von $t_1$ zu erhöhen wird im Verlauf der Arbeit erläutert.

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

Für die Erfüllung der Anforderungen am Zeitpunkt $t = t_1$ werden $n = 5$ Koeffizienten benötigt. Da $c_0 = c_1 = c_2 = 0$ sind fallen diese nun weg. Es ergibt sich:

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

    Diese Bedingung ist erfüllt.
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

    Diese Bedingung ist erfüllt.
  ],

  enum.item(3)[
    Die Funktion $s(t)$ ist auf dem Intervall $[0, 1]$ streng monoton wachsend.
    Hierzu wird überprüft, ob die Ableitung $accent("s", dot)(t)$ auf dem Intervall $[0, 1]$ streng positiv ist, also $accent("s", .)(t) >= 0$ für $0 < t < 0$.

    $
    accent("s", dot)(t) &= 30t^2 - 60t^3 + 30t^4
    &= 30t^2 (t-1)^2
    $

    $accent("s", .)(t) >= 0$ auf dem Intervall $[0, 1]$. Damit ist diese Bedingung erfüllt.
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

        Daher wird diese Bedingung als erfüllt angesehen.
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

        Daher wird diese Bedingung als erfüllt angesehen.
      ],
    )

    @fig-st_vt_at zeigt die Funktionen $s(t)$, $accent("s", dot)(t)$ und $accent("s", dot.double)(t)$ mit $t_1 = 1$.

    Sollten die maximalen Geschwindigkeiten und Beschleunigungen des Roboters überschritten werden, besteht die Möglichkeit, die Funktion $s(t)$ durch das Erhöhen von $t_1$ so anzupassen, dass die Geschwindigkeiten und Beschleunigungen des Roboters nicht mehr überschritten werden.
    Ein einfacher Ansatz hierfür wäre die Streckung oder Stauchung der Funktion $s(t)$ auf der x-Achse:

    $
    s_"neu" (t) = s(t/t_1)
    $

    Mit einem neuen Wert für $t_1$.

    Dieser Ansatz erspart zudem die Neuberechnung der Funktion $s(t)$, sowie der Ableitungen $accent("s", dot)(t)$ und $accent("s", dot.double)(t)$ und deren anschließende Überprüfung auf die Erfüllung der Anforderungen.

    @fig-st_st_gstr zeigt den zeitlichen Verlauf der Interpolation für $t_1 = 1$ (grüner Funktionsgraph) im Vergleich zur gestreckten Funktion mit $t_1 = 2$ (blauer Funktionsgraph).
  ],
)

== Berechnung der Gelenkwinkel

=== Bestimmung des Winkels $theta_3$ @src-kin_4_4

Durch die in der Trajektorienplanung erhaltenen Funktionen $X(s)$ und $s(t)$ können nun die Zielkoordinaten $"[X]"_"S"$ in Abhängigkeit von der Zeit $t$ mit $X(s(t))$ bestimmt werden. 
Ziel ist es nun, die Stiftspitze $P$ in den Punkt mit den Koordinaten $mat(x(t);y(t)) = (1-s(t)) dot mat(a_1; a_2) + s(t) dot mat(b_1; b_2)$ zu bewegen.
Hierzu müssen die Gelenkwinkel $theta_1$, $theta_2$ und $theta_3$ bestimmt werden.

#text("Abbildung fehlt. Wird sie benötigt?", fill: red, style: "italic", size: 1.1em)

Mit der Ausnahme von Punkten, welche $l_1 + l_2 + l_3$ von dem Koordinatenursprung $[O]_S$ entfernt sind, gibt es unendlich viele Möglichkeiten, die Gelenkwinkel $theta_1$, $theta_2$ und $theta_3$ einzustellen um den Punkt $[P]_S$ zu erreichen, solange sich das Gelenk $R_3$ auf dem Kreis mit dem Radius $l_3$ um den Punkt $[X]_S$ befindet und so eingestellt ist, dass der Punkt $[P]_S$ auf dem Punkt $[X]_S$ liegt.
Dies ist für die Bestimmung der Gelenkwinkel problematisch, da es keine eindeutigen Lösungen für die Gelenkwinkel gibt.

Um dieses Problem zu vermeiden, wird die Rotation der x-Achse des Toolsystems $T$, und damit die Rotation des Gelenkes $R_3$ im Bezug auf die x-Achse des Weltkoordinatensystem $S$ auf den Winkel des Richtungsvektors $accent("AB", ->)$ eingestellt.
Dies sorgt dafür, dass es nur noch eine Lösung für die Gelenkwinkel gibt.
Eine solche Herangehensweise kann potentiell auch zur Reduktion von mechanischem Stress auf die Greifvorrichtung führen, da der Stift so nicht um sein Zentrum $[P]_T$ rotiert, während er auf dem Papier aufliegt.

Der Winkel $theta$ zwischen der x-Ache von $T$ und der x-Achse von $S$ entspricht der Summe der Gelenkwinkel $theta_1$, $theta_2$ und $theta_3$ und soll im Verlauf der gesamten Bewegung des Roboterarmes konstant dem Winkel des Richtungsvektors $accent("AB", ->)$ entsprechen.

$
theta = theta_1 + theta_2 + theta_3 = "atan2"(b_2 - a_2, b_1 - a_1)
$

Um die übrigen Gelenkwinkel $theta_1$ und $theta_2$ zu bestimmen, wird zuerst der Punkt $[O_T]_S$ bestimmt. Da die Zielkoordinaten $[P]_S = mat(x(t); y(t))$ bekannt sind, kann der Punkt $[O_T]_S$ bestimmt werden, indem $l_3 + rho$ in Richtung der x-Achse von $T$ subtrahiert wird.
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

=== Bestimmung der Winkel $theta_1 (t)$ und $theta_2 (t)$ @src-kin_4_2 @src-kin_4_3

Um die Winkel $theta_1 (t)$ und $theta_2 (t)$ mit Hilfe des inversen kinematischen Problems zu bestimmen, muss die Distanz zwischen den Punkten $"[O]"_"S"$ und $[O_T]_"S"$ bestimmt werden. Hierzu wird ein Vektor $accent("v", ->)$ gebildet, welcher von $"[O]"_"S"$ auf $[O_T]_"S"$ zeigt.

$
accent("v", ->) (t) = mat(v_1(t); v_2(t)) = [O_T]_S - [O]_S = mat(x(t); y(t)) - frac((l_3 + rho), sqrt((b_1 - a_1)^2 + (b_2 - a_2)^2)) dot mat(b_1 - a_1; b_2 - a_2) - mat(0; 0)
$

Die Länge des Vektors $accent("v", ->)$ ist:

#text(
  $
  norm(accent("v", ->) (t)) = d (t) = sqrt((x(t) - frac((l_3 + rho), sqrt((b_1 - a_1)^2 + (b_2 - a_2)^2)) dot (b_1 - a_1))^2 + (y(t) - frac((l_3 + rho), sqrt((b_1 - a_1)^2 + (b_2 - a_2)^2)) dot (b_2 - a_2))^2)
  $,
  size: 9pt
)

Da die Längen der einzelnen Armglieder bekannt sind, kann die bereits aus der Lösung des inversen kinematischen Problems bekannte Formel zur Berechnung des Winkels $theta_2$ verwendet werden:  

$
theta_2 (t) = plus.minus "arccos" frac(d(t)^2 - l_1^2 - l_2^2, 2 l_1 l_2)
$

Mit der Bestimmung des Winkels $theta_2 (t)$ ist der Abstand zwischen dem ersten Drehgelenk $R_1$ und dem zweiten Drehgelenk $R_2$ korrekt eingestellt.

Schließlich kann der Winkel $theta_1 (t)$ bestimmt werden.

Der Vektor $accent("v", ->) (t)$ kann ebenfalls wie folgt dargestellt werden:

$
accent("v", ->) (t) &= "Rot"(theta_1 (t)) dot mat(l_1; 0) + "Rot"(theta_1 (t)) dot "Rot"(theta_2 (t)) dot mat(l_2; 0) \
&= "Rot"(theta_1 (t)) dot (mat(l_1; 0) + "Rot"(theta_2 (t)) dot mat(l_2; 0))
$

$"Rot"(theta_1 (t)) dot (mat(l_1; 0) + "Rot"(theta_2 (t)) dot mat(l_2; 0))$ wird im Folgenden als $accent("w", ->)$ bezeichnet. Es ergibt sich:

$
accent("v", ->) (t) &= "Rot"(theta_1 (t)) dot accent("w", ->)
$

Da $accent("v", ->) (t)$ und $accent("w", ->) (t)$ die selbe Länge haben, kann man im folgenden versuchen, den Vektor $accent("w", ->) (t)$ auf den Vektor $accent("v", ->) (t)$ zu drehen. Dies ist jedoch nur möglich, wenn die Länge des Vektors $norm(accent("v", ->))(t) = norm(accent("w", ->)) (t) eq.not 0$.
Ist $norm(accent("v", ->)) (t) = norm(accent("w", ->)) (t) = 0$ würde dies bedeuten, dass sich der Punkt $"[O]"_"S"$ und der Punkt $[O_T]_"S"$ an der selben Stelle befinden. Dies würde dazu führen, dass jeder Winkel $theta_1 (t)$ eine richtige Lösung wäre.
In diesem Fall kann ein beliebiger Winkel $theta_1 (t)$ gewählt werden.

Ist also $norm(accent("v", ->)) (t) = norm(accent("w", ->)) (t) eq.not 0$ kann der Winkel $theta_1 (t)$ mit dem intelligenten Arkustangens bestimmt werden:

$
theta_1 (t) &= "atan2"(v_2(t), v_1(t)) - "atan2"(w_2(t), w_1(t)) \
&= "atan2"(v_2(t), v_1(t)) - "atan2"(l_2 "sin"(theta_2 (t)), l_1 + l_2 "cos"(theta_2 (t)))
$

Nun sind alle Winkel $theta_1$, $theta_2$ und $theta_3$ in Abhängigkeit von der Zeit $t$ bekannt. Ein Roboterarm kann nun die Strecke $accent("AB", -)$ abfahren.
Hierfür wird zuerst der Winkel $theta_2 (t)$ bestimmt, im Anschluss der Winkel $theta_1 (t)$ und zuletzt der Winkel $theta_3 (t)$.
Diese Winkelbestimmung erfolgt für jeden Zeitpunkt $t$.

= Nachwort & Fazit

Die Beschreibung der (linearen) Interpolation mit Hilfe von Vektoren ist praxisnah, und nicht sonderlich komplex.
Ist jedoch die Anwendung der Interpolation in der Praxis erforderlich (z.B. bei der Programmierung eines Roboters), so sind weitere Faktoren, wie die Geschwindigkeit und Beschleunigung des Roboters zu beachten. Diese Faktoren erhöhen den Komplexitätsgrad der Interpolation erheblich, und erfordern eine genaue Planung der Bewegung des Roboters über die Zeit.

Da auch andere Interpolationsmethoden, wie z.B. die Bezierkurve oder Splines (Bezierkurven liegt die Lineare interpolation zu Grunde $->$ Zwischen mehreren gegebenen Punkten wird über die Zeit linear interpoliert. Es entstehen Zwischenpunkte, zwischen denen ebenfalls so lange linear interpoliert wird, bis nur noch ein Punkt übrig ist. Dieser Punkt beschreibt dann beispielsweise den Zielpunkt des Roboterarmes zu einer Zeit $t$ @src-bezier), parametrisiert und mit Vektoren beschrieben werden können, ist es auch möglich, komplexere Bewegungen des Roboters zu beschreiben. 
Auch in diesem Fall ist die Beschreibung des Bewegungsfortgangs des Roboters über die Zeit jedoch komplexer. So muss zum Beispiel beachtet werden, wie scharf die Kurve ist, und wie schnell der Roboter gewisse Kurvenabschnitte abfahren kann.

Im Alltag findet die Interpolation zwischen Punkten mit Roboterarmen sehr oft Anwendung.
Beispielsweise in der Filmproduktion, um eine Kamera auf einem immer gleichen Pfad zu bewegen oder in der Produktion von Fahrzeugen oder anderer Produkte, um einen Roboterarm auf einem vorbestimmten Pfad zu bewegen und Kollisionen mit anderen Roboterarmen, Objekten oder Lebewesen zu vermeiden.

Es ist jedoch zu beachten, dass die (lineare) Interpolation nicht immer die beste Lösung ist, um einen Roboterarm zu bewegen.
Wenn der Endeffektor keinem vorbestimmten Pfad folgen muss, können alle Gelenkwinkel des Roboters sofort auf den gewünschten Zielwert eingestellt werden.
Dadurch braucht die Bewegung nur noch die Zeit, welche das langsamste Gelenk benötigt, um sich auf den Zielwert einzustellen. 
Die Bewegung des Endeffektors ist dadurch jedoch nicht mehr geradlinig und unter Umständen schwer vorhersehbar.

// ===== Anhang

#pagebreak()

= Anhang

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


#figure(
  image("./assets/erreichbarkeit.png", width: 100%),
  caption: [
    Ein 3R-Roboterarm und die Strecke $accent("AB", -)$.
    Eingezeichnet ist der Punkt $[M]_S$ welcher um den Vektor $accent("v", ->)$ ausgehend vom Punkt $[O]_S$ verschoben wurde.
    Der orangefarbene Kreis stellt $r_max$ dar. 
    Der blaue Kreis stellt $r_min$ dar.
    Beide Kreise haben den selben Mittelpunkt $[M]_S$.
  ],
) <fig-erreichbarkeit>

#figure(
  image("./assets/para.png", width: 70%),
  caption: [
    Die Strecke $accent("AB", -)$ mit dem Punkt $[X]_S$.
    Der Punkt $[X]_S$ befindet sich an der Stelle $X(1/4)$
  ],
) <fig-para>

#figure(
  image("./assets/st_lin.png", width: 70%),
  caption: [
    Der blaue Graph stellt die Funktion $s(t) = t/t_1$ mit $t_1 = 1$ dar. Der rote Graph stellt die Funktion $accent("s", dot)(t)$ dar.
    Der rote Graph ist nicht stetig.
    Eine Ansteuerung des Roboters mit dieser Funktion ist nicht möglich.
  ],
) <fig-st_lin>

#figure(
  image("./assets/st_vt_at_diagramm.png", width: 50%),
  caption: [
    Der grüne Graph stellt die Funktion $s(t) = 10t^3 - 15t^4 + 6t^5$ mit $t_1 = 1$ dar.
    Der rote Graph stellt die Funktion $accent("s", dot)(t)$ dar.
    Der blaue Graph stellt die Funktion $accent("s", dot.double)(t)$ dar.
    Der orangefarbene Graph stellt die Funktion $accent("s", dot.triple)(t)$ dar.
  ],
) <fig-st_vt_at>

#figure(
  image("./assets/st_st_gstr_diagramm.png", width: 75%),
  caption: [
    Der grüne Graph stellt die Funktion $s(t) = 10t^3 - 15t^4 + 6t^5$ mit $t_1 = 1$ dar.
    Der blaue Graph stellt die Funktion $s(t)_"neu" = s(t/t_1)$ mit $t_1 = 2$ dar.
  ],
) <fig-st_st_gstr>

// ===== Bibliographie 
  
#pagebreak()

#bibliography("bibliography.yml")
