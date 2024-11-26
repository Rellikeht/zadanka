package zad2;

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

class Waiter {
  private final Lock lock = new ReentrantLock();
  private final Condition notEmpty = lock.newCondition();
  private final boolean[] requesting;
  private final boolean[] freeing;
  private final Lock[] locks;
  private int usingID = -1;

  Waiter(int couples) {
    // this.couples = couples;
    this.requesting = new boolean[couples];
    this.freeing = new boolean[couples];
    locks = new Lock[couples];
    for (int i = 0; i < couples; i++) {
      locks[i] = new ReentrantLock();
    }
  }

  synchronized void request(int id) {
    locks[id].lock();
    try {
      if (!requesting[id]) {
        requesting[id] = true;
      } else {
        lock.lock();
        // notEmpty.signal();

        usingID = id;
        requesting[id] = false;
        System.out.printf("Couple %d is using the table\n", id);
      }
    } finally {
      locks[id].unlock();
    }
  }

  synchronized void free(int id) {
    locks[id].lock();
    try {
      if (!freeing[id]) {
        freeing[id] = true;
      } else {
        // try {
        //   notEmpty.await();
        // } catch (InterruptedException e) {
        //   e.printStackTrace();
        // }

        freeing[id] = false;

        System.out.printf("Couple %d freed the table\n", id);

        lock.unlock();
      }
    } finally {
      locks[id].unlock();
      usingID = -1;
    }
  }
}
