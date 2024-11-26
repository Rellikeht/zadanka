function printAsync(s, cb) {
  var delay = Math.floor((Math.random() * 1000) + 500);
  setTimeout(function() {
    console.log(s);
    if (cb)
      cb();
  }, delay);
}

function task1(cb) {
  printAsync("1", function() { task2(cb); });
}

function task2(cb) {
  printAsync("2", function() { task3(cb); });
}

function task3(cb) { printAsync("3", cb); }

// // wywolanie sekwencji zadan
// task1(function() { console.log('done!'); });

/*
** Zadanie:
** Napisz funkcje loop(n), ktora powoduje wykonanie powyzszej
** sekwencji zadan n razy. Czyli: 1 2 3 1 2 3 1 2 3 ... done
**
*/

function loop(n) {
  let f = function() { console.log('done!'); };
  for (let i = 0; i < n; i++) {
    let g = f;
    f = function() { task1(g); };
  }
  f();
}

// function loop(n, f) {
//   if (n == 0) {
//     f();
//     return;
//   }
//   return loop(n - 1, function() { task1(f); });
// }

loop(3, function() { console.log('done!'); })
