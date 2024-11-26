package zad2;

import java.util.concurrent.locks.*;
import utils.Buffer;

class Buf implements Buffer {
  private final int max_permits;
  private int permits = 0;

  private final Lock lock = new ReentrantLock();
  private final Condition bigger = lock.newCondition();
  private final Condition less = lock.newCondition();

  Buf(int permits) { max_permits = permits; }

  public void acquire(int permits) throws InterruptedException {
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

  public void release(int permits) throws InterruptedException {
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
