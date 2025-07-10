import gleam/list
import gleam/float
import gleam/int

pub fn get_snake_positions(time: Float) -> List(tuple(Int, Int)) {
let amplitude = 20.0
let wavelength = 50.0
let speed = 2.0
let base_y = 440.0

list.range(0, 30)
|> list.map(fn(i) {
let x = i * 15
let y = base_y + amplitude * float.sin((float(x) / wavelength) + time * speed)
tuple(x, float.to_int(y))
})
}
