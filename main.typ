#import "@preview/cheq:0.2.2": checklist
#show: checklist.with(
  marker-map: (
    " ": sym.ballot,
    "x": sym.ballot.cross,
    "-": sym.bar.h,
    "/": sym.slash.double
  )
)

#import "@preview/lovelace:0.3.0": *

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
#set page("a4", height: auto)
#set text(lang: "en", region: "gb")


#title([#emoji.candle Advent of Code 2025 #emoji.face])

#outline()

#pagebreak()

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


#shadowed[
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

Where $cal(R)$ is the Set of Ranges R, and $id in R$ being a product identifier. The solution is:

$ sum_(R in cal(R)) sum_(id in R)  cases(
    id "if" id "is valid",
    0 "otherwise",
  ) $



#zebraw[```py
from day2 import xs

ds = [
  range(
    *(lambda ys: [ys[0], ys[1] + 1])(
      list(map(int, e.split("-")))
    )
  )
  for e in xs.split(",")
]


def p(x: int) -> int:
  x = str(x)

  if len(x) % 2 != 0: return 0

  return 0 if x[:len(x)//2] == x[len(x)//2:] else int(x)

sum(sum(map(p, d)) for d in ds)
```]

== Part Two

Now the Predicate changes for whether a product id is valid or not ...

#shadowed[
  Now, an *ID is invalid if* it is made only of some sequence of *digits repeated at least twice*. So, 12341234 (1234 two times), 123123123 (123 three times), 1212121212 (12 five times), and 1111111 (1 seven times) are all invalid IDs.
]


#figure(
  kind: "algorithm",
  supplement: [Algorithm],
  caption: [some caption],
  
  pseudocode-list(booktabs: true, numbered-title: [PredicateForValidProductIDs])[
    + input $n in NN$ is the ID that should be checked
    + $l <- floor(log_10(n)) +1  quad forall n > 0 quad$ is the `len(str(n))`
    + *for each* $i in [l/2] quad$ where [n] is {1, ..., n}
      + head $<-$ first i chars of string representation of n
      + *if* repeat(head, n=$l$ / $i$) == str(n) *then*
        + *return* $bot$
      + *end*
    + *end*
    + *return* $top$
  ]
)


$ arrow.b.double $

#zebraw[
```py
def p(x: int) -> int:
  x = str(x)
  l = len(x)

  for i in range(l // 2):
    h = x[:i+1]
    if h * (l // (i+1)) == x:
      return int(x)

  return 0
```
]


#pagebreak()

= Day 3: Lobby


#zebraw[
```python

xs = """987654321111111
811111111111119
234234234234278
818181911112111"""

xs = [list(map(int, e)) for e in xs.split()]


def day3(xs: list[list[int]]) -> int:
  def helper(x: list[int]) -> int:
    temp: int = 0
    
    for i, v in enumerate(x):
         for ii, e in enumerate(x[i+1:]):
             if int(str(v) + str(e)) > temp:
                 temp = int(str(v) + str(e))

    return temp
  
  return sum(
    helper(x)
    for x in xs
  )

print(f"{ day3(xs) = }")
```]


== Part Tow

#shadowed[
  The task per row is:
Given a sequence of digits, select exactly 12 digits, in order, such that the resulting 12 digit number is maximized.
]


#zebraw[```py

from itertools import combinations


sum(map(
  lambda y: max(map(
    lambda x: int("".join([str(e) for e in x])),
    list(combinations(y, 12))
  )),
  xs
))
```]

this is very slow for the big input ...


$ arrow.b.double $

#zebraw[```py
print(f"[INFO] { len(xs) = }, { len(xs[0]) = }")


s: int = 0


from tqdm import tqdm

for index, y in enumerate(xs):
  temp: int = 0

  print(f"[INFO] { index = }")

  for x in tqdm(combinations(y, 12)):
    g = int("".join( map(str, x)))

    if g > temp:
      temp = g

  s += temp

  print(f"{temp = }")

print(f"final { s = }")

```]


#rect[```txt
[INFO]  len(xs) = 200,  len(xs[0]) = 100
[INFO]  index = 0
??????????it [0?:??, ~700000.00it/s]^C
Traceback (most recent call last):
  File "/.../day3.py", line 258, in <module>
    g = int("".join( map(str, x)))
        ^^^^^^^^^^^^^^^^^^^^^^^^^^
KeyboardInterrupt
```]

$  (binom(100, 12) "it") / (700000 "it" / "sec") => approx 1.501 times 10^9 sec => 47.55 "average Gregorian years" ... $





This shit takes way to long ...

$ arrow.b.double $

Process digits from left to right, maintaining a stack:

- You may delete at most $n − k$ digits.
- While the current digit is larger than the last chosen digit, and deletions remain, remove the last digit.
- Append the current digit.
- At the end, truncate to length k.

This is optimal and runs in *linear time*

#zebraw[```py
xs = """987654321111111
811111111111119
234234234234278
818181911112111"""

xs = [list(map(int, e)) for e in xs.split()]

def max_subsequence_value(x: list[int], k: int = 12) -> int:
    drop = len(x) - k
    stack: list[int] = []

    for d in x:
        while drop > 0 and stack and stack[-1] < d:
            stack.pop()
            drop -= 1
        stack.append(d)

    stack = stack[:k]

    val = 0
    for d in stack:
        val = val * 10 + d
    return val


def day3(xs: list[list[int]]) -> int:
    return sum(max_subsequence_value(x, 12) for x in xs)

print(f"{day3(xs) = }")
```]

runs in $approx 0.02 sec$ for the big input #emoji.face.happy

