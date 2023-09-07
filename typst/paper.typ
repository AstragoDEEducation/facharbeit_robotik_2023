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

== Trajektorienplanung

Um den Weg des roboterarmes zu planen, ist es hilfreich, diesen als Funktion darstellen zu können. Hierfür gibt es verschiedene Wege.

== Zeichnen einer Strecke, welche dem Koordinatenursprung $O_"U"$ zuläufig ist.

Um eine Strecke zu zeichen, welche dem Koordinatenursprung zuläufig ist,
kann als einfachste Methode ein 2R-Roboterarm, wie in @gerade_zentrum dargestellt, verwendet werden.

Als Eingabeparameter werden zwei Winkel angegeben. $alpha$ als Steuerungswinkel, welcher beim Durchlauf der Bewegung kontinuierlich erhöht wird, und $delta$, welcher den Rotationswinkel der entstehenden Gerade ausgehend von der X-Achse angibt.

Es gelten die folgenden 
$
0 <= alpha <= 180° \
0 <= delta <= 360°
$


#pagebreak()

= Abbildungen

#figure(
  image("./assets/gerade_zentrum.png", width: 70%),
  caption: [
    Ein 2R-Roboterarm mit gleichlangen Armen $l_"1"$ und $l_"2"$.
  ],
) <gerade_zentrum>


  
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