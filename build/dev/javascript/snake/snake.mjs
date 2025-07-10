import * as $list from "../gleam_stdlib/gleam/list.mjs";
import { divideFloat } from "./gleam.mjs";
import { sin, int_to_float, to_int } from "./math.js";

export { int_to_float, sin, to_int };

// Your original Gleam function (compiled to JS)
function get_snake_positions_gleam(time) {
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
      return [x, to_int(y)]; // Gleam tuple becomes [x, y] in JS
    },
  );
}

// JavaScript-compatible wrapper
export function get_snake_positions(time) {
  const gleam_list = get_snake_positions_gleam(time);

  // Convert Gleam list to JavaScript array
  const js_array = [];
  let current = gleam_list;

  // Iterate through the Gleam list structure
  while (current && current.length > 0) {
    if (current[0]) {
      js_array.push(current[0]); // Each item should already be [x, y]
    }
    current = current[1]; // Move to next item in Gleam list
  }

  return js_array;
}