/// Day 1: Secret Entrance
/// 
/// $ ("L68", "L30", "R48", "L5", "R60", "L55", "L1", "L99", "R14", "L82")^T  -> 3$ 
///
/// ```example
/// #day1("L68 L30 R48 L5 R60 L55 L1 L99 R14 L82")
/// ```
///
/// -> int
#let day1(
  /// The argument 
  /// -> string
  xs
) = {
  let steps = xs.replace("L", "-").replace("R", "+").split().map(int)
  let result = steps.fold((50, 0), (acc, r) => {
    let pos = calc.rem((acc.at(0) + r), 100)
    let cnt = acc.at(1) + int(pos == 0)
    (pos, cnt)
  })
  result.at(1)
}
