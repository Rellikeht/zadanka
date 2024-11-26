package zad3;

import java.util.Random;
import util.*;

public class Philosopher implements Runnable {
  public static final int takes = 20;
  public static final int mintime = 50;
  public static final int maxtime = 200;
  public static final Random random = new Random(0);

  public final int number, amount;
  public final BinSemaphore[] forks;
  public final int right, left;
  private Semaphore waiter;

  public int sleepTime() {
    return mintime + random.nextInt(maxtime - mintime);
  }

  public Philosopher(
      int amount,
      int number,
      Semaphore waiter,
      BinSemaphore[] forks
  ) {
    this.number = number;
    this.amount = amount;
    this.forks = forks;
    this.waiter = waiter;

    left = number;
    right = (number + 1) % amount;
  }

  public void run() {
    for (int i = 0; i < takes; i++) {

      try {
        Thread.sleep(sleepTime());
      } catch (InterruptedException e) {
        e.printStackTrace();
      }

      waiter.down();
      try {
        Thread.sleep(sleepTime() / 5);
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
      forks[left].down();
      try {
        Thread.sleep(sleepTime() / 5);
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
      forks[right].down();

      System.out.printf(
          "Philosopher %d has lifted up his forks\n", number
      );
      try {
        Thread.sleep(sleepTime());
      } catch (InterruptedException e) {
        e.printStackTrace();
      }

      forks[left].up();
      try {
        Thread.sleep(sleepTime() / 5);
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
      forks[right].up();
      try {
        Thread.sleep(sleepTime() / 5);
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
      waiter.up();

      System.out.printf(
          "Philosopher %d has dropped down his forks\n", number
      );
    }
  }
}
