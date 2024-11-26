package zad1;

import java.util.Random;

public class Main {
  private static final int amount = 27;
  private static final int bufsize = 20;
  private static final String initial_data = "Start ";

  private static final int min_time = 20;
  private static final int max_time = 50;
  private static final Random random =
      new Random(System.currentTimeMillis());

  private static final int randTime() {
    return min_time + random.nextInt(max_time - min_time);
  }

  public static void main(String[] args) {
    System.out.println("Zadanie 1");
    Cell[] buffer = new Cell[bufsize];
    for (int i = 0; i < bufsize; i++) {
      buffer[i] = new Cell(initial_data);
    }

    Thread[] processes = new Thread[amount];
    for (int i = 0; i < amount - 1; i++) {
      String name = Character.toString('A' + i);
      Process p =
          new Process(i, randTime(), name, buffer, amount - 1);
      processes[i] = new Thread(p);
    }

    Process p = new Process(
        -1, randTime(), initial_data, buffer, amount - 1
    );
    processes[amount - 1] = new Thread(p);

    for (int i = 0; i < amount; i++) {
      processes[i].start();
    }

    try {
      for (int i = 0; i < amount; i++) {
        processes[i].join();
      }
    } catch (InterruptedException e) {
      e.printStackTrace();
    }

    // for (int i = 0; i < bufsize; i++) {
    //   System.out.println(buffer[i].debugReadData());
    // }
  }
}
