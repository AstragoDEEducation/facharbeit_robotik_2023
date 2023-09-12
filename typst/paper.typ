// ========== Document settings ==========

// Template setup
#import "template.typ": *

#show: project.with(
  title: "Interpolation zwischen Punkten für das Zeichnen von Strecken in der Ebene mittels eines Roboterarmes" ,
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

== Ziel dieser Arbeit (WORK IN PROGRESS)

Das Ziel der Arbeit ist die mathematische Beschreibung der Interpolation zwischen zwei Punkten mittels eines 3R-Roboterarmes. Dazu wird zunächst die Kinematik des Roboters beschrieben und mittels Analogien zum Menschlichen Körper erläutert. Anschließend wird die Interpolation zwischen zwei Punkten mittels der Inversen Kinematik beschrieben. Im Anschluss werden Beispiele für die anwendung von geradliniger Interpolation in der Industrie gegeben.

= Allgemeines

Ziel der in dieser Arbeit beshriebenen Interpolation ist es, einen 3R-Roboterarm Zwischen zwei Punkten $A$ und $B$ geradlienig in Form einer Strecke zu bewegen. 

Um eine geradliniege Interpolation auszuführen, wird die Aufgabe in mehrere Teilaufgaben zerlegt die anschließend sequenziell ausgeführt werden.
Zuerst wird die Bewegung vom Startpunkt $A$ zum Zielpunkt $B$ geplant.
Diese Aufgabe nennt sich Trajektorienplanung.
Eine Referenztrajektorie oder Referenzpfad wird generiert @SeyrMartin2006Amrm, an dem sich der Roboter in den anschließenden Phasen orientiert.

In der Navigations- und Steuerungsphase muss der Roboter anschließend seine eigene Position mittels der Lösung des direkten kinematischen Problems finden und im anschluss so gesteuert werden, dass die Referenztrajektorie bestmöglich eingehalten wird.

Diese Arbeit geht jedoch nicht weiter auf Navigation und Ansteuerung ein. 

= Trajektorienplanung

== Gültigkeit von Koordinaten

Um einen Pfad für die Bewegung des Roboters zu planen, ist zuvor, insbesondere in praktischen Anwendungen, eine Überprüfung der Erreichbarkeit von Koordinaten nötig.
Durch den Aufbau eines Roboterarms kann es passieren, dass gewisse Punkte aufgrund der Armlängen für den Roboter nicht erreichbar sind.

=== Koordinatengültigkeitsprüfung für einen 2R-Arm

Für einen 2R-Arm mit den Armlängen $l_"1"$ und $l_"2"$ lassen sich kreisförmig ausgehend vom Koordinatenursprung $O_"U"$ grenzbereiche der Erreichbarkeit eines Punktes durch einen Roboter bestimmen.
Für die Länge $l-"erreichbar"$ gilt:
$
abs(l_"1" - l_"2") <= l_"erreichbar" <= l_"1" + l_"2"
$

= Zeichnen einer Strecke durch den Koordinatenursprung $O_"U"$ mit einem 2R-Arm

Um eine Strecke zu zeichen, welche dem Koordinatenursprung zuläufig ist,
kann als einfachste Methode, mit elementargeometrischen Mitteln, ein 2R-Roboterarm mit gleichlangen Armen ($l_"1" = l_"2"$), wie in @gerade_zentrum und @gerade_zentrum_2 dargestellt, verwendet werden.

// Als Eingabeparameter werden zwei Winkel angegeben. $alpha$ als Steuerungswinkel, welcher beim Durchlauf der Bewegung kontinuierlich erhöht wird, und $gamma$, welcher den Rotationswinkel der entstehenden Gerade ausgehend von der X-Achse angibt.

// Es gelten die folgenden Einschränkungen, um eine Strecke der größtmöglichen Länge ausgehend von einem beliebigen Ausgangswinkel $gamma$
// zu zeichnen:

// $
// 0 <= alpha <= 180° \
// 0 <= gamma <= 180°
// $

// Der Winkel $beta$ gibt den Winkel zwischen X-Achse und dem Oberarm des Roboters (hier: $mono("f")$) an. Der Winkel $delta$ gibt den Winkel zwischen dem Oberarm $mono("f")$ und dem Unterarm $mono("g")$ an.

// Für die Interpolation zum Zeischnen einer Strecke ergeben sich nun die folgenden Formeln:

// $
// beta (alpha) = alpha + gamma \
// delta (alpha) = 180° - 2 alpha
// $

Der Winkel $beta$ gibt den Winkel zwischen x-Achse und dem Oberarm des Roboters (hier: $mono("f")$) an. Der Winkel $delta$ gibt den Winkel zwischen dem Oberarm $mono("f")$ und dem Unterarm $mono("g")$ an.

Für den Winkel $delta$ bei bekanntem $beta$ gilt:

$
delta = 180° - 2 beta
$

Beziehungsweise für den Winkel $beta$ bei bekanntem $delta$ gilt:

$
90° - alpha = beta
$

// ===== Abbildungen

#pagebreak()

= Abbildungen

#figure(
  image("./assets/gerade_zentrum.png", width: 60%),
  caption: [
    Ein 2R-Roboterarm mit gleichlangen Armen $l_"1"$ und $l_"2"$.
  ],
) <gerade_zentrum>

#figure(
  image("./assets/gerade_zentrum_2.png", width: 60%),
  caption: [
    Ein 2R-Roboterarm mit gleichlangen Armen $l_"1"$ und $l_"2"$ sowie
    den Winkeln $beta$ und $gamma$.
  ],
) <gerade_zentrum_2>

// ===== Bibliographie
  
#pagebreak()
#bibliography("bibliography.bib")

// === Eigener Ansatz

// Um eine Bewegung des Robortearmes aufzuführen zu können, muss sich die gesamte Strecke zwischen $A$ und $B$ in einem vom Roboter erreichbaren Bereich befinden.

// Da der hier referenzierte Roboter eine feste Basis am Koordinatenursprung des Weltsystems $O_U$ hat, ergeben sich die folgenden Einschränkungen:

// $
// l_"Gesamt" <= l_"1" + l_"2" + l_"3"
// $

// $
// l_"Gesamt" >= abs(l_"1" - l_"2" - l_"3")
// $