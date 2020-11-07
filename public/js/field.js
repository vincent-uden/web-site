class Vec3 {
    constructor(x, y, z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    dot(v) {
        return this.x * v.x + this.y * v.y + this.z * v.z;
    }

    add(v) {
        return new Vec3(this.x + v.x, this.y + v.y, this.z + v.z);
    }
    
    sub(v) {
        return new Vec3(this.x - v.x, this.y - v.y, this.z - v.z);
    }

    scale(a) {
        return new Vec3(a * this.x, a * this.y, a * this.z);
    }

    get mag() {
        return Math.sqrt(this.dot(this));
    }
}

class PointCharge {
    constructor(pos, q) {
        this.pos = pos;
        this.q = q;

        this.epsilon = 8.854 * Math.pow(10, -12);
    }

    E(r) {
        return r.sub(this.pos).scale(this.q/(4*Math.PI*this.epsilon*Math.pow(r.sub(this.pos).mag, 3)));
    }
}

let u1 = new Vec3(0, 0, 0);
let u2 = new Vec3(10, 10, 0);
let u3 = new Vec3(10, 10, 0);
let u4 = new Vec3(-10, 10, 0);
let u5 = new Vec3(-10, -10, 0);
let u6 = new Vec3(10, -10, 0);
let v1 = new Vec3(0, 0, 0);
let v3 = new Vec3(10, 10, 0);
let v4 = new Vec3(-10, 10, 0);
let v5 = new Vec3(-10, -10, 0);
let v6 = new Vec3(10, -10, 0);


let SCALE = 10;
let ARROW_SCALE = 10e10;
let c = document.getElementById("field1");
let ctx = c.getContext("2d");
let mousePos = new Vec3(0, 0, 0);
let charges = [
    new PointCharge(u1, 1.6e-19), 
    new PointCharge(u3, -1.6e-19),
    new PointCharge(u4, -1.6e-19),
    new PointCharge(u5, -1.6e-19),
    new PointCharge(u6, -1.6e-19),
];
let origCharges = [
    new PointCharge(v1, 1.6e-19), 
    new PointCharge(v3, -1.6e-19),
    new PointCharge(v4, -1.6e-19),
    new PointCharge(v5, -1.6e-19),
    new PointCharge(v6, -1.6e-19),
];

let selCharge = -1;

ctx.translate(300, 300);

clearCanvas(ctx);

let grid = genGrid(-30, 30, -30, 30, 0, 31);

c.addEventListener("mousemove", function(e) {
    let cRect = c.getBoundingClientRect();
    let cX = Math.round(e.clientX - cRect.left);
    let cY = Math.round(e.clientY - cRect.top);

    mousePos.x = cX / SCALE - 30;
    mousePos.y = cY / SCALE - 30;

    if ( selCharge != -1 ) {
        charges[selCharge].pos.x = mousePos.x;
        charges[selCharge].pos.y = mousePos.y;
    }
});

c.addEventListener("click", function(e) {
    let cRect = c.getBoundingClientRect();
    let cX = Math.round(e.clientX - cRect.left);
    let cY = Math.round(e.clientY - cRect.top);

    mousePos.x = cX / SCALE - 30;
    mousePos.y = cY / SCALE - 30;

    if ( e.shiftKey ) {
        charges.push(new PointCharge(new Vec3(mousePos.x, mousePos.y, 0), 1.6e-19));
    } else {

    for ( let i = 0; i < charges.length; i++ ) {
        if ( charges[i].pos.sub(mousePos).mag <= 1 ) {
            if ( selCharge == i ) {
                selCharge = -1;
            } else {
                if ( e.ctrlKey ) {
                    charges.splice(i,1);
                } else {
                    selCharge = i;
                }
            }
            break;
        }
    }
    }
});

c.addEventListener("contextmenu", function(e) {
    e.preventDefault();
    let cRect = c.getBoundingClientRect();
    let cX = Math.round(e.clientX - cRect.left);
    let cY = Math.round(e.clientY - cRect.top);

    mousePos.x = cX / SCALE - 30;
    mousePos.y = cY / SCALE - 30;

    for ( let i = 0; i < charges.length; i++ ) {
        if ( charges[i].pos.sub(mousePos).mag <= 1 ) {
            charges[i].q *= -1;
            break;
        }
    }
});


animate(ctx);

function genGrid(xMin, xMax, yMin, yMax, z, res) {
    let xDiff = xMax - xMin;
    let yDiff = yMax - yMin;
    let output = Array.from(Array(res), () => new Array(res));
    for ( let y = 0; y < res; y++ ) {
        for ( let x = 0; x < res; x++ ) {
            output[y][x] = new Vec3(x * xDiff / (res-1) + xMin, y * yDiff / (res-1) + yMin, z);
        }
    }
    return output;
}

function animate(ctx) {
    requestAnimationFrame(() => animate(ctx));
    clearCanvas(ctx);
    charges.forEach( (c) => drawCharge(ctx, c) );
    //drawCharge(ctx, charges[0]);
    for ( let y = 0; y < grid.length; y++ ) {
        for ( let x = 0; x < grid[y].length; x++ ) {
            let r = grid[y][x];
            let dir = new Vec3(0, 0, 0);
            charges.forEach( (c) => dir = dir.add(c.E(r).scale(ARROW_SCALE)) );
            drawArrow(ctx, r, r.add(dir));
        }
    }
}

function clearCanvas(ctx) {
    ctx.fillStyle = "rgb(0,0,0)";
    ctx.fillRect(-300, -300, 600, 600);
}

function drawCharge(ctx, q) {
    if ( q.q > 0 ) {
        ctx.fillStyle = "rgb(240,0,0)";
    } else {
        ctx.fillStyle = "rgb(0,0,240)";
    }
    ctx.beginPath();
    ctx.arc(q.pos.x * SCALE, q.pos.y * SCALE, 1 * SCALE, 0, Math.PI * 2, true);
    ctx.fill();
    ctx.closePath();
}

function drawArrow(ctx, from, to) {
    from = from.scale(SCALE);
    to = to.scale(SCALE);
    let diff = to.sub(from);
    ctx.strokeStyle = "rgb(0," + diff.mag * 10 + ",0)";

    diff = diff.scale(20/diff.mag);
    to = from.add(diff);
    let angle = Math.atan2(diff.y,diff.x);
    let headlen = diff.mag * 0.05 * SCALE;

    ctx.beginPath();
    ctx.moveTo(from.x, from.y);
    ctx.lineTo(to.x, to.y);
    ctx.lineTo(to.x - headlen * Math.cos(angle - Math.PI / 6), to.y - headlen * Math.sin(angle - Math.PI / 6));
    ctx.moveTo(to.x, to.y);
    ctx.lineTo(to.x - headlen * Math.cos(angle + Math.PI / 6), to.y - headlen * Math.sin(angle + Math.PI / 6));
    ctx.stroke();
}


let resetBtn = document.getElementById("reset");

resetBtn.addEventListener("click", function(e) {
    selCharge = -1;
    charges = [];
    origCharges.forEach( (c) => charges.push( new PointCharge(new Vec3(c.pos.x, c.pos.y, c.pos.z), c.q)));
});
