import gleam/list
import gleam/math

type Coord = #(Int, Int)

pub fn get_snake_positions(time: Float) -> List(Coord) {
  let amplitude = 20.0
  let wavelength = 50.0
  let speed = 2.0
  let base_y = 440.0

  list.range(0, 30)
  |> list.map(fn(i) {
    let x = i * 15
    let y = base_y +. amplitude *. math.sin({math.int_to_float(i) /. wavelength} +. time *. speed)
    #(x, math.floor(y))
  })
}
