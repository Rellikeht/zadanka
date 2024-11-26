package zad2;

import java.util.concurrent.locks.*;

class Buffer {
  private final int max_permits;
  private int permits = 0;

  Buffer(int permits) { max_permits = permits; }

  private final Lock lock = new ReentrantLock();
  private final Condition bigger = lock.newCondition();
  private final Condition less = lock.newCondition();

  void acquire(int permits) throws InterruptedException {
    lock.lock();
    try {
      while (this.permits < permits) {
        bigger.await();
      }
      this.permits -= permits;
      less.signal();
      bigger.signal();
    } finally {
      lock.unlock();
    }
  }

  void release(int permits) throws InterruptedException {
    lock.lock();
    try {
      while (this.permits + permits > max_permits) {
        less.await();
      }
      this.permits += permits;
      bigger.signal();
      less.signal();
    } finally {
      lock.unlock();
    }
  }

  int availablePermits() { return permits; }
}
