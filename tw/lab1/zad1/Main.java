public class Main {
  public static final int runs = 100000000;

  public static void main(String[] args) {
    Counter counter = new Counter();

    Thread t1 = new Thread(() -> {
      for (int i = 0; i < runs; i++) {
        counter.increment();
      }
    });

    Thread t2 = new Thread(() -> {
      for (int i = 0; i < runs; i++) {
        counter.decrement();
      }
    });

    t1.start();
    t2.start();

    try {
      t1.join();
      t2.join();
    } catch (Exception e) {
    }

    System.out.println(counter.data);
  }
}
