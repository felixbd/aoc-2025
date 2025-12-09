#import "@preview/cheq:0.2.2": checklist
#import "@preview/tablem:0.2.0": tablem, three-line-table
#import "@preview/shadowed:0.2.0": shadowed as shadowed-original
#import "@preview/theorion:0.3.3": cosmos, caution-box, warning-box, remark, important-box
#import cosmos.fancy: *

// #import "@preview/zebraw:0.5.5": zebraw
#import "@preview/zebraw:0.6.1": *
// #show: zebraw


#let shadowed(..args) = shadowed-original(
  radius: 4pt, inset: 12pt, fill: white, ..args
)

#set text(font:
  (
    // "Fira Sans",
    // "Atkinson Hyperlegible Next",
    // "Atkinson Hyperlegible",
    "Libertinus Serif"
  )
)

// #show math.equation: set text(font: "Fira Math")

#show raw: set text(font: "Fira Code") 

#set par(justify: true)

#show: checklist.with(
  marker-map: (
    " ": sym.ballot,
    "x": sym.ballot.cross,
    "-": sym.bar.h,
    "/": sym.slash.double
  )
)

#set page(
  "a4",
  // height: auto
)

#set text(lang: "en", region: "gb")

#let is-draft = false

#set par.line(numbering: if is-draft { "1" } else { none })

#set page(
  background: if not is-draft { none } else {
    rotate(24deg,
      text(
        45pt,
        fill: rgb(80%, 20%, 20%, 25%)
          .darken(25%)
          .transparentize(20%)
      )[
        // Unpublished working draft. \
        // Not for distribution.
        Typst $>>$ Python
      ]
    )
  }
)



= Advent of Code 2025 in Typst #emoji.face

#outline()

== day 1


=== Problem summary

Given a *sequence* of dial *rotations* on a *circular scale from 0 to 99*, 
*starting at* position *50*, determine *how often* the dial *reaches position 0* 
after applying each rotation in order.




#let signed-rotation = [
  Define the signed rotation
  $ s_i = cases(
    -k_i "if" d_i = L,
    #h(3mm) k_i "if" d_i = R,
  ) $
]

#let pos-update = [
  and the position update

  $ x_i equiv x_(i-1) + s_i med (mod med 100), quad i = 1, dots, n. $
]

#let number-of-indices = [
  The password is the number of indices $i$ for which the dial reaches zero
  $ P = |\{i in \{1, dots, n\}: x_i = 0 \}|. $
]


#align(center)[#shadowed(clip: true)[
#set align(left)

=== Mathematical formulation



- Let the dial positions be elements of the cyclic group $ZZ_(100)$.  
- Let the initial position be $x_0 = 50$.  
- Let the sequence of $n$ rotations be $(d_i, k_i)$ with $d_i in \{L, R\}$ and $k_i in  NN$.

#signed-rotation

#pos-update

#number-of-indices

]]

// #align(center)[#shadowed(clip: true)[ #set align(left)
#[
  #set text(lang: "de", region: "at")

  === Mathematische Formulierung

  Die Drehscheibe besitzt die Positionen des zyklischen Raums $ZZ_(100)$.  
  Der Anfangswert ist $x_0 = 50$.  

  Die Eingabe sei eine Folge von ganzen Zahlen $r_1, r_2, dots, r_n$,  
  wobei jede Zahl bereits ein Vorzeichen trägt.  
  Ein Eintrag ist negativ, falls die ursprüngliche Richtung L war,  
  und positiv, falls die ursprüngliche Richtung R war.

  Die Aktualisierung der Position erfolgt durch
  $
  x_i equiv x_(i-1) + r_i med (mod med 100)
  quad "für" i = 1, dots, n.
  $

  Das Passwort ergibt sich aus der Anzahl der Schritte, in denen die Position
  den Wert null annimmt:
  $
  P = |\{i in \{1, dots, n\}: x_i = 0 \}|.
  $

// ]]
]



=== Python3

