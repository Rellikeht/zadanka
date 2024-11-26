package zad2;

public class Main {
  static final int couples_amount = 1;

  public static void main(String[] args) {
    System.out.println("Zadanie 3");
    Waiter waiter = new Waiter(couples_amount);
    Thread[] threads = new Thread[couples_amount * 2];

    for (int i = 0; i < couples_amount * 2; i++) {
      Person p = new Person(i / 2, i % 2, waiter);
      threads[i] = new Thread(p);
    }

    for (int i = 0; i < couples_amount * 2; i++) {
      threads[i].start();
    }

    for (int i = 0; i < couples_amount * 2; i++) {
      try {
        threads[i].join();
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
    }
  }
}
