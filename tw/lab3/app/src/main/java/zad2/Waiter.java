package zad2;

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

class Waiter {
  private final Lock[] requesting;
  private final Lock[] acquiring;
  private final Condition[] conditions;
  private final boolean[] waiting;
  private final Lock table = new ReentrantLock();
  private final Condition empty = table.newCondition();

  Waiter(int couples) {
    requesting = new Lock[couples];
    acquiring = new Lock[couples];
    conditions = new Condition[couples];
    waiting = new boolean[couples];

    for (int i = 0; i < couples; i++) {
      requesting[i] = new ReentrantLock();
      acquiring[i] = new ReentrantLock();
      conditions[i] = requesting[i].newCondition();
    }

    table.lock();
    empty.signal();
    table.unlock();
  }

  void request(Person person) {
    requesting[person.id].lock();
    try {
      if (!waiting[person.id]) {
        waiting[person.id] = true;
        // System.out.printf(
        //     "a %d %d\n", person.id, person.number
        // );
        try {
          conditions[person.id].await();
        } catch (InterruptedException e) {
          e.printStackTrace();
        }
        return;
      }

      // System.out.printf("b %d %d\n", person.id,
      // person.number);
      waiting[person.id] = false;

      table.lock();
      // try {
      //   empty.await();
      // } catch (InterruptedException e) {
      //   e.printStackTrace();
      // }
      // table.unlock();

      System.out.printf(
          "Couple %d is using the table\n", person.id
      );

      conditions[person.id].signal();
    } finally {
      requesting[person.id].unlock();
    }
  }

  void free(Person person) {
    requesting[person.id].lock();
    try {
      if (!waiting[person.id]) {
        waiting[person.id] = true;
        try {
          conditions[person.id].await();
        } catch (InterruptedException e) {
          e.printStackTrace();
        }
        return;
      }

      waiting[person.id] = false;

      // table.lock();
      // empty.signal();
      table.unlock();

      System.out.printf(
          "Couple %d freed the table\n", person.id
      );

      conditions[person.id].signal();
    } finally {
      requesting[person.id].unlock();
    }
  }
}
