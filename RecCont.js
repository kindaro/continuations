function rec (i, cb) {
    console.log("Called with: " + i);
    if (i <= 0) {
        console.log("Termination!");
    }
    else {
        cb(i - 1, arguments.callee);
    }
}

rec (10, (i, cb) => { setTimeout(rec, 1000, i, arguments.callee); });

