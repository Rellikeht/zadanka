package zad1;

import java.util.Random;

class User implements Runnable {
  private static final int mintime = 10;
  private static final int maxtime = 50;

  final Monitor monitor;
  final boolean[] printers;
  private final Random random = new Random(0);
  public final int id;

  public int sleepTime() {
    return mintime + random.nextInt(maxtime - mintime);
  }

  User(int id, Monitor monitor, boolean[] printers) {
    this.id = id;
    this.monitor = monitor;
    this.printers = printers;
  }

  public void run() {
    while (true) {
      // nr_drukarki = Monitor_Drukarek.zarezerwuj();
      int printer = monitor.get();

      // drukuj(nr_drukarki);
      System.out.printf(
          "Printing from thread %d using printer %d\n",
          id,
          printer
      );
      try {
        Thread.sleep(sleepTime());
      } catch (InterruptedException e) {
        e.printStackTrace();
      }

      // Monitor_Drukarek.zwolnij(nr_drukarki);
      monitor.free(printer);
    }
  }
}
