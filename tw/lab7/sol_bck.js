const waitTime = 10;
const rounds = 50;

class Fork {
  constructor() {
    this.state = 0;
    return this;
  }

  acquire(cb) {
    let delay = 1;
    const tryAcquire = () => {
      setTimeout(() => {
        if (this.state === 0) {
          this.state = 1;
          cb();
        } else {
          delay *= 2;
          tryAcquire();
        }
      }, delay);
    };
    tryAcquire();
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
    this.access_time = 0;
    this.accesses = 0;
    const forks = this.forks, f1 = this.f1, f2 = this.f2;

    const eat = (remaining) => {
      if (remaining === 0)
        return;
      this.accesses += 1;
      this.access_time -= performance.now();
      console.log(`Filozof ${this.id} podnosi pierwszy widelec.`);
      forks[f1].acquire(() => {
        console.log(`Filozof ${this.id} podnosi drugi widelec.`);
        forks[f2].acquire(() => {
          this.access_time += performance.now();
          console.log(`Filozof ${this.id} je.`);
          setTimeout(() => {
            forks[f1].release();
            forks[f2].release();
            console.log(`Filozof ${this.id} kończy jedzenie.`);
            eat(remaining - 1);
          }, waitTime);
        });
      });
    };
    eat(count);
  }

  startAsym(count) {
    this.access_time = 0;
    this.accesses = 0;
    const forks = this.forks;
    const [f1, f2] =
        this.id % 2 === 0 ? [ this.f1, this.f2 ] : [ this.f2, this.f1 ];

    const eat = (remaining) => {
      if (remaining === 0)
        return;
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
          }, waitTime);
        });
      });
    };
    eat(count);
  }

  startConductor(count) {
    this.access_time = 0;
    this.accesses = 0;
    const forks = this.forks;
    const conductor = Philosopher.conductor;

    const eat = (remaining) => {
      if (remaining === 0)
        return;

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
            }, waitTime);
          });
        });
      });
    };
    eat(count);
  }
}

class Conductor {
  constructor(limit) {
    this.limit = limit;
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

Philosopher.conductor = new Conductor(4);
const N = 5;
const forks = [];
const philosophers = [];

for (let i = 0; i < N; i++) {
  forks.push(new Fork());
}
for (let i = 0; i < N; i++) {
  philosophers.push(new Philosopher(i, forks));
}

if (process.argv[2] === "1") {
  console.log("\nRozwiązanie naiwne:");
  for (let i = 0; i < N; i++) {
    philosophers[i].startNaive(rounds);
  }
} else if (process.argv[2] === "2") {

  console.log("\nRozwiązanie asymetryczne:");
  for (let i = 0; i < N; i++) {
    philosophers[i].startAsym(rounds);
  }
  let avg_access_time = 0;
  for (let i = 0; i < N; i++) {
    avg_access_time += philosophers[i].access_time / avg_access_time;
  }
  avg_access_time /= N;
  console.log("Średni czas dostępu:", avg_access_time, "\n");
} else {

  console.log("\nRozwiązanie z kelnerem:");
  for (let i = 0; i < N; i++) {
    philosophers[i].startConductor(rounds);
  }
  let avg_access_time = 0;
  for (let i = 0; i < N; i++) {
    avg_access_time += philosophers[i].access_time / avg_access_time;
  }
  avg_access_time /= N;
  console.log("Średni czas dostępu:", avg_access_time, "\n");
}
