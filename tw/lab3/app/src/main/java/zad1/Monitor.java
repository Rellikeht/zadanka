package zad1;

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

class Monitor {
  private final int[] free;
  private int count;

  private final Lock lock = new ReentrantLock();
  private final Condition notEmpty = lock.newCondition();

  Monitor(int printers) {
    this.free = new int[printers];
    this.count = printers;
    for (int i = 0; i < printers; i++) {
      free[i] = i;
    }
  }

  int get() {
    lock.lock();
    try {
      while (count <= 0) {
        try {
          notEmpty.await();
        } catch (InterruptedException e) {
          e.printStackTrace();
        }
      }
      count -= 1;
      int id = free[count];
      return id;
    } finally {
      lock.unlock();
    }
  }

  void free(int number) {
    lock.lock();
    try {
      free[count] = number;
      count += 1;
      notEmpty.signal();
    } finally {
      lock.unlock();
    }
  }
}
