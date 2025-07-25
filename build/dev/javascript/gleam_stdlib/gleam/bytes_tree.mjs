import {
  toList,
  Empty as $Empty,
  prepend as listPrepend,
  CustomType as $CustomType,
} from "../gleam.mjs";
import * as $bit_array from "../gleam/bit_array.mjs";
import * as $list from "../gleam/list.mjs";
import * as $string_tree from "../gleam/string_tree.mjs";

class Bytes extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class Text extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

class Many extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export function append_tree(first, second) {
  if (second instanceof Bytes) {
    return new Many(toList([first, second]));
  } else if (second instanceof Text) {
    return new Many(toList([first, second]));
  } else {
    let trees = second[0];
    return new Many(listPrepend(first, trees));
  }
}

export function prepend_tree(second, first) {
  return append_tree(first, second);
}

export function concat(trees) {
  return new Many(trees);
}

export function new$() {
  return concat(toList([]));
}

export function from_string(string) {
  return new Text($string_tree.from_string(string));
}

export function prepend_string(second, first) {
  return append_tree(from_string(first), second);
}

export function append_string(first, second) {
  return append_tree(first, from_string(second));
}

export function from_string_tree(tree) {
  return new Text(tree);
}

function wrap_list(bits) {
  return new Bytes(bits);
}

export function from_bit_array(bits) {
  let _pipe = bits;
  let _pipe$1 = $bit_array.pad_to_bytes(_pipe);
  return wrap_list(_pipe$1);
}

export function prepend(second, first) {
  return append_tree(from_bit_array(first), second);
}

export function append(first, second) {
  return append_tree(first, from_bit_array(second));
}

export function concat_bit_arrays(bits) {
  let _pipe = bits;
  let _pipe$1 = $list.map(_pipe, (b) => { return from_bit_array(b); });
  return concat(_pipe$1);
}

function to_list(loop$stack, loop$acc) {
  while (true) {
    let stack = loop$stack;
    let acc = loop$acc;
    if (stack instanceof $Empty) {
      return acc;
    } else {
      let $ = stack.head;
      if ($ instanceof $Empty) {
        let remaining_stack = stack.tail;
        loop$stack = remaining_stack;
        loop$acc = acc;
      } else {
        let $1 = $.head;
        if ($1 instanceof Bytes) {
          let remaining_stack = stack.tail;
          let rest = $.tail;
          let bits = $1[0];
          loop$stack = listPrepend(rest, remaining_stack);
          loop$acc = listPrepend(bits, acc);
        } else if ($1 instanceof Text) {
          let remaining_stack = stack.tail;
          let rest = $.tail;
          let tree = $1[0];
          let bits = $bit_array.from_string($string_tree.to_string(tree));
          loop$stack = listPrepend(rest, remaining_stack);
          loop$acc = listPrepend(bits, acc);
        } else {
          let remaining_stack = stack.tail;
          let rest = $.tail;
          let trees = $1[0];
          loop$stack = listPrepend(trees, listPrepend(rest, remaining_stack));
          loop$acc = acc;
        }
      }
    }
  }
}

export function to_bit_array(tree) {
  let _pipe = toList([toList([tree])]);
  let _pipe$1 = to_list(_pipe, toList([]));
  let _pipe$2 = $list.reverse(_pipe$1);
  return $bit_array.concat(_pipe$2);
}

export function byte_size(tree) {
  let _pipe = toList([toList([tree])]);
  let _pipe$1 = to_list(_pipe, toList([]));
  return $list.fold(
    _pipe$1,
    0,
    (acc, bits) => { return $bit_array.byte_size(bits) + acc; },
  );
}
