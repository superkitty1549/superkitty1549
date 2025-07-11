import { CustomType as $CustomType, isEqual } from "../gleam.mjs";

export class Lt extends $CustomType {}

export class Eq extends $CustomType {}

export class Gt extends $CustomType {}

export function negate(order) {
  if (order instanceof Lt) {
    return new Gt();
  } else if (order instanceof Eq) {
    return new Eq();
  } else {
    return new Lt();
  }
}

export function to_int(order) {
  if (order instanceof Lt) {
    return -1;
  } else if (order instanceof Eq) {
    return 0;
  } else {
    return 1;
  }
}

export function compare(a, b) {
  let x = a;
  let y = b;
  if (isEqual(x, y)) {
    return new Eq();
  } else {
    if (a instanceof Lt) {
      return new Lt();
    } else if (a instanceof Eq) {
      if (b instanceof Gt) {
        return new Lt();
      } else {
        return new Gt();
      }
    } else {
      return new Gt();
    }
  }
}

export function reverse(orderer) {
  return (a, b) => { return orderer(b, a); };
}

export function break_tie(order, other) {
  if (order instanceof Lt) {
    return order;
  } else if (order instanceof Eq) {
    return other;
  } else {
    return order;
  }
}

export function lazy_break_tie(order, comparison) {
  if (order instanceof Lt) {
    return order;
  } else if (order instanceof Eq) {
    return comparison();
  } else {
    return order;
  }
}
