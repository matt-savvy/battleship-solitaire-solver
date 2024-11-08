// output from BattleshipSolitaireSolver.Json.to_json/1
cells = ["Cell3_2", "Cell3_3", "Cell3_4", "Cell3_5", "Cell3_6", "Cell6_0", "Cell7_0",
 "Cell8_0", "Cell9_0", "Cell0_4", "Cell0_5", "Cell0_6", "Cell8_3", "Cell8_4",
 "Cell8_5", "Cell0_2", "Cell1_2", "Cell5_2", "Cell5_3", "Cell9_8", "Cell9_9",
 "Cell0_0", "Cell3_8", "Cell4_0", "Cell6_6"]

let cols = new Array(10).fill(null).map((x, i) => "Col" + i )
let rows = new Array(10).fill(null).map((x, i) => "Row" + i )
let ids = [...cells, ...cols, ...rows];

let INTERVAL = 100;

// Create a new MouseEvent
let mousedown = new MouseEvent("mousedown", {
    view: window,
    bubbles: true,
    cancelable: true
});

let mouseup = new MouseEvent("mouseup", {
    view: window,
    bubbles: true,
    cancelable: true
});

function click() {
    let id = ids.shift();
    let element = document.getElementById(id);
    // Dispatch the event on the element
    element.dispatchEvent(mousedown);
    element.dispatchEvent(mouseup);
    element.dispatchEvent(mousedown);
    element.dispatchEvent(mouseup);

    if (ids.length > 0) {
        window.setTimeout(click, INTERVAL);
    }
}

click();
