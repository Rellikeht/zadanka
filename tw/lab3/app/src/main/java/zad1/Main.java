package zad1;

public class Main {
  static final int printers_amount = 3;
  static final int threads_amount = 5;

  public static void main(String[] args) {
    System.out.println("Zadanie 1");
    boolean[] printers = new boolean[printers_amount];
    Monitor monitor = new Monitor(printers_amount);
    Thread[] threads = new Thread[threads_amount];

    for (int i = 0; i < threads_amount; i++) {
      User user = new User(i, monitor, printers);
      threads[i] = new Thread(user);
    }

    for (int i = 0; i < threads_amount; i++) {
      threads[i].start();
    }

    for (int i = 0; i < threads_amount; i++) {
      try {
        threads[i].join();
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
    }
  }
}
