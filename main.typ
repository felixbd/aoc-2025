#import "@preview/cheq:0.2.2": checklist
#import "@preview/tablem:0.2.0": tablem, three-line-table
#import "@preview/shadowed:0.2.0": shadowed as shadowed-original
#import "@preview/theorion:0.3.3": cosmos, caution-box, warning-box, remark, important-box
#import cosmos.fancy: *

#let shadowed(..args) = shadowed-original(
  radius: 4pt, inset: 12pt, fill: white, ..args
)

#set text(font:
  (
    "Fira Sans",
    "Atkinson Hyperlegible Next",
    "Atkinson Hyperlegible",
    "Libertinus Serif"
  )
)

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

#let is-draft = true

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

=== python

```py
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
>>> temp = 50
>>> for r in map(int, xs.replace("L", "-").replace("R", "+").split()):
...     temp
KeyboardInterrupt
>>> 
KeyboardInterrupt
>>> 
>>> 
>>> temp = 50
>>> count = 0
>>>
>>> 
>>> 
>>> for r in map(int, xs.replace("L", "-").replace("R", "+").split()):
...     print(temp)
...     temp = (temp + r) % 100
...     print(temp)
...     if temp == 0: count += 1
...     print(count)
...     
50
82
0
82
52
0
52
0
1
0
95
1
95
55
1
55
0
2
0
99
2
99
0
3
0
14
3
14
32
3
>>>
>>> 
>>> (lambda xs: (
...     lambda pos, c:
...         ([(pos := (pos + r) % 100,
...            c := c + (pos == 0))
...           for r in map(int, xs.replace("L", "-").replace("R", "+").split())],
...          c)[1]
... )(50, 0))(xs)
3
>>> 
>>>
```


#pagebreak(weak: true)

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

#shadowed[
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
```
]

```typst
#count-zeros("L68 L30 R48 L5 R60 L55 L1 L99 R14 L82")
```

#count-zeros("L68 L30 R48 L5 R60 L55 L1 L99 R14 L82")

