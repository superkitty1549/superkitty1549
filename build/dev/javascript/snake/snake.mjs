import * as $list from "../gleam_stdlib/gleam/list.mjs";
import { divideFloat } from "./gleam.mjs";
import { sin, int_to_float, to_int } from "./math.js";

export { int_to_float, sin, to_int };

export function get_snake_positions(time) {
  let amplitude = 20.0;
  let wavelength = 50.0;
  let speed = 2.0;
  let base_y = 440.0;
  let _pipe = $list.range(0, 30);
  return $list.map(
    _pipe,
    (i) => {
      let x = i * 15;
      let y = base_y + (amplitude * sin(
        (divideFloat(int_to_float(i), wavelength)) + (time * speed),
      ));
      return [x, to_int(y)];
    },
  );
}
