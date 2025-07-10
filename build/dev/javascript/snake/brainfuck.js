// please work please work please work
function runBF(code, input = "", write = (c) => console.log(c)) {
  const tape = new Uint8Array(30000);
  let ptr = 0, ip = 0, inputPtr = 0;
  const loopStack = [];
  const jumps = {};

  // Precompute matching brackets
  const openStack = [];
  for (let i = 0; i < code.length; i++) {
    if (code[i] === '[') openStack.push(i);
    else if (code[i] === ']') {
      const start = openStack.pop();
      jumps[start] = i;
      jumps[i] = start;
    }
  }

  while (ip < code.length) {
    switch (code[ip]) {
      case '>': ptr++; break;
      case '<': ptr--; break;
      case '+': tape[ptr]++; break;
      case '-': tape[ptr]--; break;
      case '.': write(String.fromCharCode(tape[ptr])); break;
      case ',': tape[ptr] = inputPtr < input.length ? input.charCodeAt(inputPtr++) : 0; break;
      case '[': if (!tape[ptr]) ip = jumps[ip]; break;
      case ']': if (tape[ptr]) ip = jumps[ip]; break;
    }
    ip++;
  }
}