#zebraw(
  // numbering-separator: true,
  comment-flag: $~~>$,
  // highlight-lines: range(41, 52) + range(85, 92),

   highlight-lines: (
    (31, signed-rotation),
    (34, pos-update),
    (35, number-of-indices),
    ..range(32, 39),
  ),


)[
```python
>>> from main import xs
>>> 
>>> xs
'\nL68\nL30\nR48\nL5\nR60\nL55\nL1\nL99\nR14\nL82\n'
>>> 
>>> xs.split()
['L68', 'L30', 'R48', 'L5', 'R60', 'L55', 'L1', 'L99', 'R14', 'L82']
>>> 
>>> xs.replace("L", "+")
'\n+68\n+30\nR48\n+5\nR60\n+55\n+1\n+99\nR14\n+82\n'
>>>
>>> xs.replace("L", "+").replace("R", "-")
'\n+68\n+30\n-48\n+5\n-60\n+55\n+1\n+99\n-14\n+82\n'
>>> 
>>> xs.replace("L", "+").replace("R", "-").split()
['+68', '+30', '-48', '+5', '-60', '+55', '+1', '+99', '-14', '+82']
>>> 
>>> [int(e) for e in xs.replace("L", "+").replace("R", "-").split()]
[68, 30, -48, 5, -60, 55, 1, 99, -14, 82]
>>> 
>>> list( map(int, xs.replace("L", "+").replace("R", "-").split())  )
[68, 30, -48, 5, -60, 55, 1, 99, -14, 82]
>>> 
>>> (50 + 68) % 100
18
>>> 
>>> (50 - 68) % 100
82
>>> 
>>> list( map(int, xs.replace("L", "-").replace("R", "+").split())  )
[-68, -30, 48, -5, 60, -55, -1, -99, 14, -82]
>>> 
>>> for r in map(int, xs.replace("L", "-").replace("R", "+").split()):
...     temp = (temp + r) % 100
...     if temp == 0: count += 1
...
>>> print(count)    
3
>>> 
>>> (lambda xs: (
...     lambda pos, c:
...         ([(pos := (pos + r) % 100,
...            c := c + (pos == 0))
...           for r in map(int, xs.replace("L", "-").replace("R", "+").split())],
...          c)[1]
... )(50, 0))(xs)
3
```
]


// #pagebreak(weak: true)

=== typst

#let count-zeros(xs) = {
  let steps = xs.replace("L", "-").replace("R", "+").split().map(int)
  let result = steps.fold((50, 0), (acc, r) => {
    let pos = calc.rem((acc.at(0) + r), 100)
    let cnt = acc.at(1) + int(pos == 0)
    (pos, cnt)
  })
  result.at(1)
}



#zebraw[
```typst
#let count-zeros(xs) = {
  let steps = xs.replace("L", "-").replace("R", "+").split().map(int)
  let result = steps.fold((50, 0), (acc, r) => {
    let pos = calc.rem((acc.at(0) + r), 100)
    let cnt = acc.at(1) + int(pos == 0)
    (pos, cnt)
  })
  result.at(1)
}
```]

#zebraw[
```typst
#count-zeros("L68 L30 R48 L5 R60 L55 L1 L99 R14 L82")
```]

#count-zeros("L68 L30 R48 L5 R60 L55 L1 L99 R14 L82")



#[
  // --- DOCS ---------------------------------------------

  #import "@preview/tidy:0.4.3"

  
  #let docs = tidy.parse-module(read("day1.typ"))
  // #tidy.show-module(docs)
  
  // #tidy.show-module(docs) //, style: tidy.styles.default)
  
  
  
  // #set page(width: auto, height: auto, margin: 0em)
  
  #import "day1.typ" 
  
  #let docs = tidy.parse-module(
    read("day1.typ"), 
    scope: (sincx: day1),
    preamble: "#import sincx: *;"
  )
  
  #set heading(numbering: none)
  #block(
    width: 12cm, 
    fill: luma(255), 
    inset: 20pt,
    tidy.show-module(docs, show-outline: false)
  )
  // --- END DOCS ---------------------------------------------
  
]
