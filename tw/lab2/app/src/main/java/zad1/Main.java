package zad1;

import util.*;

public class Main {
  public static final int amount = 5;

  public static void main(String[] args) {
    System.out.println("Zadanie 1");

    BinSemaphore[] forks = new BinSemaphore[amount];
    Thread[] philosophters = new Thread[amount];

    for (int i = 0; i < amount; i++) {
      forks[i] = new BinSemaphore(i);
      Philosopher p = new Philosopher(amount, i, forks);
      philosophters[i] = new Thread(p);
    }

    for (int i = 0; i < amount; i++) {
      philosophters[i].start();
    }

    for (int i = 0; i < amount; i++) {
      try {
        philosophters[i].join();
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
    }
  }
}
