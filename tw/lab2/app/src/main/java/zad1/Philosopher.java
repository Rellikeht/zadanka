package zad1;

import java.util.Random;
import util.*;

public class Philosopher implements Runnable {
  public static final int takes = 10;
  public static final int mintime = 100;
  public static final int maxtime = 500;
  public static final Random random = new Random(0);

  public final int number, amount;
  public final BinSemaphore[] forks;
  public final int right, left;

  public int sleepTime() {
    return mintime + random.nextInt(maxtime - mintime);
  }

  public Philosopher(
      int amount, int number, BinSemaphore[] forks
  ) {
    this.number = number;
    this.amount = amount;
    this.forks = forks;

    left = number;
    right = (number + 1) % amount;
  }

  public void run() {
    for (int i = 0; i < takes; i++) {
      try {
        Thread.sleep(sleepTime() / 5);
      } catch (InterruptedException e) {
        e.printStackTrace();
      }

      forks[left].down();
      try {
        Thread.sleep(sleepTime());
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
      // System.out.printf("Philosopher %d has lifted up left
      // fork\n", number);
      forks[right].down();
      // System.out.printf("Philosopher %d has lifted up right
      // fork\n", number);

      System.out.printf(
          "Philosopher %d has lifted up his forks\n", number
      );
      try {
        Thread.sleep(sleepTime());
      } catch (InterruptedException e) {
        e.printStackTrace();
      }

      forks[left].up();
      // System.out.printf("Philosopher %d has dropped down his
      // left fork\n", number);
      try {
        Thread.sleep(sleepTime() / 5);
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
      forks[right].up();
      // System.out.printf("Philosopher %d has dropped down his
      // right fork\n", number);
      System.out.printf(
          "Philosopher %d has dropped down his forks\n", number
      );
    }
  }
}
