import gleam/list

@external(javascript, "math", "sin")
pub external fn sin(x: Float) -> Float

@external(javascript, "math", "int_to_float")
pub external fn int_to_float(i: Int) -> Float

@external(javascript, "math", "to_int")
pub external fn to_int(f: Float) -> Int

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
