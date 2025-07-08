// Basic Brainfuck interpreter (no debug, just works)
window.runBrainfuck = function(code, { input, output }) {
  const tape = new Uint8Array(30000);
  let ptr = 0;
  let pc = 0;
  const loopStack = [];
  const jumpTable = {};

  // Precompute jump table for [ and ]
  const stack = [];
  for (let i = 0; i < code.length; i++) {
    if (code[i] === '[') stack.push(i);
    if (code[i] === ']') {
      const start = stack.pop();
      jumpTable[start] = i;
      jumpTable[i] = start;
    }
  }

  while (pc < code.length) {
    switch (code[pc]) {
      case '>': ptr++; break;
      case '<': ptr--; break;
      case '+': tape[ptr]++; break;
      case '-': tape[ptr]--; break;
      case '.': output(tape[ptr]); break;
      case ',': tape[ptr] = input(); break;
      case '[':
        if (tape[ptr] === 0) {
          pc = jumpTable[pc];
        }
        break;
      case ']':
        if (tape[ptr] !== 0) {
          pc = jumpTable[pc];
        }
        break;
    }
    pc++;
  }
};
