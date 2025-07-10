import gleam/list

// External functions referencing your math.js module
@external(javascript, "./math.js", "sin")
pub fn sin(x: Float) -> Float

@external(javascript, "./math.js", "int_to_float")
pub fn int_to_float(i: Int) -> Float

@external(javascript, "./math.js", "to_int")
pub fn to_int(f: Float) -> Int

type Coord = #(Int, Int)

pub fn get_snake_positions(time: Float) -> List(Coord) {
  let amplitude = 20.0
  let wavelength = 50.0
  let speed = 2.0
  let base_y = 440.0

  list.range(0, 30)
  |> list.map(fn(i) {
    let x = i * 15
    let y = base_y +. amplitude *. sin({int_to_float(i) /. wavelength} +. time *. speed)
    #(x, to_int(y))
  })
}