#import "template.typ": *

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Facharbeit",
  authors: (
    "Justus John Michael Seeck",
  ),
  date: "Datum",
)

// We generated the example code below so you can see how
// your document will look. Go ahead and replace it with
// your own content!

= Einführung
Mathematik ist cool, weil $pi dot "r"^2$ cool ist.
@harry ist töpfer.

== In this paper
#lorem(20)

=== Contributions
#lorem(40)

= Related Work
#lorem(500)


// Quellen

#pagebreak()

#bibliography("bibliography.yml")