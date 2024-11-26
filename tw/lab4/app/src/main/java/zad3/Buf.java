package zad3;

import java.util.concurrent.locks.*;
import utils.Buffer;

class Buf implements Buffer {
  private final int max_permits;
  private int permits = 0;

  private final Lock lock = new ReentrantLock();
  private final Condition bigger = lock.newCondition();
  private final Condition less = lock.newCondition();

  private long curGet = 0;
  private long newGet = 0;
  private long curPut = 0;
  private long newPut = 0;

  Buf(int permits) { max_permits = permits; }

  public void acquire(int permits) throws InterruptedException {
    lock.lock();
    long request = newGet;
    newGet += 1;

    try {
      while (this.permits < permits && request == curGet) {
        bigger.await();
      }
      this.permits -= permits;
      less.signal();
      bigger.signal();
      curGet += 1;
    } finally {
      lock.unlock();
    }
  }

  public void release(int permits) throws InterruptedException {
    lock.lock();
    long request = newPut;
    newPut += 1;

    try {
      while (this.permits + permits > max_permits &&
             request == curPut) {
        less.await();
      }
      this.permits += permits;
      bigger.signal();
      less.signal();
      curPut += 1;
    } finally {
      lock.unlock();
    }
  }

  int availablePermits() { return permits; }
}
