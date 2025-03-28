class Fork {
  constructor() {
    this.state = 0;
    return this;
  }

  acquire(cb) {
    // zaimplementuj funkcje acquire, tak by korzystala z algorytmu BEB
    // (http://pl.wikipedia.org/wiki/Binary_Exponential_Backoff), tzn:
    // 1. przed pierwsza proba podniesienia widelca Filozof odczekuje 1ms
    // 2. gdy proba jest nieudana, zwieksza czas oczekiwania dwukrotnie
    //    i ponawia probe itd.
  }

  release() { this.state = 0; }
}

class Philosopher {
  constructor(id, forks) {
    this.id = id;
    this.forks = forks;
    this.f1 = id % forks.length;
    this.f2 = (id + 1) % forks.length;
    return this;
  }

  startNaive(count) {
    var forks = this.forks, f1 = this.f1, f2 = this.f2, id = this.id;

    // zaimplementuj rozwiazanie naiwne
    // kazdy filozof powinien 'count' razy wykonywac cykl
    // podnoszenia widelcow -- jedzenia -- zwalniania widelcow
  }

  startAsym(count) {
    var forks = this.forks, f1 = this.f1, f2 = this.f2, id = this.id;

    // zaimplementuj rozwiazanie asymetryczne
    // kazdy filozof powinien 'count' razy wykonywac cykl
    // podnoszenia widelcow -- jedzenia -- zwalniania widelcow
  }

  startConductor(count) {
    var forks = this.forks, f1 = this.f1, f2 = this.f2, id = this.id;

    // zaimplementuj rozwiazanie z kelnerem
    // kazdy filozof powinien 'count' razy wykonywac cykl
    // podnoszenia widelcow -- jedzenia -- zwalniania widelcow
  }
}

var N = 5;
var forks = [];
var philosophers = [];

for (var i = 0; i < N; i++) {
  forks.push(new Fork());
}

for (var i = 0; i < N; i++) {
  philosophers.push(new Philosopher(i, forks));
}

for (var i = 0; i < N; i++) {
  philosophers[i].startNaive(10);
}
