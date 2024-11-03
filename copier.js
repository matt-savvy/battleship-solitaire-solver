let rows = {};
let cols = {};
let i = -1;
let element;

do {
    i += 1;
    element = document.getElementById("Col" + i);
    if (element) {
        const text = element.textContent;
        const count = Number(text)
        cols[i+1] = count;
    }
    element = document.getElementById("Row" + i);
    if (element) {
        const text = element.textContent;
        const count = Number(text)
        rows[i+1] = count;
    }
} while (element);

let MAX = i;

let cells = {}
const clueMaps = {
    "water": "water",
    "cap-left": "left",
    "cap-right": "right",
    "cap-top": "top",
    "cap-bottom": "bottom",
    "middle": "body",
    "sub": "buoy"
}

for (let i = 0; i < MAX; i++) {
    for (let j = 0; j < MAX; j++) {
        let classes = document.getElementById(`Cell${i}_${j}`).classList;
        classes = [...classes.values()]
        if(classes.includes("revealed")) {
            classes = classes.filter(cls => cls != "revealed");
            const key = [i+1, j+1].join(",");
            const value = clueMaps[classes[0]];
            cells[key] = value;
        }
    }
}
let clues = {
    row_counts: rows,
    col_counts: cols,
    cells: cells
}

JSON.stringify(clues);
