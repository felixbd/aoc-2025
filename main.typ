#import "@preview/cheq:0.2.2": checklist
#show: checklist.with(
  marker-map: (
    " ": sym.ballot,
    "x": sym.ballot.cross,
    "-": sym.bar.h,
    "/": sym.slash.double
  )
)

#import "@preview/tablem:0.2.0": tablem, three-line-table

#import "@preview/shadowed:0.2.0": shadowed as shadowed-original
#let shadowed(..args) = shadowed-original(
  radius: 4pt, inset: 12pt, fill: white, ..args
)

#import "@preview/theorion:0.3.3": cosmos, caution-box, warning-box, remark, important-box
#import cosmos.fancy: *

// #import "@preview/zebraw:0.5.5": zebraw
#import "@preview/zebraw:0.6.1": *
// #show: zebraw

#import "@preview/physica:0.9.7": super-T-as-transpose
#show: super-T-as-transpose // Render "..^T" as transposed matrix


#show raw: set text(font: "Fira Code") 
#set par(justify: true)
#set page("a4")
#set text(lang: "en", region: "gb")


#title([Advent of Code 2025 #emoji.face])

#outline()

= day 1


== Problem summary

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

== Mathematical formulation



- Let the dial positions be elements of the cyclic group $ZZ_(100)$.  
- Let the initial position be $x_0 = 50$.  
- Let the sequence of $n$ rotations be $(d_i, k_i)$ with $d_i in \{L, R\}$ and $k_i in  NN$.

#signed-rotation

#pos-update

#number-of-indices

]]


== Python3

#zebraw(
  // numbering-separator: true,
  comment-flag: $arrow.curve$,
  // highlight-lines: range(41, 52) + range(85, 92),

   highlight-lines: (
    (6, signed-rotation),
    (9, pos-update),
    (10, number-of-indices),
    // ..range(32, 39),
  ),


)[
```python
>>> xs = '\nL68\nL30\nR48\nL5\nR60\nL55\nL1\nL99\nR14\nL82\n'
>>>
>>> temp, count = 50, 0
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

== typst

#let day1(xs) = {
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
#let day1(xs) = {
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
#day1("L68 L30 R48 L5 R60 L55 L1 L99 R14 L82")
```]


#let xs = "L68 L30 R48 L5 R60 L55 L1 L99 R14 L82"

#day1(xs)


#rect[
  == Docs

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
    // width: 12cm, 
    // fill: green.lighten(95%), 
    inset: 15pt,
    tidy.show-module(docs, show-outline: false)
  )  
]

== Part Two


#zebraw[
```py
>>> for r in map(int, xs.replace("L", "-").replace("R", "+").split()):
...     temp = (temp + r) % 100
...     if temp == 0: count += 1
```]

$ arrow.b.bar $


#zebraw[
```py
>>> temp, count = 50, 0
>>> 
>>> for r in map(int, xs.replace("L", "-").replace("R", "+").split()):
...     if r >= 0:
...         for _ in range(r):
...             temp = (temp + 1) % 100
...             if temp == 0: count += 1
...     else:
...         for _ in range(r * (-1)):
...             temp = (temp - 1) % 100
...             if temp == 0: count += 1
...            
>>> print(temp, count)
28 6
```]

$ arrow.b.double  $

#zebraw[
```py
for r in map(int, xs.replace("L", "-").replace("R", "+").split()):
    for _ in range(abs(r)):
        temp = (temp + (1 if r > 0 else -1)) % 100
        count += temp == 0
```
]


#pagebreak(weak: true)

= Day 2: Gift Shop

#zebraw[```py
from day2 import xs

# [range(*list(map(int, e.split("-")))) for e in xs.split(",")]

ds = [range(*(lambda ys: [ys[0], ys[1] + 1])(list(map(int, e.split("-"))))) for e in xs.split(",")]


def p(x: int) -> int:
  x = str(x)
  
  if len(x) % 2 != 0:
    return 0

  # // ist leider nötig, aber muss eh das glieche wie / sein ...
  return 0 if x[:len(x)//2] == x[len(x)//2:] else int(x)

sum(sum(map(p, d)) for d in ds)
```]
