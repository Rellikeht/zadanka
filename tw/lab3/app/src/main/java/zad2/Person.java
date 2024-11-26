package zad2;

import java.util.concurrent.ThreadLocalRandom;

class Person implements Runnable {
  private static final int mintime = 10;
  private static final int maxtime = 50;

  private final Waiter waiter;
  private final ThreadLocalRandom random =
      ThreadLocalRandom.current();
  public final int id;
  public final int number;

  private int sleepTime() {
    return mintime + random.nextInt(maxtime - mintime);
  }

  Person(int id, int number, Waiter waiter) {
    this.id = id;
    this.number = number;
    this.waiter = waiter;
  }

  public void run() {
    // while (true) {
    for (int i = 0; i < 2; i++) {

      try {
        Thread.sleep(sleepTime() * 2);
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
      waiter.request(this);

      System.out.printf(
          "Person %d from couple %d is using the table\n",
          number,
          id
      );

      try {
        Thread.sleep(sleepTime());
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
      waiter.free(this);

      System.out.printf(
          "Person %d from couple %d freed the table\n",
          number,
          id
      );
    }
  }
}
