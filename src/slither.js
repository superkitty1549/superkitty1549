import { get_snake_positions } from './build/dev/javascript/snake/snake.mjs';

let time = 0;
let canvas, ctx;

export function initSnake() {
    canvas = document.createElement('canvas');
    canvas.id = 'snake-canvas';
    canvas.style.position = 'fixed';
    canvas.style.top = '0';
    canvas.style.left = '0';
    canvas.style.width = '100%';
    canvas.style.height = '100%';
    canvas.style.zIndex = '-1';
    canvas.style.pointerEvents = 'none';

    document.body.appendChild(canvas);
    ctx = canvas.getContext('2d');

    resizeCanvas();

    animate();

    window.addEventListener('resize', resizeCanvas);
}

function resizeCanvas() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
}

function drawSnake() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const positions = get_snake_positions(time);

    ctx.strokeStyle = 'rgba(0, 200, 0, 0.8)';
    ctx.lineWidth = 3;
    ctx.beginPath();

    positions.forEach((coord, index) => {
        const [x, y] = coord;

        const adjustedX = x + 50;
        const adjustedY = canvas.height - y - 100;

        if (index === 0) {
            ctx.moveTo(adjustedX, adjustedY);
        } else {
            ctx.lineTo(adjustedX, adjustedY);
        }
    });

    ctx.stroke();

    positions.forEach((coord, index) => {
        const [x, y] = coord;
        const adjustedX = x + 50;
        const adjustedY = canvas.height - y - 100;

        if (index === 0) {
            ctx.fillStyle = 'rgba(255, 255, 0, 0.9)';
            ctx.beginPath();
            ctx.arc(adjustedX, adjustedY, 8, 0, 2 * Math.PI);
            ctx.fill();

            ctx.fillStyle = 'rgba(0, 0, 0, 0.8)';
            ctx.beginPath();
            ctx.arc(adjustedX - 3, adjustedY - 2, 1.5, 0, 2 * Math.PI);
            ctx.arc(adjustedX + 3, adjustedY - 2, 1.5, 0, 2 * Math.PI);
            ctx.fill();
        } else {
            // Body segments
            const size = Math.max(3, 7 - index * 0.1);
            const alpha = Math.max(0.3, 0.9 - index * 0.02);

            ctx.fillStyle = `rgba(0, 200, 0, ${alpha})`;
            ctx.beginPath();
            ctx.arc(adjustedX, adjustedY, size, 0, 2 * Math.PI);
            ctx.fill();
        }
    });
}

function animate() {
    drawSnake();
    time += 0.02;
    requestAnimationFrame(animate);
}

export function makeSnakeClickable() {
    canvas.style.pointerEvents = 'auto';
    canvas.style.cursor = 'pointer';

    canvas.addEventListener('click', (e) => {
        const rect = canvas.getBoundingClientRect();
        const clickX = e.clientX - rect.left;
        const clickY = e.clientY - rect.top;

        const positions = get_snake_positions(time);

        for (let i = 0; i < positions.length; i++) {
            const [x, y] = positions[i];
            const adjustedX = x + 50;
            const adjustedY = canvas.height - y - 100;

            const distance = Math.sqrt(
                Math.pow(clickX - adjustedX, 2) +
                Math.pow(clickY - adjustedY, 2)
            );

            const segmentSize = i === 0 ? 8 : Math.max(3, 7 - i * 0.1);

            if (distance <= segmentSize + 5) { // extra 5px for easier clicking, yay snek clicked
                window.location.href = 'src/snake.html';
                break;
            }
        }
    });
}

//init when dom loaded
document.addEventListener('DOMContentLoaded', () => {
    initSnake();
    makeSnakeClickable();
});