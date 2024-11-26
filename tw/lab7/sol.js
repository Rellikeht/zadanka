class Fork {
  constructor() {
    this.state = 0; // 0 oznacza, że widelec jest dostępny, 1 oznacza zajęty
    return this;
  }

  acquire(cb) {
    // Implementacja algorytmu BEB
    let delay = 1; // Zaczynamy od 1ms
    const tryAcquire = () => {
      if (this.state === 0) {
        this.state = 1; // Rezerwujemy widelec
        cb(); // Wywołujemy callback, który kontynuuje działanie filozofa
      } else {
        setTimeout(() => {
          delay *= 2; // Zwiększamy czas oczekiwania dwukrotnie
          tryAcquire();
        }, delay);
      }
    };
    tryAcquire();
  }

  release() {
    this.state = 0; // Udostępniamy widelec
  }
}

class Philosopher {
  constructor(id, forks) {
    this.id = id;
    this.forks = forks;
    this.f1 = id % forks.length;       // Indeks prawego widelca
    this.f2 = (id + 1) % forks.length; // Indeks lewego widelca
    return this;
  }

  startNaive(count) {
    this.access_time = 0;
    this.accesses = 0;
    const eat = (remaining) => {
      if (remaining === 0)
        return;
      const forks = this.forks, f1 = this.f1, f2 = this.f2;

      this.accesses += 1;
      this.access_time -= performance.now();
      forks[f1].acquire(() => {
        forks[f2].acquire(() => {
          this.access_time += performance.now();
          console.log(`Filozof ${this.id} je.`);
          setTimeout(() => {
            forks[f1].release();
            forks[f2].release();
            console.log(`Filozof ${this.id} kończy jedzenie.`);
            eat(remaining - 1);
          }, 100); // Symulujemy czas jedzenia
        });
      });
    };
    eat(count);
  }

  startAsym(count) {
    this.access_time = 0;
    this.accesses = 0;
    const eat = (remaining) => {
      if (remaining === 0)
        return;

      const forks = this.forks;
      const [first, second] =
          this.id % 2 === 0 ? [ this.f1, this.f2 ] : [ this.f2, this.f1 ];

      this.accesses += 1;
      this.access_time -= performance.now();
      forks[first].acquire(() => {
        forks[second].acquire(() => {
          this.access_time += performance.now();
          console.log(`Filozof ${this.id} je.`);
          setTimeout(() => {
            forks[first].release();
            forks[second].release();
            console.log(`Filozof ${this.id} kończy jedzenie.`);
            eat(remaining - 1);
          }, 100); // Symulujemy czas jedzenia
        });
      });
    };
    eat(count);
  }

  startConductor(count) {
    this.access_time = 0;
    this.accesses = 0;
    const eat = (remaining) => {
      if (remaining === 0)
        return;

      const forks = this.forks;
      const conductor = Philosopher.conductor;

      this.accesses += 1;
      this.access_time -= performance.now();
      conductor.acquire(() => {
        forks[this.f1].acquire(() => {
          forks[this.f2].acquire(() => {
            this.access_time += performance.now();
            console.log(`Filozof ${this.id} je.`);
            setTimeout(() => {
              forks[this.f1].release();
              forks[this.f2].release();
              conductor.release();
              console.log(`Filozof ${this.id} kończy jedzenie.`);
              eat(remaining - 1);
            }, 100); // Symulujemy czas jedzenia
          });
        });
      });
    };
    eat(count);
  }
}

// Semafor dla kelnera
class Conductor {
  constructor(limit) {
    this.limit =
        limit; // Maksymalna liczba filozofów, którzy mogą rywalizować o widelce
    this.current = 0;
    this.queue = [];
  }

  acquire(cb) {
    const tryAcquire = () => {
      if (this.current < this.limit) {
        this.current++;
        cb();
      } else {
        this.queue.push(tryAcquire);
      }
    };
    tryAcquire();
  }

  release() {
    this.current--;
    if (this.queue.length > 0) {
      const next = this.queue.shift();
      next();
    }
  }
}

Philosopher.conductor =
    new Conductor(4); // Dodajemy kelnera z limitem 4 filozofów

// Uruchomienie
const N = 5;
const forks = [];
const philosophers = [];

for (let i = 0; i < N; i++) {
  forks.push(new Fork());
}

for (let i = 0; i < N; i++) {
  philosophers.push(new Philosopher(i, forks));
}

console.log("\nRozwiązanie naiwne:");
for (let i = 0; i < N; i++) {
  philosophers[i].startNaive(10);
}

setTimeout(() => {
  console.log("\nRozwiązanie asymetryczne:");
  for (let i = 0; i < N; i++) {
    philosophers[i].startAsym(10);
  }
}, 3000);

setTimeout(() => {
  console.log("\nRozwiązanie z kelnerem:");
  for (let i = 0; i < N; i++) {
    philosophers[i].startConductor(10);
  }
}, 6000);
